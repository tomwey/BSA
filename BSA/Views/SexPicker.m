//
//  SexPicker.m
//  RTA
//
//  Created by tangwei1 on 16/10/24.
//  Copyright © 2016年 tomwey. All rights reserved.
//

#import "SexPicker.h"
#import "Defines.h"

@interface SexPicker () <UIPickerViewDataSource, UIPickerViewDelegate>

@property (nonatomic, strong) UIToolbar    *toolbar;
@property (nonatomic, strong) UIPickerView *sexPicker;

@property (nonatomic, strong) UIView *maskView;
@property (nonatomic, strong) UIView *contentView;

@property (nonatomic, strong) NSArray *sexDataSource;
@property (nonatomic, strong) NSMutableDictionary *currentSelectedSex;

@property (nonatomic, copy) void (^selectedBlock)(SexPicker *sender, id selectedSex);

@end

@implementation SexPicker

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
        
        self.sexDataSource  = @[@"男", @"女"];
        
        self.sexPicker = [[UIPickerView alloc] init];
        self.sexPicker.frame = CGRectMake(0, self.toolbar.bottom, self.contentView.width,
                                          self.contentView.height - 44);
        self.sexPicker.dataSource = self;
        self.sexPicker.delegate   = self;
        [self.contentView addSubview:self.sexPicker];
        
        [self.sexPicker selectRow:[[self.selectedSex valueForKey:@"value"] integerValue]
                      inComponent:0
                         animated:YES];
        
        self.currentSelectedSex = [@{ @"label": @"男", @"value": @(0) } mutableCopy];
    }
    return self;
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return [self.sexDataSource count];
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return self.sexDataSource[row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    [self.currentSelectedSex setValue:self.sexDataSource[row] forKey:@"label"];
    [self.currentSelectedSex setValue:@(row) forKey:@"value"];
}

- (void)showInView:(UIView *)superView selectedBlock:(void (^)(SexPicker *sender, id selectedSex))block
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
        self.selectedBlock(self, self.currentSelectedSex);
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
