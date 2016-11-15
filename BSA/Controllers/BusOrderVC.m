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

@interface BusOrderVC ()

@end

@implementation BusOrderVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navBar.title = @"线路订购详情";
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(orderPaySuccess)
                                                 name:@"kOrderPaySuccessNotification"
                                               object:nil];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if ( !![[UserService sharedInstance] currentUser] ) {
        // 埋userid到localStorage
        if ( [[self.webView localStorageStringForKey:@"userid"] length] == 0 ) {
            [self.webView setLocalStorageString:[[UserService sharedInstance] currentUserAuthToken] forKey:@"userid"];
        }
    }
}

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

- (BOOL)handleRequest:(NSURLRequest *)request
       navigationType:(UIWebViewNavigationType)navigationType
{
    if ( [request.URL.absoluteString rangeOfString:@"/login.html"].location != NSNotFound &&
         [[self.webView localStorageStringForKey:@"userid"] length] == 0) {
        UIViewController *vc = [[AWMediator sharedInstance] openVCWithName:@"LoginVC" params:nil];
        [self.navigationController pushViewController:vc animated:YES];
        return NO;
    } else if ( [request.URL.absoluteString rangeOfString:@"/pay?"].location != NSNotFound ) {
        NSString *keyValues = [[request.URL.absoluteString componentsSeparatedByString:@"?"] lastObject];
        NSDictionary *params = [keyValues queryDictionaryUsingEncoding:NSUTF8StringEncoding];
        NSLog(@"params: %@", params);
        
        [self sendPayRequest:params];
        
        return NO;
    }
    return YES;
}

- (NSString *)pageUrl
{
    return [NSString stringWithFormat:@"%@&paytype=1", self.params[@"pageUrl"]];
}

@end
