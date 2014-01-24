//
//  ContactController.m
//  MiuTrip
//
//  Created by GX on 14-1-20.
//  Copyright (c) 2014年 michael. All rights reserved.
//

#import "ContactController.h"
#import "SavePassengerListRequest.h"

@interface ContactController(){
    UITextField *fieldName;
    UITextField *fieldMoviePhone;
    UITextField *fieldEmail;
    float height;

}

@end//新增联系人
@implementation ContactController


-(id)init{
    if (self = [super init]) {
        [self setSubviewFrame];
        
    }
    return self;
    
}
-(id)initWithParamss:(NSDictionary*)param{
    if (self = [super init]) {
        _param =param;
        [self setSubviewFrame];
        [self updatecontact];
    }
    return self;
}
- (void)setSubviewFrame
{
    [self setBackGroundImage:imageNameAndType(@"home_bg", nil)];
    if ([_param count]==0) {
        [self setTitle:@"新增联系人"];}
    else{
        [self setTitle:@"编辑联系人"];
    }
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
    [saveBtn addTarget:self action:@selector(saveBtn:) forControlEvents:UIControlEventTouchUpInside];
    [saveBtn setImage:imageNameAndType(@"cname_save_normal", nil) highlightImage:imageNameAndType(@"cname_save_press", nil) forState:ButtonImageStateBottom];
    [self.view addSubview:saveBtn];
    
    UIView *backGroundView =[[UIView alloc]initWithFrame:CGRectMake(10, self.topBar.frame.size.height+10, self.view.frame.size.width-20, (self.view.frame.size.height- self.topBar.frame.size.height-1.5*self.bottomBar.frame.size.height)/10*3)];
    [backGroundView setBackgroundColor:[UIColor whiteColor]];
    [backGroundView setBorderColor:[UIColor lightGrayColor] width:0.5];
    [self.contentView addSubview:backGroundView];
    
    UIView *lineOneView =[[UIView alloc]initWithFrame:CGRectMake(0, (self.view.frame.size.height- self.topBar.frame.size.height-1.5*self.bottomBar.frame.size.height)/10, self.view.frame.size.width-20,0.5)];
    [lineOneView setBorderColor:[UIColor lightGrayColor] width:0.5];
    [backGroundView addSubview:lineOneView];
    
    UIView *lineTwoView =[[UIView alloc]initWithFrame:CGRectMake(0, (self.view.frame.size.height- self.topBar.frame.size.height-1.5*self.bottomBar.frame.size.height)/10*2, self.view.frame.size.width-20,0.5)];
    [lineTwoView setBorderColor:[UIColor lightGrayColor] width:0.5];
    [backGroundView addSubview:lineTwoView];
    
    UIView *lineVerticalView =[[UIView alloc]initWithFrame:CGRectMake(backGroundView.frame.size.width/4, 0, 0.5, (self.view.frame.size.height- self.topBar.frame.size.height-1.5*self.bottomBar.frame.size.height)/10*3)];
    [lineVerticalView setBackgroundColor:[UIColor lightGrayColor]];
    [backGroundView addSubview:lineVerticalView];
    
    UILabel *Name =[[UILabel alloc]initWithFrame:CGRectMake(0, 2, backGroundView.frame.size.width/4*0.7, backGroundView.frame.size.height/3-4)];
    [Name setFont:[UIFont fontWithName:@"Arial" size:15]];
    [Name setText:@"姓名"];
    [Name setBackgroundColor:[UIColor clearColor]];
    [Name setTextAlignment:NSTextAlignmentRight];
    [backGroundView addSubview:Name];
    
    UILabel *XingName =[[UILabel alloc]initWithFrame:CGRectMake(backGroundView.frame.size.width/4*0.7, 6, backGroundView.frame.size.width*0.25*0.3, backGroundView.frame.size.height/3-6)];
    [XingName setFont:[UIFont fontWithName:@"Arial" size:15]];
    [XingName setText:@"*"];
    [XingName setBackgroundColor:[UIColor clearColor]];
    [XingName setTextColor:[UIColor redColor]];
    [backGroundView addSubview:XingName];
    UILabel *phoneLabel =[[UILabel alloc]initWithFrame:CGRectMake(0, backGroundView.frame.size.height/3+2, backGroundView.frame.size.width/4*0.7, backGroundView.frame.size.height/3-4)];
    [phoneLabel setFont:[UIFont fontWithName:@"Arial" size:15]];
    [phoneLabel setText:@"手机"];
    [phoneLabel setBackgroundColor:[UIColor clearColor]];
    [phoneLabel setTextAlignment:NSTextAlignmentRight];
    [backGroundView addSubview:phoneLabel];

    UILabel *emailLabel =[[UILabel alloc]initWithFrame:CGRectMake(0, backGroundView.frame.size.height/3*2+2, backGroundView.frame.size.width/4, backGroundView.frame.size.height/3-4)];
    [emailLabel setFont:[UIFont fontWithName:@"Arial" size:15]];
    [emailLabel setText:@"邮箱"];
    [emailLabel setBackgroundColor:[UIColor clearColor]];
    [emailLabel setTextAlignment:NSTextAlignmentCenter];
    [backGroundView addSubview:emailLabel];
//textfield
    fieldName = [[UITextField alloc]initWithFrame:CGRectMake(backGroundView.frame.size.width/4+4, 4, backGroundView.frame.size.width/4*3-8, backGroundView.frame.size.height/3-8)];
    [fieldName setDelegate:self];
    fieldName.clearButtonMode = UITextFieldViewModeWhileEditing;
    fieldName.autocapitalizationType = UITextAutocapitalizationTypeNone;
    fieldName.font =[UIFont fontWithName:@"Arial" size:20];
    [fieldName setBorderColor:[UIColor lightGrayColor] width:0.5];
    [fieldName becomeFirstResponder];
    [fieldName setTag:100];
    [backGroundView addSubview:fieldName];
    fieldMoviePhone = [[UITextField alloc]initWithFrame:CGRectMake(backGroundView.frame.size.width/4+4,backGroundView.frame.size.height/3+4, backGroundView.frame.size.width/4*3-8, backGroundView.frame.size.height/3-8)];
    fieldMoviePhone.clearButtonMode = UITextFieldViewModeWhileEditing;
    fieldMoviePhone.autocapitalizationType = UITextAutocapitalizationTypeNone;
    fieldMoviePhone.font =[UIFont fontWithName:@"Arial" size:20];
    fieldMoviePhone.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    [fieldMoviePhone setDelegate:self];
     [fieldMoviePhone setBorderColor:[UIColor lightGrayColor] width:0.5];
    [backGroundView addSubview:fieldMoviePhone];

    fieldEmail = [[UITextField alloc]initWithFrame:CGRectMake(backGroundView.frame.size.width/4+4,backGroundView.frame.size.height/3*2+4, backGroundView.frame.size.width/4*3-8, backGroundView.frame.size.height/3-8)];
    fieldEmail.clearButtonMode = UITextFieldViewModeWhileEditing;
    fieldEmail.autocapitalizationType = UITextAutocapitalizationTypeNone;
    fieldEmail.font =[UIFont fontWithName:@"Arial" size:20];
    fieldEmail.keyboardType = UIKeyboardTypeEmailAddress;
    [fieldEmail setDelegate:self];
     [fieldEmail setBorderColor:[UIColor lightGrayColor] width:0.5];
    [backGroundView addSubview:fieldEmail];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keboardWillshow:) name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillHide:) name:UIKeyboardDidHideNotification object:nil];
}
//常用联系人编辑后获得的数据
-(void)updatecontact{
    NSString *name =[_param objectForKey:@"UserName"];
    fieldName.text =name;
    NSString *moviephonenumber =[_param objectForKey:@"Mobilephone"];
    if ([moviephonenumber isKindOfClass:[NSNull class]]) {
        fieldMoviePhone.text =@"";
    }
    else{
        fieldMoviePhone.text=moviephonenumber;
    }
    NSString *email =[_param objectForKey:@"Email"];
    if ([email isKindOfClass:[NSNull class]]) {
        fieldEmail.text=@"";
    }
    else{
        fieldEmail.text =email;
    }
}


-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}
-(void)keboardWillshow:(NSNotification *)notification{
    NSDictionary *userInfo = [notification userInfo];
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    height = keyboardRect.size.height;
 self.bottomBar.frame=CGRectMake(0, self.view.frame.size.height-self.bottomBar.frame.size.height-height, self.view.frame.size.width, self.bottomBar.frame.size.height);
}
-(void)keyBoardWillHide:(NSNotification *)notification{
//    [[NSNotificationCenter defaultCenter] removeObserver:self];
    self.bottomBar.frame=CGRectMake(0, self.view.frame.size.height-self.bottomBar.frame.size.height, self.view.frame.size.width, self.bottomBar.frame.size.height);
}

-(void)saveBtn:(UIButton*)sender{
    
    if (![Utils isCina:fieldName.text]||[fieldName.text isEqualToString:@""]) {
        UIAlertView *fieldalert = [[UIAlertView alloc]initWithTitle:nil message:@"姓名为空或格式不匹配" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [fieldalert show];
        
        
        
    }
    else{
        if ([Utils isValidatePhoneNum:fieldMoviePhone.text]) {
            if ([Utils ismailbox:fieldEmail.text]) {
                [self send];
            }
            else{
                UIAlertView *fieldalert = [[UIAlertView alloc]initWithTitle:nil message:@"邮箱格式错误" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
                [fieldalert show];
            }
        }
        else{
            UIAlertView *fieldalert = [[UIAlertView alloc]initWithTitle:nil message:@"手机号码为空或格式错误" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [fieldalert show];
        }
    }
    
}
-(void)send{
    SavePassengerListRequest *request = [[SavePassengerListRequest alloc]initWidthBusinessType:BUSINESS_ACCOUNT methodName:@"SavePassengerList"];
    
    
    
    request.Passengers =[NSArray array];
    request.PassengerID =[NSNumber numberWithInt:0];
    
    request.CorpUID = @"";
    request.IsEmoloyee =[NSNumber numberWithInt:0];
    request.IsServer = [NSNumber numberWithInt:0];
    request.UserName=fieldName.text;
    request.LastName =@"";
    request.FirstName =@"";
    request.MiddleName =@"";
    request.Email = fieldEmail.text;
    request.Country =@"";
    request.Birthday =@"";
    request.IDCardlist = NULL;
    request.UID =@"";
    request.CardType =[NSNumber numberWithInt:0];
    request.CardNumber =@"";
    request.IsDefault = @"";
    request.Telephone =fieldMoviePhone.text;
    request.Fax = [NSNumber numberWithInt:0];
    request.ContactConfirmType=@"";
    request.Type =[NSNumber numberWithInt:1];
    
    
    [self.requestManager sendRequest:request];
}

/**
 *  请求成功
 *
 *  @param response
 */
-(void)requestDone:(BaseResponseModel *) response{
    if (response) {
        
        [self popViewControllerTransitionType:TransitionPush completionHandler:^{
            [self.contactDelegate saveContactsDone];}];
        
    }
    
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

@end


