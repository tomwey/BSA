//
//  UITextView+AWPlaceholder.m
//  RTA
//
//  Created by tangwei1 on 16/11/7.
//  Copyright © 2016年 tomwey. All rights reserved.
//

#import "UITextView+AWPlaceholder.h"
#import <objc/runtime.h>
#import "NSObject+AWDeallocBlock.h"

@implementation UITextView (AWPlaceholder)

@dynamic placeholder;

static char kPlaceholderLabelKey;

- (UILabel *)placeholderLabel
{
    UILabel *_label = (UILabel *)objc_getAssociatedObject(self, &kPlaceholderLabelKey);
    if ( !_label ) {
        _label = [[UILabel alloc] initWithFrame:CGRectMake(5, -1, self.frame.size.width, 30)];
        objc_setAssociatedObject(self, &kPlaceholderLabelKey, _label, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        [self addSubview:_label];
        _label.textColor = [UIColor colorWithRed:199 / 255.0
                                           green:199 / 255.0
                                            blue:205 / 255.0
                                           alpha:1.0];
        _label.font = [UIFont systemFontOfSize:14];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(textViewTextDidChange:)
                                                     name:UITextViewTextDidChangeNotification
                                                   object:nil];
        
        __weak typeof(self) me = self;
        [self addDeallocBlock:^{
            [[NSNotificationCenter defaultCenter] removeObserver:me name:UITextViewTextDidChangeNotification object:nil];
        }];
    }
    
    [self bringSubviewToFront:_label];
    
    return _label;
}

- (void)textViewTextDidChange:(NSNotification *)noti
{
    if ( self.text.length == 0 ) {
        [self placeholderLabel].hidden = NO;
    } else {
        [self placeholderLabel].hidden = YES;
    }
}

- (void)setPlaceholder:(NSString *)placeholder
{
    [self placeholderLabel].text = placeholder;
}

- (NSString *)placeholder
{
    return [self placeholderLabel].text;
}

@end
