//
//  SettingTableHeader.m
//  RTA
//
//  Created by tangwei1 on 16/10/10.
//  Copyright © 2016年 tomwey. All rights reserved.
//

#import "SettingTableHeader.h"
#import "Defines.h"

@interface SettingTableHeader ()

@property (nonatomic, strong) UIImageView *avatarView;
@property (nonatomic, strong) UILabel     *nickname;
@property (nonatomic, strong) UIImageView *arrowView;

@end

@implementation SettingTableHeader

- (instancetype)initWithFrame:(CGRect)frame
{
    if ( self = [super initWithFrame:frame] ) {
        UIImageView *bgView = AWCreateImageView(nil);
        [self addSubview:bgView];
        bgView.image = AWImageNoCached(@"setting_head_bg.png");
        
        self.frame = bgView.frame = CGRectMake(0, 0, AWFullScreenWidth(), 192);
        
        bgView.contentMode = UIViewContentModeScaleAspectFill;
        bgView.clipsToBounds = YES;
        
        [self addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)]];
    }
    return self;
}

- (void)tap:(UIGestureRecognizer *)sender
{
    CGPoint location = [sender locationInView:self];
    if ( CGRectContainsPoint(self.avatarView.frame, location) ||
        CGRectContainsPoint(self.nickname.frame, location)) {
        if ( self.didSelectCallback ) {
            self.didSelectCallback(self);
        }
    }
}

- (void)setCurrentUser:(User *)currentUser
{
    _currentUser = currentUser;
    
    NSURL *url = !!currentUser.avatar ? [NSURL URLWithString:currentUser.avatar] : nil;
    [self.avatarView setImageWithURL:url placeholderImage:[UIImage imageNamed:@"default_avatar.png"]];
    
    self.nickname.text = currentUser ? [currentUser formatUsername] : @"请登录";
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.avatarView.center = CGPointMake(self.width / 2, self.height / 2 - 20);
    
//    self.arrowView.center  = CGPointMake(self.width - 15 - self.arrowView.width / 2, self.avatarView.midY);
    
    self.nickname.frame    = CGRectMake(0, 0, 150, 40);
    self.nickname.center   = CGPointMake(self.width / 2, self.avatarView.bottom + 10 + self.nickname.height / 2);
}

- (UIImageView *)avatarView
{
    if ( !_avatarView ) {
        _avatarView = AWCreateImageView(@"default_avatar.png");
        [self addSubview:_avatarView];
//        _avatarView.frame = CGRectMake(0, 0, 64, 64);
        _avatarView.cornerRadius = _avatarView.height / 2;
    }
    return _avatarView;
}

- (UILabel *)nickname
{
    if ( !_nickname ) {
        _nickname = AWCreateLabel(CGRectZero, @"请登录",
                                  NSTextAlignmentCenter,
                                  AWSystemFontWithSize(20, NO),
                                  AWColorFromRGB(131, 131, 131));
        [self addSubview:_nickname];
        _nickname.backgroundColor = [UIColor whiteColor];
        _nickname.alpha = 0.9;
        
        _nickname.cornerRadius = 6;
    }
    return _nickname;
}

@end
