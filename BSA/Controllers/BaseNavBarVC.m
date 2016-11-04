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
    
//    self.navBar.backgroundColor = NAV_BAR_BG_COLOR;
    self.navBar.titleTextAttributes = @{ NSForegroundColorAttributeName : AWColorFromRGB(97, 97, 97) };
    
    self.contentView.backgroundColor = AWColorFromRGB(239, 239, 239);
    
    // 添加默认的返回按钮
    __weak typeof(self) me = self;
    [self addLeftBarItemWithImage:@"btn_back.png" callback:^{
      [me back];
    }];
    
    // 添加手势滑动
    UISwipeGestureRecognizer *swipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(back)];
    swipe.direction = UISwipeGestureRecognizerDirectionRight;
    [self.contentView addGestureRecognizer:swipe];
}

//- (UIView *)contentView
//{
//    return self.internalContentView;
//}
//
//- (UIView *)internalContentView
//{
//    if ( !_internalContentView ) {
//        _internalContentView = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
//        [self.view addSubview:_internalContentView];
//        [self.view sendSubviewToBack:_internalContentView];
//        UIImage *image = [[UINavigationBar appearance] backgroundImageForBarMetrics:UIBarMetricsDefault];
//        _internalContentView.top = !!image ? 0 : 64;
//        _internalContentView.height -= 64;
//        
//        if ( self.tabBarController ) {
//            _internalContentView.height -= 49;
//        }
//    }
//    return _internalContentView;
//}

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

- (UIView *)addLeftBarItemWithImage:(NSString *)imageName  callback:(void (^)(void))callback
{
    self.leftItemCallback = callback;
    
    imageName = [imageName trim];
    if ( [imageName length] == 0 ) {
        self.navBar.leftItem = nil;
        return nil;
    } else {
        UIButton *btn = AWCreateImageButton(imageName, self, @selector(btnBack1Clicked:));
        btn.tag = kNavBarLeftItemTag;
        self.navBar.leftItem = btn;//[[UIBarButtonItem alloc] initWithCustomView:btn];
        return btn;
    }
}

- (UIView *)addRightBarItemWithImage:(NSString *)imageName callback:(void (^)(void))callback
{
    self.rightItemCallback = callback;
    
    imageName = [imageName trim];
    if ( [imageName length] == 0 ) {
        self.navBar.rightItem = nil;
        return nil;
    } else {
        UIButton *btn = AWCreateImageButton(imageName, self, @selector(btnBack1Clicked:));
        btn.tag = kNavBarRightItemTag;
        self.navBar.rightItem = btn;//[[UIBarButtonItem alloc] initWithCustomView:btn];
        return btn;
    }
}

- (UIView *)addLeftBarItemWithTitle:(NSString *)title  size:(CGSize)size callback:(void (^)(void))callback
{
    self.leftItemCallback = callback;
    
    title = [title trim];
    if ( title.length == 0 || CGSizeEqualToSize(size, CGSizeZero) ) {
        self.navBar.leftItem = nil;
        return nil;
    } else {
        UIButton *btn = AWCreateTextButton(CGRectMake(0, 0, size.width, size.height),
                                           title,
                                           nil,
                                           self,
                                           @selector(btnBack1Clicked:));
        btn.tag = kNavBarLeftItemTag;
        self.navBar.leftItem = btn;//[[UIBarButtonItem alloc] initWithCustomView:btn];
        return btn;
    }
}

- (UIView *)addRightBarItemWithTitle:(NSString *)title size:(CGSize)size callback:(void (^)(void))callback
{
    self.rightItemCallback = callback;
    
    title = [title trim];
    if ( title.length == 0 || CGSizeEqualToSize(size, CGSizeZero) ) {
        self.navBar.rightItem = nil;
        return nil;
    } else {
        UIButton *btn = AWCreateTextButton(CGRectMake(0, 0, size.width, size.height),
                                           title,
                                           nil,
                                           self,
                                           @selector(btnBack1Clicked:));
        btn.tag = kNavBarRightItemTag;
        self.navBar.rightItem = btn;//[[UIBarButtonItem alloc] initWithCustomView:btn];
        return btn;
    }
}

- (void)addLeftBarItemWithView:(UIView *)aView
{
    if ( aView == nil ) {
        self.navBar.leftItem = nil;
    } else {
        self.navBar.leftItem = aView;
        //[[UIBarButtonItem alloc] initWithCustomView:aView];
    }
}

- (void)addRightBarItemWithView:(UIView *)aView
{
    if ( aView == nil ) {
        self.navBar.rightItem = nil;
    } else {
        self.navBar.rightItem = aView;
        //[[UIBarButtonItem alloc] initWithCustomView:aView];
    }
}

- (void)btnBack1Clicked:(UIButton *)sender
{
    switch (sender.tag) {
        case kNavBarLeftItemTag: {
            if ( self.leftItemCallback ) {
                self.leftItemCallback();
            }
        }
            break;
        case kNavBarRightItemTag: {
            if ( self.rightItemCallback ) {
                self.rightItemCallback();
            }
        }
            break;
            
        default:
            break;
    }
}

@end
