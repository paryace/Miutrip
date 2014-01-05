//
//  HotelDetailViewController.m
//  MiuTrip
//
//  Created by stevencheng on 13-12-14.
//  Copyright (c) 2013年 michael. All rights reserved.
//

#import "HotelDetailViewController.h"
#import "GetHotelDetailRequest.h"
#import "GetHotelDetailResponse.h"
#import "HotelDataCache.h"
#import "Utils.h"

@interface HotelDetailViewController ()

@end

@implementation HotelDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)init
{
    self = [super init];
    if (self) {
        [self setSubView];
    }
    return self;
}


-(void)setSubView{
   
    [self addTitleWithTitle:@"酒店详情" withRightView:nil];
    [self addLoadingView];
    [self getHotelDetail];
    
}

-(void)initViewWithData:(NSDictionary*)data
{
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0,40,self.contentView.frame.size.width,self.contentView.frame.size.height -40)];
    
    [self.contentView addSubview:scrollView];
    
    UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, viewWidth(scrollView),
                0)];
    [contentView setBackgroundColor:UIColorFromRGB(0xffe9e9e9)];
    [scrollView addSubview:contentView];
    
    //酒店名称
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 5,self.contentView.frame.size.width,20)];
    [nameLabel setFont:[UIFont systemFontOfSize:15]];
    [nameLabel setTextColor:color(blackColor)];
    [nameLabel setText:[data objectForKey:@"hotelName"]];
    [contentView addSubview:nameLabel];
    
    //酒店图片
    UIImageView *hotelImage = [[UIImageView alloc] initWithFrame:CGRectMake(10,30,60,70)];
    [hotelImage setBackgroundColor:color(grayColor)];
    [contentView addSubview:hotelImage];
    
    //图片数量
//    UILabel *picCount = [[UILabel alloc] initWithFrame:CGRectMake(10,65,60,20)];
//    [picCount setTextColor:color(whiteColor)];
//    [picCount setFont:[UIFont systemFontOfSize:12]];
//    [contentView addSubview:picCount];
    
    //地址
    UILabel *address = [[UILabel alloc] initWithFrame:CGRectMake(75,30,self.contentView.frame.size.width - 85,16)];
    [address setTextColor:color(blackColor)];
    [address setFont:[UIFont systemFontOfSize:13]];
    
    NSString *addstr = [NSString stringWithFormat:@"地址：%@%@%@%@",[data objectForKey:@"cityName"],[data objectForKey:@"sectionName"],[data objectForKey:@"street"],[data objectForKey:@"streetAddr"]];
    
    [address setText:addstr];
    [contentView addSubview:address];
    
    //周边
    UILabel *around = [[UILabel alloc] initWithFrame:CGRectMake(75,85,self.contentView.frame.size.width - 85,15)];
    [around setTextColor:color(blackColor)];
    [around setFont:[UIFont systemFontOfSize:13]];
    [around setText:[NSString stringWithFormat:@"周边：%@",[data objectForKey:@"nearby"]]];
    [contentView addSubview:around];
    
    //酒店简介
    UILabel *introduction = [[UILabel alloc] initWithFrame:CGRectMake(15,106,100,20)];
    [introduction setTextColor:color(blackColor)];
    [introduction setFont:[UIFont systemFontOfSize:15]];
    [introduction setText:@"酒店简介"];
    [contentView addSubview:introduction];
    
    
    UIFont *font = [UIFont systemFontOfSize:12];
    NSString *intro = [data objectForKey:@"intro"];
    int width = contentView.frame.size.width - 20;
//    float introTextHeight = [Utils heightForWidth:width text: intro font:font];
    
    CGRect rect =  CGRectMake(10, 132, width, 80);
    UIImageView *introBgView = [[UIImageView alloc]initWithFrame:rect];
    [introBgView setBackgroundColor:color(whiteColor)];
    [introBgView setBorderColor:color(lightGrayColor) width:1.0];
    [introBgView setCornerRadius:5.0];
//    [introBgView setAlpha:0.5];
    [contentView addSubview:introBgView];
    
    UILabel *introLabel = [[UILabel alloc] initWithFrame:CGRectMake(13, 132, width-6, 78)];
    [introLabel setBackgroundColor:color(clearColor)];
    [introLabel setFont:font];
    [introLabel setTextColor:color(darkGrayColor)];
    [introLabel setText:[NSString stringWithFormat:@"%@年开业 %@年装修 \n %@",
                         [data objectForKey:@"openingDate"], [data objectForKey:@"decoDate"],          intro]];
    [introLabel setNumberOfLines:4];
    [contentView addSubview:introLabel];
    
    
    //服务设施
    UILabel *service = [[UILabel alloc] initWithFrame:CGRectMake(15, 212, 120, 20)];
    [service setTextColor:color(blackColor)];
    [service setText:@"服务设施"];
    [service setFont:[UIFont systemFontOfSize:15]];
    [contentView addSubview:service];
    
    //周边交通
    UILabel *aroundSpot = [[UILabel alloc] init];
    [aroundSpot setTextColor:color(blackColor)];
    [aroundSpot setFont:[UIFont systemFontOfSize:15]];
    [aroundSpot setText:@"周边交通"];
    [contentView addSubview:aroundSpot];

}


-(void)getHotelDetail{
    
    GetHotelDetailRequest *request = [[GetHotelDetailRequest alloc] initWidthBusinessType:BUSINESS_HOTEL methodName:@"GetHotelDetail"];
    
    request.hotelId = [NSNumber numberWithInt:[HotelDataCache sharedInstance].selectedHotelId];
    
    [self.requestManager sendRequest:request];
}


-(void)requestDone:(BaseResponseModel *)response
{
 
    if(!response){
        return;
    }
    
    GetHotelDetailResponse *detailResponse = (GetHotelDetailResponse*)response;
    [self removeLoadingView];
    [self initViewWithData:detailResponse.Data];
    
}


- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
