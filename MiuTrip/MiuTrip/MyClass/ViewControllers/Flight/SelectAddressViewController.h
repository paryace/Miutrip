//
//  SelectAddressViewController.h
//  MiuTrip
//
//  Created by apple on 14-2-13.
//  Copyright (c) 2014年 michael. All rights reserved.
//

#import "BaseUIViewController.h"

typedef NS_OPTIONS(NSInteger, SelectAddressType) {
    SelectAddressProvince,
    SelectAddressCity,
    SelectAddressCanton
};

@protocol SelectAddressDelegate <NSObject>

- (void)selectAddressDone:(id)address;

@end

@interface SelectAddressViewController : BaseUIViewController<UITableViewDataSource,UITableViewDelegate>

@property (assign, nonatomic) id<SelectAddressDelegate> delegate;

- (void)getAddressList;

- (id)initWithObject:(id)object;

@end
