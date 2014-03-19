//
//  HotelOrderViewController.h
//  MiuTrip
//
//  Created by stevencheng on 13-12-21.
//  Copyright (c) 2013年 michael. All rights reserved.
//

#import "BaseUIViewController.h"
#import "UIPopoverListView.h"
//#import "UPPayPluginDelegate.h"
//#import "UPPayPlugin.h"
#import "PassengerListViewController.h"
#import "EditGuestViewController.h"

@interface HotelOrderViewController : BaseUIViewController<UIPopoverListViewDataSource,UIPopoverListViewDelegate,
                                     UITableViewDataSource,UITableViewDelegate,PassengerListViewDelegate,EditGuestDelegate>

@property (strong,nonatomic) NSArray        *popupListData;
@property (nonatomic)        int            popupType;
@property (strong,nonatomic) NSArray        *arriveTimeArray;
@property (nonatomic)        int            roomPrice;
@property (nonatomic,strong) NSArray        *contactorArray;
@property (nonatomic,strong) UIAlertView    *mAlert;
@property (nonatomic,strong) NSMutableData  *mData;

- (void)showAlertWait;
- (void)showAlertMessage:(NSString*)msg;
- (void)hideAlert;

@end

@interface customerTableViewCell : UITableViewCell

@property (nonatomic,strong) UILabel   *name;
@property (nonatomic,strong) UILabel   *costCenter;
@property (nonatomic,strong) UILabel   *costApportion;

@end