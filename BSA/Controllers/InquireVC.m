//
//  InquireVC.m
//  RTA
//
//  Created by tangwei1 on 16/10/10.
//  Copyright © 2016年 tomwey. All rights reserved.
//

#import "InquireVC.h"
#import "Defines.h"

@interface InquireVC () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) Location *startLocation;
@property (nonatomic, strong) Location *endLocation;

@property (nonatomic, weak) AWButton *okButton;

@property (nonatomic, strong) UITableView *historiesTable;
@property (nonatomic, strong) NSArray *dataSource;

@end

@implementation InquireVC

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if ( self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil] ) {
        self.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"换乘"
                                                        image:[UIImage imageNamed:@"inquire.png"]
                                                selectedImage:[UIImage imageNamed:@"inquire_selected.png"]];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navBar.title = @"换乘";
    
    [self addLeftBarItemWithView:nil];
    
    self.contentView.backgroundColor = CONTENT_VIEW_BG_COLOR;
    
    UIView *inputBg = [[UIView alloc] initWithFrame:CGRectMake(10, 10, self.contentView.width - 20, 108)];
    inputBg.backgroundColor = [UIColor whiteColor];
    inputBg.cornerRadius = 6;
    [self.contentView addSubview:inputBg];
    
    InputCell *startCell = [[InputCell alloc] initWithIcon:@"icon_start.png" title:@"我的位置"];
    [inputBg addSubview:startCell];
    startCell.frame = CGRectMake(15, 0, inputBg.width - 30, inputBg.height / 2);
    startCell.titleAttributes = @{ NSForegroundColorAttributeName: AWColorFromRGBA(50, 69, 255, 0.9) };
    
    if ( ![[AWLocationManager sharedInstance] currentLocation] ) {
        startCell.title = @"未定位";
    } else {
        self.startLocation = [[Location alloc] initWithCoordinate:[[AWLocationManager sharedInstance] currentLocation].coordinate title:@"我的位置"];
//        self.startCoordinate = [[AWLocationManager sharedInstance] currentLocation].coordinate;
    }
    
    __weak typeof(self) me = self;
    startCell.clickBlock = ^(InputCell *sender) {
        
        void (^selectLocationBlock)(id location) = ^(id location) {
            NSLog(@"%@", location);
            //    {
            //        "ad_info" =     {
            //            adcode = 650502;
            //            city = "\U54c8\U5bc6\U5e02";
            //            district = "\U4f0a\U5dde\U533a";
            //            province = "\U65b0\U7586\U7ef4\U543e\U5c14\U81ea\U6cbb\U533a";
            //        };
            //        address = "\U65b0\U7586\U7ef4\U543e\U5c14\U81ea\U6cbb\U533a\U54c8\U5bc6\U5e02\U4f0a\U5dde\U533a\U4e8c\U5821\U6536\U8d39\U7ad9\U5411\U897f500\U7c73\U5904\U8def\U5357";
            //        category = "\U6c7d\U8f66:\U52a0\U6cb9\U7ad9:\U5176\U5b83\U52a0\U6cb9\U7ad9";
            //        id = 2133268359532900694;
            //        location =     {
            //            lat = "43.01545";
            //            lng = "93.15819999999999";
            //        };
            //        tel = " ";
            //        title = "\U542b\U9526\U4e8c\U5821L-CNG\U52a0\U6c14\U5357\U7ad9";
            //        type = 0;
            //    }
            sender.title = [location valueForKey:@"title"];
            
            CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake([[[location valueForKey:@"location"] valueForKey:@"lat"] doubleValue],
                                                                           [[[location valueForKey:@"location"] valueForKey:@"lng"] doubleValue]);
            self.startLocation = [[Location alloc] initWithCoordinate:coordinate title:[location valueForKey:@"title"]];
            
        };
        UIViewController *vc = [[AWMediator sharedInstance] openVCWithName:@"LocationSearchVC" params:@{ @"selectBlock": selectLocationBlock }];
        [me.tabBarController.navigationController pushViewController:vc animated:YES];
    };
    
    // 加一根线
    AWHairlineView *line = [AWHairlineView horizontalLineWithWidth:inputBg.width
                                                             color:self.contentView.backgroundColor
                                                            inView:inputBg];
    line.center = CGPointMake(inputBg.width / 2, inputBg.height / 2);
    
    InputCell *endCell = [[InputCell alloc] initWithIcon:@"icon_end.png"
                                                   title:@"你要去哪儿？"];
    [inputBg addSubview:endCell];
    endCell.frame = startCell.frame;
    endCell.top = startCell.bottom;
    
    endCell.titleAttributes = @{ NSForegroundColorAttributeName: AWColorFromRGB(135,135,135) };
    endCell.clickBlock = ^(InputCell *sender) {
        void (^selectLocationBlock)(id location) = ^(id location) {
//            NSLog(@"%@", location);
            sender.title = [location valueForKey:@"title"];
            
            CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake([[[location valueForKey:@"location"] valueForKey:@"lat"] doubleValue],
                                                                           [[[location valueForKey:@"location"] valueForKey:@"lng"] doubleValue]);
            self.endLocation = [[Location alloc] initWithCoordinate:coordinate title:[location valueForKey:@"title"]];
        };
        UIViewController *vc = [[AWMediator sharedInstance] openVCWithName:@"LocationSearchVC" params:@{ @"selectBlock": selectLocationBlock }];
        [me.tabBarController.navigationController pushViewController:vc animated:YES];
    };
    
    // 确定
    AWButton *okButton = [AWButton buttonWithTitle:@"确定" color:NAV_BAR_BG_COLOR];
    [self.contentView addSubview:okButton];
    okButton.frame = CGRectMake(30, inputBg.bottom + 20, self.contentView.width - 30 * 2, 44);
    [okButton addTarget:self forAction:@selector(doQuery)];
    
    self.okButton = okButton;
    
    // 添加搜索历史页面
    [self reloadHistories];
}

- (void)reloadHistories
{
    [[SearchHistoryService sharedInstance] loadLatestBuslineHistories:^(NSArray *results, NSError *error) {
        if ( [results count] > 0 ) {
            NSMutableArray *temp = [results mutableCopy];
            [temp insertObject:@"搜索历史" atIndex:0];
            [temp addObject:@"清空搜索历史"];
            self.dataSource = temp;
            self.historiesTable.hidden = NO;
            [self.historiesTable reloadData];
            
            CGFloat height = self.contentView.height - self.okButton.bottom - 20 - 20;
            if ( self.historiesTable.contentSize.height <= height ) {
                self.historiesTable.height = self.historiesTable.contentSize.height;
                self.historiesTable.scrollEnabled = NO;
            } else {
                self.historiesTable.height = self.contentView.height - self.historiesTable.top - 20;
                self.historiesTable.scrollEnabled = YES;
            }
        }
    }];
}

- (void)doQuery
{
    [self queryWithStartLocation:self.startLocation endLocation:self.endLocation];
}

- (void)queryWithStartLocation:(Location *)startLocation endLocation:(Location *)endLocation
{
    if (!startLocation || !CLLocationCoordinate2DIsValid(startLocation.coordinate) ) {
        [self.contentView makeToast:@"无效的开始位置" duration:2.0 position:CSToastPositionTop];
        return;
    }
    
    if ( !endLocation || !CLLocationCoordinate2DIsValid(endLocation.coordinate) ) {
        [self.contentView makeToast:@"无效的结束位置" duration:2.0 position:CSToastPositionTop];
        return;
    }
    
    UIViewController *vc = [[AWMediator sharedInstance] openVCWithName:@"BusLineVC" params:@{ @"start": startLocation,
                                                                                              @"end": endLocation
                                                                                              }];
    [self.tabBarController.navigationController pushViewController:vc animated:YES];
    
    BuslineSearchHistory *bsh = [[BuslineSearchHistory alloc] init];
    bsh.startName = startLocation.title;
    bsh.startCoordinate = [NSString stringWithFormat:@"%f,%f", startLocation.coordinate.longitude,
                                                               startLocation.coordinate.latitude];
    bsh.endName = endLocation.title;
    bsh.endCoordinate = [NSString stringWithFormat:@"%f,%f", endLocation.coordinate.longitude,
                                                             endLocation.coordinate.latitude];
    bsh.time = @([[NSDate date] timeIntervalSince1970]);
    
    [[SearchHistoryService sharedInstance] insertBuslineHistory:bsh completion:^(BOOL succeed, NSError *error) {
        if ( error ) {
            NSLog(@"插入失败：%@", error);
        }
    }];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self reloadHistories];
    });
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.dataSource count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell.id"];
    if ( !cell ) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell.id"];
        
        if ( [cell respondsToSelector:@selector(setSeparatorInset:)] ) {
            cell.separatorInset = UIEdgeInsetsZero;
        }
        
        if ( [cell respondsToSelector:@selector(setLayoutMargins:)] ) {
            cell.layoutMargins = UIEdgeInsetsZero;
        }
    }
    
    if ( indexPath.row == 0 ) {
        cell.textLabel.text = @"搜索历史";
        cell.textLabel.textAlignment = NSTextAlignmentLeft;
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        cell.textLabel.font = AWSystemFontWithSize(16, NO);
        
    } else if ( indexPath.row == self.dataSource.count - 1 ) {
        cell.textLabel.text = @"清空搜索历史";
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
        
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
        
        cell.textLabel.font = AWSystemFontWithSize(16, NO);
    } else {
        cell.imageView.image = [UIImage imageNamed:@"icon_search1.png"];
        
        cell.textLabel.font = AWSystemFontWithSize(15, NO);
        
        BuslineSearchHistory *his = self.dataSource[indexPath.row];
        cell.textLabel.text = [NSString stringWithFormat:@"%@—%@", his.startName, his.endName];
        cell.textLabel.textAlignment = NSTextAlignmentLeft;
        
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
    }
    
    cell.textLabel.textColor = IOS_DEFAULT_CELL_SEPARATOR_LINE_COLOR;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if ( indexPath.row != 0 ) {
        if ( indexPath.row == self.dataSource.count - 1 ) {
            [[SearchHistoryService sharedInstance] removeAllBuslineHistories:^(BOOL succeed, NSError *error) {
                if ( succeed ) {
                    self.historiesTable.hidden = YES;
                }
            }];
        } else {
            BuslineSearchHistory *his = self.dataSource[indexPath.row];
            
            CGFloat lat = [[[his.startCoordinate componentsSeparatedByString:@","] lastObject] floatValue];
            CGFloat lng = [[[his.startCoordinate componentsSeparatedByString:@","] firstObject] floatValue];
            CLLocationCoordinate2D coordinate1 = CLLocationCoordinate2DMake(lat, lng);
            
            Location *startLocation = [[Location alloc] initWithCoordinate:coordinate1 title:his.startName];
            
            lat = [[[his.endCoordinate componentsSeparatedByString:@","] lastObject] floatValue];
            lng = [[[his.endCoordinate componentsSeparatedByString:@","] firstObject] floatValue];
            CLLocationCoordinate2D coordinate2 = CLLocationCoordinate2DMake(lat, lng);
            
            Location *endLocation = [[Location alloc] initWithCoordinate:coordinate2 title:his.endName];
            
            [self queryWithStartLocation:startLocation endLocation:endLocation];
        }
    }
}

- (UITableView *)historiesTable
{
    if ( !_historiesTable ) {
        CGRect frame = CGRectMake(15, self.okButton.bottom + 20,
                                  self.contentView.width - 30,
                                  self.contentView.height - self.okButton.bottom - 20 - 20);
        _historiesTable = [[UITableView alloc] initWithFrame:frame style:UITableViewStylePlain];
        
        _historiesTable.backgroundColor = [UIColor whiteColor];
        _historiesTable.dataSource = self;
        _historiesTable.delegate   = self;
        [_historiesTable removeBlankCells];
        
        [_historiesTable removeCompatibility];
        
        _historiesTable.hidden = YES;
        
        [self.contentView addSubview:_historiesTable];
    }
    return _historiesTable;
}

@end
