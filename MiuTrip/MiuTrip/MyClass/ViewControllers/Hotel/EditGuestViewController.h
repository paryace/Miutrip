//
//  EditGuestViewController.h
//  MiuTrip
//
//  Created by apple on 14-3-14.
//  Copyright (c) 2014年 michael. All rights reserved.
//

#import "BaseUIViewController.h"

@interface EditGuestViewController : BaseUIViewController<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>

@property (strong, nonatomic) UITextField *userName;
@property (strong, nonatomic) NSString *costCentre;
@property (strong, nonatomic) NSString *ShareAmount;

@property (strong, nonatomic) UITableView *costCentreList;
@property (strong, nonatomic) NSMutableArray *costCentreArray;
@property (strong, nonatomic) NSArray *shareAmountArray;
@property (strong, nonatomic) NSArray *mArray;
@property (copy, nonatomic)   void (^selectResult)(NSString *, NSString *, NSString *);

@end
