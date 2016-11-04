//
//  SexPicker.h
//  RTA
//
//  Created by tangwei1 on 16/10/24.
//  Copyright © 2016年 tomwey. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SexPicker : UIView

@property (nonatomic, strong) id selectedSex;

- (void)showInView:(UIView *)superView selectedBlock:(void (^)(SexPicker *sender, id selectedObj))block;

@end
