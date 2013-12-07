//
//  GetCorpPolicyResponse.h
//  MiuTrip
//
//  Created by Y on 13-12-4.
//  Copyright (c) 2013年 michael. All rights reserved.
//

#import "BaseResponseModel.h"


@interface GetCorpPolicyResponse : BaseResponseModel

@property (strong, nonatomic) NSNumber     *PID;                    //差旅规则ID
@property (strong, nonatomic) NSNumber     *CorpID;                 //企业ID
@property (strong, nonatomic) NSString      *OrderRange;            //预定范围
@property (strong, nonatomic) NSString      *IsNeedRC_FltN;         //是否国内机票需要ReasonCode T/F
@property (strong, nonatomic) NSNumber     *PreMinute;              //Reason Code检测时间段前分钟数
@property (strong, nonatomic) NSNumber     *LastMinute;             //Reason Code检测时间段后分钟数
@property (strong, nonatomic) NSString      *FltPreBookRC;          //是否需要国内机票提前预订Reason Code T/F
@property (strong, nonatomic) NSNumber     *FltPreBookDays;         //国内机票提前预订天数
@property (strong, nonatomic) NSString      *IntlFltPreBookRC;      //是否允许国际机票提前预订Reason Code T/F
@property (strong, nonatomic) NSNumber     *IntlFltPreBookDays;     //国际机票提前预订天数
@property (strong, nonatomic) NSString      *Insurance;             //国内机票是否可买保险
@property (strong, nonatomic) NSString      *IntlInsurance;         //两舱是否可预订
@property (strong, nonatomic) NSString      *HotelRC;               //酒店预订ReasonCode
@property (strong, nonatomic) NSString      *FltPolicyTitle;        //飞机票政策标题
@property (strong, nonatomic) NSString      *FltRule;               //飞机票规则

@property (strong, nonatomic) NSMutableArray *HotelReasonCodeN;     //国内酒店RC	List<ReasonCodeDTO>
@property (strong, nonatomic) NSMutableArray *HotelReasonCodeI;     //国际酒店RC	List<ReasonCodeDTO>
@property (strong, nonatomic) NSMutableArray *PreBookReasonCodeN;   //国内提前预定RC	List<ReasonCodeDTO>
@property (strong, nonatomic) NSMutableArray *FltPricelReasonCodeN; //国内飞机票最低价RC	List<ReasonCodeDTO>
@property (strong, nonatomic) NSMutableArray *PreBookReasonCodeI;   //国际提前预定RC	List<ReasonCodeDTO>
@property (strong, nonatomic) NSMutableArray *FltPricelReasonCodeI; //国际飞机票最低价RC	List<ReasonCodeDTO>

@property (assign, nonatomic) NSNumber       *HtlAmountLimtMax;       //酒店预订标准上限
@property (strong, nonatomic) NSString      *DefineFlag;            //是否需要自定义字段 T/F
@property (strong, nonatomic) NSString      *PolicyName;            //差旅规则名称
@property (strong, nonatomic) NSString      *PolicyDesc;            //政策描述
@property (strong, nonatomic) NSString      *GetHotelPolicyString;  //获取酒店政策字符串
@property (strong, nonatomic) GetCorpPolicyResponse *Empty;                 //空政策


@end



@interface ReasonCodeResponse : BaseResponseModel

@property (strong, nonatomic) NSNumber     *RID;                    //RC代码
@property (strong, nonatomic) NSNumber     *CorpID;                 //企业ID
@property (strong, nonatomic) NSString      *ReasonCode;            //RC描述
@property (strong, nonatomic) NSString      *ReasonCodeEn;          //RC描述(英文)
@property (strong, nonatomic) NSNumber     *RCClass;                //RC状态(1:有效,0:停用)
@property (strong, nonatomic) NSNumber     *RCType;                 //RC类别(1.机票低价RC，2：机票提前RC)

@end

