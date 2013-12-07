//
//  CorpServerCardDTO.h
//  MiuTrip
//
//  Created by apple on 13-11-28.
//  Copyright (c) 2013年 michael. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CorpServerCardDTO : NSObject

@property (strong, nonatomic) NSString      *UID;                   //用户ID
@property (strong, nonatomic) NSString      *CorpID;                //公司ID
@property (strong, nonatomic) NSString      *UserName;              //用户名称
@property (strong, nonatomic) NSString      *LastName;              //英文名字
@property (strong, nonatomic) NSString      *FirstName;             //...
@property (strong, nonatomic) NSString      *MiddleName;            //...
@property (strong, nonatomic) NSString      *HotelPolicyTitle;      //酒店政策描述
@property (strong, nonatomic) NSString      *FlightPolicyTitle;     //机票政策描述

@end
