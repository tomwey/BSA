//
//  ApplyBusVC.m
//  BSA
//
//  Created by tangwei1 on 16/11/10.
//  Copyright © 2016年 tomwey. All rights reserved.
//

#import "ApplyBusVC.h"
#import "Defines.h"

@interface ApplyBusVC ()

@property (nonatomic, assign) BOOL shouldShowLoading;

@end

@implementation ApplyBusVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navBar.title = @"我要包车";
    
    self.shouldShowLoading = YES;
}

- (NSString *)pageUrl
{
    return APPLY_BUS_URL;
}

- (BOOL)shouldShowLoadingIndicator
{
    return self.shouldShowLoading;
}

- (BOOL)handleRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    if ( [request.URL.absoluteString isEqualToString:APPLY_BUS_URL] ) {
        return YES;
    } else if ([request.URL.absoluteString rangeOfString:@"index.html"].location != NSNotFound) {
        [self.navigationController popViewControllerAnimated:YES];
        return NO;
    } else {
        NSString *pageName = nil;
        if ( [request.URL.absoluteString rangeOfString:@"tripList.html"].location != NSNotFound ) {
            pageName = @"TripListVC";
        } else if ( [request.URL.absoluteString rangeOfString:@"CAContactSet.html"].location != NSNotFound ) {
            pageName = @"ContactVC";
//            http://tadi.adgom.cn:9091/BSH/CAContactSet.html?code=101&msg=%E6%88%90%E5%8A%9F&type=contactor&value=
//            http://tadi.adgom.cn:9091/BSH/CAContactSet.html?code=101&msg=%E6%88%90%E5%8A%9F&type=phone&value=
        }
        
        if ( !pageName ) {
            return YES;
        } else {
            void (^returnCallback)(NSString *newUrl) = ^(NSString *newUrl){
                self.shouldShowLoading = NO;
                [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:newUrl]
                                                           cachePolicy:NSURLRequestReloadIgnoringCacheData
                                                       timeoutInterval:30.0]];
            };
            UIViewController *vc = [[AWMediator sharedInstance] openVCWithName:pageName params:@{ @"pageUrl": request.URL.absoluteString, @"returnCallback": returnCallback }];
            [self.navigationController pushViewController:vc animated:YES];
            return NO;
        }
    }
}

@end
