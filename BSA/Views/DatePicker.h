//
//  DatePicker.h
//  RTA
//
//  Created by tangwei1 on 16/10/24.
//  Copyright © 2016年 tomwey. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DatePicker : UIView

- (void)showInView:(UIView *)superView selectedBlock:(void (^)(DatePicker *sender, NSDate *selectedDate))block;

@end
