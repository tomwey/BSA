//
//  UserService.h
//  deyi
//
//  Created by tomwey on 9/5/16.
//  Copyright © 2016 tangwei1. All rights reserved.
//

#import <Foundation/Foundation.h>

@class User;
@interface UserService : NSObject

+ (UserService *)sharedInstance;

/**
 * 获取当前登录的用户，如果存在表示登录成功
 */
- (User *)currentUser;

- (void)saveUser: (User *)aUser;

/**
 * 获取当前用户认证Token
 */
- (NSString *)currentUserAuthToken;

/**
 * 注册
 */
- (void)signupWithMobile:(NSString *)mobile
                password:(NSString *)password
                    code:(NSString *)code
              inviteCode:(NSString *)inviteCode
              completion:(void (^)(User *aUser, NSError *error))completion;

/**
 * 登录
 */
- (void)loginWithMobile:(NSString *)mobile
               password:(NSString *)password
             completion:(void (^)(User *aUser, NSError *error))completion;

/**
 * 获取用户个人资料
 */
- (void)loadUserProfile:(NSString *)token
             completion:(void (^)(User *aUser, NSError *error))completion;

/**
 * 修改密码
 */

/**
 * 退出登录
 */
- (void)logout:(void (^)(id result, NSError *error))completion;

- (void)updateUserProfile:(NSDictionary *)params
               completion:(void (^)(User *aUser, NSError *error))completion;

- (void)updateAvatar:(NSDictionary *)params
          completion:(void (^)(User *aUser, NSError *error))completion;

@end
