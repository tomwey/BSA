//
//  TicketsListVC.m
//  BSA
//
//  Created by tangwei1 on 16/11/15.
//  Copyright © 2016年 tomwey. All rights reserved.
//

#import "TicketsListVC.h"
#import "Defines.h"
#import "iCarousel.h"

@interface TicketsListVC () <iCarouselDataSource, iCarouselDelegate>

@property (nonatomic, strong) iCarousel *carousel;
@property (nonatomic, strong) NSMutableArray *dataSource;

@property (nonatomic, strong) UIPageControl *pageControl;

//@property (nonatomic, assign) NSInteger totalPage;
//@property (nonatomic, assign) NSInteger currentPage;
//@property (nonatomic, assign) NSUInteger pageSize;

@end

@implementation TicketsListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navBar.title = @"我的车票";
    
    self.contentView.backgroundColor = AWColorFromRGB(242, 242, 242);//AWColorFromRGB(219, 230, 239);
    
//    self.pageSize = 2;
//    self.currentPage = 1;
    
    self.dataSource = [[NSMutableArray alloc] init];
    
    self.carousel = [[iCarousel alloc] init];
    [self.contentView addSubview:self.carousel];
    self.carousel.frame = self.contentView.bounds;
    
    self.carousel.backgroundColor = AWColorFromRGB(219, 230, 239);
    
    self.carousel.dataSource = self;
    self.carousel.delegate   = self;
    
    self.carousel.type = iCarouselTypeLinear;
    self.carousel.pagingEnabled = YES;
    
    [self loadData];
}

- (void)reloadData
{
//    self.currentPage = 1;
    
    [self loadData];
}

- (void)loadData
{
    __weak typeof(self) me = self;
//    if ( self.currentPage == 1 ) {
        [self.dataSource removeAllObjects];
        
        [self startLoadingInView:self.contentView
               forStateViewClass:[AWLoadingStateView class]
                  reloadCallback:^{
                      [me reloadData];
                  }];
//    }
    
    [self.dataService POST:@"GetUserTikect" params:@{ @"userid": [[UserService sharedInstance] currentUserAuthToken] }
                completion:^(id result, NSError *error) {
                    if ( error ) {
//                        self.contentView.backgroundColor = AWColorFromRGB(242, 242, 242);
                        [self finishLoading:AWLoadingStateFailure];
                    } else {
                        NSArray *data = result[@"DataList"];
                        if ( [data count] == 0 ) {
//                            self.contentView.backgroundColor = AWColorFromRGB(242, 242, 242);
                            [self finishLoading:AWLoadingStateEmptyResult];
                        } else {
//                            self.contentView.backgroundColor = AWColorFromRGB(219, 230, 239);
                            [self finishLoading:AWLoadingStateSuccess];
                            
                            [self.dataSource addObjectsFromArray:data];
                            [self.carousel reloadData];
                            
                            self.pageControl.numberOfPages = [self.dataSource count];
                        }
                    }
                }];
}

- (NSInteger)numberOfItemsInCarousel:(iCarousel *)carousel
{
    return [self.dataSource count];
}

- (UIView *)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSInteger)index reusingView:(nullable UIView *)view
{
    TicketView *ticketView = (TicketView *)view;
    if (ticketView == nil) {
        ticketView = [[TicketView alloc] initWithFrame:CGRectMake(0, 0,
                                                                  self.contentView.width * 0.8,
                                                                  [self pageContentHeight] + 40)];
    }
    
    ticketView.ticketData = self.dataSource[index];
    
    return ticketView;
}

- (CGFloat)pageContentHeight
{
    return self.contentView.width * 0.8 * 1.393 + 40;
}

- (CGFloat)carousel:(iCarousel *)carousel valueForOption:(iCarouselOption)option withDefault:(CGFloat)value
{
    if ( option == iCarouselOptionSpacing ) {
        return value * 1.06;
    }
    
    return value;
}

- (UIPageControl *)pageControl
{
    if ( !_pageControl ) {
        CGFloat dtHeight = self.contentView.height / 2 - [self pageContentHeight] / 2;
        _pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, self.contentView.height - dtHeight, self.contentView.width, 30)];
        [self.contentView addSubview:_pageControl];
        _pageControl.hidesForSinglePage = YES;
        
        _pageControl.pageIndicatorTintColor = [UIColor whiteColor];
        _pageControl.currentPageIndicatorTintColor = AWColorFromRGB(65, 149, 240);
    }
    return _pageControl;
}

- (void)carouselCurrentItemIndexDidChange:(iCarousel *)carousel
{
    self.pageControl.currentPage = carousel.currentItemIndex;
}

@end
