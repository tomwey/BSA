//
//  CommWebViewVC.h
//  BSA
//
//  Created by tangwei1 on 16/11/10.
//  Copyright © 2016年 tomwey. All rights reserved.
//

#import "BaseNavBarVC.h"

@interface CommWebViewVC : BaseNavBarVC

- (NSString *)pageUrl;

- (BOOL)handleRequest:(NSURLRequest *)request forWebView:(UIWebView *)webView;

@end
