//
//  WalkingView.m
//  RTA
//
//  Created by tangwei1 on 16/10/28.
//  Copyright © 2016年 tomwey. All rights reserved.
//

#import "WalkingView.h"
#import "Defines.h"

@interface WalkingView ()

@property (nonatomic, strong) UIImageView *iconView;
@property (nonatomic, strong) UILabel     *titleLabel;

@end
@implementation WalkingView

- (instancetype)initWithWalkingData:(id)data
{
    if ( self = [super init] ) {
        self.iconView = AWCreateImageView(@"icon_walk.png");
        [self addSubview:self.iconView];
        
        NSInteger distance = [data[@"distance"] integerValue];
        
        self.titleLabel.text = distance < 1000 ? [NSString stringWithFormat:@"步行%@米", data[@"distance"]] :
        [NSString stringWithFormat:@"步行%.1f公里", distance / 1000.0];
    }
    return self;
}

- (UILabel *)titleLabel
{
    if ( !_titleLabel ) {
        _titleLabel = AWCreateLabel(CGRectZero,
                                    nil,
                                    NSTextAlignmentLeft,
                                    AWSystemFontWithSize(15, NO),
                                    AWColorFromRGB(135, 135, 135));
        [self addSubview:_titleLabel];
    }
    return _titleLabel;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.iconView.center = CGPointMake(5 + self.iconView.width / 2, self.height / 2);
    
    for (int i = 0; i < 10; i++) {
        UIImageView *dotView = (UIImageView *)[self viewWithTag:1000 + i];
        if ( !dotView ) {
            dotView = AWCreateImageView(@"icon_walk_l.png");
            [self addSubview:dotView];
            dotView.tag = 1000 + i;
        }
        CGFloat padding = ( self.height - 10 * dotView.height ) / 9.0;
        dotView.position = CGPointMake(self.iconView.right + 13 + dotView.width / 2, ( dotView.height + padding ) * i);
    }
    
    self.titleLabel.frame = CGRectMake(self.iconView.right + 15 + 20, 0, 0, 30);
    self.titleLabel.width = self.width - self.titleLabel.left;
    self.titleLabel.top = self.height / 2 - 15;
}

@end
