//
//  CorpCostCenterDTO.h
//  MiuTrip
//
//  Created by apple on 13-11-28.
//  Copyright (c) 2013年 michael. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CostCenterListDTO;

@interface CorpCostCenterDTO : NSObject

@property (assign, nonatomic) NSInteger     ItemID;                 //选项ID
@property (assign, nonatomic) NSInteger     ItemIndex;              //项目索引
@property (assign, nonatomic) NSInteger     CorpID;                 //企业ID
@property (strong, nonatomic) NSString      *ItemTitle;             //自定义项标题
@property (strong, nonatomic) NSString      *ItemContent;           //自定义项内容
@property (assign, nonatomic) char          IsMustInput;            //是否必填
@property (assign, nonatomic) char          IsList;                 //是否下拉选择

@end

@interface  CostCenterListDTO : NSObject

@property (strong, nonatomic) NSMutableArray *costCenterList;

@property (assign, nonatomic) NSInteger     ID;                     //选择项ID
@property (assign, nonatomic) NSInteger     ItemID;                 //选项ID
@property (strong, nonatomic) NSString      *ItemText;              //选项文本
@property (strong, nonatomic) NSString      *ItemValue;             //选项值

@end