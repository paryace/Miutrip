//
//  CommonlyName.h
//  MiuTrip
//
//  Created by SuperAdmin on 13-11-15.
//  Copyright (c) 2013年 michael. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CommonlyName : NSObject

@property (strong, nonatomic) NSString                  *name;
@property (strong, nonatomic) NSString                  *nationality;
@property (assign, nonatomic) NSInteger                 cardType;
@property (strong, nonatomic) NSString                  *cardNum;
@property (strong, nonatomic) NSString                  *phoneNum;
@property (assign, nonatomic) NSInteger                 passengerType;//默认乘机人 //默认入住人 //默认联系人

@property (strong, nonatomic) NSString                  *email;
@property (strong, nonatomic) NSString                  *costCenter;

@property (assign, nonatomic) BOOL                      unfold;

+ (NSArray*)getCommonDataWithNum:(NSInteger)num;

@end
