//
//  HotelSearchView.h
//  MiuTrip
//
//  Created by stevencheng on 13-12-6.
//  Copyright (c) 2013年 michael. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HotelOrderDetail.h"
#import "HomeViewController.h"

@interface HotelSearchView : UIView

@property (nonatomic,strong) HotelOrderDetail *data;
@property (nonatomic,strong) HomeViewController *viewController;

-(id)initWidthFrame:(CGRect)frame widthdata:(HotelOrderDetail*)data
      widthDelegate:(HomeViewController*) viewController;

-(void)pressHotelItemBtn:(UIButton*)sender;

@end
