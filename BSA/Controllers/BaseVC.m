//
//  BaseVC.m
//  deyi
//
//  Created by tangwei1 on 16/9/2.
//  Copyright © 2016年 tangwei1. All rights reserved.
//

#import "BaseVC.h"
#import "Defines.h"

@interface BaseVC ()

@property (nonatomic, strong) LoadingView *loadingView;

@end
@implementation BaseVC

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = MAIN_BG_COLOR;
}

- (void)startLoading:(void (^)(void))reloadCallback
{
    [self.loadingView startLoading:reloadCallback];
}

- (void)finishLoading:(LoadingState)state
{
    [self.loadingView finishLoading:state];
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleDefault;
}

- (BOOL)prefersStatusBarHidden
{
    return NO;
}

//- (UIView *)contentView
//{
//    return self.view;
//}

- (LoadingView *)loadingView
{
    if ( !_loadingView ) {
        _loadingView = [[LoadingView alloc] init];
        [self.contentView addSubview:_loadingView];
        _loadingView.backgroundColor = MAIN_BG_COLOR;
        
        _loadingView.frame = self.contentView.bounds;
    }
    
    [self.contentView bringSubviewToFront:_loadingView];

    return _loadingView;
}

@end
