//
//  RegisterAndLogViewController.m
//  MiuTrip
//
//  Created by SuperAdmin on 11/13/13.
//  Copyright (c) 2013 michael. All rights reserved.
//

#import "RegisterAndLogViewController.h"
#import "HomeViewController.h"
#import "HotelCitesRequest.h"

@interface RegisterAndLogViewController ()

@end

@implementation RegisterAndLogViewController

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

- (void)pressBtn:(UIButton*)sender
{
    if (sender.tag == 100) {
        UIImageView *logStatusImage = (UIImageView*)[self.contentView viewWithTag:200];
        [logStatusImage setHighlighted:!(logStatusImage.highlighted)];
        [UserDefaults shareUserDefault].autoLogin = logStatusImage.highlighted;
    }else if (sender.tag == 101){
        
    }else if (sender.tag == 104){
        
        LoginRequest *request = [[LoginRequest alloc]initWidthBusinessType:BUSINESS_ACCOUNT methodName:@"Login"];
        
        request.username = _userName.text;
        request.password = _passWord.text;
        request.rememberMe = [NSNumber numberWithBool:YES];
        
        [self.requestManager sendRequestWithoutToken:request];
        
        [[Model shareModel] setUserInteractionEnabled:NO];
    }
}

#pragma mark - request handle

-(void)requestFailedWithErrorCode:(NSNumber *)errorCode withErrorMsg:(NSString *)errorMsg{
    
}

-(void)requestDone:(BaseResponseModel *) response{
    
    [[Model shareModel] setUserInteractionEnabled:YES];
    LoginResponse *loginReponse = (LoginResponse*)response;
    [[UserDefaults shareUserDefault] setAuthTkn:loginReponse.authTkn];
    HomeViewController *homeView = [[HomeViewController alloc]init];
    [[Model shareModel] showPromptText:@"登陆成功" model:YES];
    [self pushViewController:homeView transitionType:TransitionPush completionHandler:nil];
    
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesEnded:touches withEvent:event];
}

- (BOOL)clearKeyBoard
{
    BOOL canResighFirstResponder = NO;
    if ([_userName isFirstResponder]) {
        [_userName resignFirstResponder];
        canResighFirstResponder  = YES;
    }else if ([_passWord isFirstResponder]){
        [_passWord resignFirstResponder];
        canResighFirstResponder  = YES;
    }
    return canResighFirstResponder;
}

- (void)setSubviewFrame
{
    [self setBackGroundImage:imageNameAndType(@"home_bg", nil)];
    
    UIImageView *topImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 85)];
    [topImageView setBackgroundColor:color(clearColor)];
    [topImageView setImage:imageNameAndType(@"register_item1", nil)];
    [self.contentView addSubview:topImageView];
    
    UIImageView *subjoinTopImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, controlYLength(topImageView), topImageView.frame.size.width, 140)];
    [subjoinTopImageView setBackgroundColor:color(clearColor)];
    [subjoinTopImageView setImage:imageNameAndType(@"register_item2", nil)];
    [self.contentView addSubview:subjoinTopImageView];
    
    UIButton *unameLeftView = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 50, 45)];
    [unameLeftView setBackgroundColor:color(clearColor)];
    [unameLeftView setImage:imageNameAndType(@"log_uname", nil) forState:UIControlStateNormal];
    _userName = [[UITextField alloc]initWithFrame:CGRectMake(30, controlYLength(subjoinTopImageView) + 15, self.view.frame.size.width - 60, unameLeftView.frame.size.height)];
    [_userName setBackgroundColor:color(clearColor)];
    [_userName setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
    [_userName setFont:[UIFont systemFontOfSize:14]];
    [_userName setLeftView:unameLeftView];
    [_userName setLeftViewMode:UITextFieldViewModeAlways];
    CGAffineTransform uCurrentTransform = unameLeftView.transform;
    CGAffineTransform uNewTransform = CGAffineTransformScale(uCurrentTransform, 0.65, 0.65);
    [unameLeftView setTransform:uNewTransform];
    [_userName setPlaceholder:@"帐号/手机号"];
    [_userName setText:@"15000609705"];
    [_userName setBackground:imageNameAndType(@"log_text_bg", nil)];
    [self.contentView addSubview:_userName];
    
    UIButton *pwordLeftView = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 50, 50)];
    [pwordLeftView setBackgroundColor:color(clearColor)];
    [pwordLeftView setImage:imageNameAndType(@"log_pword", nil) forState:UIControlStateNormal];
    _passWord = [[UITextField alloc]initWithFrame:CGRectMake(_userName.frame.origin.x, controlYLength(_userName) + 15, _userName.frame.size.width, _userName.frame.size.height)];
    [_passWord setBackgroundColor:color(clearColor)];
    [_passWord setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
    [_passWord setFont:[UIFont systemFontOfSize:14]];
    [_passWord setLeftView:pwordLeftView];
    [_passWord setLeftViewMode:UITextFieldViewModeAlways];
    CGAffineTransform pCurrentTransform = pwordLeftView.transform;
    CGAffineTransform pNewTransform = CGAffineTransformScale(pCurrentTransform, 0.65, 0.65);
    [pwordLeftView setTransform:pNewTransform];
    [_passWord setPlaceholder:@"帐号/手机号"];
    [_passWord setText:@"w5998991"];
    [_passWord setSecureTextEntry:YES];
    [_passWord setBackground:imageNameAndType(@"log_text_bg", nil)];
    [self.contentView addSubview:_passWord];
    
    UIImageView *autoLogImage = [[UIImageView alloc]initWithFrame:CGRectMake(_passWord.frame.origin.x, controlYLength(_passWord) + 15, 15, 15)];
    [autoLogImage setBackgroundColor:color(clearColor)];
    [autoLogImage setTag:200];
    [autoLogImage setHighlighted:[UserDefaults shareUserDefault].autoLogin];
    [autoLogImage setImage:imageNameAndType(@"autolog_normal", nil)];
    [autoLogImage setHighlightedImage:imageNameAndType(@"autolog_select", nil)];
    [self.contentView addSubview:autoLogImage];
    
    UILabel *autoLogLabel = [[UILabel alloc]initWithFrame:CGRectMake(controlXLength(autoLogImage) + 2.5, autoLogImage.frame.origin.y, self.view.frame.size.width/2 - controlXLength(autoLogImage), autoLogImage.frame.size.height - 2.5)];
    [autoLogLabel setBackgroundColor:color(clearColor)];
    [autoLogLabel setFont:[UIFont systemFontOfSize:11]];
    [autoLogLabel setTextColor:color(grayColor)];
    [autoLogLabel setText:@"自动登陆"];
    [self.contentView addSubview:autoLogLabel];
    
    UIButton *autoLogBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [autoLogBtn setBackgroundColor:color(clearColor)];
    [autoLogBtn setFrame:CGRectMake(autoLogImage.frame.origin.x, autoLogLabel.frame.origin.y - 10, controlXLength(autoLogLabel) - autoLogImage.frame.origin.x, autoLogLabel.frame.size.height + 20)];
    [autoLogBtn addTarget:self action:@selector(pressBtn:) forControlEvents:UIControlEventTouchUpInside];
    [autoLogBtn setTag:100];
    [self.contentView addSubview:autoLogBtn];
    
    UIButton *forgetPasswordBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [forgetPasswordBtn setFrame:CGRectMake(controlXLength(_passWord) - autoLogBtn.frame.size.width, autoLogBtn.frame.origin.y, autoLogBtn.frame.size.width, autoLogBtn.frame.size.height)];
    [forgetPasswordBtn setBackgroundColor:color(clearColor)];
    [forgetPasswordBtn.titleLabel setFont:[UIFont systemFontOfSize:11]];
    [forgetPasswordBtn.titleLabel setTextColor:color(grayColor)];
    [forgetPasswordBtn setTitle:@"忘记密码" forState:UIControlStateNormal];
    [forgetPasswordBtn setTitleColor:color(grayColor) forState:UIControlStateNormal];
    [forgetPasswordBtn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
    [forgetPasswordBtn addTarget:self action:@selector(pressBtn:) forControlEvents:UIControlEventTouchUpInside];
    [forgetPasswordBtn setTag:101];
    [self.contentView addSubview:forgetPasswordBtn];
    
    UIButton *doneBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [doneBtn setBackgroundColor:color(clearColor)];
    [doneBtn setTag:104];
    [doneBtn setFrame:CGRectMake(self.view.frame.size.width/6, controlYLength(autoLogBtn) + 10, self.view.frame.size.width * 2/3, 45)];
    [doneBtn setTitle:@"登陆" forState:UIControlStateNormal];
    [doneBtn setBackgroundImage:imageNameAndType(@"done_btn_normal", nil) forState:UIControlStateNormal];
    [doneBtn setBackgroundImage:imageNameAndType(@"done_btn_press", nil) forState:UIControlStateHighlighted];
    [doneBtn setBackgroundImage:imageNameAndType(@"done_btn_press", nil) forState:UIControlStateSelected];
    [doneBtn addTarget:self action:@selector(pressBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:doneBtn];
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
