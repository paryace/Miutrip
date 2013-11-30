//
//  BaseRequestModel.m
//  MiuTrip
//
//  Created by stevencheng on 13-11-28.
//  Copyright (c) 2013年 michael. All rights reserved.
//

#import "BaseRequestModel.h"

@implementation BaseRequestModel

-(BaseRequestModel *)initWidthBusinessType:(BusinessType) bussinessType methodName:(NSString *)methodName{
    
    if(self == [super init]){
        _methodName = methodName;
        _businessType = bussinessType;
    }
    
    return self;
}


/**
 *  是否缓存该响应
 *
 *  @return YES:缓存该响应
 */
-(BOOL)isCacheabled{
    //如果不用缓存，子类不必重写，要缓存，子类就必须重写
    return NO;
}



-(NSString*)getRequestJsonString:(BOOL)hasToken{
    
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    
    //放入基本参数
    [dict setObject:[Utils stringWithDate:[NSDate date] withFormat:@"yyyy-MM-dd HH:mm:ss"] forKey:@"processTime"];
    [dict setObject:[NSNumber numberWithInteger:0] forKey:@"appId"];
    [dict setObject:deviceId forKey:@"deviceId"];
    
    NSString *token = [UserDefaults shareUserDefault].authTkn;
    if(hasToken && token != nil){
        [dict setObject:token forKey:@"authTkn"];
    }
    
    //获取父类的属性数量
    unsigned int outCount;
    objc_property_t *properties = class_copyPropertyList([self class], &outCount);
    
    for(int i=0;i<outCount;i++){
        objc_property_t property = properties[i];
        //获取到属性的名称
        NSString *key=[[NSString alloc]initWithCString:property_getName(property)
                                              encoding:NSUTF8StringEncoding];
        //生成获取属性名称对应值的selector;
        SEL selector = NSSelectorFromString(key);
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        //获取对应的值
        id value = [self performSelector:selector];
        //nil 转换成 null;
        if(value == nil){
            value = [NSNull null];
        }
        [dict setObject:value forKey:key];
        
    }
    //释放属性数组
    free(properties);
    
    return [dict JSONRepresentation];
}

-(NSString*)getRequestURLString{
    
    return [URLHelper getRequestURLByBusinessType:_businessType widthMethodName:_methodName];
}

@end
