//
//  CostCenterListResponse.h
//  MiuTrip
//
//  Created by Y on 13-12-4.
//  Copyright (c) 2013年 michael. All rights reserved.
//

#import "BaseResponseModel.h"

@interface GetCorpCostResponse: BaseResponseModel

@property (strong, nonatomic) NSNumber     *ItemID;                 //选项ID
@property (strong, nonatomic) NSNumber     *ItemIndex;              //项目索引
@property (strong, nonatomic) NSNumber     *CorpID;                 //企业ID
@property (strong, nonatomic) NSString      *ItemTitle;             //自定义项标题
@property (strong, nonatomic) NSString      *ItemContent;           //自定义项内容
@property (strong, nonatomic) NSNumber          *IsMustInput;            //是否必填
@property (strong, nonatomic) NSNumber          *IsList;                 //是否下拉选择

@end



@interface  CostCenterListResponse : BaseResponseModel

@property (strong, nonatomic) NSMutableArray *costCenterList;

@property (strong, nonatomic) NSNumber     *ID;                     //选择项ID
@property (strong, nonatomic) NSNumber     *ItemID;                 //选项ID
@property (strong, nonatomic) NSString      *ItemText;              //选项文本
@property (strong, nonatomic) NSString      *ItemValue;             //选项值

@end
