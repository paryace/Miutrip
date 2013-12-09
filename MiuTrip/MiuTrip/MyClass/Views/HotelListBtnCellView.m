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
    
    float topMargin = 3;
    
    UIImageView *shadow = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"hotel_list_shadow.png"]];
    shadow.frame = CGRectMake(0, 0, self.frame.size.width, 15);
    [self addSubview:shadow];
    
   
    //酒店详情
    UIButton *hotelDetail  = [UIButton buttonWithType:UIButtonTypeCustom];
    [hotelDetail setBackgroundImage:[UIImage imageNamed:@"hotel_list_btn_bg.png"] forState:UIControlStateNormal];
    
    [hotelDetail setTitle:@"酒店详情" forState:UIControlStateNormal];
    [hotelDetail setTitleColor:BlueColor forState:UIControlStateNormal];
    hotelDetail.titleLabel.font = [UIFont systemFontOfSize: 13];
    [hotelDetail setFrame:CGRectMake(0, topMargin, self.frame.size.width/3, 27)];
    [self addSubview:hotelDetail];
    
    //icon
    UIImageView *detailImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ic_hotel_detail"]];
    detailImage.frame = CGRectMake(6, 4, 19, 18);
    [hotelDetail addSubview:detailImage];
    
    //箭头
    UIImageView *arrow1 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"arrow"]];
    arrow1.frame = CGRectMake(hotelDetail.frame.size.width - 18, 7, 8, 12);
    [hotelDetail addSubview:arrow1];
    
    
    //酒店位置
    UIButton *hotelLocal  = [UIButton buttonWithType:UIButtonTypeCustom];
    [hotelLocal setBackgroundImage:[UIImage imageNamed:@"hotel_list_btn_bg.png"] forState:UIControlStateNormal];
    [hotelLocal setTitle:@"酒店位置" forState:UIControlStateNormal];
    [hotelLocal setTitleColor:BlueColor forState:UIControlStateNormal];
    hotelLocal.titleLabel.font = [UIFont systemFontOfSize: 13];
    [hotelLocal setFrame:CGRectMake(self.frame.size.width/3, topMargin, self.frame.size.width/3, 27)];
    [self addSubview:hotelLocal];
    
    
    //icon
    UIImageView *localImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ic_hotel_local"]];
    localImage.frame = CGRectMake(6, 4, 19, 18);
    [hotelLocal addSubview:localImage];
    
    //箭头
    UIImageView *arrow2 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"arrow"]];
    arrow2.frame = CGRectMake(hotelLocal.frame.size.width - 18, 7, 8, 12);
    [hotelLocal addSubview:arrow2];
    

    
    //评论
    UIButton *hotelcomments  = [UIButton buttonWithType:UIButtonTypeCustom];
    [hotelcomments setBackgroundImage:[UIImage imageNamed:@"hotel_list_btn_bg.png"] forState:UIControlStateNormal];
    [hotelcomments setTitle:@"酒店评论" forState:UIControlStateNormal];
    [hotelcomments setTitleColor:BlueColor forState:UIControlStateNormal];
    hotelcomments.titleLabel.font = [UIFont systemFontOfSize: 13];
    [hotelcomments setFrame:CGRectMake((self.frame.size.width/3)*2, topMargin, self.frame.size.width/3, 27)];
    [self addSubview:hotelcomments];
    
    
    //icon
    UIImageView *commentImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ic_hotel_comment"]];
    commentImage.frame = CGRectMake(6, 4, 19, 18);
    [hotelcomments addSubview:commentImage];
    
    //箭头
    UIImageView *arrow3 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"arrow"]];
    arrow3.frame = CGRectMake(hotelcomments.frame.size.width - 18, 7, 8, 12);
    [hotelcomments addSubview:arrow3];
    
    //竖线1
    UIView *line1 = [[UIView alloc] initWithFrame:CGRectMake((self.frame.size.width)/3-0.6, 1, 0.6, 29)];
    [line1 setBackgroundColor:color(lightGrayColor)];
    [self addSubview:line1];
    
    //竖线2
    UIView *line2 = [[UIView alloc] initWithFrame:CGRectMake((self.frame.size.width)/3*2-0.6, 1, 0.6, 29)];
    [line2 setBackgroundColor:color(lightGrayColor)];
    [self addSubview:line2];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
