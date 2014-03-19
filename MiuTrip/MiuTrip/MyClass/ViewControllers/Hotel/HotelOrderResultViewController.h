//
//  HotelOrderResultViewController.h
//  MiuTrip
//
//  Created by MB Pro on 14-3-19.
//  Copyright (c) 2014年 michael. All rights reserved.
//

#import "BaseUIViewController.h"
#import "SubmitOrderResponse.h"
#import "UPPayPlugin.h"
#import "UPPayPluginDelegate.h"

@interface HotelOrderResultViewController : BaseUIViewController<UPPayPluginDelegate>


- (id)initWithParams:(SubmitOrderResponse *)params;


@end
