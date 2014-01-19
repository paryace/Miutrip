//
//  GetCityCityCantonAndSectionsResponse.h
//  MiuTrip
//
//  Created by apple on 13-12-4.
//  Copyright (c) 2013年 michael. All rights reserved.
//

#import "BaseResponseModel.h"

@interface GetCityCityCantonAndSectionsResponse : BaseResponseModel

@property (strong, nonatomic) NSArray       *CantonList;        //区域列表	List<CantonDTO>
@property (strong, nonatomic) NSArray       *SectionList;       //	List<SectionDTO>

@end
