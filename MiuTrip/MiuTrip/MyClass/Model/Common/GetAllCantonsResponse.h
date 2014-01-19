//
//  GetAllCantonsResponse.h
//  MiuTrip
//
//  Created by apple on 13-12-4.
//  Copyright (c) 2013年 michael. All rights reserved.
//

#import "BaseResponseModel.h"

@interface GetAllCantonsResponse : BaseResponseModel

@property (strong, nonatomic) NSArray       *cantons;       //区域列表	List<CantonDTO>

@end
