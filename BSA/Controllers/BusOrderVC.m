//
//  BusOrderVC.m
//  BSA
//
//  Created by tangwei1 on 16/11/14.
//  Copyright © 2016年 tomwey. All rights reserved.
//

#import "BusOrderVC.h"
#import "Defines.h"
#import "WXApiObject.h"
#import "WXApi.h"
#import <AlipaySDK/AlipaySDK.h>

@interface BusOrderVC ()

@property (nonatomic, assign) BOOL fromLogin;

@end

@implementation BusOrderVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navBar.title = @"线路订购详情";
    
    self.fromLogin = NO;
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(orderPaySuccess)
                                                 name:@"kOrderPaySuccessNotification"
                                               object:nil];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (self.fromLogin) {
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:[self pageUrl]]
                                                 cachePolicy:NSURLRequestReloadIgnoringLocalCacheData
                                             timeoutInterval:30.0];
        [self.webView loadRequest:request];
    }
}

//- (BOOL)shouldShowLoadingIndicator
//{
//    return !self.fromLogin;
//}

- (void)orderPaySuccess
{
    void (^returnCallback)(NSString *newUrl) = self.params[@"returnCallback"];
    if ( !returnCallback ) {
        // forward
        UIViewController *vc = [[AWMediator sharedInstance] openVCWithName:@"OrderListVC" params:nil];
        [self.navigationController pushViewController:vc animated:YES];
    } else {
        // back
        returnCallback(nil);
        [self.navigationController popViewControllerAnimated:YES];
    }
}

// 微信支付
- (void)sendPayRequest:(NSDictionary *)orderParams
{
    PayReq *request   = [[PayReq alloc] init];
    request.partnerId = @"1284047701";
    request.prepayId  = orderParams[@"prepayid"];
    request.package   = @"Sign=WXPay";
    request.nonceStr  = orderParams[@"noncestr"];
    request.timeStamp = [orderParams[@"timestamp"] intValue];
    request.sign      = orderParams[@"sign"];
    [WXApi sendReq:request];
}
// alipaybsa
// 支付宝支付
- (void)sendAlipay:(NSString *)orderString
{
    [[AlipaySDK defaultService] payOrder:orderString fromScheme:@"alipaybsa" callback:^(NSDictionary *resultDic) {
        NSLog(@"--> resultDic: %@", resultDic);
    }];;
}

- (BOOL)handleRequest:(NSURLRequest *)request
       navigationType:(UIWebViewNavigationType)navigationType
{
    if ( [request.URL.absoluteString rangeOfString:@"/login.html"].location != NSNotFound &&
        ![[UserService sharedInstance] currentUser]) {
        self.fromLogin = YES;
        UIViewController *vc = [[AWMediator sharedInstance] openVCWithName:@"LoginVC" params:nil];
        [self.navigationController pushViewController:vc animated:YES];
        return NO;
    } else if ( [request.URL.absoluteString rangeOfString:@"/pay?"].location != NSNotFound ) {
        NSString *keyValues = [[request.URL.absoluteString componentsSeparatedByString:@"?"] lastObject];
        NSDictionary *params = [keyValues queryDictionaryUsingEncoding:NSUTF8StringEncoding];
        NSLog(@"params: %@", params);
        
        [self sendPayRequest:params];
        
        self.fromLogin = NO;
        
        return NO;
    }
    
    self.fromLogin = NO;
    
    return YES;
}

- (NSString *)pageUrl
{
    return [NSString stringWithFormat:@"%@&paytype=1&userid=%@", self.params[@"pageUrl"],
            !![[UserService sharedInstance] currentUser] ? [[UserService sharedInstance] currentUserAuthToken] : @"302"];
}

@end
