//
//  ActiveGiftCardUserRequest.h
//  MiuTrip
//
//  Created by apple on 14-3-7.
//  Copyright (c) 2014年 michael. All rights reserved.
//

#import "BaseRequestModel.h"

@interface ActiveGiftCardUserRequest : BaseRequestModel

@property (nonatomic, strong)NSString *UID;         //礼品卡号	是	string
@property (nonatomic, strong)NSString *LoginPass;   //礼品卡密码	是	string

@property (nonatomic, strong)NSString *CorpName;    //公司名字	是	string
@property (nonatomic, strong)NSNumber *CityID;      //所在城市Id	否	int	默认是0


@property (nonatomic, strong)NSString *UserName;    //联系人姓名	是	string
@property (nonatomic, strong)NSString *Tel;         //联系人电话	否	string
@property (nonatomic, strong)NSString *Mobilephone; //联系人手机	是	string

@property (nonatomic, strong)NSString *ChinaUmsUID; //全民付用户Uid	是	string
@property (nonatomic, strong)NSNumber *SourceID;    //渠道id	是	int	默认是0

@property (nonatomic, strong)NSString *SinaWeibUID; //新浪微博uid	否	string




@end
