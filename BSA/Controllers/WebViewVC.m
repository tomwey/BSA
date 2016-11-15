//
//  WebViewVC.m
//  RTA
//
//  Created by tangwei1 on 16/10/24.
//  Copyright © 2016年 tomwey. All rights reserved.
//

#import "WebViewVC.h"
#import "Defines.h"

@interface WebViewVC () <UIWebViewDelegate>

@property (nonatomic, strong) UIWebView *webView;
@property (nonatomic, strong) NSURL     *pageURL;
@property (nonatomic, copy)   NSString  *pageTitle;

@end

@implementation WebViewVC

- (instancetype)initWithURL:(NSURL *)pageURL title:(NSString *)title
{
    if ( self = [super init] ) {
        self.pageURL = pageURL;
        self.pageTitle = title;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navBar.title = self.pageTitle;
    
    self.webView = [[UIWebView alloc] init];
    [self.contentView addSubview:self.webView];
    self.webView.frame = self.contentView.bounds;
    
    self.webView.scalesPageToFit = YES;
    
    self.webView.delegate = self;
    
    [self.webView removeGrayBackground];
    
    [self.webView loadRequest:[NSURLRequest requestWithURL:self.pageURL]];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    if ( self.pageBackBlock ) {
        self.pageBackBlock(nil);
    }
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    [MBProgressHUD showHUDAddedTo:self.contentView animated:YES];
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request
 navigationType:(UIWebViewNavigationType)navigationType
{
    NSLog(@"type: %d, %@", navigationType, request);
    return YES;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [MBProgressHUD hideAllHUDsForView:self.contentView animated:YES];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(nullable NSError *)error
{
    [MBProgressHUD hideAllHUDsForView:self.contentView animated:YES];
}

@end
