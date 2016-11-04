//
//  AppInfo.h
//  RTA
//
//  Created by tangwei1 on 16/10/26.
//  Copyright © 2016年 tomwey. All rights reserved.
//

#import <Foundation/Foundation.h>

//AndroidDownload = "http://182.150.21.101:9091/APK/RT/0.0.1.apk";
//AndroidVersion = "0.0.1";
//IosDownload = "http://182.150.21.101:9091/APK/RT/0.0.1.apk";
//IosVersion = "0.0.1";
//QQ = 2757801355;
//QRDownLoadUrl = "http://182.150.21.101:9091/Images/QRCode/xiazai.png";
//QRUrl = "http://182.150.21.101:9091/Images/QRCode/fenxiang.jpg";
//Tel = 18108037442;
//resultdes = "\U6267\U884c\U6210\U529f";
//status = 101;

@interface AppInfo : NSObject

@property (nonatomic, copy, readonly) NSString *androidUrl;
@property (nonatomic, copy, readonly) NSString *androidVersion;
@property (nonatomic, copy, readonly) NSString *iOSUrl;
@property (nonatomic, copy, readonly) NSString *iOSVersion;
@property (nonatomic, copy, readonly) NSString *qq;
@property (nonatomic, copy, readonly) NSString *qqUrl;
@property (nonatomic, copy, readonly) NSString *qrUrl;
@property (nonatomic, copy, readonly) NSString *mobile;

//- (instancetype)initWithDictionary:()

@end
