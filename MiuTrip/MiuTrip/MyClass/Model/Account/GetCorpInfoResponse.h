//
//  GetCorpInfoResponse.h
//  MiuTrip
//
//  Created by Y on 13-12-4.
//  Copyright (c) 2013年 michael. All rights reserved.
//

#import "BaseResponseModel.h"



@interface  GetCorpInfoResponse : BaseResponseModel

@property (strong, nonatomic) NSString      *CorpName;                  //公司名称
@property (strong, nonatomic) NSString      *CorpNameEn;                //公司英文名
@property (strong, nonatomic) NSString      *CorpShortName;             //公司简短名
@property (strong, nonatomic) NSNumber     *NeedDelivery;               //是否需要定期配送      0：否 1：是
@property (strong, nonatomic) NSNumber    *NeedStrictDelivery;         //是否限制定期配送      0：否 1：是

@property (strong, nonatomic) NSMutableArray *Corp_AddressList;         //定期配送地址列表	List<Corp_AddressDTO>

@end

@interface Corp_AddressResponse : BaseResponseModel

@property (strong, nonatomic) NSString      *ID;                        //配送地址记录id
@property (strong, nonatomic) NSString      *CreateUser;                //创建人
@property (strong, nonatomic) NSString      *RecipientName;             //收件人
@property (strong, nonatomic) NSString      *ProvinceId;                //省id
@property (strong, nonatomic) NSString      *ProvinceName;              //省
@property (strong, nonatomic) NSString      *CityId;                    //城市id
@property (strong, nonatomic) NSString      *CityName;                  //城市名称
@property (strong, nonatomic) NSString      *CantonId;                  //区域Id
@property (strong, nonatomic) NSString      *CantonName;                //区域
@property (strong, nonatomic) NSString      *Address;                   //地址
@property (strong, nonatomic) NSString      *ZipCode;                   //邮编
@property (strong, nonatomic) NSString      *Tel;                       //电话
@property (strong, nonatomic) NSString      *Mobile;                    //手机

@end