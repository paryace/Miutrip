//
//  HotelListBtnCellView.h
//  MiuTrip
//
//  Created by stevencheng on 14-1-4.
//  Copyright (c) 2014年 michael. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HotelListBtnCellView : UITableViewCell

@property (nonatomic) int hotelId;
@property (nonatomic,assign) UIViewController *viewController;
@property (nonatomic,strong) NSDictionary *hotelData;
@property (nonatomic) BOOL hasMapBtn;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier hasMapBtn:(BOOL) hasMapBtn;

@end
