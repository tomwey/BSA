//
//  BusOrderVC.m
//  BSA
//
//  Created by tangwei1 on 16/11/14.
//  Copyright © 2016年 tomwey. All rights reserved.
//

#import "BusOrderVC.h"
#import "Defines.h"

@interface BusOrderVC ()

@end

@implementation BusOrderVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navBar.title = self.params[@"title"];
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

- (BOOL)handleRequest:(NSURLRequest *)request
       navigationType:(UIWebViewNavigationType)navigationType
{
//    if ( navigationType == UIWebViewNavigationTypeOther &&
//        ([request.URL.absoluteString rangeOfString:@"pay/default.aspx"].location != NSNotFound ||
//         [request.URL.absoluteString rangeOfString:@"login.html"].location != NSNotFound)) {
//        if ( ![[UserService sharedInstance] currentUser] || [[self.webView localStorageStringForKey:@"userid"] length] == 0 ) {
//            UIViewController *vc = [[AWMediator sharedInstance] openVCWithName:@"LoginVC" params:nil];
//            [self.navigationController pushViewController:vc animated:YES];
//            return NO;
//        }
//    }
//    NSLog(@"request: %@, type: %d", request, navigationType);
    if ( [request.URL.absoluteString rangeOfString:@"/login.html"].location != NSNotFound &&
         [[self.webView localStorageStringForKey:@"userid"] length] == 0) {
        UIViewController *vc = [[AWMediator sharedInstance] openVCWithName:@"LoginVC" params:nil];
        [self.navigationController pushViewController:vc animated:YES];
        return NO;
    }
    return YES;
}

- (NSString *)pageUrl
{
    return self.params[@"pageUrl"];
}

@end
