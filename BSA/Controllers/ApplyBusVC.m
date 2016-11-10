//
//  ApplyBusVC.m
//  BSA
//
//  Created by tangwei1 on 16/11/10.
//  Copyright © 2016年 tomwey. All rights reserved.
//

#import "ApplyBusVC.h"
#import "Defines.h"

@interface ApplyBusVC ()

@end

@implementation ApplyBusVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navBar.title = @"我要包车";
}

- (NSString *)pageUrl
{
    return APPLY_BUS_URL;
}

- (BOOL)handleRequest:(NSURLRequest *)request forWebView:(UIWebView *)webView
{
    if ( [request.URL.absoluteString isEqualToString:APPLY_BUS_URL] ) {
        return YES;
    }
    
    return NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
