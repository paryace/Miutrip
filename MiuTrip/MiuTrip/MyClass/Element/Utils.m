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
    if ([value isKindOfClass:[NSNull class]] || value == nil || [value isEqualToString:@""]) {
        return YES;
    }return NO;
}

+(BOOL)isEmpty:(id)value
{
    if ([value isKindOfClass:[NSNull class]] || value == nil) {
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

+(NSDate*)dateWithString:(NSString *)dateString withFormat:(NSString*)format
{
    NSDateFormatter *dateFormate = [[NSDateFormatter alloc]init];
    [dateFormate setDateFormat:format];
    NSDate *date = [dateFormate dateFromString:dateString];
    return date;
}

+(NSString *)formatDateWithString:(NSString *)dateString startFormat:(NSString *)startFormat endFormat:(NSString *)endFormat
{
    NSDateFormatter *dateFormate = [[NSDateFormatter alloc]init];
    [dateFormate setDateFormat:startFormat];
    NSDate *date = [dateFormate dateFromString:dateString];
    
    [dateFormate setDateFormat:endFormat];
    NSString *result = [dateFormate stringFromDate:date];
    return result;
}

+ (float)heightForWidth:(CGFloat)textViewWidth text:(NSString *)strText font:(UIFont*)font{
    NSAttributedString *attributedText = [[NSAttributedString alloc] initWithString:
                                          strText attributes:@{NSFontAttributeName: font}];
    
    CGRect rect = [attributedText boundingRectWithSize:CGSizeMake(textViewWidth, 9999) options:NSStringDrawingUsesLineFragmentOrigin context:nil];
    
    return ceilf(rect.size.height);
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


+(BOOL)string:(NSString*)string isEqualToString:(NSString*)goalString
{
    BOOL equal = NO;
    if ([[string uppercaseString] isEqualToString:[goalString uppercaseString]]) {
        equal = YES;
    }
    return equal;
}

+(BOOL)string:(NSString*)string containsString:(NSString*)substring
{
    BOOL contain = NO;
    NSLog(@"string = %@",string);
    if ([[string uppercaseString] rangeOfString:[substring uppercaseString]].length > 0) {
        contain = YES;
    }
    NSLog(@"bool = %d",contain);
    return contain;
}


+(CATransition *)getAnimation:(TransitionType)mytag subType:(Direction)subTag{
    if (mytag != TransitionNone) {
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
    }else{
        return nil;
    }
}

//中文和小写字母
+(BOOL)isCina:(NSString*)value{
    
    return [value isMatchedByRegex:@"^[a-z]+$|^[\u4e00-\u9fa5]{0,}$"];
}
//只是英文字母
+(BOOL)isEnglish:(NSString*)value{
    return [value isMatchedByRegex:@"^[A-Za-z]+$"];
    
}
//英文和数字
+(BOOL)isnumberandenglish:(NSString*)value{
    return [value isMatchedByRegex:@"^[A-Za-z0-9]+$"];
}
//数字,英文,括号
+(BOOL)isnumberandenglishandkuo:(NSString *)value{
    return [value isMatchedByRegex:@"^[A-Za-z0-9]+$"];
}
+(BOOL)ismailbox:(NSString*)value{
    return  [value isMatchedByRegex:@"\\b([a-zA-Z0-9%_.+\\-]+)@([a-zA-Z0-9.\\-]+?\\.[a-zA-Z]{2,6})\\b"];
}


@end
