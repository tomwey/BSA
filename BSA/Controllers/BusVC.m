//
//  BusVC.m
//  BSA
//
//  Created by tangwei1 on 16/11/3.
//  Copyright © 2016年 tomwey. All rights reserved.
//

#import "BusVC.h"
#import "Defines.h"

@interface BusVC ()

@property (nonatomic, strong) UIScrollView *scrollView;

@end

@implementation BusVC

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if ( self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil] ) {
        self.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"定制公交"
                                                        image:[UIImage imageNamed:@"dzbus.png"]
                                                selectedImage:[UIImage imageNamed:@"dzbus_selected.png"]];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.scrollView = [[UIScrollView alloc] initWithFrame:self.contentView.bounds];
    [self.contentView addSubview:self.scrollView];
    self.scrollView.showsVerticalScrollIndicator = NO;
    
    UIImageView *headView = AWCreateImageView(nil);
    headView.image = AWImageNoCached(@"banner_bg.png");
    [self.scrollView addSubview:headView];
    headView.frame = CGRectMake(0, 0, self.contentView.width, self.contentView.width * 576 / 1242.0);
    
    CGFloat margin = 10;
    
    // 电子车票
    UIView *bgView = [[UIView alloc] init];
    [self.scrollView addSubview:bgView];
    bgView.backgroundColor = [UIColor whiteColor];
    
    UIImageView *tickView = AWCreateImageView(nil);
    tickView.image = AWImageNoCached(@"ticket.png");
    [bgView addSubview:tickView];
    [tickView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(gotoTicket)]];
    tickView.userInteractionEnabled = YES;
    
    CGFloat factor = tickView.image.size.height / tickView.image.size.width;
    bgView.frame = CGRectMake(0, headView.bottom + margin, self.contentView.width, self.contentView.width * factor);
    
    tickView.frame = CGRectInset(bgView.bounds, 10, 10);
    
    // 功能区域
    NSArray *sections = @[@"subscribe.png",@"purchase.png",@"dzorder.png",@"recruit.png",@"route.png",@"demand.png"];
    NSArray *titles   = @[@"预约", @"订购", @"我的订单", @"参与招募",@"开行线路", @"个人需求"];
    NSInteger numberOfCols = 3;
    NSInteger padding = 1;
    
    CGFloat contentHeight = bgView.bottom + margin;
    
    for (int i=0; i<sections.count; i++) {
        UIView *containerView = [[UIView alloc] init];
        [self.scrollView addSubview:containerView];
        containerView.backgroundColor = [UIColor whiteColor];
        
        containerView.tag = 1000 + i;
        
        [containerView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)]];
        
        static CGFloat width, height;
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            width = ceilf((self.scrollView.width - padding * ( numberOfCols - 1 )) / numberOfCols);
            height = 100.0;//width * 200 / 238.0;
        });
        
        containerView.frame = CGRectMake(0, 0, width, height);
        
        int m = i % numberOfCols;
        int n = i / numberOfCols;
        
        containerView.position = CGPointMake(( width + padding ) * m,
                                             bgView.bottom + margin + ( height + padding ) * n);
        
        contentHeight = containerView.bottom + margin;
        
        UIImageView *iconView = AWCreateImageView(sections[i]);
        [containerView addSubview:iconView];
        iconView.frame = CGRectMake(0, 0, 40, 40);
        iconView.center = CGPointMake(containerView.width / 2, 15 + iconView.height / 2.0);
        
        UILabel *titelLabel = AWCreateLabel(CGRectMake(0, 0, containerView.width,
                                                       34),
                                            titles[i],
                                            NSTextAlignmentCenter,
                                            AWSystemFontWithSize(16, NO),
                                            AWColorFromRGB(83, 83, 83));
        [containerView addSubview:titelLabel];
        titelLabel.position = CGPointMake(0, iconView.bottom);
    }
    
    self.scrollView.contentSize = CGSizeMake(self.contentView.width, contentHeight);
}

- (void)tap:(UIGestureRecognizer *)gesture
{
    NSArray *h5Pages = @[
                         @"booking.html",@"purchase.html",@"order_list.html",
                         @"group.html",@"recruit.html",@"person.html",
                         ];
    NSArray *titles   = @[@"预约", @"订购", @"我的订单", @"参与招募",@"开行线路", @"个人需求"];
    
    NSInteger index = gesture.view.tag - 1000;
    
    NSString *url = [NSString stringWithFormat:@"%@/%@", H5_HOST, h5Pages[index]];
    WebViewVC *page = [[WebViewVC alloc] initWithURL:[NSURL URLWithString:url] title:titles[index]];
    [self.tabBarController.navigationController pushViewController:page animated:YES];
}

- (void)gotoTicket
{
    NSString *url = [NSString stringWithFormat:@"%@/ticket.html", H5_HOST];
    WebViewVC *page = [[WebViewVC alloc] initWithURL:[NSURL URLWithString:url] title:@"电子车票"];
    [self.tabBarController.navigationController pushViewController:page animated:YES];
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

@end
