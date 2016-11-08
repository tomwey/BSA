//
//  BaseNavBarVC.m
//  deyi
//
//  Created by tangwei1 on 16/9/2.
//  Copyright © 2016年 tangwei1. All rights reserved.
//

#import "BaseNavBarVC.h"
#import "Defines.h"

#define kNavBarLeftItemTag 1011
#define kNavBarRightItemTag 1012

@interface BaseNavBarVC ()

@property (nonatomic, copy, nullable) void (^leftItemCallback)(void);
@property (nonatomic, copy, nullable) void (^rightItemCallback)(void);

@property (nonatomic, strong) UIView *internalContentView;

@end

@implementation BaseNavBarVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.navBar.titleTextAttributes = @{ NSForegroundColorAttributeName : AWColorFromRGB(97, 97, 97) };
    
    self.contentView.backgroundColor = AWColorFromRGB(239, 239, 239);
    
    // 添加默认的返回按钮
    __weak typeof(self) me = self;
    [self addLeftItemWithImage:@"btn_back.png" leftMargin:2 callback:^{
        [me back];
    }];
    
    // 添加手势滑动
    UISwipeGestureRecognizer *swipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(back)];
    swipe.direction = UISwipeGestureRecognizerDirectionRight;
    [self.contentView addGestureRecognizer:swipe];
}

- (void)back
{
    if ( self.navigationController ) {
        if ( [[self.navigationController viewControllers] count] == 1 ) {
            [self.navigationController dismissViewControllerAnimated:YES completion:nil];
        } else {
            // > 1
            [self.navigationController popViewControllerAnimated:YES];
        }
    } else {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

@end
