//
//  CouponGetVC.m
//  BSA
//
//  Created by tangwei1 on 16/11/15.
//  Copyright © 2016年 tomwey. All rights reserved.
//

#import "CouponGetVC.h"
#import "Defines.h"

@interface CouponGetVC ()

@end

@implementation CouponGetVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navBar.title = @"领取优惠券";
}

- (NSString *)pageUrl
{
    return self.params[@"pageUrl"];
}

- (BOOL)handleRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    if ( [request.URL.absoluteString rangeOfString:@"/get_coupon.html"].location != NSNotFound ) {
        return YES;
    } else {
        return NO;
    }
}

@end
