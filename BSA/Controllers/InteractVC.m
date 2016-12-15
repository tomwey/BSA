//
//  InteractVC.m
//  RTA
//
//  Created by tangwei1 on 16/10/10.
//  Copyright © 2016年 tomwey. All rights reserved.
//

#import "InteractVC.h"
#import "Defines.h"

@interface InteractVC () <UIWebViewDelegate>

@property (nonatomic, strong) UIWebView *webView;

@property (nonatomic, assign) BOOL loadFail;

@end
@implementation InteractVC

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if ( self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil] ) {
        self.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"互动广场"
                                                        image:[UIImage imageNamed:@"news.png"]
                                                selectedImage:[UIImage imageNamed:@"news_selected.png"]];
    }
    return self;
}

- (void)dealloc
{
    [self.webView removeObserver:self forKeyPath:@"loading"];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
//    self.automaticallyAdjustsScrollViewInsets = YES;
    
//    self.navBar.title = @"互动广场";
    
//    [self addLeftItemWithView:nil];
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.webView = [[UIWebView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:self.webView];
    self.webView.top = 20;
    self.webView.height -= 20;
    self.webView.delegate = self;
    
    self.webView.scalesPageToFit = YES;
    
    [self.webView removeGrayBackground];
//    self.webView.backgroundColor = [UIColor redColor];
    
//    self.webView.scrollView.contentInset = UIEdgeInsetsMake(-20, 0, 0, 0);
    
//    [self.webView addObserver:self
//                   forKeyPath:@"loading"
//                      options:NSKeyValueObservingOptionNew
//                      context:NULL];
    if ( !AWOSVersionIsLower(9.0) ) {
        [self removeWebViewCompatity];
    }
    
//    dispatch_async(dispatch_get_main_queue(), ^{
        [self startLoad];
//    });
    
}

//- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
//{
//    if ( self.webView.isLoading ) {
//        
//    } else {
//        [MBProgressHUD hideAllHUDsForView:self.contentView animated:YES];
//    }
//}

//- (void)viewWillAppear:(BOOL)animated
//{
//    [super viewWillAppear:animated];
//    
////    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
//    
//    if ( self.loadFail ) {
//        [self startLoad];
//    }
//    
////    if ( !AWOSVersionIsLower(9.0) ) {
////        [self removeWebViewCompatity];
////    }
//}

- (void)startLoad
{
//    [MBProgressHUD showHUDAddedTo:self.contentView animated:YES];
    
    NSURL *pageURL = [NSURL URLWithString:SQUARE_LIST_URL];
    [self.webView loadRequest:[NSURLRequest requestWithURL:pageURL]];
}

- (void)removeWebViewCompatity
{
    self.webView.scrollView.contentInset = UIEdgeInsetsMake(-20, 0, 0, 0);
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    __weak typeof(self) me = self;
    [self startLoadingInView:self.contentView
           forStateViewClass:[AWLoadingStateView class]
              reloadCallback:^{
        [me startLoad];
    }];
}

- (BOOL)webView:(UIWebView *)webView
shouldStartLoadWithRequest:(NSURLRequest *)request
 navigationType:(UIWebViewNavigationType)navigationType
{
    if ( [[request.URL absoluteString] isEqualToString:SQUARE_LIST_URL] ) {
        return YES;
    }
    
    WebViewVC *vc = [[WebViewVC alloc] initWithURL:request.URL title:@"详情"];
    vc.pageBackBlock = ^(id data) {
        [self removeWebViewCompatity];
    };
    [self.tabBarController.navigationController pushViewController:vc animated:YES];
    
    return NO;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
//    self.loadFail = NO;
//    [MBProgressHUD hideAllHUDsForView:self.contentView animated:YES];
    [self finishLoading:AWLoadingStateSuccess];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [self finishLoading:AWLoadingStateFailure];
//    self.loadFail = YES;
//    [MBProgressHUD hideAllHUDsForView:self.contentView animated:YES];
//    [self.contentView makeToast:@"Oops, 出错了！" duration:2.0 position:CSToastPositionTop];
}

@end
