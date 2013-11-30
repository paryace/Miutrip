//
//  MemberDeliverDTO.h
//  MiuTrip
//
//  Created by apple on 13-11-28.
//  Copyright (c) 2013年 michael. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CityDTO;
@class ProvinceDTO;
@class CantonDTO;

@interface MemberDeliverDTO : NSObject

@property (assign, nonatomic) NSInteger     AddID;                  //配送ID
@property (strong, nonatomic) NSString      *UID;                   //用户ID
@property (strong, nonatomic) NSString      *RecipientName;         //收件人名称
@property (assign, nonatomic) NSInteger     Province;               //省
@property (assign, nonatomic) NSInteger     City;                   //市
@property (assign, nonatomic) NSInteger     Canton;                 //区
@property (strong, nonatomic) NSString      *Address;               //详细地址
@property (strong, nonatomic) NSString      *ZipCode;               //邮政编码
@property (strong, nonatomic) NSString      *Tel;                   //电话
@property (strong, nonatomic) NSString      *Mobile;                //手机
@property (strong, nonatomic) CityDTO       *CityMode;              //城市模型
@property (strong, nonatomic) ProvinceDTO   *ProvinceMode;          //省模型
@property (strong, nonatomic) CantonDTO     *CantonMode;            //区模型
@property (strong, nonatomic) NSString      *LastUseDate;           //最后使用时间

@end
