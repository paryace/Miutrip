//
//  AddNewPassengerViewController.m
//  MiuTrip
//
//  Created by apple on 1/24/14.
//  Copyright (c) 2014 michael. All rights reserved.
//

#import "AddNewPassengerViewController.h"

@interface AddNewPassengerViewController ()

@property (strong, nonatomic) UILabel       *ticketTypeLb;
@property (strong, nonatomic) UITextField   *userNameTf;
@property (strong, nonatomic) UIButton      *cardTypeBtn;
@property (strong, nonatomic) UITextField   *cardNumTf;

@property (strong, nonatomic) UIButton      *insureBtn;
@property (strong, nonatomic) UIButton      *costCenterBtn;

@property (assign, nonatomic) BOOL          saveToCommonName;

@property (strong, nonatomic) BookPassengersResponse *passengerInfo;

@property (assign, nonatomic) PassengerInitType initType;

@end

@implementation AddNewPassengerViewController

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
        _initType = PassengerAdd;
        [self setSubviewFrame];
    }
    return self;
}

- (id)initWithParams:(id)params
{
    if (self = [super init]) {
        _passengerInfo = params;
        if (params) {
            _initType = PassengerEdit;
        }else{
            _initType = PassengerAdd;
        }
        [self setSubviewFrame];
    }
    return self;
}

- (void)pressBtnItem:(UIButton*)sender
{
    NSLog(@"sender tag = %d",sender.tag);
}

- (void)pressRightBtn:(UIButton*)sender
{
    [self savePassenger];
}

- (void)savePassenger
{
    [self.requestManager sendRequest:[self getSavePassengerRequest]];
}

- (void)savePassengerDone:(SavePassengerListResponse*)response
{
    
}

- (void)requestDone:(BaseResponseModel *)response
{
    if ([response isKindOfClass:[SavePassengerListResponse class]]) {
        [self savePassengerDone:(SavePassengerListResponse*)response];
    }
}

- (SavePassengerListRequest *)getSavePassengerRequest
{
    SavePassengerListRequest *request = [[SavePassengerListRequest alloc]initWidthBusinessType:BUSINESS_FLIGHT methodName:@"SavePassengerList"];
    if (!_passengerInfo) {
        _passengerInfo = [[BookPassengersResponse alloc]init];
        [_passengerInfo setIsEmoloyee:[NSNumber numberWithBool:NO]];
        [_passengerInfo setIsServer:[NSNumber numberWithBool:NO]];
        [_passengerInfo setIsServerCard:[NSNumber numberWithBool:NO]];
    }
    CustomStatusBtn *customBtn = (CustomStatusBtn*)[self.contentView viewWithTag:103];
    [_passengerInfo setType:[NSNumber numberWithInt:customBtn.select]];
    [_passengerInfo setUserName:_userNameTf.text];
    [_passengerInfo setDeptID:[UserDefaults shareUserDefault].loginInfo.DeptID];
    
    MemberIDcardResponse *IDCard = [[MemberIDcardResponse alloc]init];
    [IDCard setCardType:[IDCard getCardTypeCodeWithName:_cardTypeBtn.titleLabel.text]];
    [IDCard setCardNumber:_cardNumTf.text];
    
    [_passengerInfo setIDCardList:[NSMutableArray arrayWithArray:@[IDCard]]];
    
    [request setPassengers:@[_passengerInfo]];
    return request;
}

#pragma mark - view init
- (void)setSubviewFrame
{
    _saveToCommonName = NO;
    
    [self setBackGroundImage:imageNameAndType(@"home_bg", nil)];
    [self setTitle:_passengerInfo?@"编辑乘客":@"新增乘客"];
    [self setTopBarBackGroundImage:imageNameAndType(@"topbar", nil)];
    
    UIButton *returnBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [returnBtn setBackgroundColor:color(clearColor)];
    [returnBtn setImage:imageNameAndType(@"return", nil) forState:UIControlStateNormal];
    [returnBtn setFrame:CGRectMake(0, 0, self.topBar.frame.size.height, self.topBar.frame.size.height)];
    [self setReturnButton:returnBtn];
    [self.view addSubview:returnBtn];
    
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightBtn setBackgroundColor:color(clearColor)];
    [rightBtn setFrame:CGRectMake(appFrame.size.width - returnBtn.frame.size.width, returnBtn.frame.origin.y, returnBtn.frame.size.width, returnBtn.frame.size.height)];
    [rightBtn setScaleX:0.7 scaleY:0.7];
    [rightBtn setImage:imageNameAndType(@"abs__ic_cab_done_holo_dark", nil) forState:UIControlStateNormal];
    [rightBtn setImage:imageNameAndType(@"abs__ic_cab_done_holo_light", nil) forState:UIControlStateHighlighted];
    [rightBtn addTarget:self action:@selector(pressRightBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:rightBtn];
    
    [self setSubjoinViewFrame];
}

- (void)setSubjoinViewFrame
{
    UIView *topBGView = [[UIView alloc]initWithFrame:CGRectMake(10, controlYLength(self.topBar) + 10, self.contentView.frame.size.width - 20, 0)];
    [topBGView setBackgroundColor:color(whiteColor)];
    [topBGView setCornerRadius:5];
    [topBGView setBorderColor:color(lightGrayColor) width:0.5];
    [self.contentView addSubview:topBGView];
    
    UILabel *ticketTypeLeftView = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, topBGView.frame.size.width/3, 40)];
    [ticketTypeLeftView setBackgroundColor:color(clearColor)];
    [ticketTypeLeftView setFont:[UIFont systemFontOfSize:14]];
    [ticketTypeLeftView setText:@"类型"];
    [ticketTypeLeftView setTextAlignment:NSTextAlignmentCenter];
    [ticketTypeLeftView setTextColor:color(darkGrayColor)];
    [topBGView addSubview:ticketTypeLeftView];
    _ticketTypeLb = [[UILabel alloc]initWithFrame:CGRectMake(controlXLength(ticketTypeLeftView), ticketTypeLeftView.frame.origin.y, topBGView.frame.size.width - controlXLength(ticketTypeLeftView), ticketTypeLeftView.frame.size.height)];
    [_ticketTypeLb setBackgroundColor:color(clearColor)];
    [_ticketTypeLb setFont:[UIFont systemFontOfSize:14]];
    [_ticketTypeLb setText:@"成人票"];
    [topBGView addSubview:_ticketTypeLb];
    
    UILabel *userNameLeftView = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, ticketTypeLeftView.frame.size.width, ticketTypeLeftView.frame.size.height)];
    [userNameLeftView setBackgroundColor:color(clearColor)];
    [userNameLeftView setFont:[UIFont systemFontOfSize:14]];
    [userNameLeftView setText:@"姓名"];
    [userNameLeftView setTextAlignment:NSTextAlignmentCenter];
    [userNameLeftView setTextColor:color(darkGrayColor)];
    _userNameTf = [[UITextField alloc]initWithFrame:CGRectMake(0, controlYLength(_ticketTypeLb), topBGView.frame.size.width, _ticketTypeLb.frame.size.height)];
    [_userNameTf setFont:[UIFont systemFontOfSize:14]];
    [_userNameTf setBackgroundColor:color(clearColor)];
    [_userNameTf setBorderColor:color(lightGrayColor) width:0.5];
    [_userNameTf setLeftViewMode:UITextFieldViewModeAlways];
    [_userNameTf setLeftView:userNameLeftView];
    [_userNameTf setDelegate:self];
    [_userNameTf setText:_passengerInfo?_passengerInfo.UserName:nil];
    [_userNameTf setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
    [topBGView addSubview:_userNameTf];
    
    MemberIDcardResponse *defaultIDCard = [_passengerInfo getDefaultIDCard];
    
    UILabel *cardTypeLeftView = [[UILabel alloc]initWithFrame:CGRectMake(ticketTypeLeftView.frame.origin.x, controlYLength(_userNameTf), ticketTypeLeftView.frame.size.width, ticketTypeLeftView.frame.size.height)];
    [cardTypeLeftView setBackgroundColor:color(clearColor)];
    [cardTypeLeftView setFont:[UIFont systemFontOfSize:14]];
    [cardTypeLeftView setText:@"证件名称"];
    [cardTypeLeftView setTextAlignment:NSTextAlignmentCenter];
    [cardTypeLeftView setTextColor:color(darkGrayColor)];
    [topBGView addSubview:cardTypeLeftView];
    _cardTypeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_cardTypeBtn setFrame:CGRectMake(_ticketTypeLb.frame.origin.x, cardTypeLeftView.frame.origin.y, _ticketTypeLb.frame.size.width, _ticketTypeLb.frame.size.height)];
    [_cardTypeBtn setTag:100];
    [_cardTypeBtn.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [_cardTypeBtn.titleLabel setTextAlignment:NSTextAlignmentLeft];
    [_cardTypeBtn setTitle:_passengerInfo?[defaultIDCard getCardTypeName]:@"身份证" forState:UIControlStateNormal];
    [_cardTypeBtn addTarget:self action:@selector(pressBtnItem:) forControlEvents:UIControlEventTouchUpInside];
    [_cardTypeBtn setTitleColor:color(blackColor) forState:UIControlStateNormal];
    [_cardTypeBtn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [topBGView addSubview:_cardTypeBtn];
    UIImageView *cardTypeBRightView = [[UIImageView alloc]initWithFrame:CGRectMake(controlXLength(_cardTypeBtn) - _cardTypeBtn.frame.size.height, _cardTypeBtn.frame.origin.y, _cardTypeBtn.frame.size.height, _cardTypeBtn.frame.size.height)];
    [cardTypeBRightView setImage:imageNameAndType(@"arrow", nil)];
    [cardTypeBRightView setScaleX:0.2 scaleY:0.3];
    [topBGView addSubview:cardTypeBRightView];
    
    [topBGView createLineWithParam:color(lightGrayColor) frame:CGRectMake(0, controlYLength(_cardTypeBtn), topBGView.frame.size.width, 0.5)];
    
    UILabel *cardNumLeftView = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, ticketTypeLeftView.frame.size.width, ticketTypeLeftView.frame.size.height)];
    [cardNumLeftView setBackgroundColor:color(clearColor)];
    [cardNumLeftView setFont:[UIFont systemFontOfSize:14]];
    [cardNumLeftView setText:@"证件号码"];
    [cardNumLeftView setTextAlignment:NSTextAlignmentCenter];
    [cardNumLeftView setTextColor:color(darkGrayColor)];
    _cardNumTf = [[UITextField alloc]initWithFrame:CGRectMake(_userNameTf.frame.origin.x, controlYLength(_cardTypeBtn), _userNameTf.frame.size.width, _userNameTf.frame.size.height)];
    [_cardNumTf setBackgroundColor:color(clearColor)];
    [_cardNumTf setFont:[UIFont systemFontOfSize:14]];
    [_cardNumTf setLeftViewMode:UITextFieldViewModeAlways];
    [_cardNumTf setText:_passengerInfo?[defaultIDCard CardNumber]:nil];
    [_cardNumTf setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
    [_cardNumTf setLeftView:cardNumLeftView];
    [_cardNumTf setDelegate:self];
    [topBGView addSubview:_cardNumTf];
    
    [topBGView setFrame:CGRectMake(topBGView.frame.origin.x, topBGView.frame.origin.y, topBGView.frame.size.width, controlYLength(_cardNumTf))];
    
    UIView *bottomBGView = [[UIView alloc]initWithFrame:CGRectMake(topBGView.frame.origin.x, controlYLength(topBGView) + 10, topBGView.frame.size.width, 0)];
    [bottomBGView setBackgroundColor:color(whiteColor)];
    [bottomBGView setCornerRadius:5];
    [bottomBGView setBorderColor:color(lightGrayColor) width:0.5];
    [self.contentView addSubview:bottomBGView];
    
    UILabel *insureLeftView = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, ticketTypeLeftView.frame.size.width, ticketTypeLeftView.frame.size.height)];
    [insureLeftView setBackgroundColor:color(clearColor)];
    [insureLeftView setFont:[UIFont systemFontOfSize:14]];
    [insureLeftView setText:@"保险"];
    [insureLeftView setTextAlignment:NSTextAlignmentCenter];
    [insureLeftView setTextColor:color(darkGrayColor)];
    [bottomBGView addSubview:insureLeftView];
    _insureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_insureBtn setFrame:CGRectMake(controlXLength(insureLeftView), insureLeftView.frame.origin.y, bottomBGView.frame.size.width - controlXLength(insureLeftView), insureLeftView.frame.size.height)];
    [_insureBtn setTag:101];
    [_insureBtn.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [_insureBtn.titleLabel setTextAlignment:NSTextAlignmentLeft];
    [_insureBtn setTitle:_passengerInfo?_passengerInfo.UserName:nil forState:UIControlStateNormal];
    [_insureBtn setTitleColor:color(blackColor) forState:UIControlStateNormal];
    [_insureBtn addTarget:self action:@selector(pressBtnItem:) forControlEvents:UIControlEventTouchUpInside];
    [_insureBtn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [bottomBGView addSubview:_insureBtn];
    UIImageView *insureRightView = [[UIImageView alloc]initWithFrame:CGRectMake(controlXLength(_insureBtn) - _insureBtn.frame.size.height, _insureBtn.frame.origin.y, _insureBtn.frame.size.height, _insureBtn.frame.size.height)];
    [insureRightView setImage:imageNameAndType(@"arrow", nil)];
    [insureRightView setScaleX:0.2 scaleY:0.3];
    [bottomBGView addSubview:insureRightView];
    
    [bottomBGView createLineWithParam:color(lightGrayColor) frame:CGRectMake(0, controlYLength(_insureBtn), bottomBGView.frame.size.width, 0.5)];
    
    UILabel *costCenterLeftView = [[UILabel alloc]initWithFrame:CGRectMake(insureLeftView.frame.origin.x, controlYLength(insureLeftView), insureLeftView.frame.size.width, insureLeftView.frame.size.height)];
    [costCenterLeftView setBackgroundColor:color(clearColor)];
    [costCenterLeftView setFont:[UIFont systemFontOfSize:14]];
    [costCenterLeftView setText:@"成本中心"];
    [costCenterLeftView setTextAlignment:NSTextAlignmentCenter];
    [costCenterLeftView setTextColor:color(darkGrayColor)];
    [bottomBGView addSubview:costCenterLeftView];
    _costCenterBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_costCenterBtn setFrame:CGRectMake(_insureBtn.frame.origin.x, controlYLength(_insureBtn), _insureBtn.frame.size.width, _insureBtn.frame.size.height)];
    [_costCenterBtn setTag:102];
    [_costCenterBtn setBackgroundColor:color(clearColor)];
    [_costCenterBtn.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [_costCenterBtn setTitle:_passengerInfo?_passengerInfo.DeptName:nil forState:UIControlStateNormal];
    [_costCenterBtn.titleLabel setTextAlignment:NSTextAlignmentLeft];
    [_costCenterBtn setTitleColor:color(blackColor) forState:UIControlStateNormal];
    [_costCenterBtn addTarget:self action:@selector(pressBtnItem:) forControlEvents:UIControlEventTouchUpInside];
    [_costCenterBtn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [bottomBGView addSubview:_costCenterBtn];
    UIImageView *costCenterRightView = [[UIImageView alloc]initWithFrame:CGRectMake(controlXLength(_costCenterBtn) - _costCenterBtn.frame.size.height, _costCenterBtn.frame.origin.y, _costCenterBtn.frame.size.height, _costCenterBtn.frame.size.height)];
    [costCenterRightView setImage:imageNameAndType(@"arrow", nil)];
    [costCenterRightView setScaleX:0.2 scaleY:0.3];
    [bottomBGView addSubview:costCenterRightView];
    
    [bottomBGView setFrame:CGRectMake(bottomBGView.frame.origin.x, bottomBGView.frame.origin.y, bottomBGView.frame.size.width, controlYLength(_costCenterBtn))];
    
    CustomStatusBtn *saveToCommonNameBtn = [[CustomStatusBtn alloc]initWithFrame:CGRectMake(bottomBGView.frame.origin.x, controlYLength(bottomBGView) + 10, bottomBGView.frame.size.width, 30)];
    [saveToCommonNameBtn setImage:imageNameAndType(@"autolog_normal", nil) selectedImage:imageNameAndType(@"autolog_select", nil)];
    [saveToCommonNameBtn setDetail:@"保存到常用姓名"];
    [saveToCommonNameBtn addTarget:self action:@selector(pressSaveToCommonName:) forControlEvents:UIControlEventTouchUpInside];
    [saveToCommonNameBtn setLeftViewScaleX:0.7 scaleY:0.7];
    [saveToCommonNameBtn setTag:103];
    [self.contentView addSubview:saveToCommonNameBtn];
    
}

- (void)pressSaveToCommonName:(UIButton*)sender
{
    CustomStatusBtn *customBtn = (CustomStatusBtn*)[self.contentView viewWithTag:103];
    [customBtn setSelect:!customBtn.select];
    _saveToCommonName = customBtn.select;
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesEnded:touches withEvent:event];
    [self clearKeyBoard];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if ([textField isFirstResponder]) {
        [textField resignFirstResponder];
    }
    return YES;
}

- (BOOL)clearKeyBoard
{
    BOOL canResighFirstResponder = NO;
    if ([_userNameTf isFirstResponder]) {
        [_userNameTf resignFirstResponder];
        canResighFirstResponder  = YES;
    }else if ([_cardNumTf isFirstResponder]){
        [_cardNumTf resignFirstResponder];
        canResighFirstResponder  = YES;
    }
    return canResighFirstResponder;
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
