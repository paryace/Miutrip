//
//  CommonlyNameViewController.h
//  MiuTrip
//
//  Created by SuperAdmin on 13-11-15.
//  Copyright (c) 2013年 michael. All rights reserved.
//

#import "BaseUIViewController.h"

@class BookPassengersResponse;
@class CustomBtn;

#define             CommonlyNameViewCellHeight                  40

@protocol CommonlyNameSelectDelegate <NSObject>

- (void)contactSelectDone:(id)contact;

@end

@interface CommonlyNameViewController : BaseUIViewController<UITableViewDataSource,UITableViewDelegate>

@property (assign, nonatomic) id<CommonlyNameSelectDelegate> delegate;

@property (strong, nonatomic) NSMutableArray                *dataSource;
@property (strong, nonatomic) UITableView                   *theTableView;

- (void)getContact;

@end

@interface CommonlyNameViewCell : UITableViewCell

@property (assign, nonatomic) BOOL                          isSelect;
@property (assign, nonatomic) BOOL                          unfold;
@property (strong, nonatomic) CustomBtn                     *selectBtn;

- (void)setBackGroundImage:(UIImage*)image;
- (void)subviewUnfold:(BOOL)show;

- (void)setContentWithParams:(BookPassengersResponse*)passengerDetail;

@end

