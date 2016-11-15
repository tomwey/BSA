//
//  ContactVC.m
//  BSA
//
//  Created by tangwei1 on 16/11/15.
//  Copyright © 2016年 tomwey. All rights reserved.
//

#import "ContactVC.h"
#import "Defines.h"

@interface ContactVC ()

@end

@implementation ContactVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navBar.title = @"联系信息";
}

- (NSString *)pageUrl
{
    return self.params[@"pageUrl"];
}

- (BOOL)handleRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    if ( [request.URL.absoluteString isEqualToString:self.pageUrl] ) {
        return YES;
    } else {
        void (^returnCallback)(NSString *newUrl) = self.params[@"returnCallback"];
        if ( returnCallback ) {
            returnCallback(request.URL.absoluteString);
        }
        [self.navigationController popViewControllerAnimated:YES];
        return NO;
    }
}

@end
