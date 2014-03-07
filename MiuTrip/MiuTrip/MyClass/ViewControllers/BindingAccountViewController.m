//
//  BindingAccountViewController.m
//  MiuTrip
//
//  Created by Y on 14-2-25.
//  Copyright (c) 2014年 michael. All rights reserved.
//

#import "BindingAccountViewController.h"
#import "BindingUserByUMSRequest.h"

#define PASSWORD  1000
#define USERNAME  1001

@interface BindingAccountViewController ()

@end

@implementation BindingAccountViewController

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
        [self setSubviewFrame];
    }
    return self;
}

- (void)setSubviewFrame
{
    [self setBackGroundImage:imageNameAndType(@"home_bg", nil)];
    [self setTitle:@"绑定帐号"];
    [self setTopBarBackGroundImage:imageNameAndType(@"topbar", nil)];
    
    UIButton *returnBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [returnBtn setBackgroundColor:color(clearColor)];
    [returnBtn setImage:imageNameAndType(@"return", nil) forState:UIControlStateNormal];
    [returnBtn setFrame:CGRectMake(0, 0, self.topBar.frame.size.height, self.topBar.frame.size.height)];
    [self setReturnButton:returnBtn];
    [self.view addSubview:returnBtn];
    
    [self setSubjoinViewFrame];
}

-(void)setSubjoinViewFrame
{
    UIImageView *topView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_finish"]];
    [topView setFrame:CGRectMake(self.contentView.frame.size.width/15-5,self.contentView.frame.size.height/12 + 15,self.contentView.frame.size.width/10 - 5 ,self.contentView.frame.size.width/10 - 5)];
    [self.contentView addSubview:topView];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(controlXLength(topView) + 5, topView.frame.origin.y , self.view.frame.size.width/2,topView.frame.size.height)];
    [titleLabel setText:@"我想绑定已有觅优帐号"];
    [titleLabel setFont:[UIFont boldSystemFontOfSize:15]];
    [titleLabel setBackgroundColor:[UIColor clearColor]];
    [titleLabel setTextColor:[UIColor grayColor]];
    [self.contentView addSubview:titleLabel];
    
    UIImageView *bgImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"log_text_bg"]];
    [bgImageView setFrame:CGRectMake(topView.frame.origin.x - 6 , controlYLength(topView)+5, appFrame.size.width - 20, self.contentView.frame.size.height/5 - 20)];
    [self.contentView addSubview:bgImageView];
    
    UILabel *account = [[UILabel alloc] initWithFrame:CGRectMake(bgImageView.frame.origin.x + 5,bgImageView.frame.origin.y+5,bgImageView.frame.size.width/4,bgImageView.frame.size.height/2-5)];
    [account setText:@"  帐    号"];
    [account setBackgroundColor:[UIColor clearColor]];
    [account setTextColor:[UIColor grayColor]];
    [self.contentView addSubview:account];

    UITextField * accountTf = [[UITextField alloc] initWithFrame:CGRectMake(controlXLength(account)+ 10, account.frame.origin.y, bgImageView.frame.size.width - 20 - account.frame.size.width, bgImageView.frame.size.height/2)];
    accountTf.clearButtonMode = UITextFieldViewModeWhileEditing;
    accountTf.tag = USERNAME;
    [self.contentView addSubview:accountTf];
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(account.frame.origin.x, controlYLength(account), bgImageView.frame.size.width - 10, 0.5)];
    [line setBackgroundColor:[UIColor lightGrayColor]];
    [self.contentView addSubview:line];
    
    UIView *line2 = [[UIView alloc] initWithFrame:CGRectMake(controlXLength(account), account.frame.origin.y, 0.5, bgImageView.frame.size.height - 12)];
    [line2 setBackgroundColor:[UIColor lightGrayColor]];
    [self.contentView addSubview:line2];
    
    UILabel *passWord = [[UILabel alloc] initWithFrame:CGRectMake(bgImageView.frame.origin.x + 5,controlYLength(account),bgImageView.frame.size.width/4,bgImageView.frame.size.height/2-5)];
    [passWord setText:@"  密    码"];
    [passWord setBackgroundColor:[UIColor clearColor]];
    [passWord setTextColor:[UIColor grayColor]];
    [self.contentView addSubview:passWord];
    
    UITextField * psdTf = [[UITextField alloc] initWithFrame:CGRectMake(controlXLength(passWord)+10, passWord.frame.origin.y, bgImageView.frame.size.width - 20 - passWord.frame.size.width, bgImageView.frame.size.height/2)];
    psdTf.secureTextEntry = YES;
    psdTf.clearButtonMode = UITextFieldViewModeWhileEditing;
    psdTf.tag = PASSWORD;
    [self.contentView addSubview:psdTf];
    
    UIButton *forgrtPsd = [[UIButton alloc] initWithFrame:CGRectMake(controlXLength(bgImageView) - bgImageView.frame.size.width/4-30, controlYLength(bgImageView) + 2, bgImageView.frame.size.width/3, bgImageView.frame.size.height/2)];
    [forgrtPsd setTitle:@"忘记密码" forState:UIControlStateNormal];
    forgrtPsd.titleLabel.font = [UIFont systemFontOfSize:13.5f];
    [forgrtPsd setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [forgrtPsd addTarget:self action:@selector(forgetPsd:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:forgrtPsd];
//
//    _mark = [[UIImageView alloc] initWithFrame:CGRectMake(forgrtPsd.frame.origin.x - 15, forgrtPsd.frame.origin.y + 14, 20, 20)];
//    _mark.image = [UIImage imageNamed:@"autolog_normal.png"];
//    [self.contentView addSubview:_mark];
    
#pragma mark -- 记录登陆按钮
    // CGRect frame;
    MarkState *logState = [[MarkState alloc] initWithFrame:CGRectMake(controlXLength(bgImageView) - bgImageView.frame.size.width + 10, controlYLength(bgImageView), bgImageView.frame.size.width/3, bgImageView.frame.size.height/2)];
    logState.mark.image = [UIImage imageNamed:@"autolog_normal.png"];
    logState.mTitle.text = @"记住登陆状态";
    [logState addTarget:self action:@selector(markLogState:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:logState];
    
    UIImageView *bgBtnView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"button_booking"] highlightedImage: [UIImage imageNamed:@"button_booking_pressed"]];
    [bgBtnView setFrame:CGRectMake(self.view.frame.size.width/4, controlYLength(logState) + 20, self.view.frame.size.width/2, bgImageView.frame.size.height/2)];
    [self.contentView addSubview:bgBtnView];
    
    
    UIButton *bindingBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width/4, controlYLength(logState) + 20, self.view.frame.size.width/2, bgImageView.frame.size.height/2)];
    [bindingBtn setTitle:@"   绑      定   " forState:UIControlStateNormal];
    [bindingBtn addTarget:self action:@selector(bindingAccount:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:bindingBtn];
    
}


#pragma mark -- 绑定按钮事件

- (void)bindingAccount:(UIButton *)bindingBtn
{
    [self setRequestArgumentsToSendRequest];
}


#pragma mark -- 请求参数设置 发送请求

- (void)setRequestArgumentsToSendRequest
{
    //获取用户信息
    UITextField *userName = (UITextField *)[self.contentView viewWithTag:USERNAME];
    UITextField *passWord = (UITextField *)[self.contentView viewWithTag:PASSWORD];
    
    BindingUserByUMSRequest *request = [[BindingUserByUMSRequest alloc] initWidthBusinessType:BUSINESS_ACCOUNT methodName:@"BindingUserByUMS"];
    request.Password = passWord.text;
    request.RememberMe = [NSNumber numberWithBool:_saveState];
    request.UserName = userName.text;
    //OTA类型 OTA 类型 ：Ctrip，Mango
    request.UmsUid  =  @"Mango";
    
    [self.requestManager sendRequest:request];
    
}


- (void)requestDone:(BaseResponseModel *)response
{
    NSLog(@"绑定成功");
}


- (void)requestFailedWithErrorCode:(NSNumber *)errorCode withErrorMsg:(NSString *)errorMsg
{
    NSLog(@"%@",errorCode);
}

#pragma mark -- 记住登陆状态按钮事件

- (void)markLogState:(MarkState *)logState
{
    UIImage *noMark = [UIImage imageNamed:@"autolog_normal.png"];
    UIImage *markOn = [UIImage imageNamed:@"autolog_select.png"];
    if (logState.mark.image == noMark) {
        logState.mark.image = markOn;
        self.saveState = YES;
    }else{
        logState.mark.image = noMark;
        self.saveState = NO;
    }
    NSLog(@"点了");
}

#pragma mark -- 忘记密码按钮事件

- (void)forgetPsd:(UIButton *)forget
{

}


@end

#pragma mark --- 记住登陆状态按钮自定义实现

@implementation MarkState


- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setMarkStateButtonItem];
    }
    return self;
}

- (void)setMarkStateButtonItem
{
    _mark = [[UIImageView alloc] initWithFrame:CGRectMake(0, self.frame.size.height/2 - 7, self.frame.size.width / 6, self.frame.size.height - 2 * (self.frame.size.height / 2 -7) + 3)];
    _mark.backgroundColor = [UIColor clearColor];
    [self addSubview:_mark];
    
    _mTitle = [[UILabel alloc] initWithFrame:CGRectMake(self.frame.size.width / 6, 0, self.frame.size.width * 5 / 6, self.frame.size.height)];
    _mTitle.backgroundColor = [UIColor clearColor];
    _mTitle.textColor = [UIColor darkGrayColor];
    _mTitle.textAlignment = NSTextAlignmentLeft;
    _mTitle.adjustsFontSizeToFitWidth = YES;
    [self addSubview:_mTitle];
}



@end

