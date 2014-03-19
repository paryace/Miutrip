//
//  HotelCustomerModel.m
//  MiuTrip
//
//  Created by stevencheng on 13-12-29.
//  Copyright (c) 2013年 michael. All rights reserved.
//

#import "HotelCustomerModel.h"
#import "GetContactRequest.h"

@implementation HotelCustomerModel


+ (HotelCustomerModel *)getCustomer:(id)object
{
    if ([object isKindOfClass:[BookPassengersResponse class]]) {
        BookPassengersResponse *response = object;
        HotelCustomerModel *customer = [[HotelCustomerModel alloc]init];
        customer.name = response.UserName;
        customer.UID = response.UniqueID;
        customer.passengerId = [NSString stringWithFormat:@"%@",response.PassengerID];
        customer.corpUID = [NSString stringWithFormat:@"%@",response.CorpUID];
        customer.costCenter = response.DeptName;
        customer.apportionRate = 1;
        
        return customer;
    }else if ([object isKindOfClass:[HotelCustomerModel class]]){
        return object;
    }else
        return nil;
}

- (id)init
{
    self = [super init];
    if (self) {
        _shareAmount = 1.0;
    }
    return self;
}



@end
