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
-(void)parshJsonToResponse:(NSObject *)responseData{
    
    if(responseData == NULL){
        return;
    }
    
    NSDictionary *dictData = nil;
    if ([responseData isKindOfClass:[NSDictionary class]]) {
        dictData = (NSDictionary*)responseData;
    }else{
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
        id value = [dictData objectForKey:key];
                
        NSError *error = nil;
        //校验值是否正确，正确则用KVC赋值
        if([self validateValue:&value forKey:key error:&error]){
            [self setValue:value forKey:key];
        }
        
    }
    //释放属性
    free(properties);
    
}

-(NSDictionary*)getRequestJsonString{
    
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    
    //获取父类的属性数量
    unsigned int outCount;
    objc_property_t *properties = class_copyPropertyList([self class], &outCount);
    
    for (int i=0;i<outCount;i++){
        objc_property_t property = properties[i];
        //获取到属性的名称
        NSString *key=[[NSString alloc]initWithCString:property_getName(property)
                                              encoding:NSUTF8StringEncoding];
        //生成获取属性名称对应值的selector;
        SEL selector = NSSelectorFromString(key);
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        //获取对应的值
        id value = nil;
        if ([self respondsToSelector:selector]) {
            @try {
                value = [self performSelector:selector];
            }
            @catch (NSException *exception) {
                NSLog(@"name = %@,reason = %@",exception.name,exception.reason);
            }
            @finally {
                
            }
        }
        //nil 转换成 null;
        if(value == nil){
            value = [NSNull null];
        }
        [dict setObject:value forKey:key];
        
    }
    //释放属性数组
    free(properties);
    
    return dict;
}

- (id)proxyForJson
{
    return [self getRequestJsonString];
}


@end
