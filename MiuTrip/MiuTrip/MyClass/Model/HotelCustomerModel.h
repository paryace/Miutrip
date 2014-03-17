//
//  HotelCustomerModel.h
//  MiuTrip
//
//  Created by stevencheng on 13-12-29.
//  Copyright (c) 2013年 michael. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HotelCustomerModel : NSObject

@property (nonatomic,strong) NSString    *passengerId;
@property (nonatomic,strong) NSString    *name;
@property (nonatomic,strong) NSString    *deptName;
@property (nonatomic,strong) NSString    *costCenter;
@property (nonatomic)        float       apportionRate;
@property (nonatomic,strong) NSString    *corpUID;
@property (nonatomic,strong) NSString    *UID;
@property (nonatomic)        int         policyId;

+ (HotelCustomerModel*)getCustomer:(id)object;

@end
