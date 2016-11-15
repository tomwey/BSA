//
//  Defines.h
//  deyi
//
//  Created by tangwei1 on 16/9/2.
//  Copyright © 2016年 tangwei1. All rights reserved.
//

#ifndef Defines_h
#define Defines_h

#import "AWMacros.h"

#import "AWGeometry.h"

#import "AWUITools.h"

#import "AWTextField.h"

#import "AWTableView.h"

#import "AWHairlineView.h"

#import "AWAPIManager.h"

#import "NSStringAdditions.h"

#import "AWMediator.h"

#import "MBProgressHUD.h"

#import "AFNetworking.h"
#import "UIImageView+AFNetworking.h"

#import "APIManager.h"

#import "UIWebView+RemoveGrayBackground.h"

#define IOS_DEFAULT_NAVBAR_BOTTOM_LINE_COLOR  AWColorFromRGB(163, 164, 165)
#define IOS_DEFAULT_CELL_SEPARATOR_LINE_COLOR AWColorFromRGB(187, 188, 193)

#define MAIN_BG_COLOR         AWColorFromRGB(239, 239, 239)
#define NAV_BAR_BG_COLOR      AWColorFromRGB(50, 69, 255)
#define CONTENT_VIEW_BG_COLOR AWColorFromRGB(239, 239, 239)
#define MAIN_BLUE_COLOR       AWColorFromRGB(38, 133, 247)

#define HOME_HAIRLINE_COLOR   MAIN_BG_COLOR//AWColorFromRGB(240, 240, 242)

#define WX_APP_ID     @"wx0a45255c7eb48647"
#define WX_APP_SECRET @"31130acde0e69ede9e6850f86f0050d8"

#define QQ_APP_ID     @"1105816344"
#define QQ_APP_SECRET @"L05JC5Hy601sqPph"

#define UMENG_KEY     @"582578067f2c74617e000125"

#define NFC_APP_URL       @""
#define OFFICIAL_TELPHONE @"18108037442"
#define OFFICIAL_QQ       @"2757801355"

#define OFFICIAL_WECHAT_URL   @"http://tdzh.cddzgj.com:9091/weixin.html"
#define FEEDBACK_URL          @"http://tdzh.cddzgj.com:9091/RTH/feedback.html"

// 我要包车
#define APPLY_BUS_URL         @"http://tadi.adgom.cn:9091/BSH/carAppointment.html"

// 广场列表地址
#define SQUARE_LIST_URL       @"http://tadi.adgom.cn:9091/square.html"

// 线路订购详情地址
#define LINE_DETAIL_URL       @"http://tadi.adgom.cn:9091/BSH/ordering.html"

////// API接口
#define API_HOST      @"http://182.150.21.101:9091/BSI/BSIWCF.svc"
#define H5_HOST       @"http://dzh.cddzgj.com"

#define API_KEY    @"27654725447"
#define API_SECRET @"dfjhskdhsiwnvhkjhdguwnvbxmn"
#define AES_KEY    @"666AA4DF3533497D973D852004B975BC"

// 线路订购列表
#define GET_BUS_LINE_ORDER_PUBLISH_RESULT @"GetBusLineOrderPublishResult" // pageindex, pagesize

// 线路订购详情
#define GET_BUS_LINE_ORDER_PUBLISH_RESULT_DETAIL @"GetBusLineOrderPublishResultDetail" // monthtype, lineno

// 提交订单
#define SUBMIT_ORDER @"SubmitOrder" // lineno, monthtype, packagevalue, userid

// 根据用户电话获取用户信息
#define GET_USER_MODEL @"GetUserModel" // userid

// 获取所有车型信息
#define GET_BUS_TYPE_RESULT_BY_WAP

// 获取用户的所有订单
#define GET_MY_ORDER_PAY_RESULT @"GetMyOrderPayResult" // userid

// 获取所有的优惠券
#define GET_LINE_ORDER_PACKEGE_RESULT @"GetLineOrderPackegeResult"

// 获取官方信息接口
#define GET_RT_RESULT @"GetRTResult"

// 用户登陆
#define USER_LOGIN    @"UserLogin" // pwd, loginname

// 用户注册
#define ADD_USER_INFO @"AddUserInfo" // pwd, tel

// 更新用户信息
#define UPDATE_USER_INFO @"UpdateUserInfo" // userid, key, value (key可以为：username, sex, birthday)

// SendVerCode
#define SEND_VER_CODE    @"SendVerCode" // tel

// 验证验证码
#define CHECK_VER_CODE   @"CheckVerCode" // tel, vercode

// 判断用户是否存在
#define IS_EXIST_USER_INFO @"IsExitUserInfo" // tel

// 首页获取站点
#define GET_STATION_BY_LNG_AND_LAT @"GetStationByLngAndLat" // lng, lat

// 根据最近的站台获取车辆线路
#define GET_BUS_LINE_QUERY_RESULT  @"GetBusLineQueryResult" // stationid, lng, lat

// 更新头像
#define UPLOAD_PIC @"UploadPic"

#define BUS_LIST_TITLE_BLACK_COLOR AWColorFromRGB(83,83,83)
#define BUS_LIST_TITLE_GRAY_COLOR  AWColorFromRGB(135,135,135)
#define BUS_LIST_CONTAINER_BORDER_GRAY_COLOR  AWColorFromRGB(208,208,208)

#define BUS_LIST_FONT_SMALL 15

#import "ParamUtil.h"

#import "AWLocationManager.h"

#import "UIViewController+CreateFactory.h"
#import "NSObject+RTIDataService.h"
#import "UITableView+RefreshControl.h"

#import "AppDelegate.h"

#import "CustomNavBar.h"

#import "AWButton.h"

#import "NetworkService.h"

#import "UIView+Toast.h"

#import "AWTextField.h"

#import "UITextView+AWPlaceholder.h"

#import "AWLoadingStateBaseView.h"
#import "AWLoadingStateView.h"

// Models
#import "User.h"
#import "Location.h"
#import "BuslineSearchHistory.h"
#import "LocationSearchHistory.h"

// Services
#import "UserService.h"
#import "VersionCheckService.h"
#import "SearchHistoryService.h"

// Views
#import "SettingTableHeader.h"
#import "DatePicker.h"
#import "SexPicker.h"
#import "InputCell.h"
#import "BannerView.h"

// Controllers
#import "WebViewVC.h"

#endif /* Defines_h */
