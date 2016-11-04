//
//  BusLineDetailVC.m
//  RTA
//
//  Created by tangwei1 on 16/10/28.
//  Copyright © 2016年 tomwey. All rights reserved.
//

#import "BusLineDetailVC.h"
#import "Defines.h"
#import "WalkingView.h"
#import "BusLineView.h"

@interface BusLineDetailVC ()

@property (nonatomic, strong) UIScrollView *buslineContentView;

@end

@implementation BusLineDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navBar.title = @"路线详情";
    
    id buslineInfo = self.params[@"busline"];
    
    CGFloat padding = 15;
    
    UILabel *titleLabel = AWCreateLabel(CGRectMake(padding, padding,
                                                   self.contentView.width - padding * 2,
                                                   30),
                                        buslineInfo[@"formated_title"],
                                        NSTextAlignmentLeft,
                                        AWSystemFontWithSize(20, NO),
                                        AWColorFromRGB(57, 57, 57));
    [self.contentView addSubview:titleLabel];
    
    // body
    UILabel *bodyLabel = AWCreateLabel(CGRectMake(padding, titleLabel.bottom + 10,
                                                  titleLabel.width,
                                                  titleLabel.height),
                                       buslineInfo[@"formated_body"],
                                       NSTextAlignmentLeft,
                                       AWSystemFontWithSize(15, NO),
                                       AWColorFromRGB(135, 135, 135));
    [self.contentView addSubview:bodyLabel];
    
    // 线
    AWHairlineView *horizontalLine = [AWHairlineView horizontalLineWithWidth:self.contentView.width
                                                                       color:CONTENT_VIEW_BG_COLOR
                                                                      inView:self.contentView];
    horizontalLine.center = CGPointMake(self.contentView.width / 2, 95);
    
    // 添加路线详情
    [self addBuslineContents];
}

- (void)addBuslineContents
{
    self.buslineContentView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 105, self.contentView.width,
                                                                             self.contentView.height - 95)];
    [self.contentView addSubview:self.buslineContentView];
    
    CGFloat top = 10;
    // 添加起点
    UIImageView *startIconView = AWCreateImageView(@"icon_start.png");
    [self.buslineContentView addSubview:startIconView];
    startIconView.center = CGPointMake(73 + startIconView.width / 2, top + startIconView.height / 2);
    
    UILabel *startLabel = AWCreateLabel(CGRectZero,
                                        nil,
                                        NSTextAlignmentLeft,
                                        AWSystemFontWithSize(15, NO),
                                        AWColorFromRGB(135, 135, 135));
    [self.buslineContentView addSubview:startLabel];
    startLabel.frame = CGRectMake(startIconView.right + 14, startIconView.center.y - 15,
                                     self.buslineContentView.width - startIconView.right - 15 - 20,
                                     30);
    
    startLabel.text = [NSString stringWithFormat:@"起点(%@)", self.params[@"startName"]];
    
    top = startIconView.bottom;
    
    // 添加中间步骤
    NSArray *segments = self.params[@"busline"][@"segments"];
    for (id seg in segments) {
        id walking = seg[@"walking"];
        if ( walking ) {
            WalkingView *wView = [[WalkingView alloc] initWithWalkingData:walking];
            [self.buslineContentView addSubview:wView];
            wView.frame = CGRectMake(15, top + 5, self.contentView.width - 30, 60);
            top = wView.bottom + 5;
        }
        
        id busline = [seg[@"bus"][@"buslines"] firstObject];
        if ( busline ) {
            BusLineView *bView = [[BusLineView alloc] initWithBuslineData:busline];
            [self.buslineContentView addSubview:bView];
            bView.frame = CGRectMake(15, top, self.contentView.width - 30,
                                     150);
            top = bView.bottom;
        }
    }
    
    // 添加终点
    UIImageView *endIconView = AWCreateImageView(@"icon_end.png");
    [self.buslineContentView addSubview:endIconView];
    endIconView.center = CGPointMake(73 + endIconView.width / 2, top + endIconView.height / 2);
    
    UILabel *endLabel = AWCreateLabel(CGRectZero,
                                        nil,
                                        NSTextAlignmentLeft,
                                        AWSystemFontWithSize(15, NO),
                                        AWColorFromRGB(135, 135, 135));
    [self.buslineContentView addSubview:endLabel];
    endLabel.frame = CGRectMake(endIconView.right + 14, endIconView.center.y - 15,
                                  self.buslineContentView.width - endIconView.right - 15 - 20,
                                  30);
    
    endLabel.text = [NSString stringWithFormat:@"终点(%@)", self.params[@"endName"]];
    
    top = endIconView.bottom;
    
    self.buslineContentView.contentSize = CGSizeMake(self.contentView.width, top + 30);
}

@end
