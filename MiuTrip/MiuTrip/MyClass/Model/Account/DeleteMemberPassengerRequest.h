//
//  DeleteMemberPassengerRequest.h
//  MiuTrip
//
//  Created by Y on 13-12-2.
//  Copyright (c) 2013年 michael. All rights reserved.
//

#import "BaseRequestModel.h"
#import "DeleteMemberPassengerResponse.h"
////////////////////////////////////////////////////////////////////////////////

@interface DeleteMemberPassengerRequest : BaseRequestModel

@property (nonatomic , strong) NSNumber *PassengerID;   //旅客ID

@end


