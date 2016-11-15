//
//  CommWebViewVC.h
//  BSA
//
//  Created by tangwei1 on 16/11/10.
//  Copyright © 2016年 tomwey. All rights reserved.
//

#import "BaseNavBarVC.h"
#import "UIWebView+KeyValueStorage.h"

@interface CommWebViewVC : BaseNavBarVC

@property (nonatomic, strong, readonly) UIWebView *webView;

- (NSString *)pageUrl;

- (BOOL)shouldShowLoadingIndicator;

- (BOOL)handleRequest:(NSURLRequest *)request
       navigationType:(UIWebViewNavigationType)navigationType;

@end
