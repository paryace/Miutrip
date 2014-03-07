//
//  AccountActViewController.m
//  MiuTrip
//
//  Created by pingguo on 14-2-25.
//  Copyright (c) 2014年 michael. All rights reserved.
//

#import "AccountActViewController.h"
#import "ActiveGiftCardUserRequest.h"


#define CORPVIWE_TAG    500
#define MANAGERVIEW_TAG 501

#define CORPNAME_TAG  1000
#define CORPTEL_TAG    1001
#define CODEFIELD_TAG 1002
#define GIFTCARD_TAG  1003
#define USERNAME_TAG  1004
#define PHONE_TAG     1005

@interface AccountActViewController ()

@end

@implementation AccountActViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (id)init{
    if (self= [super init]) {
        [self.contentView setHidden:NO];
    }
    [self setSubViews];
    return self;
}
- (void)setSubViews{
    [self setTopBarBackGroundImage:imageNameAndType(@"top_bg", nil)];
    [self setTitle:@"帐户激活"];
    [self setBackGroundImage:imageNameAndType(@"home_bg", nil)];
    
    UIButton *returnBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [returnBtn setFrame:CGRectMake(0, 0, 70, self.topBar.frame.size.height)];
    [returnBtn setImage:imageNameAndType(@"return", nil) forState:UIControlStateNormal];
    [returnBtn setScaleX:0.7 scaleY:0.7];
    [self setReturnButton:returnBtn];
    [self.view addSubview:returnBtn];
    
    UILabel *corpInfo = [[UILabel alloc]initWithFrame:CGRectMake(10, controlYLength(self.topBar)+10, self.contentView.frame.size.width-20, 20)];
    [corpInfo setText:@"公司信息"];
    [corpInfo setTextColor:[UIColor colorWithRed:70/255.0 green:70/255.0 blue:200/255.0 alpha:1.0]];
    [self.contentView addSubview:corpInfo];
    
    UIView *corpView = [[UIView alloc]initWithFrame:CGRectMake(5, controlYLength(corpInfo)+10, self.contentView.frame.size.width-10, 80)];
    corpView.tag = CORPVIWE_TAG;
    [corpView setBackgroundColor:color(whiteColor)];
    [corpView setBorderColor:color(grayColor) width:0.5];
    [corpView.layer setCornerRadius:3.0];
    [self.contentView addSubview:corpView];
    
    UILabel *corpName = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, corpView.frame.size.width/4, corpView.frame.size.height/2)];
    [corpName setText:@"公司名称"];
    [corpName setTextAlignment:NSTextAlignmentCenter];
    [corpView addSubview:corpName];
    
    [corpView addSubview:[self createLine:CGRectMake(corpView.frame.size.width/4, 0, 0.5f, corpView.frame.size.height)]];
    
    UITextField *name = [[UITextField alloc]initWithFrame:CGRectMake(corpView.frame.size.width/4, 0, corpView.frame.size.width*3/4, corpView.frame.size.height/2)];
    [name setBorderStyle:UITextBorderStyleNone];
    [name setDelegate:self];
    name.tag = CORPNAME_TAG;
    name.clearButtonMode = UITextFieldViewModeWhileEditing;
    [corpView addSubview:name];
    
    [corpView addSubview:[self createLine:CGRectMake(0,corpView.frame.size.height/2,corpView.frame.size.width,0.5f)]];
    
    UILabel *corpTel = [[UILabel alloc]initWithFrame:CGRectMake(0,corpName.frame.size.height, corpView.frame.size.width/4, corpView.frame.size.height/2)];
    [corpTel setText:@"公司电话"];
    [corpTel setTextAlignment:NSTextAlignmentCenter];
    [corpView addSubview:corpTel];
    
    
    UITextField *tel = [[UITextField alloc]initWithFrame:CGRectMake(corpView.frame.size.width/4,corpView.frame.size.height/2, corpView.frame.size.width*3/4, corpView.frame.size.height/2)];
    [tel setBorderStyle:UITextBorderStyleNone];
    [tel setDelegate:self];
    tel.tag = CORPTEL_TAG;
    //tel.keyboardType = UIKeyboardTypeNumberPad;
    tel.clearButtonMode = UITextFieldViewModeWhileEditing;
    [corpView addSubview:tel];
    
    UILabel *managerInfo = [[UILabel alloc]initWithFrame:CGRectMake(10, controlYLength(corpView)+10, self.contentView.frame.size.width-20, 20)];
    [managerInfo setText:@"管理员信息"];
    [managerInfo setTextColor:[UIColor colorWithRed:70/255.0 green:70/255.0 blue:200/255.0 alpha:1.0]];
    [self.contentView addSubview:managerInfo];
    
    UIView *managerView = [[UIView alloc]initWithFrame:CGRectMake(5, controlYLength(managerInfo)+10, self.contentView.frame.size.width-10, 160)];
    [managerView setBackgroundColor:color(whiteColor)];
    [managerView setBorderColor:color(grayColor) width:0.5];
    [managerView.layer setCornerRadius:3.0];
    managerView.tag = MANAGERVIEW_TAG;
    [self.contentView addSubview:managerView];
    
    UILabel *managerName = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, managerView.frame.size.width/4, managerView.frame.size.height/4)];
    [managerName setText:@"姓 名"];
    [managerName setTextAlignment:NSTextAlignmentCenter];
    [managerView addSubview:managerName];
    
    [managerView addSubview:[self createLine:CGRectMake(managerView.frame.size.width/4, 0, 0.5f, managerView.frame.size.height)]];
    
    UITextField *nameField = [[UITextField alloc]initWithFrame:CGRectMake(managerView.frame.size.width/4, 0, managerView.frame.size.width*3/4, managerView.frame.size.height/4)];
    [nameField setBorderStyle:UITextBorderStyleNone];
    [nameField setDelegate:self];
    nameField.tag = USERNAME_TAG;
    nameField.clearButtonMode = UITextFieldViewModeWhileEditing;
    [managerView addSubview:nameField];
    
    [managerView addSubview:[self createLine:CGRectMake(0,managerView.frame.size.height/4,managerView.frame.size.width,0.5f)]];
    
    UILabel *managerPhone = [[UILabel alloc]initWithFrame:CGRectMake(0, controlYLength(name), managerView.frame.size.width/4, managerView.frame.size.height/4)];
    [managerPhone setText:@"手机号 "];
    [managerPhone setTextAlignment:NSTextAlignmentCenter];
    [managerView addSubview:managerPhone];
    
    
    UITextField *phone = [[UITextField alloc]initWithFrame:CGRectMake(managerView.frame.size.width/4, controlYLength(name), managerView.frame.size.width*3/4, managerView.frame.size.height/4)];
    [phone setBorderStyle:UITextBorderStyleNone];
    [phone setDelegate:self];
    [managerView addSubview:phone];
    phone.tag = PHONE_TAG;
   // phone.keyboardType = UIKeyboardTypeNumberPad;
    phone.clearButtonMode = UITextFieldViewModeWhileEditing;
    [managerView addSubview:[self createLine:CGRectMake(0,managerView.frame.size.height*2/4,managerView.frame.size.width,0.5f)]];
    
#pragma mark --礼品卡卡号
    UILabel *giftCardNumber = [[UILabel alloc] initWithFrame:CGRectMake(0, controlYLength(phone), managerView.frame.size.width/4, managerView.frame.size.height/4)];
    giftCardNumber.text = @"礼品卡号";
    giftCardNumber.textAlignment = NSTextAlignmentCenter;
    [managerView addSubview:giftCardNumber];
    
    UITextField *giftCardNumberField = [[UITextField alloc] initWithFrame:CGRectMake(managerView.frame.size.width/4, controlYLength(phone), managerView.frame.size.width*3/4, managerView.frame.size.height/4)];
    giftCardNumberField.borderStyle = UITextBorderStyleNone;
    giftCardNumberField.delegate = self;
    //giftCardNumberField.keyboardType = UIKeyboardTypeNumberPad;
    giftCardNumberField.tag = GIFTCARD_TAG;
    giftCardNumberField.clearButtonMode = UITextFieldViewModeWhileEditing;
    [managerView addSubview:giftCardNumberField];
    
        [managerView addSubview:[self createLine:CGRectMake(0,managerView.frame.size.height*3/4,managerView.frame.size.width,0.5f)]];
    
    UILabel *code = [[UILabel alloc]initWithFrame:CGRectMake(0, controlYLength(giftCardNumber), managerView.frame.size.width/4, managerView.frame.size.height/4)];
    [code setText:@"激活码"];
    [code setTextAlignment:NSTextAlignmentCenter];
    [managerView addSubview:code];
    
    
    UITextField *codeField = [[UITextField alloc]initWithFrame:CGRectMake(managerView.frame.size.width/4, controlYLength(giftCardNumber), managerView.frame.size.width*1/4 + 50, managerView.frame.size.height/4)];
    [codeField setBorderStyle:UITextBorderStyleNone];
    [codeField setDelegate:self];
    codeField.tag = CODEFIELD_TAG;
    //codeField.keyboardType = UIKeyboardTypeNumberPad;
    codeField.clearButtonMode = UITextFieldViewModeWhileEditing;
    [managerView addSubview:codeField];
    
    UIButton *freeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [freeBtn setFrame:CGRectMake(managerView.frame.size.width*2/3, controlYLength(giftCardNumber)+5,managerView.frame.size.width/3-10, managerView.frame.size.height/4-10)];
    [freeBtn setBackgroundImage:imageNameAndType(@"bg_btn_blue", nil) forState:UIControlStateNormal];
    [freeBtn setTitle:@"免费获取激活码" forState:UIControlStateNormal];
    [freeBtn.titleLabel setFont:[UIFont systemFontOfSize:11]];
    [managerView addSubview:freeBtn];
    
    UIButton *actBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [actBtn setFrame:CGRectMake(self.contentView.frame.size.width/4, controlYLength(managerView)+20, self.contentView.frame.size.width/2, 50)];
    [actBtn setBackgroundImage:imageNameAndType(@"done_btn_normal", nil) forState:UIControlStateNormal];
    [actBtn setBackgroundImage:imageNameAndType(@"done_btn_press", nil) forState:UIControlStateHighlighted];
    [actBtn setTitle:@"激活" forState:UIControlStateNormal];
    [actBtn setTitleColor:color(whiteColor) forState:UIControlStateNormal];
    [actBtn addTarget:self action:@selector(activate:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:actBtn];
    
}


- (void)activate:(UIButton *)act
{
    [self setRequestArgumentsToSendRequest];
}



- (void)setRequestArgumentsToSendRequest
{
    
    //从界面获取请求参数
    UIView *corpView = (UIView *)[self.contentView viewWithTag:CORPVIWE_TAG];
    UIView *managerView = (UIView *)[self.contentView viewWithTag:MANAGERVIEW_TAG];
    
    UITextField *corpName = (UITextField *)[corpView viewWithTag:CORPNAME_TAG];
    UITextField *corpTel = (UITextField *)[corpView viewWithTag:CORPTEL_TAG];
    
    UITextField *userName = (UITextField *)[managerView viewWithTag:USERNAME_TAG];
    UITextField *phone = (UITextField *)[managerView viewWithTag:PHONE_TAG];
    UITextField *card = (UITextField *)[managerView viewWithTag:GIFTCARD_TAG];
    UITextField *code = (UITextField *)[managerView viewWithTag:CODEFIELD_TAG];
    
    ActiveGiftCardUserRequest *request = [[ActiveGiftCardUserRequest alloc] initWidthBusinessType:BUSINESS_ACCOUNT methodName:@"ActiveGiftCardUser"];
    request.UID = card.text;
    request.CorpName = corpName.text;
    request.CityID = [NSNumber numberWithInt:0];
    request.UserName = userName.text;
    request.Tel = corpTel.text;
    request.Mobilephone = phone.text;
    request.ChinaUmsUID = @"15138531681";
    request.SourceID = [NSNumber numberWithInt:0];
    request.SinaWeibUID = @"";
    request.LoginPass = code.text;
    
    [self.requestManager sendRequest:request];
}

- (void)requestDone:(BaseResponseModel *)response
{
    NSLog(@"成功");
}

- (void)requestFailedWithErrorCode:(NSNumber *)errorCode withErrorMsg:(NSString *)errorMsg
{
    NSLog(@"失败");
}

-(UIImageView*)createLine:(CGRect)frame{
    UIImageView *iamge = [[UIImageView alloc]initWithFrame:frame];
    [iamge setBackgroundColor:color(grayColor)];
    [iamge setAlpha:0.5];
    return iamge;
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (textField.tag == CODEFIELD_TAG ) {
        CGRect frame ;
        frame = CGRectMake(self.contentView.frame.origin.x, self.contentView.frame.origin.y - 50, self.contentView.frame.size.width, self.contentView.frame.size.height);
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.5f];
        self.contentView.frame = frame;
        [UIView commitAnimations];
    }
}


- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField.tag == CODEFIELD_TAG ) {
        
        CGRect frame ;
        frame = CGRectMake(self.contentView.frame.origin.x, self.contentView.frame.origin.y + 50, self.contentView.frame.size.width, self.contentView.frame.size.height);
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.5f];
        self.contentView.frame = frame;
        [UIView commitAnimations];
    }

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
