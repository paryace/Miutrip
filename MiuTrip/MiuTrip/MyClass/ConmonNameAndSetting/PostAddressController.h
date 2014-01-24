//
//  PostAddressController.h
//  MiuTrip
//
//  Created by GX on 14-1-23.
//  Copyright (c) 2014年 michael. All rights reserved.
//

#import "BaseUIViewController.h"

@interface PostAddressController : BaseUIViewController<UITableViewDataSource,UITableViewDelegate>
@property (strong,nonatomic) void (^postAddress)(NSString*);
@end
