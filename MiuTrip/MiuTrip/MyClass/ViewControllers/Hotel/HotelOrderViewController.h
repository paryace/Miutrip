//
//  HotelOrderViewController.h
//  MiuTrip
//
//  Created by stevencheng on 13-12-21.
//  Copyright (c) 2013年 michael. All rights reserved.
//

#import "BaseUIViewController.h"
#import "UIPopoverListView.h"

@interface HotelOrderViewController : BaseUIViewController<UIPopoverListViewDataSource,UIPopoverListViewDelegate,
                                     UITableViewDataSource,UITableViewDelegate>

@property (strong,nonatomic) NSArray  *popupListData;
@property (nonatomic)        int      popupType;
@property (strong,nonatomic) NSArray  *arriveTimeArray;
@property (nonatomic)        int      roomPrice;
@property (nonatomic,strong) NSArray  *contactorArray;

@end

@interface customerTableViewCell : UITableViewCell

@property (nonatomic,strong) UILabel   *name;
@property (nonatomic,strong) UILabel   *costCenter;
@property (nonatomic,strong) UILabel   *costApportion;

@end