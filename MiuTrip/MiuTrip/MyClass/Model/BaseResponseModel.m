//
//  BaseResponseModel.m
//  MiuTrip
//
//  Created by stevencheng on 13-11-28.
//  Copyright (c) 2013年 michael. All rights reserved.
//

#import "BaseResponseModel.h"

@implementation BaseResponseModel




/**
 *  将服务端返回的响应JSON字符串解析，并赋值给当前的Response
 *  对象
 */
-(void)parshJsonToResponse:(NSDictionary *)responseData{
    
    if(responseData == NULL){
        return;
    }
    
    unsigned int outCount;
    objc_property_t *properties = class_copyPropertyList([self class], &outCount);
    
    for(int i=0;i<outCount;i++){
        objc_property_t property = properties[i];
        
        //反射属性的名称
        NSString *key=[[NSString alloc]initWithCString:property_getName(property)
                                              encoding:NSUTF8StringEncoding];
        //获取属性对应的值
        id value = [responseData objectForKey:key];
                
        NSError *error = nil;
        //校验值是否正确，正确则用KVC赋值
        if([self validateValue:&value forKey:key error:&error]){
            [self setValue:value forKey:key];
        }
        
    }
    //释放属性
    free(properties);
    
}

@end
