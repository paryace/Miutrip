//
//  HotelListBtnCellView.m
//  MiuTrip
//
//  Created by stevencheng on 13-12-7.
//  Copyright (c) 2013年 michael. All rights reserved.
//

#import "HotelListBtnCellView.h"

@implementation HotelListBtnCellView

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setUpView];
    }
    return self;
}

-(void)setUpView
{
   
    UIButton *hotelDetail  = [UIButton buttonWithType:UIButtonTypeCustom];
    hotelDetail.titleLabel.text = @"酒店详情";
    [hotelDetail setFrame:CGRectMake(0, 0, self.frame.size.width/3, 30)];
    [self addSubview:hotelDetail];
    
    UIButton *hotelLocal  = [UIButton buttonWithType:UIButtonTypeCustom];
    hotelLocal.titleLabel.text = @"酒店位置";
    [hotelLocal setFrame:CGRectMake(0, 0, self.frame.size.width/3, 30)];
    [self addSubview:hotelLocal];
    
    UIButton *hotelcomments  = [UIButton buttonWithType:UIButtonTypeCustom];
    hotelcomments.titleLabel.text = @"酒店评论";
    [hotelcomments setFrame:CGRectMake(0, 0, self.frame.size.width/3, 30)];
    [self addSubview:hotelcomments];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
