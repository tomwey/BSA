//
//  InputCell.h
//  RTA
//
//  Created by tangwei1 on 16/10/27.
//  Copyright © 2016年 tomwey. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InputCell : UIView

@property (nonatomic, copy) NSString *title;

@property (nonatomic, copy) NSDictionary *titleAttributes;

@property (nonatomic, copy) void (^clickBlock)(InputCell *sender);

- (instancetype)initWithIcon:(NSString *)iconName title:(NSString *)title;

@end
