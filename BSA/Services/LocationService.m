//
//  LocationService.m
//  deyi
//
//  Created by tangwei1 on 16/9/5.
//  Copyright © 2016年 tangwei1. All rights reserved.
//

#import "LocationService.h"
#import "Defines.h"

@interface LocationService () <APIManagerDelegate>

@property (nonatomic, strong) APIManager *apiManager;

@property (nonatomic, strong) APIManager *POISearchAPIManager;

@property (nonatomic, copy) void (^completionBlock)(id result, NSError *error);

@property (nonatomic, copy) void (^POISearchCompletionBlock)(NSArray *result, NSError *error);

@end

@implementation LocationService

static NSString * const QQLBSServer        = @"http://apis.map.qq.com";
static NSString * const QQLBSServiceAPIKey = @"5TXBZ-RDMH3-6GN36-3YZ6J-2QJYK-XIFZI";

static NSString * const QQGeocodeAPI       = @"/ws/geocoder/v1";
static NSString * const QQPOISearchAPI     = @"/ws/place/v1/search";

- (void)parseLocation:(CLLocation *)aLocation completion:(void (^)(id result, NSError *error))completion
{
    if ( !self.apiManager ) {
        self.apiManager = [APIManager apiManagerWithDelegate:self];
        APIConfig *config = [[APIConfig alloc] init];
        config.productionServer = config.stageServer = QQLBSServer;
        self.apiManager.apiConfig = config;
    }
    
    [self.apiManager cancelRequest];
    
    self.completionBlock = completion;
    
    NSString* locationVal = [NSString stringWithFormat:@"%.06lf,%.06lf", aLocation.coordinate.latitude, aLocation.coordinate.longitude];
    [self.apiManager sendRequest:APIRequestCreate(QQGeocodeAPI, RequestMethodGet, @{ @"location" : locationVal, @"key" : QQLBSServiceAPIKey, @"coord_type" : @(1)  })];
}

- (void)POISearch:(NSString *)keyword
         boundary:(NSString *)boundary
       completion:( void (^)(NSArray* locations, NSError* aError) )completion
{
    if ( self.POISearchAPIManager == nil ) {
        self.POISearchAPIManager = [APIManager apiManagerWithDelegate:self];
        APIConfig* config = [[APIConfig alloc] init];
        config.stageServer = config.productionServer = QQLBSServer;
        self.POISearchAPIManager.apiConfig = config;
    }
    
    [self.POISearchAPIManager cancelRequest];
    
    self.POISearchCompletionBlock = completion;
    
    NSString *cityValue = [NSString stringWithFormat:@"region(%@,0)", boundary ?: @"成都"];
    APIRequest* request = APIRequestCreate(QQPOISearchAPI, RequestMethodGet, @{@"keyword" : keyword,
                                                                               @"boundary" : cityValue,
                                                                               @"key" : QQLBSServiceAPIKey,
                                                                               //@"orderby" : @"_distance",
                                                                               @"page_index" : @(1),
                                                                               @"page_size" : @(20),
                                                                               });
    [self.POISearchAPIManager sendRequest:request];
}

/** 网络请求成功回调 */
- (void)apiManagerDidSuccess:(APIManager *)manager
{
    if ( manager == self.apiManager ) {
        // 逆地理解析
        if ( self.completionBlock ) {
//            id result = [[manager fetchDataWithReformer:nil] objectForKey:@"result"];
//            LocationInfo *info = [[LocationInfo alloc] initWithDictionary:result];
//            self.completionBlock(info, nil);
//            self.completionBlock = nil;
        }
    } else if ( manager == self.POISearchAPIManager ) {
        // 兴趣点搜索
        [self parsePOIs:[manager fetchDataWithReformer:nil]];
    }
}

/** 网络请求失败回调 */
- (void)apiManagerDidFailure:(APIManager *)manager
{
    if ( manager == self.apiManager ) {
        // 逆地理解析
        if ( self.completionBlock ) {
            self.completionBlock(nil, [NSError errorWithDomain:manager.apiError.message
                                                          code:manager.apiError.code
                                                      userInfo:nil]);
            self.completionBlock = nil;
        }
    } else if ( manager == self.POISearchAPIManager ) {
        // 兴趣点搜索
        if ( self.POISearchCompletionBlock ) {
            self.POISearchCompletionBlock(nil, [NSError errorWithDomain:manager.apiError.message
                                                                   code:manager.apiError.code
                                                               userInfo:nil]);
            self.POISearchCompletionBlock = nil;
        }
    }
}

- (void)parsePOIs:(id)poiInfo
{
    NSInteger code = [[poiInfo objectForKey:@"status"] integerValue];
    if ( code != 0 ) {
        NSError* error = [NSError errorWithDomain:[poiInfo objectForKey:@"message"]
                                             code:-1
                                         userInfo:nil];
        if ( self.POISearchCompletionBlock ) {
            self.POISearchCompletionBlock(nil, error);
        }
    } else {
        NSArray* locations = [poiInfo objectForKey:@"data"];
        if ( self.POISearchCompletionBlock ) {
            self.POISearchCompletionBlock(locations, nil);
        }
    }
}

@end
