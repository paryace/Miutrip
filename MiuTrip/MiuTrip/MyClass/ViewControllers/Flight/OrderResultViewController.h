//
//  OrderResultViewController.h
//  MiuTrip
//
//  Created by apple on 13-12-3.
//  Copyright (c) 2013年 michael. All rights reserved.
//

#import "BaseUIViewController.h"
#import "SubmitFlightOrderRequest.h"
#import "UPPayPlugin.h"
#import "UPPayPluginDelegate.h"

@protocol OrderResultDelegate <NSObject>

- (void)OrderSuccess;

@end

@interface OrderResultViewController : BaseUIViewController<UPPayPluginDelegate>

- (id)initWithParams:(SubmitFlightOrderResponse*)params;      //list<MsgPayEntity>

@end
