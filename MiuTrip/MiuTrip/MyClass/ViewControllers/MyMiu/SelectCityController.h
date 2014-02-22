//
//  StartCityController.h
//  MiuTrip
//
//  Created by GX on 14-1-22.
//  Copyright (c) 2014年 michael. All rights reserved.
//

#import "BaseUIViewController.h"

@interface SelectCityController : BaseUIViewController <UITableViewDataSource,UITableViewDelegate>
@property (strong,nonatomic) void (^selectCity)(NSString*);
-(id)initWithParams;
@end
