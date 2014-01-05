//
//  HotelListBtnCellView.m
//  MiuTrip
//
//  Created by stevencheng on 14-1-4.
//  Copyright (c) 2014年 michael. All rights reserved.
//

#import "HotelListBtnCellView.h"
#import "HotelDataCache.h"
#import "HotelDetailViewController.h"
#import "HotelMapViewControler.h"
#import "HotelCommentViewController.h"

@implementation HotelListBtnCellView

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier hasMapBtn:(BOOL) hasMapBtn
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _hasMapBtn = hasMapBtn;
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
    
    int viewWidth = self.frame.size.width;
    int btnWidth = viewWidth/2;
    if(_hasMapBtn){
        btnWidth = viewWidth/3;
    }
    
    //酒店详情
    UIButton *hotelDetail  = [UIButton buttonWithType:UIButtonTypeCustom];
    [hotelDetail setBackgroundImage:[UIImage imageNamed:@"hotel_list_btn_bg.png"] forState:UIControlStateNormal];
    [hotelDetail setTag:1001];
    [hotelDetail setTitle:@"酒店详情" forState:UIControlStateNormal];
    [hotelDetail setTitleColor:BlueColor forState:UIControlStateNormal];
    hotelDetail.titleLabel.font = [UIFont systemFontOfSize: 13];
    [hotelDetail setFrame:CGRectMake(0, topMargin, btnWidth, 27)];
    [hotelDetail addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:hotelDetail];
    
    //icon
    UIImageView *detailImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ic_hotel_detail"]];
    detailImage.frame = CGRectMake(6, 4, 19, 18);
    [hotelDetail addSubview:detailImage];
    
    //箭头
    UIImageView *arrow1 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"arrow"]];
    arrow1.frame = CGRectMake(hotelDetail.frame.size.width - 18, 7, 8, 12);
    [hotelDetail addSubview:arrow1];
    
    int left = btnWidth;
    if(_hasMapBtn){
        
        //酒店位置
        UIButton *hotelLocal  = [UIButton buttonWithType:UIButtonTypeCustom];
        [hotelLocal setTag:1002];
        [hotelLocal setBackgroundImage:[UIImage imageNamed:@"hotel_list_btn_bg.png"] forState:UIControlStateNormal];
        [hotelLocal setTitle:@"酒店位置" forState:UIControlStateNormal];
        [hotelLocal setTitleColor:BlueColor forState:UIControlStateNormal];
        hotelLocal.titleLabel.font = [UIFont systemFontOfSize: 13];
        [hotelLocal setFrame:CGRectMake(btnWidth, topMargin, btnWidth, 27)];
        [hotelLocal addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:hotelLocal];
        
        
        //icon
        UIImageView *localImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ic_hotel_local"]];
        localImage.frame = CGRectMake(6, 4, 19, 18);
        [hotelLocal addSubview:localImage];
        
        //箭头
        UIImageView *arrow2 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"arrow"]];
        arrow2.frame = CGRectMake(hotelLocal.frame.size.width - 18, 7, 8, 12);
        [hotelLocal addSubview:arrow2];
        
        left = btnWidth*2;
    }
    
   
    
    //评论
    UIButton *hotelcomments  = [UIButton buttonWithType:UIButtonTypeCustom];
    [hotelcomments setTag:1003];
    [hotelcomments setBackgroundImage:[UIImage imageNamed:@"hotel_list_btn_bg.png"] forState:UIControlStateNormal];
    [hotelcomments setTitle:@"酒店评论" forState:UIControlStateNormal];
    [hotelcomments setTitleColor:BlueColor forState:UIControlStateNormal];
    hotelcomments.titleLabel.font = [UIFont systemFontOfSize: 13];
    [hotelcomments setFrame:CGRectMake(left, topMargin, btnWidth, 27)];
    [hotelcomments addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:hotelcomments];
    
    //icon
    UIImageView *commentImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ic_hotel_comment"]];
    commentImage.frame = CGRectMake(6, 4, 19, 18);
    [hotelcomments addSubview:commentImage];
    
    //箭头
    UIImageView *arrow3 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"arrow"]];
    arrow3.frame = CGRectMake(hotelcomments.frame.size.width - 18, 7, 8, 12);
    [hotelcomments addSubview:arrow3];
    
    if(_hasMapBtn){
        //竖线1
        UIView *line1 = [[UIView alloc] initWithFrame:CGRectMake(btnWidth-0.6, 1, 0.6, 29)];
        [line1 setBackgroundColor:color(lightGrayColor)];
        [self addSubview:line1];
        
        //竖线2
        UIView *line2 = [[UIView alloc] initWithFrame:CGRectMake(btnWidth*2-0.6, 1, 0.6, 29)];
        [line2 setBackgroundColor:color(lightGrayColor)];
        [self addSubview:line2];
    }else{
        //竖线
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(btnWidth-0.6, 1, 0.6, 29)];
        [line setBackgroundColor:color(lightGrayColor)];
        [self addSubview:line];
    }

    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

-(void)buttonPressed:(UIButton *)sender{
    switch(sender.tag){
        case 1001:
            [self goHotelDetail];
            break;
        case 1002:
            [self goHotelMap];
            break;
        case 1003:
            [self goHotelComments];
            break;
    }
}

-(void)goHotelMap{
    HotelMapViewControler *viewController = [[HotelMapViewControler alloc] initWithType:1 withData:_hotelData];
    [_viewController.navigationController pushViewController:viewController animated:YES];
}

-(void)goHotelDetail{
    [HotelDataCache sharedInstance].selectedHotelId = _hotelId;
    HotelDetailViewController *viewController = [[HotelDetailViewController alloc] init];
    [_viewController.navigationController pushViewController:viewController animated:YES];
}

-(void)goHotelComments{
    [HotelDataCache sharedInstance].selectedHotelId = _hotelId;
    HotelCommentViewController *viewController = [[HotelCommentViewController alloc] init];
    [_viewController.navigationController pushViewController:viewController animated:YES];
}

@end
