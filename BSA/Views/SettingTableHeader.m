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
        self.frame = CGRectMake(0, 0, AWFullScreenWidth(), 120);
        
        UIImageView *bgView = AWCreateImageView(@"setting_user_bg.png");
        [self addSubview:bgView];
        
        bgView.contentMode = UIViewContentModeScaleAspectFill;
        bgView.clipsToBounds = YES;
        
        bgView.frame = self.bounds;
        
        [self addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap)]];
    }
    return self;
}

- (void)tap
{
    if ( self.didSelectCallback ) {
        self.didSelectCallback(self);
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
    
    self.avatarView.center = CGPointMake(15 + self.avatarView.width / 2, self.height / 2);
    
    self.arrowView.center  = CGPointMake(self.width - 15 - self.arrowView.width / 2, self.avatarView.midY);
    
    self.nickname.frame    = CGRectMake(self.avatarView.right + 10, self.avatarView.midY - 34 / 2,
                                        self.arrowView.left - 10 - self.avatarView.right - 10,
                                        34);
}

- (UIImageView *)avatarView
{
    if ( !_avatarView ) {
        _avatarView = AWCreateImageView(@"default_avatar.png");
        [self addSubview:_avatarView];
        _avatarView.frame = CGRectMake(0, 0, 64, 64);
        _avatarView.cornerRadius = _avatarView.height / 2;
    }
    return _avatarView;
}

- (UILabel *)nickname
{
    if ( !_nickname ) {
        _nickname = AWCreateLabel(CGRectZero, @"请登录",
                                  NSTextAlignmentLeft,
                                  AWSystemFontWithSize(20, NO),
                                  [UIColor whiteColor]);
        [self addSubview:_nickname];
    }
    return _nickname;
}

- (UIImageView *)arrowView
{
    if ( !_arrowView ) {
        _arrowView = AWCreateImageView(@"setting_user_arrow.png");
        [self addSubview:_arrowView];
    }
    return _arrowView;
}

@end
