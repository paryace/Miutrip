//
//  SettingViewController.h
//  MiuTrip
//
//  Created by SuperAdmin on 13-11-18.
//  Copyright (c) 2013年 michael. All rights reserved.
//

#import "BaseUIViewController.h"

@interface SettingViewController : BaseUIViewController<UITableViewDataSource,UITableViewDelegate>
@property (strong,nonatomic) void (^PostAddressData)(NSMutableArray*);
@end
