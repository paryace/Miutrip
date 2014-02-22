//
//  SettingViewController.m
//  MiuTrip
//
//  Created by SuperAdmin on 13-11-18.
//  Copyright (c) 2013年 michael. All rights reserved.
//

#import "SettingViewController.h"
#import "SelectCityController.h"
#import "UserDefaults.h"
#import "PostAddressController.h"
#import "GetAPIMailCondigRequest.h"
#import "GetAPIMailCondigResponse.h"
@interface SettingViewController (){
    NSArray *priceScopeData;
    UITableView *priceScopeView;
    UIViewController *backGroundModel;
    UIView *backGroundView;
    UIView *priceTitleView;
    UITableView *PostTypeView;
    UIView *postTitleView;
    NSArray *PostTypeForData;
    NSInteger num;
}

@property (strong, nonatomic) NSMutableDictionary           *switchControls;

@property (strong, nonatomic) UILabel                       *startCityField;
@property (strong, nonatomic) UILabel                       *goalCityField;
@property (strong, nonatomic) UILabel                       *priceRangeField;
@property (strong, nonatomic) UILabel                       *postTypeField;
@property (strong, nonatomic) UILabel                       *postAddressField;

@end

@implementation SettingViewController

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
        [self.contentView setHidden:NO];
        _switchControls = [NSMutableDictionary dictionary];
        priceScopeData =[NSArray arrayWithObjects:@"不限",@"0~150元",@"151元~300元",@"301元~450元",@"451元~600元",@"600元以上", nil];
        [self setSubviewFrame];
        [self postTypeRequest];
        
        
    }
    return self;
}

- (void)pressRightBtn:(UIButton*)sender
{
    
}

- (void)pressItem:(UIButton*)sender
{   if(sender.tag==400){
    SelectCityController *selecttCityView =[[SelectCityController alloc]init];
    [self pushViewController:selecttCityView transitionType:TransitionPush completionHandler:nil];
    selecttCityView.selectCity = ^(NSString *cityName){
        _startCityField.text=cityName;
    };
}
    if (sender.tag==401) {
        SelectCityController *selectCityView =[[SelectCityController alloc]initWithParams];
        [self pushViewController:selectCityView transitionType:TransitionPush completionHandler:nil];
        selectCityView.selectCity = ^(NSString *cityName){
            _goalCityField.text=cityName;
        };
    }
    if (sender.tag==402) {
        
        [self.view addSubview:backGroundModel.view];
        [backGroundModel.view addSubview:backGroundView];
        [backGroundModel.view addSubview:priceTitleView];
        [backGroundModel.view addSubview:priceScopeView];
        
    }
    
    if (sender.tag==403) {
        [self.view addSubview:backGroundModel.view];
        [backGroundModel.view addSubview:backGroundView];
        [backGroundModel.view addSubview:postTitleView];
        [backGroundModel.view addSubview:PostTypeView];
    }
    
    if (sender.tag==404) {
        
        PostAddressController *postModelView =[[PostAddressController alloc]init];
        [self pushViewController:postModelView transitionType:TransitionPush completionHandler:^{
            postModelView.postAddress=^(NSString *postAdress){
                _postAddressField.text=postAdress;
            };
        }];
        
    }
}

-(void)postTypeRequest{
    GetAPIMailCondigRequest *postForTypeRequest =[[GetAPIMailCondigRequest alloc]initWidthBusinessType:BUSINESS_FLIGHT methodName:@"GetAPIMailConfig"];
    postForTypeRequest.oTAType =[NSNumber numberWithInt:5];
    [self.requestManager sendRequest:postForTypeRequest];
}
- (void)requestDone:(BaseResponseModel *)response{
    
    if ([response isKindOfClass:[GetAPIMailCondigResponse class]]) {
        [self getPostTypeDone:(GetAPIMailCondigResponse *)response];
    }
}
-(void)getPostTypeDone:(GetAPIMailCondigResponse *)response{
    PostTypeForData =response.mList;
    [priceScopeView reloadData];
}

//请求失败
-(void)requestFailedWithErrorCode:(NSNumber *)errorCode withErrorMsg:(NSString *)errorMsg
{
    NSLog(@"error = %@",errorMsg);
    
}
-(BaseResponseModel*) getResponseFromRequestClassName:(NSString*) requestClassName{
    
    if(requestClassName == nil || requestClassName.length == 0){
        return nil;
    }
    
    if([requestClassName hasSuffix:@"Request"]){
        //替换字符串生成对应的RESPONSE类名称
        NSString *responseClassName = [requestClassName stringByReplacingOccurrencesOfString:@"Request" withString:@"Response"];
        //反射出对应的类
        Class responseClass = NSClassFromString(responseClassName);
        //没找到该类，或出错
        if(!responseClass){
            return nil;
        }
        //生成对应的对象
        return [[responseClass alloc] init];
    }
    
    return nil;
}


- (void)selectReserveGoal:(UIButton*)sender
{
    NSArray *array = nil;
    if (sender.tag == 100 || sender.tag == 101) {
        array = [_switchControls objectForKey:@"reserveGoal"];
        [UserDefaults shareUserDefault].reserveObject = sender.tag - 100;
    }else if (sender.tag == 200 || sender.tag == 201){
        array = [_switchControls objectForKey:@"tripGoal"];
        [UserDefaults shareUserDefault].tripGoal = sender.tag - 200;
    }
    for (CustomStatusBtn *control in array) {
        [control setHighlighteds:(control.tag == sender.tag)];
    }
}

- (void)pressSegmentedControl:(UISegmentedControl*)segmentedControl
{
    [UserDefaults shareUserDefault].launchPage = segmentedControl.selectedSegmentIndex;
    [self segmentedControlSelectIndex:[UserDefaults shareUserDefault].launchPage];
}

- (void)segmentedControlSelectIndex:(NSInteger)index
{
    NSArray *array = [_switchControls objectForKey:@"segmentedControl"];
    for (int i = 0;i<[array count];i++) {
        UIButton *btn = [array objectAtIndex:i];
        [btn setHighlighted:(index == i)];
    }
}

#pragma mark - view init
- (void)setSubviewFrame
{
    [self setBackGroundImage:imageNameAndType(@"home_bg", nil)];
    [self setTitle:@"系统设置"];
    [self setTopBarBackGroundImage:imageNameAndType(@"topbar", nil)];
    
    UIButton *returnBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [returnBtn setBackgroundColor:color(clearColor)];
    [returnBtn setImage:imageNameAndType(@"return", nil) forState:UIControlStateNormal];
    [returnBtn setFrame:CGRectMake(0, 0, self.topBar.frame.size.height, self.topBar.frame.size.height)];
    [self setReturnButton:returnBtn];
    [self.view addSubview:returnBtn];
    UIButton *saveBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [saveBtn setFrame:CGRectMake(self.topBar.frame.size.width - self.topBar.frame.size.height-10, 5, self.topBar.frame.size.height, self.topBar.frame.size.height-10)];
    [saveBtn setTitle:@"保存" forState:UIControlStateNormal];
    [saveBtn addTarget:self action:@selector(settingSaveBtn:) forControlEvents:UIControlEventTouchUpInside];
    [saveBtn setImage:imageNameAndType(@"cname_save_normal", nil) highlightImage:imageNameAndType(@"cname_save_press", nil) forState:ButtonImageStateBottom];
    [self.view addSubview:saveBtn];
    
    
}

- (void)setSubjoinViewFrame
{
    UIImageView *preferImage = [[UIImageView alloc]initWithFrame:CGRectMake(10, controlYLength(self.topBar) + 5, 30, 30)];
    [preferImage setBackgroundColor:color(clearColor)];
    [preferImage setImage:imageNameAndType(@"set_prefer", nil)];
    [self.contentView addSubview:preferImage];
    
    UILabel *preferLabel = [[UILabel alloc]initWithFrame:CGRectMake(controlXLength(preferImage), preferImage.frame.origin.y, self.contentView.frame.size.width - controlXLength(preferImage), preferImage.frame.size.height)];
    [preferLabel setText:@"订单偏好"];
    [preferLabel setFont:[UIFont boldSystemFontOfSize:13]];
    [preferLabel setBackgroundColor:color(clearColor)];
    [self.contentView addSubview:preferLabel];
    
    UIImageView *preferBGView = [[UIImageView alloc]initWithFrame:CGRectMake(5, controlYLength(preferImage) + 5, self.contentView.frame.size.width - 10, 40 * 7 + 5)];
    [preferBGView setBackgroundColor:color(clearColor)];
    [preferBGView setUserInteractionEnabled:YES];
    [preferBGView setImage:stretchImage(@"set_box_bg", nil)];
    [self.contentView addSubview:preferBGView];
    
    UILabel *reserveObjectLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 40 * 0, preferBGView.frame.size.width/4 - 10, 40)];
    [reserveObjectLabel setBackgroundColor:[UIColor clearColor]];
    [reserveObjectLabel setTextColor:color(darkGrayColor)];
    [reserveObjectLabel setText:@"预定对象"];
    [reserveObjectLabel setAutoSize:YES];
    [preferBGView addSubview:reserveObjectLabel];
    
    CustomStatusBtn *reserveForSelf = [[CustomStatusBtn alloc]initWithFrame:CGRectMake(controlXLength(reserveObjectLabel) + 10, reserveObjectLabel.frame.origin.y, (preferBGView.frame.size.width - controlXLength(reserveObjectLabel) - 20)/2, reserveObjectLabel.frame.size.height)];
    [reserveForSelf setDetail:@"本人"];
    [reserveForSelf setTag:100];
    NSLog(@"high = %d",[UserDefaults shareUserDefault].reserveObject);
    [reserveForSelf setHighlighteds:([UserDefaults shareUserDefault].reserveObject == 0)];
    [reserveForSelf setBackgroundColor:color(clearColor)];
    [reserveForSelf setImage:imageNameAndType(@"set_item_normal", nil) selectedImage:imageNameAndType(@"set_item_select", nil)];
    [reserveForSelf addTarget:self action:@selector(selectReserveGoal:) forControlEvents:UIControlEventTouchUpInside];
    [preferBGView addSubview:reserveForSelf];
    
    CustomStatusBtn *reserveForOthers = [[CustomStatusBtn alloc]initWithFrame:CGRectMake(controlXLength(reserveForSelf), reserveObjectLabel.frame.origin.y, reserveForSelf.frame.size.width, reserveForSelf.frame.size.height)];
    [reserveForOthers setDetail:@"他人/多人"];
    [reserveForOthers setTag:101];
    [reserveForOthers setHighlighteds:([UserDefaults shareUserDefault].reserveObject == 1)];
    [reserveForOthers setBackgroundColor:color(clearColor)];
    [reserveForOthers setImage:imageNameAndType(@"set_item_normal", nil) selectedImage:imageNameAndType(@"set_item_select", nil)];
    [reserveForOthers addTarget:self action:@selector(selectReserveGoal:) forControlEvents:UIControlEventTouchUpInside];
    [preferBGView addSubview:reserveForOthers];
    
    UIImageView *lineOne = [[UIImageView alloc]initWithFrame:CGRectMake(0, controlYLength(reserveObjectLabel) - 0.5, preferBGView.frame.size.width, 1)];
    [lineOne setBackgroundColor:color(clearColor)];
    [lineOne setImage:imageNameAndType(@"setting_line", nil)];
    [preferBGView addSubview:lineOne];
    
    [_switchControls setValue:@[reserveForSelf,reserveForOthers] forKey:@"reserveGoal"];
    
    UILabel *tripGoalLabel = [[UILabel alloc]initWithFrame:CGRectMake(reserveObjectLabel.frame.origin.x, 40 * 1, reserveObjectLabel.frame.size.width, reserveObjectLabel.frame.size.height)];
    [tripGoalLabel setBackgroundColor:[UIColor clearColor]];
    [tripGoalLabel setTextColor:color(darkGrayColor)];
    [tripGoalLabel setText:@"出行目的"];
    [tripGoalLabel setAutoSize:YES];
    [preferBGView addSubview:tripGoalLabel];
    
    CustomStatusBtn *onBusiness = [[CustomStatusBtn alloc]initWithFrame:CGRectMake(controlXLength(tripGoalLabel) + 10, tripGoalLabel.frame.origin.y, reserveForSelf.frame.size.width, reserveForSelf.frame.size.height)];
    [onBusiness setDetail:@"因公"];
    [onBusiness setTag:200];
    [onBusiness setHighlighteds:([UserDefaults shareUserDefault].tripGoal == 0)];
    [onBusiness setBackgroundColor:color(clearColor)];
    [onBusiness setImage:imageNameAndType(@"set_item_normal", nil) selectedImage:imageNameAndType(@"set_item_select", nil)];
    [onBusiness addTarget:self action:@selector(selectReserveGoal:) forControlEvents:UIControlEventTouchUpInside];
    [preferBGView addSubview:onBusiness];
    
    CustomStatusBtn *forPrivate = [[CustomStatusBtn alloc]initWithFrame:CGRectMake(controlXLength(onBusiness), tripGoalLabel.frame.origin.y, reserveForSelf.frame.size.width, reserveForSelf.frame.size.height)];
    [forPrivate setDetail:@"因私"];
    [forPrivate setTag:201];
    [forPrivate setHighlighteds:([UserDefaults shareUserDefault].tripGoal == 1)];
    [forPrivate setBackgroundColor:color(clearColor)];
    [forPrivate setImage:imageNameAndType(@"set_item_normal", nil) selectedImage:imageNameAndType(@"set_item_select", nil)];
    [forPrivate addTarget:self action:@selector(selectReserveGoal:) forControlEvents:UIControlEventTouchUpInside];
    [preferBGView addSubview:forPrivate];
    
    [reserveForSelf setLeftViewScaleX:0.65 scaleY:0.65];
    [reserveForOthers setLeftViewScaleX:0.65 scaleY:0.65];
    [forPrivate setLeftViewScaleX:0.65 scaleY:0.65];
    [onBusiness setLeftViewScaleX:0.65 scaleY:0.65];
    
    [_switchControls setValue:@[onBusiness,forPrivate] forKey:@"tripGoal"];
    
    [preferBGView addSubview:[self createLine:CGRectMake(0, controlYLength(tripGoalLabel) - 0.5, lineOne.frame.size.width, lineOne.frame.size.height)]];
    
    UILabel *startCityLabel = [[UILabel alloc]initWithFrame:CGRectMake(tripGoalLabel.frame.origin.x, controlYLength(tripGoalLabel), tripGoalLabel.frame.size.width, tripGoalLabel.frame.size.height)];
    [startCityLabel setTextColor:color(darkGrayColor)];
    [startCityLabel setText:@"出发城市"];
    [startCityLabel setBackgroundColor:[UIColor clearColor]];
    [startCityLabel setAutoSize:YES];
    [preferBGView addSubview:startCityLabel];
    _startCityField = [[UILabel alloc]initWithFrame:CGRectMake(controlXLength(startCityLabel) + 20, startCityLabel.frame.origin.y, preferBGView.frame.size.width - controlXLength(startCityLabel) - 20, startCityLabel.frame.size.height)];
    if ([[UserDefaults shareUserDefault] startCity]==nil) {
        [_startCityField setText:@"选择出发城市"];
    }
    else{
        _startCityField.text=[[UserDefaults shareUserDefault] startCity];
    }
    [_startCityField setBackgroundColor:color(clearColor)];
    [preferBGView addSubview:_startCityField];
    UIButton *startCityBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [startCityBtn setBackgroundColor:color(clearColor)];
    [startCityBtn setFrame:_startCityField.frame];
    [startCityBtn setTag:400];
    [startCityBtn addTarget:self action:@selector(pressItem:) forControlEvents:UIControlEventTouchUpInside];
    [preferBGView addSubview:startCityBtn];
    
    [preferBGView addSubview:[self createLine:CGRectMake(lineOne.frame.origin.x, controlYLength(startCityBtn), lineOne.frame.size.width, lineOne.frame.size.height)]];
    
    UILabel *goalCityLabel = [[UILabel alloc]initWithFrame:CGRectMake(startCityLabel.frame.origin.x, controlYLength(startCityLabel), startCityLabel.frame.size.width, startCityLabel.frame.size.height)];
    [goalCityLabel setTextColor:color(darkGrayColor)];
    [goalCityLabel setText:@"入住城市"];
    [goalCityLabel setBackgroundColor:[UIColor clearColor]];
    [goalCityLabel setAutoSize:YES];
    [preferBGView addSubview:goalCityLabel];
    _goalCityField = [[UILabel alloc]initWithFrame:CGRectMake(_startCityField.frame.origin.x, controlYLength(_startCityField), _startCityField.frame.size.width, _startCityField.frame.size.height)];
    [_goalCityField setBackgroundColor:color(clearColor)];
    if ([[UserDefaults shareUserDefault] goalCity]==nil) {
        [_goalCityField setText:@"选择入住城市"];
    }
    else{
        _goalCityField.text=[[UserDefaults shareUserDefault] goalCity];
    }
    [preferBGView addSubview:_goalCityField];
    UIButton *goalCityBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [goalCityBtn setBackgroundColor:color(clearColor)];
    [goalCityBtn setFrame:_goalCityField.frame];
    [goalCityBtn setTag:401];
    [goalCityBtn addTarget:self action:@selector(pressItem:) forControlEvents:UIControlEventTouchUpInside];
    [preferBGView addSubview:goalCityBtn];
    
    [preferBGView addSubview:[self createLine:CGRectMake(lineOne.frame.origin.x, controlYLength(goalCityBtn), lineOne.frame.size.width, lineOne.frame.size.height)]];
    
    UILabel *priceRangeLabel = [[UILabel alloc]initWithFrame:CGRectMake(startCityLabel.frame.origin.x, controlYLength(goalCityLabel), startCityLabel.frame.size.width, startCityLabel.frame.size.height)];
    [priceRangeLabel setTextColor:color(darkGrayColor)];
    [priceRangeLabel setText:@"价格范围"];
    [priceRangeLabel setBackgroundColor:[UIColor clearColor]];
    [priceRangeLabel setAutoSize:YES];
    [preferBGView addSubview:priceRangeLabel];
    _priceRangeField = [[UILabel alloc]initWithFrame:CGRectMake(_startCityField.frame.origin.x, controlYLength(_goalCityField), _startCityField.frame.size.width, _startCityField.frame.size.height)];
    [_priceRangeField setBackgroundColor:color(clearColor)];
    if (![[UserDefaults shareUserDefault] priceRange]) {
        _priceRangeField.text=@"请选择价格范围";
    }
    else{
        _priceRangeField.text =[priceScopeData objectAtIndex:[[UserDefaults shareUserDefault] priceRange]];
    }
    
    
    [preferBGView addSubview:_priceRangeField];
    UIButton *priceRangeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [priceRangeBtn setBackgroundColor:color(clearColor)];
    [priceRangeBtn setFrame:_priceRangeField.frame];
    [priceRangeBtn setTag:402];
    [priceRangeBtn addTarget:self action:@selector(pressItem:) forControlEvents:UIControlEventTouchUpInside];
    [preferBGView addSubview:priceRangeBtn];
    
    [preferBGView addSubview:[self createLine:CGRectMake(lineOne.frame.origin.x, controlYLength(priceRangeBtn), lineOne.frame.size.width, lineOne.frame.size.height)]];
    
    UILabel *postTypeLabel = [[UILabel alloc]initWithFrame:CGRectMake(startCityLabel.frame.origin.x, controlYLength(priceRangeLabel), startCityLabel.frame.size.width, startCityLabel.frame.size.height)];
    [postTypeLabel setTextColor:color(darkGrayColor)];
    [postTypeLabel setText:@"配送方式"];
    [postTypeLabel setBackgroundColor:[UIColor clearColor]];
    [postTypeLabel setAutoSize:YES];
    [preferBGView addSubview:postTypeLabel];
    _postTypeField = [[UILabel alloc]initWithFrame:CGRectMake(_startCityField.frame.origin.x, controlYLength(_priceRangeField), _startCityField.frame.size.width, _startCityField.frame.size.height)];
    [_postTypeField setBackgroundColor:color(clearColor)];
    
    
    _postTypeField.text =  [[PostTypeForData objectAtIndex:[[UserDefaults shareUserDefault] postType]] objectForKey:@"mName"];
    
    
    [preferBGView addSubview:_postTypeField];
    UIButton *postTypeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [postTypeBtn setBackgroundColor:color(clearColor)];
    [postTypeBtn setFrame:_postTypeField.frame];
    [postTypeBtn setTag:403];
    [postTypeBtn addTarget:self action:@selector(pressItem:) forControlEvents:UIControlEventTouchUpInside];
    [preferBGView addSubview:postTypeBtn];
    
    [preferBGView addSubview:[self createLine:CGRectMake(lineOne.frame.origin.x, controlYLength(postTypeBtn), lineOne.frame.size.width, lineOne.frame.size.height)]];
    
    UILabel *postAddressLabel = [[UILabel alloc]initWithFrame:CGRectMake(startCityLabel.frame.origin.x, controlYLength(postTypeLabel), startCityLabel.frame.size.width, startCityLabel.frame.size.height)];
    [postAddressLabel setTextColor:color(darkGrayColor)];
    [postAddressLabel setText:@"配送地址"];
    [postAddressLabel setBackgroundColor:[UIColor clearColor]];
    [postAddressLabel setAutoSize:YES];
    [preferBGView addSubview:postAddressLabel];
    _postAddressField = [[UILabel alloc]initWithFrame:CGRectMake(_startCityField.frame.origin.x, controlYLength(_postTypeField), _startCityField.frame.size.width, _startCityField.frame.size.height)];
    [_postAddressField setBackgroundColor:color(clearColor)];
    if ([[UserDefaults shareUserDefault] postAddress]==nil) {
        [_postAddressField setText:@"上海市"];
    }
    else{
        [_postAddressField setText:[[UserDefaults shareUserDefault] postAddress]];
    }
    [preferBGView addSubview:_postAddressField];
    UIButton *postAddressBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [postAddressBtn setBackgroundColor:color(clearColor)];
    [postAddressBtn setFrame:_postAddressField.frame];
    [postAddressBtn setTag:404];
    [postAddressBtn addTarget:self action:@selector(pressItem:) forControlEvents:UIControlEventTouchUpInside];
    [preferBGView addSubview:postAddressBtn];
    
    UIImageView *otherPreferImage = [[UIImageView alloc]initWithFrame:CGRectMake(preferImage.frame.origin.x, controlYLength(preferBGView), preferImage.frame.size.width, preferImage.frame.size.height)];
    [otherPreferImage setBackgroundColor:color(clearColor)];
    [otherPreferImage setImage:imageNameAndType(@"set_prefer", nil)];
    [self.contentView addSubview:otherPreferImage];
    
    UILabel *otherPreferLabel = [[UILabel alloc]initWithFrame:CGRectMake(controlXLength(otherPreferImage), otherPreferImage.frame.origin.y, preferLabel.frame.size.width, preferLabel.frame.size.height)];
    [otherPreferLabel setText:@"其他偏好"];
    [otherPreferLabel setFont:[UIFont boldSystemFontOfSize:13]];
    [otherPreferLabel setBackgroundColor:color(clearColor)];
    [self.contentView addSubview:otherPreferLabel];
    
    UIImageView *otherPreferBGView = [[UIImageView alloc]initWithFrame:CGRectMake(preferBGView.frame.origin.x, controlYLength(otherPreferImage) + 5, preferBGView.frame.size.width, 40 * 4 + 4)];
    [otherPreferBGView setBackgroundColor:color(clearColor)];
    [otherPreferBGView setUserInteractionEnabled:YES];
    [otherPreferBGView setImage:stretchImage(@"set_box_bg", nil)];
    [self.contentView addSubview:otherPreferBGView];
    
    UILabel *launchPageLabel = [[UILabel alloc]initWithFrame:CGRectMake(startCityLabel.frame.origin.x, 0, startCityLabel.frame.size.width, startCityLabel.frame.size.height)];
    [launchPageLabel setTextColor:color(darkGrayColor)];
    [launchPageLabel setText:@"启动首页"];
    [launchPageLabel setBackgroundColor:[UIColor clearColor]];
    [launchPageLabel setAutoSize:YES];
    [otherPreferBGView addSubview:launchPageLabel];
    
    UISegmentedControl *segmentedControl = [[UISegmentedControl alloc]initWithItems:@[@".",@".",@"."]];
    [segmentedControl setFrame:CGRectMake(_startCityField.frame.origin.x, 5, _startCityField.frame.size.width - 10, _startCityField.frame.size.height - 10)];
    [segmentedControl setAlpha:0.1];
    [segmentedControl setTag:500];
    [segmentedControl addTarget:self action:@selector(pressSegmentedControl:) forControlEvents:UIControlEventValueChanged];
    [segmentedControl setBackgroundColor:color(clearColor)];
    
    UIButton *segmentedItemOne = [UIButton buttonWithType:UIButtonTypeCustom];
    [segmentedItemOne setFrame:CGRectMake(segmentedControl.frame.origin.x, segmentedControl.frame.origin.y, segmentedControl.frame.size.width/3, segmentedControl.frame.size.height)];
    [segmentedItemOne setTitle:@"国内酒店" forState:UIControlStateNormal];
    //[segmentedItemOne.titleLabel setFont:[UIFont systemFontOfSize:12]];
    [segmentedItemOne.titleLabel setAutoSize:YES];
    [segmentedItemOne setTitleColor:color(blackColor) forState:UIControlStateNormal];
    [segmentedItemOne setBackgroundColor:color(clearColor)];
    [segmentedItemOne setBackgroundImage:imageNameAndType(@"set_sgitem_l_normal", nil) forState:UIControlStateNormal];
    [segmentedItemOne setBackgroundImage:imageNameAndType(@"set_sgitem_l_select", nil) forState:UIControlStateHighlighted];
    [otherPreferBGView addSubview:segmentedItemOne];
    
    UIButton *segmentedItemTwo = [UIButton buttonWithType:UIButtonTypeCustom];
    [segmentedItemTwo setFrame:CGRectMake(controlXLength(segmentedItemOne), segmentedItemOne.frame.origin.y, segmentedItemOne.frame.size.width, segmentedItemOne.frame.size.height)];
    [segmentedItemTwo setTitle:@"国内机票" forState:UIControlStateNormal];
    [segmentedItemTwo.titleLabel setAutoSize:YES];
    [segmentedItemTwo setTitleColor:color(blackColor) forState:UIControlStateNormal];
    [segmentedItemTwo setBackgroundColor:color(clearColor)];
    [segmentedItemTwo setBackgroundImage:imageNameAndType(@"set_sgitem_normal", nil) forState:UIControlStateNormal];
    [segmentedItemTwo setBackgroundImage:imageNameAndType(@"set_sgitem_select", nil) forState:UIControlStateHighlighted];
    [otherPreferBGView addSubview:segmentedItemTwo];
    
    UIButton *segmentedItemThree = [UIButton buttonWithType:UIButtonTypeCustom];
    [segmentedItemThree setFrame:CGRectMake(controlXLength(segmentedItemTwo), segmentedItemOne.frame.origin.y, segmentedItemOne.frame.size.width, segmentedItemOne.frame.size.height)];
    [segmentedItemThree setTitle:@"我的觅优" forState:UIControlStateNormal];
    [segmentedItemThree.titleLabel setAutoSize:YES];
    [segmentedItemThree setTitleColor:color(blackColor) forState:UIControlStateNormal];
    [segmentedItemThree setBackgroundColor:color(clearColor)];
    [segmentedItemThree setBackgroundImage:imageNameAndType(@"set_sgitem_r_normal", nil) forState:UIControlStateNormal];
    [segmentedItemThree setBackgroundImage:imageNameAndType(@"set_sgitem_r_select", nil) forState:UIControlStateHighlighted];
    [otherPreferBGView addSubview:segmentedItemThree];
    
    [otherPreferBGView addSubview:segmentedControl];
    
    [_switchControls setValue:@[segmentedItemOne,segmentedItemTwo,segmentedItemThree] forKey:@"segmentedControl"];
    
    [otherPreferBGView addSubview:[self createLine:CGRectMake(lineOne.frame.origin.x, controlYLength(launchPageLabel), lineOne.frame.size.width, lineOne.frame.size.height)]];
    
    UILabel *shakeLabel = [[UILabel alloc]initWithFrame:CGRectMake(startCityLabel.frame.origin.x, controlYLength(launchPageLabel), startCityLabel.frame.size.width, startCityLabel.frame.size.height)];
    [shakeLabel setTextColor:color(darkGrayColor)];
    [shakeLabel setText:@"摇动设置"];
    [shakeLabel setBackgroundColor:[UIColor clearColor]];
    [shakeLabel setTextColor:color(darkGrayColor)];
    [shakeLabel setAutoSize:YES];
    [otherPreferBGView addSubview:shakeLabel];
    UISwitch *sch = [[UISwitch alloc]init];
    [sch setOn:[UserDefaults shareUserDefault].allowShake];
    [sch setOnTintColor:color(colorWithRed:90.0/255.0 green:110.0/255.0 blue:190.0/255.0 alpha:1)];
    [sch addTarget:self action:@selector(pressSch:) forControlEvents:UIControlEventValueChanged];
    [sch setFrame:CGRectMake(controlXLength(segmentedControl) - sch.frame.size.width, shakeLabel.frame.origin.y + 5, 0, 0)];
    [otherPreferBGView addSubview:sch];
    
    [otherPreferBGView addSubview:[self createLine:CGRectMake(lineOne.frame.origin.x, controlYLength(shakeLabel), lineOne.frame.size.width, lineOne.frame.size.height)]];
    
    UILabel *searchRadiuLabel = [[UILabel alloc]initWithFrame:CGRectMake(startCityLabel.frame.origin.x, controlYLength(shakeLabel) + 20, shakeLabel.frame.size.width, shakeLabel.frame.size.height)];
    [searchRadiuLabel setBackgroundColor:color(clearColor)];
    [searchRadiuLabel setText:@"搜索半径"];
    [searchRadiuLabel setBackgroundColor:[UIColor clearColor]];
    [searchRadiuLabel setTextColor:color(darkGrayColor)];
    [searchRadiuLabel setAutoSize:YES];
    [otherPreferBGView addSubview:searchRadiuLabel];
    
    CustomProgressView *progressView = [[CustomProgressView alloc]initWithItems:@[@"500米",@"1公里",@"2公里",@"5公里",@"10公里"]];
    [progressView setProgressImage:imageNameAndType(@"set_progress_select", nil)];
    [progressView setTrackImage:imageNameAndType(@"set_progress_normal", nil)];
    [progressView setFrame:CGRectMake(segmentedControl.frame.origin.x, controlYLength(shakeLabel) + 10, segmentedControl.frame.size.width, 60)];
    [progressView setProgress:[UserDefaults shareUserDefault].searchRadiu];
    [progressView setThumbImage:imageNameAndType(@"set_location", nil)];
    [otherPreferBGView addSubview:progressView];
    
    [self segmentedControlSelectIndex:[UserDefaults shareUserDefault].launchPage];
    //暗色效果
    backGroundModel=[[UIViewController alloc]init];
    [backGroundModel.view setFrame:CGRectMake(0, -20, self.view.frame.size.width, self.view.frame.size.height+20)];
    backGroundView =[[UIView alloc]initWithFrame:CGRectMake(0, -20, backGroundModel.view.frame.size.width, backGroundModel.view.frame.size.height)];
    [backGroundView setBackgroundColor:[UIColor blackColor]];
    [backGroundView setAlpha:0.35];
    //UITableView标题
    priceTitleView =[[UIView alloc]initWithFrame:CGRectMake(30, 3*self.topBar.frame.size.height-40, self.view.frame.size.width-60, 40)];
    [priceTitleView setBackgroundColor:[UIColor blackColor]];
    UILabel *priceTitleLabel =[[UILabel alloc]initWithFrame:CGRectMake(0, 0, priceTitleView.frame.size.width, priceTitleView.frame.size.height)];
    [priceTitleLabel setFont:[UIFont fontWithName:@"Arial" size:25]];
    [priceTitleLabel setBackgroundColor:[UIColor clearColor]];
    [priceTitleLabel setTextColor:[UIColor whiteColor]];
    [priceTitleLabel setText:@"价格筛选"];
    [priceTitleView addSubview:priceTitleLabel];
    
    postTitleView =[[UIView alloc]initWithFrame:CGRectMake(30, 3*self.topBar.frame.size.height-40, self.view.frame.size.width-60, 40)];
    [postTitleView setBackgroundColor:[UIColor blackColor]];
    UILabel *postTitleLabel =[[UILabel alloc]initWithFrame:CGRectMake(0, 0, priceTitleView.frame.size.width, postTitleView.frame.size.height)];
    [postTitleLabel setFont:[UIFont fontWithName:@"Arial" size:25]];
    [postTitleLabel setBackgroundColor:[UIColor clearColor]];
    [postTitleLabel setTextColor:[UIColor whiteColor]];
    [postTitleLabel setText:@"选择配送方式"];
    [postTitleView addSubview:postTitleLabel];
    
    
    //UITableView
    priceScopeView =[[UITableView alloc]initWithFrame:CGRectMake(30, 3*self.topBar.frame.size.height, self.view.frame.size.width-60, self.view.frame.size.height/2)];
    [priceScopeView setDataSource:self];
    [priceScopeView setDelegate:self];
    [priceScopeView setTag:1000];
    priceScopeView.separatorStyle=UITableViewCellSeparatorStyleNone;
    priceScopeView.showsVerticalScrollIndicator=NO;
    priceScopeView.bounces=NO;
    
    PostTypeView =[[UITableView alloc]initWithFrame:CGRectMake(30, 3*self.topBar.frame.size.height, self.view.frame.size.width-60, self.view.frame.size.height/2)];
    [PostTypeView setDataSource:self];
    [PostTypeView setDelegate:self];
    [PostTypeView setTag:1001];
    PostTypeView.separatorStyle=UITableViewCellSeparatorStyleNone;
    PostTypeView.showsVerticalScrollIndicator=NO;
    PostTypeView.bounces=NO;
}
-(void)settingSaveBtn:(UIButton*)sender{
}
- (void)pressSch:(UISwitch*)sch
{
    [UserDefaults shareUserDefault].allowShake = sch.on;
}

- (UIImageView*)createLine:(CGRect)rect
{
    UIImageView *line = [[UIImageView alloc]initWithFrame:rect];
    [line setBackgroundColor:color(clearColor)];
    [line setImage:imageNameAndType(@"setting_line", nil)];
    return line;
}
//UITableView
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{   if(tableView.tag==1000){
    return [priceScopeData count];
}
else{
    return [PostTypeForData count];
    
}
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath*)indexPath{
    return 40.0f;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{ if(tableView.tag==1000){
    
    static NSString *CellIdentifier =@"CellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell ==nil) {
        cell =[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    cell.textLabel.text=[priceScopeData objectAtIndex:indexPath.row];
    
    return cell;
}
else{
    static NSString *CellIdentifier =@"CellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell ==nil) {
        cell =[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
 
    cell.textLabel.text=[[PostTypeForData objectAtIndex:indexPath.row] objectForKey:@"mName"];;
    return cell;
    
}
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(tableView.tag==1000){
        for (int i=0; i<=[priceScopeData count];i++) {
            if(indexPath.row==i){
                [priceScopeView removeFromSuperview];
                [backGroundView removeFromSuperview];
                [priceTitleView removeFromSuperview];
                [backGroundModel.view removeFromSuperview];
                
            }
        }
        _priceRangeField.text=[priceScopeData objectAtIndex:indexPath.row];
        [[UserDefaults shareUserDefault] setPriceRange:indexPath.row];
    }
    else{
        for (int i=0; i<=[PostTypeForData count];i++) {
            if(indexPath.row==i){
                [PostTypeView removeFromSuperview];
                [postTitleView removeFromSuperview];
                [backGroundView removeFromSuperview];
                [backGroundModel.view removeFromSuperview];
                
            }
        }
        
        
        _postTypeField.text =[[PostTypeForData objectAtIndex:indexPath.row] objectForKey:@"mName"];
        
        num=indexPath.row;
        
    }
    
    //    _postTypeField.text =[[PostTypeForData objectAtIndex:[[UserDefaults shareUserDefault] postType]] objectForKey:@"mName"];
    
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[UserDefaults shareUserDefault]setPostType:num ];
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
