//
//  GetSectionsByCityIdResponse.h
//  MiuTrip
//
//  Created by apple on 13-12-4.
//  Copyright (c) 2013年 michael. All rights reserved.
//

#import "BaseResponseModel.h"

@interface GetSectionsByCityIdResponse : BaseResponseModel

@property (strong, nonatomic) NSArray       *sections;      //商业区       List<SectionDTO>

@end

@interface SectionDTO : NSObject

@property (strong, nonatomic) NSNumber      *Id;            //商业区ID	int
@property (strong, nonatomic) NSString      *Name;          //商业区名称
@property (strong, nonatomic) NSNumber      *CityId;        //城市ID	int

@end
