//
//  HotelListCellviewCell.m
//  MiuTrip
//
//  Created by stevencheng on 13-12-7.
//  Copyright (c) 2013年 michael. All rights reserved.
//

#import "HotelListCellviewCell.h"

@implementation HotelListCellviewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setUpView];
    }
    return self;
}

-(void) setUpView{

    //图片
    UIImageView *hotelImage = [[UIImageView alloc]init];
    [hotelImage setFrame:CGRectMake(3, 0, 70, 70)];
    
    [self addSubview:hotelImage];
    //酒店名称
    _hotelName = [[UILabel alloc] initWithFrame:CGRectMake(65, 1, self.frame.size.width - 65, 20)];
    [_hotelName setFont:[UIFont boldSystemFontOfSize:15]];
    [_hotelName setTextColor:color(blackColor)];
    [_hotelName setNumberOfLines:1];
    [self addSubview:_hotelName];
    
    //箭头
    UIImageView *arrow = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"arrow.png"]];
    [arrow setFrame:CGRectMake(self.frame.size.width-17, (70 - 16)/2, 12, 16)];
    [self addSubview:arrow];
    
    //价格
    _price = [[UILabel alloc] initWithFrame:CGRectMake(self.frame.size.width - 69, (70 - 16)/2, 50,16)];
    [_price setFont:[UIFont systemFontOfSize:13]];
    [_price setTextColor:UIColorFromRGB(0xee7600)];
    [self addSubview:_price];
    
    //地址
    _address = [[UILabel alloc] initWithFrame:CGRectMake(65, 23, self.frame.size.width - 140, 32)];
    [_address setTextColor:color(grayColor)];
    [_address setFont:[UIFont systemFontOfSize:13]];
    [_address setNumberOfLines:2];
    [self addSubview:_address];
    
    //好评，评论
    _comment = [[UILabel alloc] initWithFrame:CGRectMake(65, 57, self.frame.size.width, 15)];
    [_comment setTextColor:color(grayColor)];
    [_comment setFont:[UIFont systemFontOfSize:12]];
    
    [self addSubview:_comment];
}


-(void)layoutSubviews{
    [super layoutSubviews];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
