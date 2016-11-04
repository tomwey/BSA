//
//  BaseNavBarVC.h
//  deyi
//
//  Created by tangwei1 on 16/9/2.
//  Copyright © 2016年 tangwei1. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseVC.h"

@interface BaseNavBarVC : BaseVC

- (UIView *)addLeftBarItemWithImage:(NSString *)imageName  callback:(void (^)(void))callback;
- (UIView *)addRightBarItemWithImage:(NSString *)imageName callback:(void (^)(void))callback;

- (UIView *)addLeftBarItemWithTitle:(NSString *)title  size:(CGSize)size callback:(void (^)(void))callback;
- (UIView *)addRightBarItemWithTitle:(NSString *)title size:(CGSize)size callback:(void (^)(void))callback;

- (void)addLeftBarItemWithView:(UIView *)aView;
- (void)addRightBarItemWithView:(UIView *)aView;

@end
