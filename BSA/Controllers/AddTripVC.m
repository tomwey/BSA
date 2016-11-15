//
//  AddTripVC.m
//  BSA
//
//  Created by tangwei1 on 16/11/15.
//  Copyright © 2016年 tomwey. All rights reserved.
//

#import "AddTripVC.h"
#import "Defines.h"

@interface AddTripVC ()

@property (nonatomic, assign) BOOL shouldShowLoading;

@end

@implementation AddTripVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navBar.title = @"添加行程";
    
    self.shouldShowLoading = YES;
}

- (NSString *)pageUrl
{
    return ADD_TRIP_URL;
}

- (BOOL)handleRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    if ( [request.URL.absoluteString isEqualToString:ADD_TRIP_URL] ) {
        return YES;
    } else {
        if ( [request.URL.absoluteString rangeOfString:@"addTripSearch.html"].location != NSNotFound ) {
            void (^returnCallback)(NSString *newUrl) = ^(NSString *newUrl) {
                self.shouldShowLoading = NO;
                [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:newUrl] cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:30.0]];
            };
            UIViewController *vc = [[AWMediator sharedInstance] openVCWithName:@"LocationSearchVC" params:@{ @"pageUrl": request.URL.absoluteString, @"returnCallback": returnCallback }];
            [self.navigationController pushViewController:vc animated:YES];
            return NO;
        } else if ( [request.URL.absoluteString rangeOfString:@"tripList.html"].location != NSNotFound ) {
            void (^returnCallback)(NSString *newUrl) = self.params[@"returnCallback"];
            if ( returnCallback ) {
                returnCallback(request.URL.absoluteString);
            }
            
            [self.navigationController popViewControllerAnimated:YES];
            return NO;
        } else {
            return YES;
        }
    }
}

- (BOOL)shouldShowLoadingIndicator
{
    return self.shouldShowLoading;
}

@end
