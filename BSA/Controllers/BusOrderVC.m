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
    
    self.navBar.title = @"订购";
    
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
        if ( [resultDic[@"resultStatus"] integerValue] == 9000 ) {
            //                [self.window makeToast:@"支付宝支付成功" duration:2.0 position:CSToastPositionTop];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"kOrderPaySuccessNotification" object:nil];
        } else {
            [AWAppWindow() makeToast:@"支付宝支付失败" duration:2.0 position:CSToastPositionTop];
        }
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
    } else if ( [request.URL.absoluteString hasPrefix:@"alipay://"] ) {
        
        self.fromLogin = NO;
        
        NSString *orderString = [[request.URL.absoluteString componentsSeparatedByString:@"?"] lastObject];
        NSDictionary *result = [orderString queryDictionaryUsingEncoding:NSUTF8StringEncoding];
        
        NSString *newOrderString = [NSString stringWithFormat:@"partner=\"%@\"&seller_id=\"%@\"&out_trade_no=\"%@\"&subject=\"%@\"&body=\"%@\"&total_fee=\"%@\"&notify_url=\"%@\"&service=\"%@\"&payment_type=\"%@\"&_input_charset=\"%@\"&it_b_pay=\"%@\"&sign=\"%@\"&sign_type=\"%@\"",
                                    result[@"partner"],
                                    result[@"seller_id"],
                                    result[@"out_trade_no"],
                                    result[@"subject"],
                                    result[@"body"],
                                    result[@"total_fee"],
                                    result[@"notify_url"],
                                    result[@"service"],
                                    result[@"payment_type"],
                                    result[@"_input_charset"],
                                    result[@"it_b_pay"],
//                                    result[@"show_url"],
                                    [result[@"sign"] URLEncode],
                                    result[@"sign_type"] ];
        
        NSLog(@"orderString: %@", newOrderString);
        
        [self sendAlipay:newOrderString];

        return NO;
    } else if ( [request.URL.absoluteString hasPrefix:@"weixin://"] ) {
        
        self.fromLogin = NO;
        
        NSString *keyValues = [[request.URL.absoluteString componentsSeparatedByString:@"?"] lastObject];
        NSDictionary *params = [keyValues queryDictionaryUsingEncoding:NSUTF8StringEncoding];
        NSLog(@"params: %@", params);
        
        [self sendPayRequest:params];
        
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
