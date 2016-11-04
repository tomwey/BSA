//
//  LocationService.h
//  deyi
//
//  Created by tangwei1 on 16/9/5.
//  Copyright © 2016年 tangwei1. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface LocationService : NSObject

- (void)parseLocation:(CLLocation *)aLocation completion:(void (^)(id result, NSError *error))completion;

/**
 * POI数据搜索
 *
 * @param keyword 位置关键字
 * @param boundary 搜索范围，一般为某个城市
 * @param completion 搜索完成的回调，回调参数locations为原生的位置数据
 * @return
 */
- (void)POISearch:(NSString *)keyword
         boundary:(NSString *)boundary
       completion:( void (^)(NSArray* locations, NSError* aError) )completion;

@end
