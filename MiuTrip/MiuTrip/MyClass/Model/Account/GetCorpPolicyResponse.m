//
//  GetCorpPolicyResponse.m
//  MiuTrip
//
//  Created by Y on 13-12-4.
//  Copyright (c) 2013年 michael. All rights reserved.
//

#import "GetCorpPolicyResponse.h"

@implementation GetCorpPolicyResponse

- (void)getObjects
{
    
    NSMutableArray *HotelReasonCodeNArray = [NSMutableArray array];
    for (NSDictionary *dic in _HotelReasonCodeN) {
        ReasonCodeDTO *rcDTO = [[ReasonCodeDTO alloc]init];
        [rcDTO parshJsonToResponse:dic];
        [HotelReasonCodeNArray addObject:rcDTO];
    }
    _HotelReasonCodeN = HotelReasonCodeNArray;
    
    NSMutableArray *HotelReasonCodeIArray = [NSMutableArray array];
    for (NSDictionary *dic in _HotelReasonCodeI) {
        ReasonCodeDTO *rcDTO = [[ReasonCodeDTO alloc]init];
        [rcDTO parshJsonToResponse:dic];
        [HotelReasonCodeIArray addObject:rcDTO];
    }
    _HotelReasonCodeI = HotelReasonCodeIArray;
    
    NSMutableArray *PreBookReasonCodeNArray = [NSMutableArray array];
    for (NSDictionary *dic in _PreBookReasonCodeN) {
        ReasonCodeDTO *rcDTO = [[ReasonCodeDTO alloc]init];
        [rcDTO parshJsonToResponse:dic];
        [PreBookReasonCodeNArray addObject:rcDTO];
    }
    _PreBookReasonCodeN = PreBookReasonCodeNArray;
    
    NSMutableArray *FltPricelReasonCodeNArray = [NSMutableArray array];
    for (NSDictionary *dic in _FltPricelReasonCodeN) {
        ReasonCodeDTO *rcDTO = [[ReasonCodeDTO alloc]init];
        [rcDTO parshJsonToResponse:dic];
        [FltPricelReasonCodeNArray addObject:rcDTO];
    }
    _FltPricelReasonCodeN = FltPricelReasonCodeNArray;
    
    NSMutableArray *PreBookReasonCodeIArray = [NSMutableArray array];
    for (NSDictionary *dic in _PreBookReasonCodeI) {
        ReasonCodeDTO *rcDTO = [[ReasonCodeDTO alloc]init];
        [rcDTO parshJsonToResponse:dic];
        [PreBookReasonCodeIArray addObject:rcDTO];
    }
    _PreBookReasonCodeI = PreBookReasonCodeIArray;
    
    NSMutableArray *FltPricelReasonCodeIArray = [NSMutableArray array];
    for (NSDictionary *dic in _FltPricelReasonCodeI) {
        ReasonCodeDTO *rcDTO = [[ReasonCodeDTO alloc]init];
        [rcDTO parshJsonToResponse:dic];
        [FltPricelReasonCodeIArray addObject:rcDTO];
    }
    _FltPricelReasonCodeI = FltPricelReasonCodeIArray;
    
    NSMutableArray *FltRateReasonCodeNArray = [NSMutableArray array];
    for (NSDictionary *dic in _FltRateReasonCodeN) {
        ReasonCodeDTO *rcDTO = [[ReasonCodeDTO alloc]init];
        [rcDTO parshJsonToResponse:dic];
        [FltRateReasonCodeNArray addObject:rcDTO];
    }
    _FltRateReasonCodeN = FltRateReasonCodeNArray;
    
    NSMutableArray *FltRateReasonCodeIArray = [NSMutableArray array];
    for (NSDictionary *dic in _FltRateReasonCodeI) {
        ReasonCodeDTO *rcDTO = [[ReasonCodeDTO alloc]init];
        [rcDTO parshJsonToResponse:dic];
        [FltRateReasonCodeIArray addObject:rcDTO];
    }
    _FltRateReasonCodeI = FltRateReasonCodeIArray;

}

@end

@implementation ReasonCodeDTO

@end