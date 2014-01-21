//
//  LittleMiuDetail.m
//  MiuTrip
//
//  Created by pingguo on 13-12-18.
//  Copyright (c) 2013年 michael. All rights reserved.
//

#import "LittleMiuDetail.h"
#import "CommonlyName.h"

@implementation LittleMiuDetail

+(LittleMiuDetail*)sharedInstance{
    DEFINE_SHARED_INSTANCE_USING_BLOCK(^{
        return [[self alloc] init];
    });
}

- (id)init
{
    if (self = [super init]) {
        _unfold = NO;
        NSInteger num = arc4random()%4 + 1;
        _passengers = [CommonlyName getCommonDataWithNum:num];
    }
    return self;
}

+ (NSArray*)getCommonDataWithNum:(NSInteger)num
{
    NSMutableArray *array = [NSMutableArray array];
    for (int i = 0; i<num; i++) {
        LittleMiuDetail *detail = [[LittleMiuDetail alloc]init];
        [array addObject:detail];
    }
    return array;
}


@end
