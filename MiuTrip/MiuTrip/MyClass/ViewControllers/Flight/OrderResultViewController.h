//
//  OrderResultViewController.h
//  MiuTrip
//
//  Created by apple on 13-12-3.
//  Copyright (c) 2013年 michael. All rights reserved.
//

#import "BaseUIViewController.h"
#import "SubmitFlightOrderRequest.h"

@interface OrderResultViewController : BaseUIViewController

- (id)initWithParams:(SubmitFlightOrderResponse*)params;      //list<MsgPayEntity>

@end
