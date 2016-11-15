//
//  LocationSearchVC.m
//  RTA
//
//  Created by tomwey on 10/27/16.
//  Copyright © 2016 tomwey. All rights reserved.
//

#import "LocationSearchVC.h"
#import "Defines.h"

@interface LocationSearchVC ()

@end
@implementation LocationSearchVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navBar.title = @"搜索";
    
}

- (NSString *)pageUrl
{
    return self.params[@"pageUrl"];
}

- (BOOL)handleRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    if ( [request.URL.absoluteString rangeOfString:@"addTrip.html"].location != NSNotFound ) {
        if ( self.params[@"returnCallback"] ) {
            void (^returnCallback)(NSString *newUrl) = self.params[@"returnCallback"];
            returnCallback(request.URL.absoluteString);
        }
        [self.navigationController popViewControllerAnimated:YES];
        return NO;
    } else {
        return YES;
    }
}

@end
