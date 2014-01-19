//
//  OrderFillInViewController.h
//  MiuTrip
//
//  Created by SuperAdmin on 13-12-2.
//  Copyright (c) 2013年 michael. All rights reserved.
//

#import "BaseUIViewController.h"

#define         OrderFillCellHeight         40.0
#define         OrderFillCellWidth          (appFrame.size.width - 30)

@class DomesticFlightDataDTO;

@interface OrderFillInViewController : BaseUIViewController<UITableViewDataSource,UITableViewDelegate>

- (id)initWithFlight:(DomesticFlightDataDTO *)flight;

@end

@interface OrderFillInViewCell : UITableViewCell

- (void)setContentWithParams:(NSObject*)param;

@end
