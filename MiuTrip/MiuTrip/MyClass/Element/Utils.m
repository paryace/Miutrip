//
//  Utils.m
//  TrainTicketQuery
//
//  Created by M J on 13-8-20.
//  Copyright (c) 2013年 M J. All rights reserved.
//

#import "Utils.h"

@implementation Utils

+(NSString*)nilToEmpty:(NSString*)value
{
    return value == nil?@"":value;
}

+(NSString*)NULLToEmpty:(id)value
{
    return ([value isKindOfClass:[NSNull class]] || value == nil)?@"":value;
}

+(BOOL)textIsEmpty:(NSString*)value
{
    if ([value isEqualToString:@""] || value == nil) {
        return YES;
    }return NO;
}

+(NSString *)stringWithDate:(NSDate*)date withFormat:(NSString*)format
{
    NSDateFormatter *dateFormate = [[NSDateFormatter alloc]init];
    [dateFormate setDateFormat:format];
    NSString *dateString = [dateFormate stringFromDate:date];
    return dateString;
}

+(NSDate*)dateWithString:(NSString *)date withFormat:(NSString*)format
{
    NSDateFormatter *dateFormate = [[NSDateFormatter alloc]init];
    [dateFormate setDateFormat:format];
    NSDate *dateString = [dateFormate dateFromString:date];
    return dateString;
}

+ (float)heightForWidth:(CGFloat)textViewWidth text:(NSString *)strText font:(UIFont*)font{
    float fPadding = 16.0; // 8.0px x 2
    CGSize constraint = CGSizeMake(textViewWidth - fPadding, CGFLOAT_MAX);
    
    NSAttributedString *attribute = [[NSAttributedString alloc]initWithString:strText];
    NSRange range = NSMakeRange(0, attribute.length);
    NSDictionary *dic = [attribute attributesAtIndex:0 effectiveRange:&range];
    
    CGSize size = [strText boundingRectWithSize:constraint options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading  attributes:dic context:nil].size;
    
    float fHeight = size.height + 16.0;
    
    return fHeight;
}

+(BOOL)isValidatePhoneNum:(NSString *)phoneNum
{
    
    NSString *phoneNumRegex = @"(\\+\\d+)?1[3458]\\d{9}$";
    
    NSPredicate *phoneNumTest = [NSPredicate predicateWithFormat:@"SELF MATCHES%@",phoneNumRegex];
    
    return [phoneNumTest evaluateWithObject:phoneNum];
}

+(BOOL)isValidatePassportNum:(NSString *)passportNum
{
    NSString *phoneNumRegex = @"P\\d{7}|G\\d{8}|\\d{8}D|S\\d{7}|S\\d{8}|D\\d{8}";
    
    NSPredicate *phoneNumTest = [NSPredicate predicateWithFormat:@"SELF MATCHES%@",phoneNumRegex];
    
    return [phoneNumTest evaluateWithObject:passportNum];
}

+(BOOL)isValidateIdNum:(NSString *)idNum
{
    NSString *phoneNumRegex2 = @"^\\d{15}(\\d{2}[0-9xX])?$";
    
    NSPredicate *phoneNumTest = [NSPredicate predicateWithFormat:@"SELF MATCHES%@",phoneNumRegex2];
    return [phoneNumTest evaluateWithObject:idNum];
}

+(CATransition *)getAnimation:(TransitionType)mytag subType:(Direction)subTag{
    CATransition *animation = [CATransition animation];
    animation.delegate = self;
    animation.duration = transitionDuration;
    animation.timingFunction = UIViewAnimationCurveEaseInOut;
    
    switch (mytag) {
        case TransitionFade:
            animation.type = kCATransitionFade;
            break;
        case TransitionPush:
            animation.type = kCATransitionPush;
            break;
        case TransitionReveal:
            animation.type = kCATransitionReveal;
            break;
        case TransitionMoveIn:
            animation.type = kCATransitionMoveIn;
            break;
        case TransitionCube:
            animation.type = @"cube";
            break;
        case TransitionSuckEffect:
            animation.type = @"suckEffect";
            break;
        case TransitionOglFlip:
            animation.type = @"oglFlip";
            break;
        case TransitionRippleEffect:
            animation.type = @"rippleEffect";
            break;
        case TransitionPageCurl:
            animation.type = @"pageCurl";
            break;
        case TransitionPageUnCurl:
            animation.type = @"pageUnCurl";
            break;
        case TransitionCameraIrisHollowOpen:
            animation.type = @"cameraIrisHollowOpen";
            break;
        case TransitionCameraIrisHollowClose:
            animation.type = @"cameraIrisHollowClose";
            break;
        default:
            
            break;
    }
    
    
    int i = subTag;
    switch (i) {
            
        case DirectionLeft: 
            animation.subtype = kCATransitionFromLeft; 
            break; 
        case DirectionBottom:
            animation.subtype = kCATransitionFromBottom; 
            break; 
        case DirectionRight:
            animation.subtype = kCATransitionFromRight; 
            break; 
        case DirectionTop:
            animation.subtype = kCATransitionFromTop; 
            break; 
        default: 
            
            break; 
    } 
    return animation; 
} 


@end
