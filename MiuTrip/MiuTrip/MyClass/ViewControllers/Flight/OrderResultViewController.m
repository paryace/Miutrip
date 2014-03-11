//
//  OrderResultViewController.m
//  MiuTrip
//
//  Created by apple on 13-12-3.
//  Copyright (c) 2013年 michael. All rights reserved.
//

#import "OrderResultViewController.h"
#import "SubmitFlightOrderResponse.h"

@interface OrderResultViewController ()

@property (strong, nonatomic) UIImageView       *orderStatusIv;
@property (strong, nonatomic) UILabel           *orderPromptLb;
@property (strong, nonatomic) UILabel           *orderNumLb;
@property (strong, nonatomic) UILabel           *priceLb;

@property (strong, nonatomic) SubmitFlightOrderResponse *response;

@end

@implementation OrderResultViewController

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
        [self setSubviewFrame];
    }
    return self;
}

- (id)initWithParams:(SubmitFlightOrderResponse *)params
{
    self = [super init];
    if (self) {
        _response = params;
        [self setSubviewFrame];
    }
    return self;
}

- (void)pressReturnBtn:(UIButton*)sender
{
    [self popToMainViewControllerTransitionType:TransitionPush completionHandler:nil];
}

#pragma mark - UPPay
- (void)UPPay
{
    [UPPayPlugin startPay:_response.PaySerialId sysProvide:nil spId:nil mode:@"00" viewController:self delegate:self];
}

- (void)UPPayPluginResult:(NSString*)result
{
    [self popToMainViewControllerTransitionType:TransitionNone completionHandler:^{
        NSLog(@"pop to main");
        [[Model shareModel] goToAirOrderList];
    }];
}

- (void)pressOrderDetailBtn:(UIButton*)sender
{
    [self popToMainViewControllerTransitionType:TransitionNone completionHandler:^{
        NSLog(@"pop to main");
        [[Model shareModel] goToAirOrderList];
    }];
}

- (void)pressLittleMiuBtn:(UIButton*)sender
{
    [self popToMainViewControllerTransitionType:TransitionNone completionHandler:^{
        NSLog(@"pop to main");
        [[Model shareModel] goToLittleMiu];
    }];
}

#pragma mark - view init
- (void)setSubviewFrame
{
    [self setBackGroundImage:imageNameAndType(@"home_bg", nil)];
    [self setTitle:@"订单结果"];
    [self setTopBarBackGroundImage:imageNameAndType(@"topbar", nil)];
    
    UIButton *returnBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [returnBtn setBackgroundColor:color(clearColor)];
    [returnBtn setImage:imageNameAndType(@"return", nil) forState:UIControlStateNormal];
    [returnBtn setFrame:CGRectMake(0, 0, self.topBar.frame.size.height, self.topBar.frame.size.height)];
    //    [self setReturnButton:returnBtn];
    [returnBtn addTarget:self action:@selector(pressReturnBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:returnBtn];
    
    [self setSubjoinViewFrame];
}

- (void)setSubjoinViewFrame
{
    _orderStatusIv = [[UIImageView alloc]initWithFrame:CGRectMake(20, controlYLength(self.topBar) + 20, 45, 45)];
    [_orderStatusIv setImage:imageNameAndType(@"icon_finish", nil)];
    [self.contentView addSubview:_orderStatusIv];
    
    _orderPromptLb = [[UILabel alloc]initWithFrame:CGRectMake(controlXLength(_orderStatusIv), _orderStatusIv.frame.origin.y, self.contentView.frame.size.width - controlXLength(_orderStatusIv) - _orderStatusIv.frame.origin.x, _orderStatusIv.frame.size.height)];
    [_orderPromptLb setBackgroundColor:color(clearColor)];
    [_orderPromptLb setFont:[UIFont systemFontOfSize:13]];
    [_orderPromptLb setAutoBreakLine:YES];
    [_orderPromptLb setText:@"订单已提交,我们将尽快通过您选择的方式来确认您的订单."];
    [_orderPromptLb setAutoSize:YES];
    [self.contentView addSubview:_orderPromptLb];
    
    NSArray *MsgPayEntitys = _response.OrderList;
    CGFloat orderItemCellHeight = 30.0f * 2;
    for (int i = 0; i<[MsgPayEntitys count]; i++) {
        if (i == 0) {
            [self.contentView createLineWithParam:color(lightGrayColor) frame:CGRectMake(_orderPromptLb.frame.origin.x, controlYLength(_orderPromptLb), _orderPromptLb.frame.size.width, 0.5)];
        }
        MsgPayEntity *entity = [MsgPayEntitys objectAtIndex:i];
        UILabel *orderNumLeft = [[UILabel alloc]initWithFrame:CGRectMake(_orderPromptLb.frame.origin.x, controlYLength(_orderPromptLb) + orderItemCellHeight * i, 70, 30)];
        [orderNumLeft setText:@"订单号:"];
        [orderNumLeft setBackgroundColor:color(clearColor)];
        [orderNumLeft setAutoSize:YES];
        [orderNumLeft setFont:_orderPromptLb.font];
        [self.contentView addSubview:orderNumLeft];
        _orderNumLb = [[UILabel alloc]initWithFrame:CGRectMake(controlXLength(orderNumLeft) + 10, orderNumLeft.frame.origin.y,  _orderPromptLb.frame.size.width - orderNumLeft.frame.size.width - 10, orderNumLeft.frame.size.height)];
        [_orderNumLb setText:[NSString stringWithFormat:@"%@",entity.OrderId]];
        [_orderNumLb setAutoSize:YES];
        [_orderNumLb setBackgroundColor:color(clearColor)];
        [self.contentView addSubview:_orderNumLb];
        
        UILabel *orderDesc = [[UILabel alloc]initWithFrame:CGRectMake(orderNumLeft.frame.origin.x, controlYLength(orderNumLeft), orderNumLeft.frame.size.width, orderNumLeft.frame.size.height)];
        [orderDesc setText:entity.FlightDesc];
        [orderDesc setFont:_orderPromptLb.font];
        [orderDesc setAutoSize:YES];
        [orderDesc setBackgroundColor:color(clearColor)];
        [self.contentView addSubview:orderDesc];
        
        _priceLb = [[UILabel alloc]initWithFrame:CGRectMake(_orderNumLb.frame.origin.x, controlYLength(_orderNumLb), _orderNumLb.frame.size.width, _orderNumLb.frame.size.height)];
        [_priceLb setText:[NSString stringWithFormat:@"金额:%@",entity.Amount]];
        [_priceLb setFont:_orderPromptLb.font];
        [_priceLb setAutoSize:YES];
        [_priceLb setBackgroundColor:color(clearColor)];
        [_priceLb setTextColor:color(colorWithRed:245.0/255.0 green:117.0/255.0 blue:36.0/255.0 alpha:1)];
        [self.contentView addSubview:_priceLb];
        
        [self.contentView createLineWithParam:color(lightGrayColor) frame:CGRectMake(_orderPromptLb.frame.origin.x, orderItemCellHeight * i, _orderPromptLb.frame.size.width, 0.5)];
    }
    
    UIButton *orderDetailBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [orderDetailBtn setBackgroundImage:imageNameAndType(@"button_style1", nil) forState:UIControlStateNormal];
    [orderDetailBtn setFrame:CGRectMake(self.contentView.frame.size.width/8 - 10, controlYLength(_priceLb) + 10, self.contentView.frame.size.width/4, 35)];
    [orderDetailBtn.titleLabel setFont:[UIFont systemFontOfSize:13]];
    [orderDetailBtn setTitle:@"订单详情" forState:UIControlStateNormal];
    [orderDetailBtn setTitleColor:color(colorWithRed:50.0/255.0 green:120.0/255.0 blue:160.0/255.0 alpha:1) forState:UIControlStateNormal];
    [orderDetailBtn setTitleColor:color(whiteColor) forState:UIControlStateHighlighted];
    [orderDetailBtn addTarget:self action:@selector(pressOrderDetailBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:orderDetailBtn];
    
    UIButton *littleMiuBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [littleMiuBtn setBackgroundImage:imageNameAndType(@"button_style1", nil) forState:UIControlStateNormal];
    [littleMiuBtn setFrame:CGRectMake(controlXLength(orderDetailBtn) + 10, orderDetailBtn.frame.origin.y, orderDetailBtn.frame.size.width, orderDetailBtn.frame.size.height)];
    [littleMiuBtn.titleLabel setFont:[UIFont systemFontOfSize:13]];
    [littleMiuBtn setTitle:@"贴心小觅" forState:UIControlStateNormal];
    [littleMiuBtn setTitleColor:color(colorWithRed:50.0/255.0 green:120.0/255.0 blue:160.0/255.0 alpha:1) forState:UIControlStateNormal];
    [littleMiuBtn setTitleColor:color(whiteColor) forState:UIControlStateHighlighted];
    [littleMiuBtn addTarget:self action:@selector(pressLittleMiuBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:littleMiuBtn];
    
    UIButton *continuePayBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [continuePayBtn setBackgroundImage:imageNameAndType(@"done_btn_normal", nil) forState:UIControlStateNormal];
    [continuePayBtn setBackgroundImage:imageNameAndType(@"done_btn_press", nil) forState:UIControlStateHighlighted];
    [continuePayBtn setFrame:CGRectMake(controlXLength(littleMiuBtn) + 10, orderDetailBtn.frame.origin.y - 2.5, orderDetailBtn.frame.size.width + 5, orderDetailBtn.frame.size.height + 5)];
    [continuePayBtn.titleLabel setFont:[UIFont systemFontOfSize:13]];
    [continuePayBtn setTitle:@"继续支付" forState:UIControlStateNormal];
    [continuePayBtn setTitleColor:color(colorWithRed:50.0/255.0 green:120.0/255.0 blue:160.0/255.0 alpha:1) forState:UIControlStateHighlighted];
    [continuePayBtn addTarget:self action:@selector(UPPay) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:continuePayBtn];
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
