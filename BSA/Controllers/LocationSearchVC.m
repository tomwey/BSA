//
//  LocationSearchVC.m
//  RTA
//
//  Created by tomwey on 10/27/16.
//  Copyright © 2016 tomwey. All rights reserved.
//

#import "LocationSearchVC.h"
#import "Defines.h"
#import "LocationService.h"

@interface LocationSearchVC () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, weak) UIView *searchBg;

@property (nonatomic, copy) NSArray *dataSource;

@property (nonatomic, strong) LocationService *locationService;

@property (nonatomic, strong) UITableView *searchTableView;
@property (nonatomic, strong) NSArray *searchDataSource;

@end
@implementation LocationSearchVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navBar.title = @"搜索";
    
    self.contentView.backgroundColor = CONTENT_VIEW_BG_COLOR;
    
    // 搜索
    UIView *searchBg = [[UIView alloc] initWithFrame:CGRectMake(10, 10, self.contentView.width - 20, 50)];
    [self.contentView addSubview:searchBg];
    searchBg.cornerRadius = 6;
    searchBg.backgroundColor = [UIColor whiteColor];
    
    self.searchBg = searchBg;
    
    UIImageView *iconView = AWCreateImageView(@"icon_search.png");
    [searchBg addSubview:iconView];
    iconView.center = CGPointMake(10 + iconView.width / 2,
                                  searchBg.height / 2);
    
    CGRect frame = CGRectMake(iconView.right + 10,
                              5,
                              searchBg.width - iconView.right - 10 - 10,
                              40);
    UITextField *searchInput = [[UITextField alloc] initWithFrame:frame];
    [searchBg addSubview:searchInput];
    searchInput.placeholder = @"输入地址";
    searchInput.autocorrectionType = UITextAutocorrectionTypeNo;
    
    [searchInput addTarget:self action:@selector(doSearch:)
          forControlEvents:UIControlEventEditingChanged];
    
    [self loadSearchHistories];
}

- (void)loadSearchHistories
{
    [[SearchHistoryService sharedInstance] loadLatestSearchKeywordHistories:^(NSArray *results, NSError *error) {
        if ( [results count] > 0 ) {
            
            NSMutableArray *temp = [results mutableCopy];
            [temp insertObject:@"搜索历史" atIndex:0];
            [temp addObject:@"情况搜索历史"];
            
            self.searchDataSource = temp;
            self.searchTableView.hidden = NO;
            
            [self.searchTableView reloadData];
            
            if ( self.searchTableView.contentSize.height <= self.searchTableView.height ) {
                self.searchTableView.height = self.searchTableView.contentSize.height;
                self.searchTableView.scrollEnabled = NO;
            } else {
                self.searchTableView.height = self.contentView.height - self.searchTableView.top - 10;
                self.searchTableView.scrollEnabled = YES;
            }
        }
    }];
}

- (void)doSearch:(UITextField *)sender
{
    if ( sender.text.trim.length == 0 ) {
        self.dataSource = @[];
        self.tableView.hidden = YES;
        self.searchTableView.hidden = NO;
    } else {
        if ( !self.locationService ) {
            self.locationService = [[LocationService alloc] init];
        }
        
        [self.locationService POISearch:sender.text.trim boundary:@"哈密" completion:^(NSArray *locations, NSError *aError) {
//            NSLog(@"result: %@", locations);
            self.dataSource = locations;
            if ( [self.dataSource count] > 0 ) {
                self.tableView.hidden = NO;
                self.searchTableView.hidden = YES;
                [self.tableView reloadData];
            } else {
                self.tableView.hidden = YES;
                self.searchTableView.hidden = NO;
            }
        }];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ( tableView == self.tableView )
        return [self.dataSource count];
    return [self.searchDataSource count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ( tableView == self.tableView ) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell.id"];
        if ( !cell ) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell.id"];
        }
        
        cell.textLabel.text = [self.dataSource[indexPath.row] valueForKey:@"title"];
        
        return cell;
    } else {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell.id2"];
        if ( !cell ) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell.id2"];
            
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
        } else if ( indexPath.row == self.searchDataSource.count - 1 ) {
            cell.textLabel.text = @"清空搜索历史";
            cell.textLabel.textAlignment = NSTextAlignmentCenter;
        } else {
            cell.imageView.image = [UIImage imageNamed:@"icon_search1.png"];
            cell.textLabel.textAlignment = NSTextAlignmentLeft;
            cell.textLabel.text = [self.searchDataSource[indexPath.row] keyword];
            
            cell.textLabel.font = AWSystemFontWithSize(15, NO);
        }
        
        cell.textLabel.textColor = IOS_DEFAULT_CELL_SEPARATOR_LINE_COLOR;
        
        return cell;
    }
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
    if ( tableView == self.tableView ) {
        id info = self.dataSource[indexPath.row];
        
        if (self.params[@"selectBlock"]) {
            ((void (^)(id info))self.params[@"selectBlock"])(info);
            LocationSearchHistory *his = [[LocationSearchHistory alloc] init];
            his.keyword = info[@"title"];
            his.location = [NSString stringWithFormat:@"%@,%@",
                            [[info valueForKey:@"location"] valueForKey:@"lng"],
                            [[info valueForKey:@"location"] valueForKey:@"lat"]
                            ];
            his.time = @([[NSDate date] timeIntervalSince1970]);
            
            [[SearchHistoryService sharedInstance] insertLocSearchHistory:his completion:^(BOOL succeed, NSError *error) {
                
            }];
        }
        
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        if ( indexPath.row != 0 ) {
            if ( indexPath.row == self.searchDataSource.count - 1 ) {
                [[SearchHistoryService sharedInstance] removeAllLocSearchHistories:^(BOOL succeed, NSError *error) {
                    if ( succeed ) {
                        self.searchTableView.hidden = YES;
                    }
                }];
            } else {
                LocationSearchHistory *obj = self.searchDataSource[indexPath.row];
                NSDictionary *selectedInfo = @{ @"title": obj.keyword,
                                                @"location": @{
                                                        @"lat": [[obj.location componentsSeparatedByString:@","] lastObject],
                                                        @"lng": [[obj.location componentsSeparatedByString:@","] firstObject]
                                                        }};
                if (self.params[@"selectBlock"]) {
                    ((void (^)(id info))self.params[@"selectBlock"])(selectedInfo);
                }
                
                [self.navigationController popViewControllerAnimated:YES];
            }
        }
    }
}

- (UITableView *)tableView
{
    if ( !_tableView ) {
        CGRect frame = CGRectMake(self.searchBg.left,
                                  self.searchBg.bottom + 10,
                                  self.searchBg.width,
                                  self.contentView.height - 264 - self.searchBg.bottom - 20);
        _tableView = [[UITableView alloc] initWithFrame:frame style:UITableViewStylePlain];
        [self.contentView addSubview:_tableView];
        _tableView.cornerRadius = 6;
        
        _tableView.dataSource = self;
        _tableView.delegate = self;
        
        [_tableView removeBlankCells];
        
        [_tableView removeCompatibility];
        
        _tableView.hidden = YES;
        
        _tableView.rowHeight = 50;
    }
    return _tableView;
}

- (UITableView *)searchTableView
{
    if ( !_searchTableView ) {
        CGRect frame = CGRectMake(self.searchBg.left,
                                  self.searchBg.bottom + 10,
                                  self.searchBg.width,
                                  self.contentView.height - self.searchBg.bottom - 20);
        _searchTableView = [[UITableView alloc] initWithFrame:frame style:UITableViewStylePlain];
        
        [self.contentView addSubview:_searchTableView];
        
        _searchTableView.dataSource = self;
        _searchTableView.delegate = self;
        
        [_searchTableView removeBlankCells];
        [_tableView removeCompatibility];
    }
    return _searchTableView;
}

@end
