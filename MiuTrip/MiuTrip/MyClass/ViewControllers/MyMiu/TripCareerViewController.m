//
//  TripCareerViewController.m
//  MiuTrip
//
//  Created by SuperAdmin on 13-11-20.
//  Copyright (c) 2013年 michael. All rights reserved.
//

#import "TripCareerViewController.h"
#import "GetTravelLifeInfoRequest.h"
#import "GetTravelLifeInfoResponse.h"
@interface TripCareerViewController ()

//@property (strong, nonatomic) TravelLifeInfo    *travelLifeInfo;

@end

@implementation TripCareerViewController

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
    if (self = [super init]) {
//        _travelLifeInfo = [[GetTravelLifeInfoResponse alloc]init];
        [self.contentView setHidden:NO];
        [self setSubviewFrame];
    }
    return self;
}

#pragma mark - request handle
//- (void)getTravelLifeInfoDone:(TravelLifeInfo *)traveLifeInfo
//{
//    _travelLifeInfo = traveLifeInfo;
//    [self setSubjoinViewFrame];
//}

#pragma mark - view init
- (void)setSubviewFrame
{
    [self setBackGroundImage:imageNameAndType(@"home_bg", nil)];
    [self setTitle:@"商旅生涯"];
    [self setTopBarBackGroundImage:imageNameAndType(@"topbar", nil)];
    
    UIButton *returnBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [returnBtn setBackgroundColor:color(clearColor)];
    [returnBtn setImage:imageNameAndType(@"return", nil) forState:UIControlStateNormal];
    [returnBtn setFrame:CGRectMake(0, 0, self.topBar.frame.size.height, self.topBar.frame.size.height)];
    [self setReturnButton:returnBtn];
    [self.view addSubview:returnBtn];
    [self sendUserRequest];
    
}

- (void)setSubjoinViewFrame
{
    UIImageView *itemBg = [[UIImageView alloc]initWithFrame:CGRectMake(5, 10 + controlYLength(self.topBar), self.contentView.frame.size.width - 10, 0)];
    [itemBg setBackgroundColor:color(clearColor)];
    UIImage *itemImage = imageNameAndType(@"t_item_bg", nil);
    [itemBg setImage:[itemImage stretchableImageWithLeftCapWidth:itemImage.size.width/2 topCapHeight:itemImage.size.height/2]];
    [self.contentView addSubview:itemBg];
    
    TripCareerItem *airLevelItem = [[TripCareerItem alloc]initWithFrame:CGRectMake(10, 10, itemBg.frame.size.width - 20, 0)];
    [airLevelItem setTitleImage:imageNameAndType(@"t_career_ariLevel", nil)];
    [airLevelItem setTitle:imageNameAndType(@"sub_arilevel", nil)];
    [airLevelItem.leftImageView setScaleX:0.85 scaleY:0.85];
    [airLevelItem setContentText:[_travelLifeInfo flightLevelDetail]];
    [itemBg addSubview:airLevelItem];
    
    [itemBg addSubview:[self createLineWithFrame:CGRectMake(airLevelItem.frame.origin.x, controlYLength(airLevelItem) + 5, airLevelItem.frame.size.width, 1.5)]];
    
    TripCareerItem *arrivedItem = [[TripCareerItem alloc]initWithFrame:CGRectMake(airLevelItem.frame.origin.x, controlYLength(airLevelItem) + 10, airLevelItem.frame.size.width, 0)];
    [arrivedItem setTitleImage:imageNameAndType(@"t_career_arrived", nil)];
    [arrivedItem setTitle:imageNameAndType(@"sub_arrived", nil)];
    [arrivedItem.leftImageView setScaleX:0.85 scaleY:0.85];
    [arrivedItem setContentText:[_travelLifeInfo arrivePlaceDetail]];
    [itemBg addSubview:arrivedItem];
    
    [itemBg addSubview:[self createLineWithFrame:CGRectMake(airLevelItem.frame.origin.x, controlYLength(arrivedItem) + 5, airLevelItem.frame.size.width, 1.5)]];
    
    TripCareerItem *checkedInItem = [[TripCareerItem alloc]initWithFrame:CGRectMake(airLevelItem.frame.origin.x, controlYLength(arrivedItem) + 10, airLevelItem.frame.size.width, 0)];
    [checkedInItem setTitleImage:imageNameAndType(@"t_career_checkedIn", nil)];
    [checkedInItem setTitle:imageNameAndType(@"sub_checkedIn", nil)];
    [checkedInItem.leftImageView setScaleX:0.85 scaleY:0.85];
    [checkedInItem setContentText:[_travelLifeInfo checkedInHotelDetail]];
    [itemBg addSubview:checkedInItem];
    
    [itemBg addSubview:[self createLineWithFrame:CGRectMake(airLevelItem.frame.origin.x, controlYLength(checkedInItem) + 5, airLevelItem.frame.size.width, 1.5)]];
    
    TripCareerItem *paidItem = [[TripCareerItem alloc]initWithFrame:CGRectMake(airLevelItem.frame.origin.x, controlYLength(checkedInItem) + 10, airLevelItem.frame.size.width, 0)];
    [paidItem setTitleImage:imageNameAndType(@"t_career_paied", nil)];
    [paidItem setTitle:imageNameAndType(@"sub_paied", nil)];
    [paidItem.leftImageView setScaleX:0.85 scaleY:0.85];
    [paidItem setContentText:[_travelLifeInfo expenseDetail]];
    [itemBg addSubview:paidItem];
    
    [itemBg addSubview:[self createLineWithFrame:CGRectMake(airLevelItem.frame.origin.x, controlYLength(paidItem) + 5, airLevelItem.frame.size.width, 1.5)]];
    
    TripCareerItem *tripEvaluateItem = [[TripCareerItem alloc]initWithFrame:CGRectMake(airLevelItem.frame.origin.x, controlYLength(paidItem) + 10, airLevelItem.frame.size.width, 0)];
    [tripEvaluateItem setTitleImage:imageNameAndType(@"t_career_tripevaluate", nil)];
    [tripEvaluateItem setTitle:imageNameAndType(@"sub_tripevaluate", nil)];
    [tripEvaluateItem.leftImageView setScaleX:0.85 scaleY:0.85];
    [tripEvaluateItem setContentText:[_travelLifeInfo tripCareerDetail]];
    [itemBg addSubview:tripEvaluateItem];
    
    [itemBg setFrame:CGRectMake(itemBg.frame.origin.x, itemBg.frame.origin.y, itemBg.frame.size.width, controlYLength(tripEvaluateItem) + 10)];
    [self.contentView resetContentSize];
}

- (void)sendUserRequest{
    [self addLoadingView];
    GetTravelLifeInfoRequest *lifeRequest = [[GetTravelLifeInfoRequest alloc]initWidthBusinessType:BUSINESS_ACCOUNT methodName:@"GetTravelLifeInfo"];
    
    [self.requestManager sendRequest:lifeRequest];
}

- (void)getTravelLifeInfoResponseDone:(GetTravelLifeInfoResponse*)response
{
    [self removeLoadingView];
    
    _travelLifeInfo = response;

    [self setSubjoinViewFrame];
}

- (void)requestDone:(BaseResponseModel *)response{
    if (response) {
        if ([response isKindOfClass:[GetTravelLifeInfoResponse class]]) {
            [self getTravelLifeInfoResponseDone:(GetTravelLifeInfoResponse*)response];
        }
    }
}

- (UIImageView *)createLineWithFrame:(CGRect)rect
{
    UIImageView *line = [[UIImageView alloc]initWithFrame:rect];
    [line setBackgroundColor:color(clearColor)];
    [line setImage:imageNameAndType(@"t_line", nil)];
    return line;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

@interface TripCareerItem ()

@end

@implementation TripCareerItem

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, 40)]) {
        [self setSubviewFrame];
    }
    return self;
}

- (void)setSubviewFrame
{
    _leftImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 40, 40)];
    [_leftImageView setBackgroundColor:color(clearColor)];
    //    [self setTitleImage:[UIImage imageNamed:@"t_career_airLevel"]];
    [self addSubview:_leftImageView];
    
    _titleAsLabel = [[UILabel alloc]initWithFrame:CGRectMake(controlXLength(_leftImageView), _leftImageView.frame.origin.y, self.frame.size.width - controlXLength(_leftImageView), _leftImageView.frame.size.height)];
    [_titleAsLabel setBackgroundColor:color(clearColor)];
    [_titleAsLabel setAutoSize:YES];
    [_titleAsLabel setHidden:YES];
    [_titleAsLabel setFont:[UIFont systemFontOfSize:13]];
    [self addSubview:_titleAsLabel];
    
    _titleAsImage = [[UIImageView alloc] initWithFrame:CGRectMake(_titleAsLabel.frame.origin.x, _titleAsLabel.frame.origin.y, 75, _titleAsLabel.frame.size.height)];
    [_titleAsImage setBackgroundColor:color(clearColor)];
    [_titleAsImage setHidden:YES];
    [_titleAsImage setContentMode:UIViewContentModeScaleAspectFit];
    [self addSubview:_titleAsImage];
    
    _contentLabel = [[UILabel alloc]initWithFrame:CGRectMake(_leftImageView.frame.origin.x, controlYLength(_leftImageView), self.frame.size.width, 0 )];
    [_contentLabel setBackgroundColor:color(clearColor)];
    [_contentLabel setFont:[UIFont systemFontOfSize:13]];
    [_contentLabel setAutoBreakLine:YES];
    [self addSubview:_contentLabel];
}

- (void)setTitleImage:(UIImage*)image
{
    [_leftImageView setImage:image];
}

- (void)setTitle:(NSObject*)title
{
    if ([title isKindOfClass:[NSString class]]) {
        NSString *string = (NSString*)title;
        [_titleAsLabel setText:string];
        [_titleAsImage setHidden:YES];
        [_titleAsLabel setHidden:NO];
    }else if ([title isKindOfClass:[UIImage class]]){
        UIImage *image = (UIImage*)title;
        [_titleAsImage setImage:image];
        [_titleAsImage setHidden:NO];
        [_titleAsLabel setHidden:YES];
    }
}

- (void)setContentText:(NSString*)text
{
    CGFloat height = [Utils heightForWidth:_contentLabel.frame.size.width text:text font:_contentLabel.font];
    [_contentLabel setFrame:CGRectMake(_contentLabel.frame.origin.x, _contentLabel.frame.origin.y, _contentLabel.frame.size.width, height)];
    [_contentLabel setText:text];
    [self setFrame:CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, 40 + height)];
}

@end













