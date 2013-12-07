//
//  GetAPIInsuranceConfigRequest.m
//  MiuTrip
//
//  Created by pingguo on 13-12-3.
//  Copyright (c) 2013年 michael. All rights reserved.
//

#import "GetInsuranceConfigRequest.h"

@implementation GetInsuranceConfigRequest

-(NSString *)getRequestURLString{
    
    return [URLHelper getRequestURLByBusinessType:BUSINESS_FLIGHT widthMethodName:@"GetAPIInsuranceConfig"];
    
}
@end
