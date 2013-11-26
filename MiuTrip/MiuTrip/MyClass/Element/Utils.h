//
//  Utils.h
//  TrainTicketQuery
//
//  Created by M J on 13-8-20.
//  Copyright (c) 2013年 M J. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>

#define             transitionDuration              0.35f
#define             WeekDays                        @"星期日,星期一,星期二,星期三,星期四,星期五,星期六"

typedef NS_OPTIONS(NSInteger, TransitionType){
    TransitionFade,
    TransitionPush,
    TransitionReveal,
    TransitionMoveIn,
    TransitionCube,
    TransitionSuckEffect,
    TransitionOglFlip,
    TransitionRippleEffect,
    TransitionPageCurl,
    TransitionPageUnCurl,
    TransitionCameraIrisHollowOpen,
    TransitionCameraIrisHollowClose
};

typedef NS_OPTIONS(NSInteger, Direction){
    DirectionLeft,
    DirectionBottom,
    DirectionRight,
    DirectionTop
};

@interface Utils : NSObject

+(NSString*)nilToEmpty:(NSString*)value;
+(NSString*)NULLToEmpty:(id)value;
+(BOOL)textIsEmpty:(NSString*)value;
+(NSString *)stringWithDate:(NSDate*)date withFormat:(NSString*)format;
+(NSDate*)dateWithString:(NSString *)date withFormat:(NSString*)format;
+(float)heightForWidth:(CGFloat)textViewWidth text:(NSString *)strText font:(UIFont*)font;
+(BOOL)isValidatePhoneNum:(NSString *)phoneNum;
+(BOOL)isValidateIdNum:(NSString *)idNum;
+(BOOL)isValidatePassportNum:(NSString *)passportNum;

+(CATransition *)getAnimation:(TransitionType)mytag subType:(Direction)subTag;

@end
