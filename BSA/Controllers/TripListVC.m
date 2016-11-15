//
//  TripListVC.m
//  BSA
//
//  Created by tangwei1 on 16/11/15.
//  Copyright © 2016年 tomwey. All rights reserved.
//

#import "TripListVC.h"
#import "Defines.h"

@interface TripListVC ()

@end

@implementation TripListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navBar.title = @"行程";
    
    __weak typeof(self) me = self;
    [self addRightItemWithImage:@"add_trip.png" rightMargin:5 callback:^{
        void (^returnCallback)(NSString *newUrl) = ^(NSString *url){
            [me.webView reload];
        };
        UIViewController *vc = [[AWMediator sharedInstance] openVCWithName:@"AddTripVC" params:@{ @"returnCallback": returnCallback }];
        [me.navigationController pushViewController:vc animated:YES];
    }];
}

- (NSString *)pageUrl
{
    return self.params[@"pageUrl"];
}

- (BOOL)handleRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    if ( [request.URL.absoluteString rangeOfString:@"carAppointment.html"].location != NSNotFound ) {
        void (^returnCallback)(NSString *newUrl) = self.params[@"returnCallback"];
        if ( returnCallback ) {
            returnCallback(request.URL.absoluteString);
        }
        [self.navigationController popViewControllerAnimated:YES];
        return NO;
    }
    return YES;
}

@end
