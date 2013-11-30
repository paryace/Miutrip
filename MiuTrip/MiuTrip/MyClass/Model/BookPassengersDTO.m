//
//  BookPassengersDTO.m
//  MiuTrip
//
//  Created by apple on 13-11-28.
//  Copyright (c) 2013年 michael. All rights reserved.
//

#import "BookPassengersDTO.h"
#import "Utils.h"

@implementation BookPassengersDTO

+ (NSArray*)getListWithData:(NSArray*)data
{
    NSMutableArray *array = [NSMutableArray array];
    for (NSDictionary *params in data) {
        BookPassengersDTO *passenger = [[BookPassengersDTO alloc]initWithParams:params];
        [array addObject:passenger];
    }
    return array;
}

- (id)initWithParams:(NSDictionary*)params
{
    if (self = [super init]) {
        _unfold = NO;
        
        _AccessLevel = [[params objectForKey:@"AccessLevel"] integerValue];
        _AccessType  = [[params objectForKey:@"AccessType"] integerValue];
        _AgentRange  = [[params objectForKey:@"AgentRange"] integerValue];
//        _AirlineCardList = nil;
//        _IDCardList = nil;
        NSString *birthDay = nil;
        @try {
            birthDay = [[params objectForKey:@"Birthday"] stringByMatching:@"\\d+"];
        }
        @catch (NSException *exception) {
            NSLog(@"name = %@\nreason = %@",exception.name,exception.reason);
        }
        @finally {
            
        }
    
        if (birthDay.length > 11) {
            _Birthday = [birthDay substringWithRange:NSMakeRange(0, 10)];
        }else
            _Birthday = birthDay;
        _ContactConfirmType = [Utils NULLToEmpty:[params objectForKey:@"ContactConfirmType"]];
        _CorpID = [[params objectForKey:@"CorpID"] integerValue];
        _CorpUID = [Utils NULLToEmpty:[params objectForKey:@"CorpUID"]];
        _Country = [Utils NULLToEmpty:[params objectForKey:@"Country"]];
        NSLog(@"country = %@",_Country);
        _DepLev = [[params objectForKey:@"DepLev"] integerValue];
        _DeptID = [[params objectForKey:@"DeptID"] integerValue];
        _DeptName = [Utils NULLToEmpty:[params objectForKey:@"DeptName"]];
        _DeptNameEn = [Utils NULLToEmpty:[params objectForKey:@"DeptNameEn"]];
        _Email = [Utils NULLToEmpty:[params objectForKey:@"Email"]];
        _EmployeeID = [Utils NULLToEmpty:[params objectForKey:@"EmployeeID"]];
        _Fax = [Utils NULLToEmpty:[params objectForKey:@"Fax"]];
        _FirstName = [Utils NULLToEmpty:[params objectForKey:@"FirstName"]];
        _FullENName = [Utils NULLToEmpty:[params objectForKey:@"FullENName"]];
        _Gender = [Utils NULLToEmpty:[params objectForKey:@"Gender"]];
        _IsEmoloyee = [[params objectForKey:@"IsEmoloyee"] boolValue];
        _IsServerCard = [[params objectForKey:@"IsServerCard"] integerValue];
        _LastName = [Utils NULLToEmpty:[params objectForKey:@"LastName"]];
        _MiddleName = [Utils NULLToEmpty:[params objectForKey:@"MiddleName"]];
        _MileageRule = [[params objectForKey:@"MileageRule"] integerValue];
        _Mobilephone = [Utils NULLToEmpty:[params objectForKey:@"Mobilephone"]];
        _OrderForSelf = [[params objectForKey:@"OrderForSelf"] integerValue];
        _PassengerID = [[params objectForKey:@"PassengerID"] integerValue];
        _PolicyID = [Utils NULLToEmpty:[params objectForKey:@"PolicyID"]];
        _Position = [Utils NULLToEmpty:[params objectForKey:@"Position"]];
        _PreDeptID = [[params objectForKey:@"PreDeptID"] integerValue];
        _Status = [Utils NULLToEmpty:[params objectForKey:@"Status"]];
        _Telephone = [Utils NULLToEmpty:[params objectForKey:@"Telephone"]];
        _UniqueID = [Utils NULLToEmpty:[params objectForKey:@"UniqueID"]];
        _UserName = [Utils NULLToEmpty:[params objectForKey:@"UserName"]];
    }
    return self;
}

@end
