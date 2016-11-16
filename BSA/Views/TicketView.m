//
//  TicketView.m
//  BSA
//
//  Created by tangwei1 on 16/11/16.
//  Copyright © 2016年 tomwey. All rights reserved.
//

#import "TicketView.h"
#import "Defines.h"
#import "UIImage+MDQRCode.h"

@interface TicketView ()

@property (nonatomic, strong) UILabel *stationLabel;

@property (nonatomic, strong) UIImageView *bgView;

@property (nonatomic, strong) UIImageView *qrcodeView;
@property (nonatomic, strong) UILabel *validTimeLabel;

@property (nonatomic, strong) UIImageView *busIconView;
@property (nonatomic, strong) UILabel *busTypeLabel;

@end

@implementation TicketView

- (void)setTicketData:(id)ticketData
{
    if ( _ticketData == ticketData )
        return;
    
    _ticketData = ticketData;
    
    if ( _ticketData ) {
        [self updateContent];
    }
}

- (void)updateContent
{
    //                    BeginTime = "2016-11-01";
    //                    BusType = "\U4e2d\U578b\U5ba2\U8f66";
    //                    BusTypePic = "http://182.150.21.101:9091/Images/BS/BusType/zhong.png";
    //                    EndTime = "2016-11-30";
    //                    MD5 = "";
    //                    StartStation = "\U6d77\U68e0\U8def\U559c\U6811\U8857\U53e3";
    //                    StopStation = "\U5929\U534e\U4e8c\U8def";
    self.stationLabel.text = [NSString stringWithFormat:@"%@ — %@",
                              [self.ticketData valueForKey:@"StartStation"],
                              [self.ticketData valueForKey:@"StopStation"]];
    self.validTimeLabel.text = [NSString stringWithFormat:@"使用日期: %@ - %@",
                                [[[self.ticketData valueForKey:@"BeginTime"] description] stringByReplacingOccurrencesOfString:@"-" withString:@"/"],
                                [[[self.ticketData valueForKey:@"EndTime"] description] stringByReplacingOccurrencesOfString:@"-" withString:@"/"]];
    
    [self.busIconView setImageWithURL:[NSURL URLWithString:[[self.ticketData valueForKey:@"BusTypePic"] description]]];
    
    self.busTypeLabel.text = [[self.ticketData valueForKey:@"BusType"] description];
    [self.busTypeLabel sizeToFit];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.stationLabel.frame = CGRectMake(0, 0, self.width, 40);
    
    self.bgView.frame = CGRectMake(0, self.stationLabel.bottom, self.width, self.width * 1.393);
    
    CGFloat qrcodeWidth = self.bgView.width * 400 / 580.0;
    self.qrcodeView.frame = CGRectMake(self.bgView.width / 2 - qrcodeWidth / 2,
                                       self.bgView.width / 2 - qrcodeWidth / 2,
                                       qrcodeWidth, qrcodeWidth);
    if ( [self.ticketData valueForKey:@"MD5"] ) {
        self.qrcodeView.image = [UIImage mdQRCodeForString:[[self.ticketData valueForKey:@"MD5"] description]
                                                      size:self.qrcodeView.width];
    }
    
    CGFloat height = self.bgView.width * 105 / 580.0;
    self.validTimeLabel.frame = CGRectMake(0, self.bgView.height - height, self.bgView.width, height);
    
    CGFloat dtHeight = self.bgView.width * 145 / 580.0;
    
    self.busIconView.frame = CGRectMake(0, 0,  32, 16);
    self.busIconView.center = CGPointMake(self.bgView.width / 2, self.validTimeLabel.top - dtHeight / 2);
    
    if ( [self.ticketData valueForKey:@"BusType"] ) {
        CGFloat dtWidth = self.busTypeLabel.width + self.busIconView.width + 5;
        CGFloat dtx = self.bgView.width / 2 - dtWidth / 2;
        self.busIconView.left = dtx;
        
        self.busTypeLabel.left = self.busIconView.right + 5;
        self.busTypeLabel.top  = self.busIconView.midY - self.busTypeLabel.height / 2;
    }
}

- (UILabel *)stationLabel
{
    if ( !_stationLabel ) {
        _stationLabel = AWCreateLabel(CGRectZero,
                                      nil,
                                      NSTextAlignmentCenter,
                                      AWSystemFontWithSize(16, NO),
                                      AWColorFromRGB(112, 112, 112));
        [self addSubview:_stationLabel];
    }
    return _stationLabel;
}

- (UIImageView *)bgView
{
    if ( !_bgView ) {
        _bgView = AWCreateImageView(nil);
        [self addSubview:_bgView];
        _bgView.image = AWImageNoCached(@"ticket_bg.png");
    }
    return _bgView;
}

- (UIImageView *)qrcodeView
{
    if ( !_qrcodeView ) {
        _qrcodeView = AWCreateImageView(nil);
        [self.bgView addSubview:_qrcodeView];
    }
    return _qrcodeView;
}

- (UILabel *)validTimeLabel
{
    if ( !_validTimeLabel ) {
        _validTimeLabel = AWCreateLabel(CGRectZero,
                                        nil,
                                        NSTextAlignmentCenter,
                                        AWSystemFontWithSize(14, NO),
                                        [UIColor whiteColor]);
        [self.bgView addSubview:_validTimeLabel];
    }
    return _validTimeLabel;
}

- (UIImageView *)busIconView
{
    if ( !_busIconView ) {
        _busIconView = AWCreateImageView(nil);
        [self.bgView addSubview:_busIconView];
    }
    return _busIconView;
}

- (UILabel *)busTypeLabel
{
    if ( !_busTypeLabel ) {
        _busTypeLabel = AWCreateLabel(CGRectZero,
                                        nil,
                                        NSTextAlignmentCenter,
                                        AWSystemFontWithSize(14, NO),
                                        AWColorFromRGB(135, 135, 135));
        [self.bgView addSubview:_busTypeLabel];
    }
    return _busTypeLabel;
}

@end
