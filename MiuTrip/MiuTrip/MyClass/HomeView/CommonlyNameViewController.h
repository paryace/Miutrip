//
//  CommonlyNameViewController.h
//  MiuTrip
//
//  Created by SuperAdmin on 13-11-15.
//  Copyright (c) 2013年 michael. All rights reserved.
//

#import "BaseUIViewController.h"

#define             CommonlyNameViewCellHeight                  40

@interface CommonlyNameViewController : BaseUIViewController<UITableViewDataSource,UITableViewDelegate>

@property (strong, nonatomic) NSMutableArray                *dataSource;
@property (strong, nonatomic) UITableView                   *theTableView;



@end

@interface CommonlyNameViewCell : UITableViewCell

@property (assign, nonatomic) BOOL                          unfold;

- (void)setBackGroundImage:(UIImage*)image;
- (void)subviewUnfold:(BOOL)show;

- (void)setContentWithParams:(BookPassengersDTO*)passengerDetail;

@end

