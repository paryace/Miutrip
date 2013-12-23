//
//  HotelCantonViewController.h
//  MiuTrip
//
//  Created by stevencheng on 13-12-22.
//  Copyright (c) 2013年 michael. All rights reserved.
//

#import "BaseUIViewController.h"

@interface HotelCantonViewController : BaseUIViewController<UITableViewDataSource,UITableViewDelegate>

@property (strong,nonatomic) NSArray *cantonData;

@end
