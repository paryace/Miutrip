//
//  EditGuestViewController.h
//  MiuTrip
//
//  Created by apple on 14-3-14.
//  Copyright (c) 2014年 michael. All rights reserved.
//

#import "BaseUIViewController.h"

@protocol EditGuestDelegate <NSObject>

- (void)editGuestDone:(NSInteger)index;

@end

@interface EditGuestViewController : BaseUIViewController<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>

@property (assign, nonatomic) id<EditGuestDelegate> delegate;
@property (strong, nonatomic) UITextField *userName;
@property (strong, nonatomic) CostCenterItem *costCentre;
@property (assign, nonatomic) CGFloat       shareAmount;
@property (assign, nonatomic) NSInteger     customerIndex;

@property (strong, nonatomic) UITableView *costCentreList;
@property (strong, nonatomic) NSMutableArray *costCentreArray;
@property (strong, nonatomic) NSArray *shareAmountArray;
@property (strong, nonatomic) NSArray *mArray;
@property (copy, nonatomic)   void (^selectResult)(NSString *, NSString *, NSString *);

- (id)initWithIndex:(NSInteger)index;   // -1:add new customer  indexPath.row:edit customer

@end
