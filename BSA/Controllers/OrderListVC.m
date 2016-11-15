//
//  OrderListVC.m
//  BSA
//
//  Created by tangwei1 on 16/11/15.
//  Copyright © 2016年 tomwey. All rights reserved.
//

#import "OrderListVC.h"
#import "Defines.h"

@interface OrderListVC ()

@end

@implementation OrderListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navBar.title = @"我的订单";
}

- (NSString *)pageUrl
{
    return [NSString stringWithFormat:@"%@?userid=%@", ORDER_LIST_URL, [[UserService sharedInstance] currentUserAuthToken]];
}

- (BOOL)handleRequest:(NSURLRequest *)request
       navigationType:(UIWebViewNavigationType)navigationType
{
    if ( [request.URL.absoluteString rangeOfString:@"myOrderList.html"].location != NSNotFound ) {
        return YES;
    } else {
        UIViewController *vc = [[AWMediator sharedInstance] openVCWithName:@"BusOrderVC" params:@{ @"pageUrl": request.URL.absoluteString }];
        [self.navigationController pushViewController:vc animated:YES];
        return NO;
    }
}

@end
