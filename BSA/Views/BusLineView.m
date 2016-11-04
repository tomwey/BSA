//
//  BusLineView.m
//  RTA
//
//  Created by tangwei1 on 16/10/28.
//  Copyright © 2016年 tomwey. All rights reserved.
//

#import "BusLineView.h"
#import "Defines.h"

@interface BusLineView ()

@property (nonatomic, strong) UIImageView *iconView;
@property (nonatomic, strong) UILabel     *startLabel;
@property (nonatomic, strong) UILabel     *totalLabel;
@property (nonatomic, strong) UILabel     *endLabel;

@property (nonatomic, strong) UIImageView *startIconView;
@property (nonatomic, strong) AWHairlineView *verticalLine;
@property (nonatomic, strong) UIImageView *endIconView;

@end

@implementation BusLineView

- (instancetype)initWithBuslineData:(id)buslineData
{
    if ( self = [super init] ) {
        self.iconView = AWCreateImageView(@"icon_bus.png");
        [self addSubview:self.iconView];
        
        self.startIconView = AWCreateImageView(@"icon_bus_l.png");
        [self addSubview:self.startIconView];
        
        self.endIconView = AWCreateImageView(@"icon_bus_l.png");
        [self addSubview:self.endIconView];
        
        self.startLabel.text = [NSString stringWithFormat:@"%@ 上车", buslineData[@"departure_stop"][@"name"]];
        self.totalLabel.text = [NSString stringWithFormat:@"共%@站", buslineData[@"via_num"]];
        self.endLabel.text   = [NSString stringWithFormat:@"%@ 下车",buslineData[@"arrival_stop"][@"name"]];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.iconView.center = CGPointMake(5 + self.iconView.width / 2, self.height / 2);
    
    self.startIconView.position = CGPointMake(self.iconView.right + 15, 0);
    self.endIconView.position = CGPointMake(self.startIconView.left,
                                            self.height - self.endIconView.height);
    
    if ( !self.verticalLine ) {
        self.verticalLine = [AWHairlineView verticalLineWithHeight:self.endIconView.top - self.startIconView.bottom
                                                             color:AWColorFromRGB(28, 167, 145)
                                                            inView:self];
    }
    self.verticalLine.center = CGPointMake(self.startIconView.midX, self.height / 2);
    
    self.startLabel.frame = CGRectMake(self.startIconView.right + 15,
                                       0,
                                       self.width - self.startIconView.right - 20,
                                       30);
    self.totalLabel.frame = self.startLabel.frame;
    self.totalLabel.top = self.height / 2 - self.totalLabel.height / 2;
    
    self.endLabel.frame = self.startLabel.frame;
    self.endLabel.top = self.height - self.endLabel.height;
}

- (UILabel *)startLabel
{
    if ( !_startLabel ) {
        _startLabel = AWCreateLabel(CGRectZero,
                                    nil,
                                    NSTextAlignmentLeft,
                                    AWSystemFontWithSize(15, NO),
                                    AWColorFromRGB(135, 135, 135));
        [self addSubview:_startLabel];
    }
    return _startLabel;
}

- (UILabel *)totalLabel
{
    if ( !_totalLabel ) {
        _totalLabel = AWCreateLabel(CGRectZero,
                                    nil,
                                    NSTextAlignmentLeft,
                                    AWSystemFontWithSize(15, NO),
                                    AWColorFromRGB(135, 135, 135));
        [self addSubview:_totalLabel];
    }
    return _totalLabel;
}

- (UILabel *)endLabel
{
    if ( !_endLabel ) {
        _endLabel = AWCreateLabel(CGRectZero,
                                    nil,
                                    NSTextAlignmentLeft,
                                    AWSystemFontWithSize(15, NO),
                                    AWColorFromRGB(135, 135, 135));
        [self addSubview:_endLabel];
    }
    return _endLabel;
}

@end
