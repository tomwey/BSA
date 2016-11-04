//
//  BusLineCell.m
//  RTA
//
//  Created by tangwei1 on 16/10/28.
//  Copyright © 2016年 tomwey. All rights reserved.
//

#import "BusLineCell.h"
#import "Defines.h"

@interface BusLineCell ()

@property (nonatomic, strong) UIView *container;

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *bodyLabel;
//@property (nonatomic, strong) UILabel *stationsNumLabel;
//@property (nonatomic, strong) UILabel *walkingDistanceLabel;

@property (nonatomic, copy) void (^clickBlock)(UIView<AWTableDataConfig> *sender, id selectedData);

@property (nonatomic, strong) id currentData;

@end
@implementation BusLineCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if ( self = [super initWithStyle:style reuseIdentifier:reuseIdentifier] ) {
        self.backgroundColor = [UIColor clearColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

- (void)configData:(id)data selectBlock:(void (^)(UIView<AWTableDataConfig> *sender, id selectedData))selectBlock
{
    self.clickBlock = selectBlock;
    
    NSDictionary *busLineInfo = [self parseBusLineInfo:data];
//    • › 〉
    NSLog(@"%@", [data valueForKey:@"walking_distance"]);
    id obj = [data valueForKey:@"walking_distance"];
    
    NSInteger distance;
    if ( [obj isKindOfClass:[NSNumber class]] ||
        [obj isKindOfClass:[NSString class]]) {
        distance = [obj intValue];
    } else {
        distance = 0;
    }
    self.titleLabel.text = [self composeLineInfo:[busLineInfo objectForKey:@"names"]];
    self.bodyLabel.text = [NSString stringWithFormat:@"%@ • %d站 • %@",
                           [self formatDuration:[[data valueForKey:@"duration"] doubleValue]],
                           [[busLineInfo objectForKey:@"total"] intValue],
                           [self formatWalkingDistance:distance]];
    
    NSMutableDictionary *dict = [data mutableCopy];
    
    [dict setObject:self.titleLabel.text forKey:@"formated_title"];
    [dict setObject:self.bodyLabel.text forKey:@"formated_body"];
    
    self.currentData = [dict copy];
}

- (void)tap
{
    if ( self.clickBlock ) {
        self.clickBlock(self, self.currentData);
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat padding = 10;
    self.container.frame = CGRectMake(padding, padding,
                                      self.width - padding * 2,
                                      80);
    self.titleLabel.frame = CGRectMake(15, 10, self.container.width - 30,
                                       30);
    self.bodyLabel.frame = self.titleLabel.frame;
    self.bodyLabel.top = self.titleLabel.bottom;
}

- (NSDictionary *) parseBusLineInfo:(id)data
{
    NSMutableDictionary *temp = [@{} mutableCopy];
    
    id segments = data[@"segments"];
    if ( [segments isKindOfClass:[NSArray class]] ) {
        NSInteger total = 0;
        NSMutableArray *lines = [NSMutableArray array];
        for (id seg in segments) {
            id buslines = [seg objectForKey:@"bus"];
            id buslinesArr  = [buslines objectForKey:@"buslines"];
            if ( buslinesArr && [buslinesArr isKindOfClass:[NSArray class]] ) {
                if ( [buslinesArr count] > 0 ) {
                    id busline = [buslinesArr firstObject];
                    
                    //                NSLog(@"busline: %@", busline);
                    total += [busline[@"via_num"] integerValue];
                    NSString *name = [busline[@"name"] description];
                    
                    NSInteger location = [name rangeOfString:@"("].location;
                    if ( location != NSNotFound ) {
                        name = [name substringToIndex:location];
                    }
                    
                    [lines addObject:name];
                }
            }
        }
        
        [temp setObject:@(total) forKey:@"total"];
        [temp setObject:lines forKey:@"names"];
        
//        NSLog(@"temp: %@", temp);
    }
    
    return [temp copy];
}

- (NSString *)composeLineInfo:(NSArray *)names
{
    return [names componentsJoinedByString:@" › "];
}

- (NSString *)formatDuration:(NSTimeInterval)duration
{
    NSInteger hour = duration / 3600;
    NSInteger minutes = ( duration - hour * 3600 ) / 60;
    
    if ( hour > 0 ) {
        if ( minutes > 0 ) {
            return [NSString stringWithFormat:@"%ld小时%ld分钟", (long)hour, (long)minutes];
        } else {
            return [NSString stringWithFormat:@"%ld小时", (long)hour];
        }
    } else {
        return [NSString stringWithFormat:@"%ld分钟", (long)minutes];
    }
}

- (NSString *)formatWalkingDistance:(int)distance
{
    NSString *formatString = distance < 1000 ? [NSString stringWithFormat:@"步行%d米", distance]
    : [NSString stringWithFormat:@"步行%.1f公里", distance / 1000.0];
    return formatString;
}

- (UIView *)container
{
    if ( !_container ) {
        _container = [[UIView alloc] init];
        [self.contentView addSubview:_container];
        _container.backgroundColor = [UIColor whiteColor];
        _container.cornerRadius = 4;
        
        [_container addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap)]];
    }
    return _container;
}

- (UILabel *)titleLabel
{
    if ( !_titleLabel ) {
        _titleLabel = AWCreateLabel(CGRectZero,
                                    nil,
                                    NSTextAlignmentLeft,
                                    AWSystemFontWithSize(20, NO),
                                    AWColorFromRGB(57, 57, 57));
        [self.container addSubview:_titleLabel];
    }
    return _titleLabel;
}

- (UILabel *)bodyLabel
{
    if ( !_bodyLabel ) {
        _bodyLabel = AWCreateLabel(CGRectZero, nil,
                                   NSTextAlignmentLeft,
                                   AWSystemFontWithSize(15, NO),
                                   AWColorFromRGB(135, 135, 135));
        [self.container addSubview:_bodyLabel];
    }
    return _bodyLabel;
}

@end
