//
//  HotelListCellviewCell.h
//  MiuTrip
//
//  Created by stevencheng on 13-12-7.
//  Copyright (c) 2013年 michael. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AsyncImageView.h"

/**
 *  酒店列表酒店信息CELL
 */
@interface HotelListCellviewCell : UITableViewCell

@property (nonatomic,strong) AsyncImageView *hotelImage;
@property (nonatomic,strong) UILabel *hotelName;    //酒店名称
@property (nonatomic,strong) UILabel *address;      //酒店地址
@property (nonatomic,strong) UILabel *comment;      //酒店好评，评论
@property (nonatomic,strong) UILabel *price;        //酒店价格

@end
