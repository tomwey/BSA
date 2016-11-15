//
//  CommWebViewVC.m
//  BSA
//
//  Created by tangwei1 on 16/11/10.
//  Copyright © 2016年 tomwey. All rights reserved.
//

#import "CommWebViewVC.h"
#import "Defines.h"

@interface CommWebViewVC () <UIWebViewDelegate>

@property (nonatomic, strong, readwrite) UIWebView *webView;

@end

@implementation CommWebViewVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.webView = [[UIWebView alloc] init];
    [self.contentView addSubview:self.webView];
    self.webView.frame = self.contentView.bounds;
    
    self.webView.scalesPageToFit = YES;
    
    self.webView.delegate = self;
    
    [self.webView removeGrayBackground];
    
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[self pageUrl]]]];
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    [self startLoadingInView:self.contentView
           forStateViewClass:[AWLoadingStateView class]
              reloadCallback:^{
                  
              }];
//    [MBProgressHUD showHUDAddedTo:self.contentView animated:YES];
}

- (NSString *)pageUrl
{
    return nil;
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    return [self handleRequest:request navigationType:navigationType];
}

- (BOOL)handleRequest:(NSURLRequest *)request
       navigationType:(UIWebViewNavigationType)navigationType
{
    return YES;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [self finishLoading:AWLoadingStateSuccess];
//    [MBProgressHUD hideAllHUDsForView:self.contentView animated:YES];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(nullable NSError *)error
{
    [self finishLoading:AWLoadingStateFailure];
//    [MBProgressHUD hideAllHUDsForView:self.contentView animated:YES];
}

@end
