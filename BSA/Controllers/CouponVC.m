//
//  CouponVC.m
//  BSA
//
//  Created by tangwei1 on 16/11/15.
//  Copyright © 2016年 tomwey. All rights reserved.
//

#import "CouponVC.h"
#import "Defines.h"

@interface CouponVC ()

@end

@implementation CouponVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navBar.title = @"优惠券";
}

- (NSString *)pageUrl
{
    return COUPON_LIST_URL;
}

- (BOOL)handleRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    if ( [request.URL.absoluteString isEqualToString:COUPON_LIST_URL] ) {
        return YES;
    } else {
        UIViewController *vc = [[AWMediator sharedInstance] openVCWithName:@"CouponGetVC" params:@{ @"pageUrl": request.URL.absoluteString }];
        [self.navigationController pushViewController:vc animated:YES];
        return NO;
    }
}

@end
