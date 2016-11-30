//
//  BusCell.m
//  RTA
//
//  Created by tangwei1 on 16/10/25.
//  Copyright © 2016年 tomwey. All rights reserved.
//

#import "BusCell.h"
#import "Defines.h"

@interface BusCell ()

@property (nonatomic, strong) UIView *containerView;

// 班车编号
@property (nonatomic, strong) UILabel *busNoLabel;

// 班车开行年月
@property (nonatomic, strong) UILabel *onlineDateLabel;

// 始发站
@property (nonatomic, strong) UILabel *startNameLabel;

// 始发站地址
@property (nonatomic, strong) UILabel *startAddressLabel;

// 开车时间
@property (nonatomic, strong) UILabel *startTimeLabel;

// 水平线
@property (nonatomic, strong) AWHairlineView *horizontalLine;

// 垂直线
@property (nonatomic, strong) AWHairlineView *verticalLine1;
@property (nonatomic, strong) AWHairlineView *verticalLine2;

// 终到站
@property (nonatomic, strong) UILabel *endNameLabel;

// 终到站地址
@property (nonatomic, strong) UILabel *endAddressLabel;

// 到站时间
@property (nonatomic, strong) UILabel *endTimeLabel;

// 班车简介
@property (nonatomic, strong) UILabel *busIntroLabel;

// 预定时间
@property (nonatomic, strong) UILabel *orderTimeTipLabel;

// 余票
@property (nonatomic, strong) UILabel *leftTicketsLabel;

@property (nonatomic, strong) id selectedData;

@property (nonatomic, copy) void (^didSelectBlock)(UIView<AWTableDataConfig> *sender, id selectedData);

@end
@implementation BusCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if ( self = [super initWithStyle:style reuseIdentifier:reuseIdentifier] ) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)configData:(id)data selectBlock:(void (^)(UIView<AWTableDataConfig> *sender, id selectedData))selectBlock
{
    NSLog(@"data: %@", data);
//    {
//        BaseData = 0;
//        BeginTime = "07:50";
//        BusNo = "<null>";
//        BusType = "\U5927\U578b\U5ba2\U8f66";
//        CarrierNo = 0;
//        CouponPrice = "<null>";
//        CouponValue = "<null>";
//        CurrentPrice = "<null>";
//        DistanceMileage = 0;
//        DistanceTime = 0;
//        EndTime = "08:45";
//        LeastTicket = 34;
//        LineInfo = "<null>";
//        LineName = "\U5353\U9526\U57ce-\U5929\U5e9c\U8f6f\U4ef6\U56ed";
//        LineNo = B006;
//        MaxPrice = 0;
//        MinPrice = 0;
//        Month = 12;
//        MonthType = 1;
//        OrderedCount = 0;
//        PrimePrice = "<null>";
//        PublishTime = "<null>";
//        RedunNo = 0;
//        RemainderNo = 0;
//        SalesPackageID = "<null>";
//        SalesPackageValue = 0;
//        StartStation = "\U6d77\U68e0\U8def\U559c\U6811\U8857\U53e3";
//        StartTime = "<null>";
//        StopStation = "\U5929\U534e\U4e8c\U8def";
//        StopTime = "<null>";
//        TimeName = "48\U592919\U5c0f\U65f634\U5206\U949f";
//        TimeType = 2;
//        VipData = 0;
//        Year = 2016;
//    }
    self.selectedData = data;
    self.didSelectBlock = selectBlock;
    
    // 设置班车编号
    self.busNoLabel.text = [[data valueForKey:@"LineNo"] description];
    
    // 设置班车开行年月
    NSString *string = [NSString stringWithFormat:@"%@月\n%@年",
                        [data valueForKey:@"Month"],
                        [data valueForKey:@"Year"]
                        ];
    NSMutableAttributedString *attrText = [[NSMutableAttributedString alloc] initWithString:string];
    NSRange range = [string rangeOfString:@"月"];
    [attrText addAttributes:@{ NSFontAttributeName: AWSystemFontWithSize(20, NO) }
                      range:NSMakeRange(0, range.location)];
    self.onlineDateLabel.attributedText = attrText;
    
//    LineName
    NSArray *lineNames = [[[data valueForKey:@"LineName"] description] componentsSeparatedByString:@"-"];
    
    // 设置始发站信息
    self.startNameLabel.text = [lineNames firstObject];
    self.startAddressLabel.text = [[data valueForKey:@"StartStation"] description];
    self.startTimeLabel.text = [[data valueForKey:@"BeginTime"] description];
    
    // 设置终到站信息
    self.endNameLabel.text = [lineNames lastObject];
    self.endAddressLabel.text = [[data valueForKey:@"StopStation"] description];
    self.endTimeLabel.text = [[data valueForKey:@"EndTime"] description];
    
    // 班车简介
    self.busIntroLabel.text = [[data valueForKey:@"BusType"] description];
    
    // 余票
    NSString *leftTicket = [NSString stringWithFormat:@"余%@张", [data valueForKey: @"LeastTicket"]];
    attrText = [[NSMutableAttributedString alloc] initWithString:leftTicket];
    [attrText addAttributes:@{ NSFontAttributeName: AWSystemFontWithSize(20, NO), NSForegroundColorAttributeName: self.startNameLabel.textColor }
                      range:NSMakeRange(1, attrText.string.length - 2)];
    self.leftTicketsLabel.attributedText = attrText;
    
    // 预定时间提醒
    if ( [[data valueForKey:@"TimeName"] description].length == 0 ) {
        self.orderTimeTipLabel.text = @"已结束";
    } else {
        NSString *timeReminder = [NSString stringWithFormat:@"还有%@订购结束", [data valueForKey:@"TimeName"]];
        attrText = [[NSMutableAttributedString alloc] initWithString:timeReminder];
        [attrText addAttributes:@{ NSForegroundColorAttributeName: AWColorFromRGB(247, 152, 39) }
                          range:NSMakeRange(2, attrText.string.length - 6)];
        self.orderTimeTipLabel.attributedText = attrText;
    }
    
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.containerView.frame = CGRectMake(0, 15, self.width, self.height - 15);
    
    CGFloat padding = 15;
    self.busNoLabel.frame = CGRectMake(padding, padding, 50, 30);
    
    self.onlineDateLabel.frame = CGRectMake(0, 0, self.busNoLabel.width, 60);
    self.onlineDateLabel.top = self.containerView.height - 15 - self.onlineDateLabel.height;
    self.onlineDateLabel.left = self.busNoLabel.left;
    
    // 始发站信息
    CGFloat width = 100;//( self.containerView.width - self.busNoLabel.right - 10 - padding - 20 ) / 2 ;
    self.startNameLabel.frame = CGRectMake(0, 0, width, 30);
    self.startNameLabel.left  = self.busNoLabel.right + 10;
    self.startNameLabel.top   = padding - 5;
    
    self.startAddressLabel.frame = self.startNameLabel.frame;
    self.startAddressLabel.top   = self.startNameLabel.bottom - 6;
    
    width = ( self.containerView.width - self.busNoLabel.right - 10 - 20 ) / 3;
    self.startTimeLabel.frame = CGRectMake(0, 0, width, 30);
    self.startTimeLabel.left  = self.startNameLabel.left;
    self.startTimeLabel.top   = self.startAddressLabel.bottom + 5;
    
    // 水平线
    self.horizontalLine.center = CGPointMake(self.startNameLabel.right - 10 + self.horizontalLine.width / 2,
                                             self.startNameLabel.midY);
    
    // 垂直线1
//    self.verticalLine1.center = CGPointMake(self.startTimeLabel.right,
//                                            self.startTimeLabel.midY);
    
    // 终到站信息
    self.endNameLabel.frame = self.startNameLabel.frame;
    self.endNameLabel.left  = self.horizontalLine.right + 5;
    
    self.endAddressLabel.frame = self.endNameLabel.frame;
    self.endAddressLabel.top = self.endNameLabel.bottom - 6;
    
    self.endTimeLabel.frame = self.startTimeLabel.frame;
    self.endTimeLabel.left  = self.endNameLabel.left;
    
    // 垂直线2
//    self.verticalLine2.center = CGPointMake(self.endTimeLabel.right,
//                                            self.endTimeLabel.midY);
    
    // 余票
    self.leftTicketsLabel.frame = self.endTimeLabel.frame;
    self.leftTicketsLabel.left  = self.containerView.width - padding - self.leftTicketsLabel.width;
    
    // 简介
    self.busIntroLabel.frame = self.startNameLabel.frame;
    self.busIntroLabel.top   = self.containerView.height - self.busIntroLabel.height - 10;
    
    // 预定时间提醒
    self.orderTimeTipLabel.frame = self.busIntroLabel.frame;
    self.orderTimeTipLabel.width += 30;
    self.orderTimeTipLabel.left  = self.width - 30 - self.orderTimeTipLabel.width;
}

- (void)tap
{
    if ( self.didSelectBlock ) {
        self.didSelectBlock(self, self.selectedData);
    }
}

- (UIView *)containerView
{
    if ( !_containerView ) {
        _containerView = [[UIView alloc] init];
        [self.contentView addSubview:_containerView];
        _containerView.backgroundColor = [UIColor whiteColor];

        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap)];
        [_containerView addGestureRecognizer:tap];
    }
    return _containerView;
}

- (UILabel *)busNoLabel
{
    if ( !_busNoLabel ) {
        _busNoLabel = AWCreateLabel(CGRectZero,
                                    nil,
                                    NSTextAlignmentCenter,
                                    AWSystemFontWithSize(15, NO),
                                    [UIColor whiteColor]);
        [self.containerView addSubview:_busNoLabel];
        _busNoLabel.backgroundColor = MAIN_BLUE_COLOR;
    }
    return _busNoLabel;
}

- (UILabel *)onlineDateLabel
{
    if ( !_onlineDateLabel ) {
        _onlineDateLabel = AWCreateLabel(CGRectZero,
                                      nil,
                                      NSTextAlignmentCenter,
                                      AWSystemFontWithSize(14, NO),
                                      AWColorFromRGB(83,83,83));
        [self.containerView addSubview:_onlineDateLabel];
        _onlineDateLabel.numberOfLines = 2;
    }
    return _onlineDateLabel;
}

- (UILabel *)startNameLabel
{
    if ( !_startNameLabel ) {
        _startNameLabel = AWCreateLabel(CGRectZero,
                                        nil,
                                        NSTextAlignmentLeft,
                                        AWSystemFontWithSize(16, NO),
                                        AWColorFromRGB(39, 39, 39));
        [self.containerView addSubview:_startNameLabel];
    }
    return _startNameLabel;
}

- (UILabel *)startAddressLabel
{
    if ( !_startAddressLabel ) {
        _startAddressLabel = AWCreateLabel(CGRectZero,
                                       nil,
                                       NSTextAlignmentLeft,
                                       AWSystemFontWithSize(13, YES),
                                       AWColorFromRGB(135, 135, 135));
        [self.containerView addSubview:_startAddressLabel];
    }
    return _startAddressLabel;
}

- (UILabel *)startTimeLabel
{
    if ( !_startTimeLabel ) {
        _startTimeLabel = AWCreateLabel(CGRectZero,
                                         nil,
                                         NSTextAlignmentLeft,
                                         self.startNameLabel.font,
                                         self.startNameLabel.textColor);
        [self.containerView addSubview:_startTimeLabel];
    }
    return _startTimeLabel;
}

- (UILabel *)endNameLabel
{
    if ( !_endNameLabel ) {
        _endNameLabel = AWCreateLabel(CGRectZero,
                                        nil,
                                        NSTextAlignmentLeft,
                                        AWSystemFontWithSize(16, NO),
                                        AWColorFromRGB(39, 39, 39));
        [self.containerView addSubview:_endNameLabel];
    }
    return _endNameLabel;
}

- (UILabel *)endAddressLabel
{
    if ( !_endAddressLabel ) {
        _endAddressLabel = AWCreateLabel(CGRectZero,
                                           nil,
                                           NSTextAlignmentLeft,
                                           AWSystemFontWithSize(13, YES),
                                           AWColorFromRGB(135, 135, 135));
        [self.containerView addSubview:_endAddressLabel];
    }
    return _endAddressLabel;
}

- (UILabel *)endTimeLabel
{
    if ( !_endTimeLabel ) {
        _endTimeLabel = AWCreateLabel(CGRectZero,
                                        nil,
                                        NSTextAlignmentLeft,
                                        self.startNameLabel.font,
                                        self.startNameLabel.textColor);
        [self.containerView addSubview:_endTimeLabel];
    }
    return _endTimeLabel;
}

- (UILabel *)busIntroLabel
{
    if ( !_busIntroLabel ) {
        _busIntroLabel = AWCreateLabel(CGRectZero,
                                         nil,
                                         NSTextAlignmentLeft,
                                         AWSystemFontWithSize(13, YES),
                                         AWColorFromRGB(135, 135, 135));
        [self.containerView addSubview:_busIntroLabel];
    }
    return _busIntroLabel;
}

- (UILabel *)orderTimeTipLabel
{
    if ( !_orderTimeTipLabel ) {
        _orderTimeTipLabel = AWCreateLabel(CGRectZero,
                                       nil,
                                       NSTextAlignmentRight,
                                       AWSystemFontWithSize(13, YES),
                                       AWColorFromRGB(135, 135, 135));
        [self.containerView addSubview:_orderTimeTipLabel];
    }
    return _orderTimeTipLabel;
}

- (UILabel *)leftTicketsLabel
{
    if ( !_leftTicketsLabel ) {
        _leftTicketsLabel = AWCreateLabel(CGRectZero,
                                       nil,
                                       NSTextAlignmentRight,
                                       AWSystemFontWithSize(14, YES),
                                       AWColorFromRGB(135, 135, 135));
        [self.containerView addSubview:_leftTicketsLabel];
    }
    return _leftTicketsLabel;
}

- (AWHairlineView *)horizontalLine
{
    if ( !_horizontalLine ) {
        _horizontalLine = [AWHairlineView horizontalLineWithWidth:10
                                                            color:self.startNameLabel.textColor
                                                           inView:self.containerView];
    }
    return _horizontalLine;
}

- (AWHairlineView *)verticalLine1
{
    if ( !_verticalLine1 ) {
        _verticalLine1 = [AWHairlineView verticalLineWithHeight:10
                                                          color:self.startAddressLabel.textColor
                                                         inView:self.containerView];
    }
    return _verticalLine1;
}

- (AWHairlineView *)verticalLine2
{
    if ( !_verticalLine2 ) {
        _verticalLine2 = [AWHairlineView verticalLineWithHeight:10
                                                          color:self.startAddressLabel.textColor
                                                         inView:self.containerView];
    }
    return _verticalLine2;
}


@end
