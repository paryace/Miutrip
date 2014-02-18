//
//  OrderFillInViewController.h
//  MiuTrip
//
//  Created by SuperAdmin on 13-12-2.
//  Copyright (c) 2013年 michael. All rights reserved.
//

#import "BaseUIViewController.h"
#import "PassengerListViewController.h"
#import "CommonlyNameViewController.h"
#import "PostTypeViewController.h"

#define         OrderFillCellHeight         35.0
#define         OrderFillCellWidth          (appFrame.size.width - 30)

@class DomesticFlightDataDTO;
@class SubmitFlightOrderRequest;
@class OnlinePassengersDTO;

@interface OrderFillInViewController : BaseUIViewController<UITableViewDataSource,UITableViewDelegate,PassengerListViewDelegate,CommonlyNameSelectDelegate,UITextFieldDelegate,PostTypeDelegate>

@property (strong, nonatomic) id policyExecutor;
@property (strong, nonatomic) NSArray   *passengers;

- (id)initWithRequest:(SubmitFlightOrderRequest *)request corpPolicy:(GetCorpPolicyResponse*)corpPolicy;

- (void)saveOrder;

@end

@interface OrderFillInViewCell : UITableViewCell

- (void)setContentWithParams:(NSObject*)param;
- (void)setInsuranceWithCorpPolicy:(GetCorpPolicyResponse*)corpPolicy;

@end
