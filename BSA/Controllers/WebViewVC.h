//
//  WebViewVC.h
//  RTA
//
//  Created by tangwei1 on 16/10/24.
//  Copyright © 2016年 tomwey. All rights reserved.
//

#import "BaseNavBarVC.h"

@interface WebViewVC : BaseNavBarVC

- (instancetype)initWithURL:(NSURL *)pageURL title:(NSString *)title;

@property (nonatomic, copy) void (^pageBackBlock)(id data);

@end
