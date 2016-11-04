//
//  DatePicker.m
//  RTA
//
//  Created by tangwei1 on 16/10/24.
//  Copyright © 2016年 tomwey. All rights reserved.
//

#import "DatePicker.h"
#import "Defines.h"

@interface DatePicker ()

@property (nonatomic, strong) UIToolbar    *toolbar;
@property (nonatomic, strong) UIDatePicker *datePicker;

@property (nonatomic, strong) UIView *maskView;
@property (nonatomic, strong) UIView *contentView;

@property (nonatomic, copy) void (^selectedBlock)(DatePicker *sender, NSDate *selectedDate);

@end

@implementation DatePicker

- (instancetype)initWithFrame:(CGRect)frame
{
    if ( self = [super initWithFrame:frame] ) {
        
        self.frame = AWFullScreenBounds();
        
        self.maskView = [[UIView alloc] initWithFrame:self.bounds];
        [self addSubview:self.maskView];
        
        self.maskView.backgroundColor = [UIColor blackColor];
        self.maskView.alpha = 0.0;
        
        self.contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.width, 244)];
        [self addSubview:self.contentView];
        self.contentView.backgroundColor = [UIColor whiteColor];
        
        self.toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, AWFullScreenWidth(), 44)];
        [self.contentView addSubview:self.toolbar];
        
        self.toolbar.items = @[[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
                                                                             target:self
                                                                             action:@selector(dismiss)],
                               [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                                                             target:nil
                                                                             action:nil],
                               [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                                                             target:self
                                                                             action:@selector(done)]
                               ];
        self.toolbar.barTintColor = IOS_DEFAULT_CELL_SEPARATOR_LINE_COLOR;
        
        self.datePicker = [[UIDatePicker alloc] init];
        self.datePicker.frame = CGRectMake(0, self.toolbar.bottom, self.contentView.width, self.contentView.height - 44);
        self.datePicker.datePickerMode = UIDatePickerModeDate;
        [self.contentView addSubview:self.datePicker];
        
        NSCalendar *calendar = [NSCalendar currentCalendar];
        
        NSDateComponents *comp = [[NSDateComponents alloc] init];
        comp.year = 1900;
        comp.month = 1;
        comp.day = 1;
        [calendar dateFromComponents:comp];
        
        self.datePicker.minimumDate = [calendar dateFromComponents:comp];
        self.datePicker.maximumDate = [NSDate date];
    }
    return self;
}

- (void)showInView:(UIView *)superView selectedBlock:(void (^)(DatePicker *sender, NSDate *selectedDate))block
{
    self.selectedBlock = block;
    
    if ( !self.superview ) {
        [superView addSubview:self];
    }
    
    [superView bringSubviewToFront:self];
    
    self.contentView.position = CGPointMake(0, AWFullScreenHeight());
    
    self.maskView.alpha = 0.0;
    
    AWSetAllTouchesDisabled(YES);
    
    [UIView animateWithDuration:.3 animations:^{
        self.contentView.position = CGPointMake(0, AWFullScreenHeight() - self.contentView.height);
        self.maskView.alpha = 0.6;
    } completion:^(BOOL finished) {
        AWSetAllTouchesDisabled(NO);
    }];
}

- (void)done
{
    if ( self.selectedBlock ) {
        self.selectedBlock(self, self.datePicker.date);
    }
    
    [self dismiss];
}

- (void)dismiss
{
    AWSetAllTouchesDisabled(YES);
    
    [UIView animateWithDuration:.3 animations:^{
        self.contentView.position = CGPointMake(0, AWFullScreenHeight());
        self.maskView.alpha = 0.0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        AWSetAllTouchesDisabled(NO);
    }];
}

@end
