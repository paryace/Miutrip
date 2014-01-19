//
//  UserDefaults.h
//  TrainTicketQuery
//
//  Created by M J on 13-9-2.
//  Copyright (c) 2013年 M J. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GetLoginUserInfoResponse.h"

@class LoginInfoDTO;

@interface UserDefaults : NSObject

+(UserDefaults*)shareUserDefault;

@property (strong, nonatomic) GetLoginUserInfoResponse  *loginInfo;

@property (strong, nonatomic) NSString                  *userName;
@property (strong, nonatomic) NSString                  *passWord;
@property (strong, nonatomic) NSString                  *mobile;
@property (strong, nonatomic) NSString                  *email;
@property (strong, nonatomic) NSString                  *sex;
@property (assign, nonatomic) BOOL                      getUserInfo;

@property (assign, nonatomic) BOOL                      autoLogin;

//0:本人 1:他人/多人
@property (assign, nonatomic) NSInteger                 reserveObject;              //预定对象
//0:因公 2:因私
@property (assign, nonatomic) NSInteger                 tripGoal;                   //出行目的
@property (strong, nonatomic) NSString                  *startCity;                 //出发城市
@property (strong, nonatomic) NSString                  *goalCity;                  //入住城市
//1:不限  2:0~150  3:151~300  4:301~450  5:451~600  6:600以上
@property (assign, nonatomic) NSInteger                 priceRange;                 //价格区间
//0:不需要行程单 1:平邮 6.0元 2:快递 10.0元 3:EMS 10.0元 4:快递到付 10.0元
@property (assign, nonatomic) NSInteger                 postType;                   //配送方式
@property (strong, nonatomic) NSString                  *postAddress;               //邮寄地址
//0:国内酒店 1:国内机票 2:我的miu
@property (assign, nonatomic) NSInteger                 launchPage;                 //启动首页
@property (assign, nonatomic) BOOL                      allowShake;                 //摇动设置      //0:关闭 1:开启
@property (assign, nonatomic) CGFloat                   searchRadiu;                //搜索半径

@property (strong, nonatomic) NSString                  *authTkn;                   //token

@property (strong, nonatomic) NSArray                   *allCity;                   //城市列表

- (void)clearDefaults;

- (NSString *)getPriceRange;
- (NSString *)getPostType;

@end
