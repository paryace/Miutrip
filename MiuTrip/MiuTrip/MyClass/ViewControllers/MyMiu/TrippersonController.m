//
//  TrippersonController.m
//  MiuTrip
//
//  Created by GX on 14-1-20.
//  Copyright (c) 2014年 michael. All rights reserved.
//

#import "TrippersonController.h"
#import "SqliteManager.h"
#import "SavePassengerListRequest.h"
#import "Nation.h"

@interface TrippersonController(){
    UIView *backGroundView;
    UITextField *fieldName;
    UITextField *fieldFirstName;
    UITextField *fieldMiddlerName;
    UITextField *fieldLastName;
    UITextField *fieldCertificateNumber;
    UITextField *fieldPhone;
    UITextField *fieldEmail;
    UILabel *labelcertificateType;
    UITableView *certificateTypeView;
    NSArray *certificatedata;
    UIButton *certificateButton;
    UILabel *strlabelcertificate;
    
    UILabel *nationlityLabel;
    UIButton *nationalityButton;
    UITableView *nationlityView;
    NSArray *nationlitydata;
    UILabel *strlabel;
    NSNumber *num;
  
    
    UILabel *dateOFbirthlabel;
    UIButton *dateOFbirthbutton;
    UIDatePicker *myPickerView;
    UIButton *pickerbutton;
    NSString *change;
    
    UIView *effectView;
    UIView *effectOtherView;
    UIViewController *effectBackgroundView;
    UIView *alphaView;
    float height;
    NSTimeInterval animationDuration;
    BOOL panduan;//0为新增1为编辑修改
}
@end//新增出行人
@implementation TrippersonController


-(id)initWithParams:(NSDictionary*)param{
    if (self = [super init]) {
        _param = [NSMutableDictionary dictionaryWithDictionary:param];
        
        [self setSubviewFrame];
        [self updatetrip];
        SqliteManager *sqliteModel =[[SqliteManager alloc]init];
        nationlitydata =[sqliteModel mappingNationInfo];
        panduan=1;
    }
    return self;
    
}

- (id)init
{
    if (self = [super init]) {
        [self setSubviewFrame];
        SqliteManager *sqliteModel =[[SqliteManager alloc]init];
        nationlitydata =[sqliteModel mappingNationInfo];
        panduan=0;
    }
    return self;
    
}

- (void)setSubviewFrame
{
    //游标
    //    UIView *fieldTag = [self.view viewWithTag:currEditingTextTag];
    
    
    
    
    [self setBackGroundImage:imageNameAndType(@"home_bg", nil)];
    if ([_param count]==0) {
        [self setTitle:@"新增出行人"];
    }
    else{
        [self setTitle:@"编辑出行人"];
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
    [saveBtn addTarget:self action:@selector(conmonsaveBtn:) forControlEvents:UIControlEventTouchUpInside];
    [saveBtn setImage:imageNameAndType(@"cname_save_normal", nil) highlightImage:imageNameAndType(@"cname_save_press", nil) forState:ButtonImageStateBottom];
    [self.view addSubview:saveBtn];
 
   backGroundView =[[UIView alloc]initWithFrame:CGRectMake(10, self.topBar.frame.size.height+10, self.view.frame.size.width-20, self.view.frame.size.height- self.topBar.frame.size.height-1.5*self.bottomBar.frame.size.height)];
    [backGroundView setBackgroundColor:[UIColor whiteColor]];
    [backGroundView setBorderColor:[UIColor lightGrayColor] width:0.5];
    [self.contentView addSubview:backGroundView];
    //线
    UIView *lineOneView =[[UIView alloc]initWithFrame:CGRectMake(0, backGroundView.frame.size.height/10, backGroundView.frame.size.width, 0.5)];
    [lineOneView setBackgroundColor:[UIColor lightGrayColor]];
    [backGroundView addSubview:lineOneView];
    
    UIView *lineTwoView =[[UIView alloc]initWithFrame:CGRectMake(0, 4*backGroundView.frame.size.height/10, backGroundView.frame.size.width, 0.5)];
    [lineTwoView setBackgroundColor:[UIColor lightGrayColor]];
    [backGroundView addSubview:lineTwoView];
    UIView *lineThreeView =[[UIView alloc]initWithFrame:CGRectMake(0, 5*backGroundView.frame.size.height/10, backGroundView.frame.size.width, 0.5)];
    [lineThreeView setBackgroundColor:[UIColor lightGrayColor]];
    [backGroundView addSubview:lineThreeView];
    UIView *lineFourView =[[UIView alloc]initWithFrame:CGRectMake(0, 6*backGroundView.frame.size.height/10, backGroundView.frame.size.width,0.5)];
    [lineFourView setBackgroundColor:[UIColor lightGrayColor]];
    [backGroundView addSubview:lineFourView];
    UIView *lineFiveView =[[UIView alloc]initWithFrame:CGRectMake(0,7*backGroundView.frame.size.height/10, backGroundView.frame.size.width, 0.5)];
    [lineFiveView setBackgroundColor:[UIColor lightGrayColor]];
    [backGroundView addSubview:lineFiveView];
    
    UIView *lineSixView =[[UIView alloc]initWithFrame:CGRectMake(0, 8*backGroundView.frame.size.height/10, backGroundView.frame.size.width, 0.5)];
    [lineSixView setBackgroundColor:[UIColor lightGrayColor]];
    [backGroundView addSubview:lineSixView];
    
    UIView *lineSevenView =[[UIView alloc]initWithFrame:CGRectMake(0, 9*backGroundView.frame.size.height/10, backGroundView.frame.size.width,0.5)];
    [lineSevenView setBackgroundColor:[UIColor lightGrayColor]];
    [backGroundView addSubview:lineSevenView];
    
    UIView *lineVertiaclView =[[UIView alloc]initWithFrame:CGRectMake(backGroundView.frame.size.width/4,0,0.5, backGroundView.frame.size.height)];
    [lineVertiaclView setBackgroundColor:[UIColor lightGrayColor]];
    [backGroundView addSubview:lineVertiaclView];
 //静态label
    UILabel *Name =[[UILabel alloc]initWithFrame:CGRectMake(0, 2, backGroundView.frame.size.width/4*0.7, backGroundView.frame.size.height/10-4)];
    [Name setFont:[UIFont fontWithName:@"Arial" size:15]];
    [Name setBackgroundColor:[UIColor clearColor]];
    [Name setText:@"姓名"];
    [Name setBorderColor:[UIColor whiteColor] width:0.1];
    [Name setTextAlignment:NSTextAlignmentRight];
    [backGroundView addSubview:Name];
    
    UILabel *XingName =[[UILabel alloc]initWithFrame:CGRectMake(backGroundView.frame.size.width/4*0.7, 6, backGroundView.frame.size.width*0.25*0.3, backGroundView.frame.size.height/10-6)];
    [XingName setFont:[UIFont fontWithName:@"Arial" size:15]];
    [XingName setText:@"*"];
    [XingName setBackgroundColor:[UIColor clearColor]];
    [XingName setTextColor:[UIColor redColor]];
    [backGroundView addSubview:XingName];
    
    UILabel *englishName =[[UILabel alloc]initWithFrame:CGRectMake(0, 2*backGroundView.frame.size.height/10+2, backGroundView.frame.size.width/4, backGroundView.frame.size.height/10-4)];
    [englishName setText:@"英文姓名"];
    [englishName setFont:[UIFont fontWithName:@"Arial" size:15]];
    [englishName setTextAlignment:NSTextAlignmentCenter];
    [englishName setBackgroundColor:[UIColor clearColor]];
    [backGroundView addSubview:englishName];
    
    UILabel *nationLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, backGroundView.frame.size.height/10*4+2, backGroundView.frame.size.width/4, backGroundView.frame.size.height/10-4)];
    [nationLabel setText:@"国  籍"];
    [nationLabel setFont:[UIFont fontWithName:@"Arial" size:15]];
    [nationLabel setTextAlignment:NSTextAlignmentCenter];
    [nationLabel setBackgroundColor:[UIColor clearColor]];
    [backGroundView addSubview:nationLabel];
    
    UILabel *birthDateLabel =[[UILabel alloc]initWithFrame:CGRectMake(0, backGroundView.frame.size.height/10*5+2, backGroundView.frame.size.width/4*0.85, backGroundView.frame.size.height/10-4)];
    [birthDateLabel setText:@"出生日期"];
    [birthDateLabel setBackgroundColor:[UIColor clearColor]];
    [birthDateLabel setFont:[UIFont fontWithName:@"Arial" size:15]];

    [backGroundView addSubview:birthDateLabel];
    UILabel *birthDateXing =[[UILabel alloc]initWithFrame:CGRectMake(backGroundView.frame.size.width/4*0.85, backGroundView.frame.size.height/10*5+6, backGroundView.frame.size.width/4*0.15,  backGroundView.frame.size.height/10-6)];
    [birthDateLabel setTextAlignment:NSTextAlignmentRight];
    [birthDateXing setText:@"*"];
    [birthDateXing setFont:[UIFont fontWithName:@"Arial" size:15]];
    [birthDateXing setTextColor:[UIColor redColor]];
    [birthDateXing setTextColor:[UIColor redColor]];
    [birthDateXing setBackgroundColor:[UIColor clearColor]];
    [backGroundView addSubview:birthDateXing];
    
    UILabel *certificateTypeLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, backGroundView.frame.size.height/10*6+2, backGroundView.frame.size.width/4*0.85, backGroundView.frame.size.height/10-4)];
    [certificateTypeLabel setText:@"证件类型"];
    [certificateTypeLabel setTextAlignment:NSTextAlignmentRight];
    [certificateTypeLabel setBackgroundColor:[UIColor clearColor]];
    [certificateTypeLabel setFont:[UIFont fontWithName:@"Arial" size:15]];
    [backGroundView addSubview:certificateTypeLabel];
    
    UILabel *certificateTypeXing =[[UILabel alloc]initWithFrame:CGRectMake(backGroundView.frame.size.width/4*0.85, backGroundView.frame.size.height/10*6+6, backGroundView.frame.size.width/4*0.15,  backGroundView.frame.size.height/10-6)];
    [certificateTypeXing setText:@"*"];
    [certificateTypeXing setFont:[UIFont fontWithName:@"Arial" size:15]];
    [certificateTypeXing setTextColor:[UIColor redColor]];
    [certificateTypeXing setBackgroundColor:[UIColor clearColor]];
    [backGroundView addSubview:certificateTypeXing];
    
    UILabel *certificateTypeNumber =[[UILabel alloc]initWithFrame:CGRectMake(0, backGroundView.frame.size.height/10*7+2, backGroundView.frame.size.width/4*0.85, backGroundView.frame.size.height/10-4)];
    [certificateTypeNumber setText:@"证件号码"];
    [certificateTypeNumber setTextAlignment:NSTextAlignmentRight];
    [certificateTypeNumber setBackgroundColor:[UIColor clearColor]];
    [certificateTypeNumber setFont:[UIFont fontWithName:@"Arial" size:15]];
    [backGroundView addSubview:certificateTypeNumber];
    
    UILabel *certificateTypeNumberXing =[[UILabel alloc]initWithFrame:CGRectMake(backGroundView.frame.size.width/4*0.85, backGroundView.frame.size.height/10*7+6, backGroundView.frame.size.width/4*0.15, backGroundView.frame.size.height/10-6)];
    [certificateTypeNumberXing setText:@"*"];
    [certificateTypeNumberXing setTextColor:[UIColor redColor]];
    [certificateTypeNumberXing setBackgroundColor:[UIColor clearColor]];
    [certificateTypeNumberXing setFont:[UIFont fontWithName:@"Arial" size:15]];
    [backGroundView addSubview:certificateTypeNumberXing];
    
    UILabel *phoneLanbel =[[UILabel alloc]initWithFrame:CGRectMake(0, backGroundView.frame.size.height/10*8+2, backGroundView.frame.size.width/4, backGroundView.frame.size.height/10-4)];
    [phoneLanbel setText:@"手  机"];
    [phoneLanbel setBackgroundColor:[UIColor clearColor]];
    [phoneLanbel setTextAlignment:NSTextAlignmentCenter];
    [phoneLanbel setFont:[UIFont fontWithName:@"Arial" size:15]];
    [backGroundView addSubview:phoneLanbel];
    
    UILabel *emailLabel =[[UILabel alloc]initWithFrame:CGRectMake(0, backGroundView.frame.size.height/10*9+2, backGroundView.frame.size.width/4, backGroundView.frame.size.height/10-4)];
    [emailLabel setText:@"邮  箱"];
    [emailLabel setBackgroundColor:[UIColor clearColor]];
    [emailLabel setTextAlignment:NSTextAlignmentCenter];
    [emailLabel setFont:[UIFont fontWithName:@"Arial" size:15]];
    [backGroundView addSubview:emailLabel];
//textfield
    fieldName=[[UITextField alloc]initWithFrame:CGRectMake(backGroundView.frame.size.width/4+4, 4, backGroundView.frame.size.width/4*3-8, backGroundView.frame.size.height/10-8)];
    [fieldName setBorderColor:[UIColor lightGrayColor] width:0.5];
    fieldName.clearButtonMode = UITextFieldViewModeWhileEditing;//一键清除
    [fieldName becomeFirstResponder];
    [fieldName setTag:100];
    fieldName.font=[UIFont fontWithName:@"Arial" size:20];
    [fieldName setDelegate:self];
    [backGroundView addSubview:fieldName];
    fieldFirstName =[[UITextField alloc]initWithFrame:CGRectMake(backGroundView.frame.size.width/4+4,backGroundView.frame.size.height/10+4, backGroundView.frame.size.width/4*3-8, backGroundView.frame.size.height/10-8)];
    [fieldFirstName setBorderColor:[UIColor lightGrayColor] width:0.5];
    fieldFirstName.clearButtonMode = UITextFieldViewModeWhileEditing;//一键清除
    [fieldFirstName becomeFirstResponder];
    [fieldFirstName setTag:101];
    fieldFirstName.font=[UIFont fontWithName:@"Arial" size:20];
    [fieldFirstName setDelegate:self];
    [backGroundView addSubview:fieldFirstName];

    fieldMiddlerName=[[UITextField alloc]initWithFrame:CGRectMake(backGroundView.frame.size.width/4+4,backGroundView.frame.size.height/10*2+4, backGroundView.frame.size.width/4*3-8, backGroundView.frame.size.height/10-8)];
    [fieldMiddlerName setBorderColor:[UIColor lightGrayColor] width:0.5];
    fieldMiddlerName.clearButtonMode = UITextFieldViewModeWhileEditing;//一键清除
    [fieldMiddlerName becomeFirstResponder];
    [fieldMiddlerName setTag:102];
    fieldMiddlerName.font=[UIFont fontWithName:@"Arial" size:20];
    [fieldMiddlerName setDelegate:self];
    [backGroundView addSubview:fieldMiddlerName];
    fieldLastName =[[UITextField alloc]initWithFrame:CGRectMake(backGroundView.frame.size.width/4+4,backGroundView.frame.size.height/10*3+4, backGroundView.frame.size.width/4*3-8, backGroundView.frame.size.height/10-8)];
    [fieldLastName setBorderColor:[UIColor lightGrayColor] width:0.5];
    fieldLastName.clearButtonMode = UITextFieldViewModeWhileEditing;//一键清除
    [fieldLastName becomeFirstResponder];
    [fieldLastName setTag:103];
    fieldLastName.font=[UIFont fontWithName:@"Arial" size:20];
    [fieldLastName setDelegate:self];
    [backGroundView addSubview:fieldLastName];


    fieldCertificateNumber =[[UITextField alloc]initWithFrame:CGRectMake(backGroundView.frame.size.width/4+4,backGroundView.frame.size.height/10*7+4, backGroundView.frame.size.width/4*3-8, backGroundView.frame.size.height/10-8)];
    [fieldCertificateNumber setBorderColor:[UIColor lightGrayColor] width:0.5];
    fieldCertificateNumber.clearButtonMode = UITextFieldViewModeWhileEditing;//一键清除
    [fieldCertificateNumber becomeFirstResponder];
    [fieldCertificateNumber setTag:104];
    fieldCertificateNumber.keyboardType=UIKeyboardTypeNumbersAndPunctuation;
    fieldCertificateNumber.font=[UIFont fontWithName:@"Arial" size:20];
    [fieldCertificateNumber setDelegate:self];
    [backGroundView addSubview:fieldCertificateNumber];
    fieldPhone =[[UITextField alloc]initWithFrame:CGRectMake(backGroundView.frame.size.width/4+4,backGroundView.frame.size.height/10*8+5, backGroundView.frame.size.width/4*3-8, backGroundView.frame.size.height/10-8)];
    [fieldPhone setBorderColor:[UIColor lightGrayColor] width:0.5];
    fieldPhone.clearButtonMode = UITextFieldViewModeWhileEditing;//一键清除
    [fieldPhone becomeFirstResponder];
    [fieldPhone setTag:105];
    fieldPhone.keyboardType=UIKeyboardTypeNumbersAndPunctuation;
    fieldPhone.font=[UIFont fontWithName:@"Arial" size:20];
    [fieldPhone setDelegate:self];
    [backGroundView addSubview:fieldPhone];
    
     fieldEmail=[[UITextField alloc]initWithFrame:CGRectMake(backGroundView.frame.size.width/4+4,backGroundView.frame.size.height/10*9+4, backGroundView.frame.size.width/4*3-8, backGroundView.frame.size.height/10-8)];
    [fieldEmail setBorderColor:[UIColor lightGrayColor] width:0.5];
    fieldEmail.clearButtonMode = UITextFieldViewModeWhileEditing;//一键清除
    [fieldEmail becomeFirstResponder];
    [fieldEmail setTag:106];
    fieldEmail.font=[UIFont fontWithName:@"Arial" size:20];
    [fieldEmail setDelegate:self];
    fieldEmail.keyboardType=UIKeyboardTypeEmailAddress;
    [backGroundView addSubview:fieldEmail];
//tableView标题
    effectView =[[UIView alloc]initWithFrame:CGRectMake(30,self.topBar.frame.size.height-20,self.view.frame.size.width-60,40)];
    [effectView setBackgroundColor:[UIColor blackColor]];
    UILabel *nationTitleLabel =[[UILabel alloc]initWithFrame:CGRectMake(0, 0, effectView.frame.size.width, 40)];
    nationTitleLabel.text=@"选择国籍";
    [nationTitleLabel setBackgroundColor:color(clearColor)];
    [nationTitleLabel setFont:[UIFont fontWithName:@"Arial" size:25]];
    nationTitleLabel.textColor=[UIColor whiteColor];
    [effectView addSubview:nationTitleLabel];
    
    effectOtherView =[[UIView alloc]initWithFrame:CGRectMake(30,self.view.frame.size.height/3-40,self.view.frame.size.width-60,40)];
    [effectOtherView setBackgroundColor:[UIColor blackColor]];
    UILabel *certificateTitleLabel =[[UILabel alloc]initWithFrame:CGRectMake(0, 0, effectOtherView.frame.size.width, 40)];
    [certificateTitleLabel setText:@"证件类型"];
    [certificateTitleLabel setBackgroundColor:color(clearColor)];
    [certificateTitleLabel setFont:[UIFont fontWithName:@"Arial" size:25]];
    certificateTitleLabel.textColor =[UIColor whiteColor];
    [effectOtherView addSubview:certificateTitleLabel];
//半透明罩
    
    effectBackgroundView =[[UIViewController alloc]init];
    if (deviceVersion<7.0) {
        alphaView =[[UIView alloc]initWithFrame:CGRectMake(0, -20, effectBackgroundView.view.frame.size.width, effectBackgroundView.view.frame.size.height)];
    }
    else{
        alphaView =[[UIView alloc]initWithFrame:CGRectMake(0, 0, effectBackgroundView.view.frame.size.width, effectBackgroundView.view.frame.size.height)];
    }
      [alphaView setBackgroundColor:[UIColor blackColor]];
    [alphaView setAlpha:0.35];
  
    
//国籍
    nationlityLabel =[[UILabel alloc]initWithFrame:CGRectMake(backGroundView.frame.size.width/4+4, backGroundView.frame.size.height/10*4+2, backGroundView.frame.size.width/4*3*0.7, backGroundView.frame.size.height/10-4)];
    [nationlityLabel setAutoSize:YES];
    [nationlityLabel setBackgroundColor:[UIColor clearColor]];
     nationlityLabel.text=@"中国大陆";

     [backGroundView addSubview:nationlityLabel];
    nationalityButton =[[UIButton alloc]initWithFrame:CGRectMake(backGroundView.frame.size.width/4+backGroundView.frame.size.width/4*3*0.7, backGroundView.frame.size.height/10*4+2, backGroundView.frame.size.width/4*3*0.3, backGroundView.frame.size.height/10-4)];
    [nationalityButton setBackgroundImage:[UIImage imageNamed:@"cname_item_select"] forState:UIControlStateNormal];
    [nationalityButton addTarget:self action:@selector(nationalitybutton:) forControlEvents:UIControlEventTouchUpInside];
    [backGroundView addSubview:nationalityButton];
    nationlityView=[[UITableView alloc]initWithFrame:CGRectMake(30,self.topBar.frame.size.height+20,self.view.frame.size.width-60,backGroundView.frame.size.height)];
        nationlityView.separatorStyle=UITableViewCellSeparatorStyleNone;
        nationlityView.bounces=NO;
    [nationlityView setTag:1001];
        [nationlityView setDelegate:self];
        [nationlityView setDataSource:self];
        //国籍数据
        SqliteManager *nationarray =[[SqliteManager alloc]init];
        nationlitydata=[nationarray mappingNationInfo];
    
        //日期选择器
      dateOFbirthlabel = [[UILabel alloc]initWithFrame:CGRectMake(backGroundView.frame.size.width/4+4, backGroundView.frame.size.height/10*5+2, backGroundView.frame.size.width/4*3*0.7, backGroundView.frame.size.height/10-4)];
       [dateOFbirthlabel setBackgroundColor:[UIColor clearColor]];
        [backGroundView addSubview:dateOFbirthlabel];
    
       dateOFbirthbutton=[[UIButton alloc]initWithFrame:CGRectMake(backGroundView.frame.size.width/4+backGroundView.frame.size.width/4*3*0.7, backGroundView.frame.size.height/10*5+2, backGroundView.frame.size.width/4*3*0.3, backGroundView.frame.size.height/10-4)];
        [dateOFbirthbutton setBackgroundImage:[UIImage imageNamed:@"cname_item_select"] forState:UIControlStateNormal];
       [dateOFbirthbutton addTarget:self action:@selector(dateOFbirthbutton:) forControlEvents:UIControlEventTouchUpInside];
        [backGroundView addSubview:dateOFbirthbutton];
    
    pickerbutton = [[UIButton alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height-260, self.view.frame.size.width, self.topBar.frame.size.height)];
    pickerbutton.backgroundColor = [UIColor blackColor];
    [pickerbutton setTitle:@"确认" forState:UIControlStateNormal];
    pickerbutton.titleLabel.font =[UIFont fontWithName:@"Arial" size:25];
    [pickerbutton addTarget:self action:@selector(pickerbutton:) forControlEvents:UIControlEventTouchUpInside];
        myPickerView=[[UIDatePicker alloc]initWithFrame:CGRectMake(0,self.view.frame.size.height-260+self.bottomBar.frame.size.height+10 ,self.view.frame.size.width, 260)];
       myPickerView.datePickerMode =UIDatePickerModeDate;
    [myPickerView setBackgroundColor:[UIColor whiteColor]];
        //日期选择器时间范围
        myPickerView.maximumDate =[[NSDate alloc]initWithTimeIntervalSinceNow:0];
   
    //label and button and View for certificate  证件类型
   labelcertificateType = [[UILabel alloc]initWithFrame:CGRectMake(backGroundView.frame.size.width/4+4, backGroundView.frame.size.height/10*6, backGroundView.frame.size.width/4*3*0.7, backGroundView.frame.size.height/10)];
    [labelcertificateType setBackgroundColor:[UIColor clearColor]];
    [backGroundView addSubview:labelcertificateType];
    
    
   certificateButton=[[UIButton alloc]initWithFrame:CGRectMake(backGroundView.frame.size.width/4+backGroundView.frame.size.width/4*3*0.7, backGroundView.frame.size.height/10*6+2, backGroundView.frame.size.width/4*3*0.3, backGroundView.frame.size.height/10-4)];
    [certificateButton setBackgroundImage:[UIImage imageNamed:@"cname_item_select"] forState:UIControlStateNormal];
    [certificateButton addTarget:self action:@selector(certificateButton:) forControlEvents:UIControlEventTouchUpInside];
    [backGroundView addSubview:certificateButton];

    certificateTypeView =[[UITableView alloc]initWithFrame:CGRectMake(30,effectBackgroundView.view.frame.size.height/3,self.view.frame.size.width-60,5*self.topBar.frame.size.height)];
    certificateTypeView.separatorStyle=UITableViewCellSeparatorStyleNone;
        certificateTypeView.showsVerticalScrollIndicator=NO;
    certificateTypeView.bounces=NO;
    [certificateTypeView setTag:1000];
    [certificateTypeView setDelegate:self];
    [certificateTypeView setDataSource:self];
    certificatedata=[[NSArray alloc]initWithObjects:@"身份证",@"护照",@"军官证",@"回乡证",@"港澳通行证",@"台胞证",@"其他", nil];
    [nationlityView setDataSource:self];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keboardWillshow:) name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillHide:) name:UIKeyboardDidHideNotification object:nil];
}
//编辑后界面显示数据的方法
-(void)updatetrip{
    fieldName.text = [_param objectForKey:@"UserName"];
    NSString *firstname =[_param objectForKey:@"FirstName"];
    if ([firstname isKindOfClass:[NSNull class]]) {
        fieldFirstName.text =@"";
    }
    else {
        fieldFirstName.text =firstname;
    }
    NSString *middlename =[_param objectForKey:@"MiddleName"];
    if ([middlename isKindOfClass:[NSNull class]]) {
        fieldMiddlerName.text =@"";
    }
    else{
        fieldMiddlerName.text =middlename;
    }
    NSString *lastname =[_param objectForKey:@"LastName"];
    if ([lastname isKindOfClass:[NSNull class]]) {
        fieldLastName.text =@"";
    }
    else{
        fieldLastName.text =lastname;
    }
    NSString *nation =[_param objectForKey:@"Country"];
    if ([nation isKindOfClass:[NSNull class]]) {
        nationlityLabel.text =@"中国大陆";
    }
    else{
        NSString *countryName = nil;
       
        for (Nation *nation in [[SqliteManager shareSqliteManager] mappingNationInfo]) {
            if ([nation.abb_name isEqualToString:[_param objectForKey:@"Country"]]) {
                countryName = [nation china_name];
                continue;
            }
        }
       nationlityLabel.text =countryName;
        
    }
    
    NSString *dateOFbirth =[_param objectForKey:@"Birthday"];
    if ([dateOFbirth isKindOfClass:[NSNull class]]) {
        dateOFbirthlabel.text =@"1980-01-01";
    }
    else{
      
        dateOFbirthlabel.text =dateOFbirth;
    }
    
    //证件类型解析
    NSArray *array= [_param objectForKey:@"IDCardList"];
    if ([array count]==0) {
        labelcertificateType.text =@"身份证";
        fieldCertificateNumber.text = @"";
    }
    else{
        NSDictionary *dicc =[array objectAtIndex:0];
        NSNumber *cardtype =[dicc objectForKey:@"CardType"];
        NSString *cardtypestring =[[NSString alloc]init];
        cardtypestring =[cardtype stringValue];
        if ([cardtypestring isEqual:@"0"]) {
            labelcertificateType.text=@"身份证";
        }
        if ([cardtypestring isEqual:@"1"]) {
            labelcertificateType.text =@"护照";
        }
        if ([cardtypestring isEqual:@"2"]) {
            labelcertificateType.text =@"军官证";
        }
        if ([cardtypestring isEqual:@"3"]) {
            labelcertificateType.text=@"回乡证";
        }
        if ([cardtypestring isEqual:@"4"]) {
            labelcertificateType.text = @"港澳通行证";
        }
        if ([cardtypestring isEqual:@"5"]) {
            labelcertificateType.text =@"台胞证";
        }
        if ([cardtypestring isEqual:@"9"]) {
            labelcertificateType.text=@"其他";
        }
        
        NSString *cardnumber =[dicc objectForKey:@"CardNumber"];
        if ([cardnumber isKindOfClass:[NSNull class]] ) {
            fieldCertificateNumber.text = @"";
        }
        else{
            fieldCertificateNumber.text=cardnumber;
        }
        
    }
    NSString *phonenumber =[_param objectForKey:@"Mobilephone"];
    if ([phonenumber isKindOfClass:[NSNull class]]) {
        fieldPhone.text =@"";
    }
    else{
        fieldPhone.text =phonenumber;
    }
    NSString *mailbox =[_param objectForKey:@"Email"];
    if ([mailbox isKindOfClass:[NSNull class]]) {
        fieldEmail.text=@"";
    }
    else{
        fieldEmail.text =mailbox;
    }
}

//界面恢复和键盘关闭
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
   

    [textField resignFirstResponder];
   
    return YES;
}

-(void)keboardWillshow:(NSNotification *)notification{
    NSDictionary *userInfo = [notification userInfo];
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    height = keyboardRect.size.height;
    animationDuration = [[[notification userInfo] valueForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    UITextField *responder = nil;
    if ([fieldName isFirstResponder]) {
        responder=fieldName;
    }else if ([fieldFirstName isFirstResponder]){
        responder=fieldFirstName;
    }else if ([fieldMiddlerName isFirstResponder]){
        responder=fieldMiddlerName;
    }else if ([fieldLastName isFirstResponder]){
        responder =fieldLastName;
    }else if ([fieldCertificateNumber isFirstResponder]){
        responder=fieldCertificateNumber;
    }else if ([fieldPhone isFirstResponder]){
        responder=fieldCertificateNumber;
    }else if ([fieldEmail isFirstResponder]){
        responder=fieldEmail;
    }
           self.bottomBar.frame=CGRectMake(0, self.view.frame.size.height-self.bottomBar.frame.size.height-height, self.view.frame.size.width, self.bottomBar.frame.size.height);
  

    if (responder==fieldCertificateNumber||responder==fieldPhone||responder==fieldEmail) {
            [UIView animateWithDuration:animationDuration animations:^{
                backGroundView.frame=CGRectMake(10, self.topBar.frame.size.height+10-height, self.view.frame.size.width-20, self.view.frame.size.height- self.topBar.frame.size.height-1.5*self.bottomBar.frame.size.height);
            } completion:^(BOOL finished){
        
            }];
    }
    
    
      }
-(void)keyBoardWillHide:(NSNotification *)notification{
   
        self.bottomBar.frame=CGRectMake(0, self.view.frame.size.height-self.bottomBar.frame.size.height, self.view.frame.size.width, self.bottomBar.frame.size.height);

        [UIView animateWithDuration:animationDuration animations:^{
            backGroundView.frame=CGRectMake(10, self.topBar.frame.size.height+10, self.view.frame.size.width-20, self.view.frame.size.height- self.topBar.frame.size.height-1.5*self.bottomBar.frame.size.height);
        } completion:^(BOOL finished){
    
        }];
//    [[NSNotificationCenter defaultCenter] removeObserver:self];

}

- (void)certificateButton:(UIButton*)sender
{   [effectBackgroundView.view addSubview:alphaView];
    [effectBackgroundView.view addSubview:effectOtherView];
    [effectBackgroundView.view addSubview:certificateTypeView];
    [self.view addSubview:effectBackgroundView.view];
}
- (void)nationalitybutton:(UIButton*)sender
{   [effectBackgroundView.view addSubview:alphaView];
    [effectBackgroundView.view addSubview:effectView];
    [effectBackgroundView.view addSubview:nationlityView];
    [self.view addSubview:effectBackgroundView.view];

}
- (void)dateOFbirthbutton:(UIButton*)sender
{
    [effectBackgroundView.view addSubview:alphaView];
    [effectBackgroundView.view addSubview:pickerbutton];
    [effectBackgroundView.view addSubview:myPickerView];
    [self.view addSubview:effectBackgroundView.view];
}

- (void)pickerbutton:(UIButton*)sender
{
    [pickerbutton removeFromSuperview];
    [myPickerView removeFromSuperview];
    [alphaView removeFromSuperview];
    [effectBackgroundView.view removeFromSuperview];
    NSDate *theDate = myPickerView.date;
    
    NSDateFormatter *dateFormatter =[[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"YYYY-MM-dd"];
    dateOFbirthlabel.text =[dateFormatter stringFromDate:theDate];
}



- (void)conmonsaveBtn:(UIButton*)sender{
    
    [self limit];
    
}
//限制
-(void)limit{
    if (![Utils isCina:fieldName.text]||(fieldName.text==nil)||[fieldName.text isEqualToString:@""]||[fieldName.text isKindOfClass:[NSNull class]]) {
        UIAlertView *fieldalert = [[UIAlertView alloc]initWithTitle:nil message:@"姓名为空或格式不匹配" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [fieldalert show];
    }
    else{
        if ([Utils isEnglish:fieldFirstName.text]||(fieldFirstName.text==nil)||([fieldFirstName.text isEqualToString:@""])||([fieldFirstName.text isKindOfClass:[NSNull class]])) {
            if ([Utils isEnglish:fieldMiddlerName.text]||(fieldMiddlerName.text==nil)||([fieldMiddlerName.text isEqualToString:@""])||([fieldMiddlerName.text isKindOfClass:[NSNull class]])) {
                if ([Utils isEnglish:fieldLastName.text]||(fieldLastName.text==nil)||([fieldLastName.text isEqualToString:@""])||([fieldLastName.text isKindOfClass:[NSNull class]])){
                    if (dateOFbirthlabel.text ==nil||[dateOFbirthlabel.text isEqualToString:@""]||[dateOFbirthlabel isKindOfClass:[NSNull class]]) {
                        UIAlertView *labelalert = [[UIAlertView alloc]initWithTitle:nil message:@"出生日期不能为空,请选择日期" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
                        [labelalert show];
                    }
                    else{
                        if (labelcertificateType.text==nil||[labelcertificateType.text isEqualToString:@""]||[labelcertificateType isKindOfClass:[NSNull class]]) {
                            UIAlertView *labelalert = [[UIAlertView alloc]initWithTitle:nil message:@"证件类型不能为空,请选择证件类型" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
                            [labelalert show];
                        }
                        else{
                            //身份证判定
                            if ([labelcertificateType.text isEqualToString:@"身份证"]) {
                                if ([nationlityLabel.text isEqualToString:@"中国大陆"]||[nationlityLabel.text isEqualToString:@"中国香港"]||[nationlityLabel.text isEqualToString:@"中国澳门"]) {
                                    if (![Utils isValidateIdNum:fieldCertificateNumber.text]) {
                                        UIAlertView *fieldalert = [[UIAlertView alloc]initWithTitle:nil message:@"身份证号码为空或格式不匹配" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
                                        
                                        [fieldalert show];
                                    }
                                    else{
                                        
                                        
                                        
                                        if (![Utils isValidatePhoneNum:fieldPhone.text]) {
                                            UIAlertView *fieldalert = [[UIAlertView alloc]initWithTitle:nil message:@"手机号码格式错误" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
                                            [fieldalert show];
                                        }
                                        else{
                                            if (![Utils ismailbox:fieldEmail.text]) {
                                                UIAlertView *fieldalert = [[UIAlertView alloc]initWithTitle:nil message:@"邮箱格式错误" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
                                                [fieldalert show];
                                            }
                                            else{
                                                [self getpassenger];
                                            }
                                            
                                        }
                                    }
                                }
                                else{
                                    UIAlertView *fieldalert = [[UIAlertView alloc]initWithTitle:nil message:@"国籍与证件类型不匹配" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
                                    [fieldalert show];
                                }
                            }
                            
                            
                            //护照判定
                            if ([labelcertificateType.text isEqualToString:@"护照"]) {
                                if (fieldCertificateNumber.text.length>14||fieldCertificateNumber.text==nil||[fieldCertificateNumber.text isEqualToString:@""]){
                                    UIAlertView *fieldalert = [[UIAlertView alloc]initWithTitle:nil message:@"护照号码为空或格式不匹配（不得超过14位字符或数组）" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
                                    [fieldalert show];
                                    
                                }
                                
                                else{
                                    if (![Utils isValidatePhoneNum:fieldPhone.text]) {
                                        UIAlertView *fieldalert = [[UIAlertView alloc]initWithTitle:nil message:@"手机号码格式错误" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
                                        [fieldalert show];
                                    }
                                    else{
                                        if (![Utils ismailbox:fieldEmail.text]) {
                                            UIAlertView *fieldalert = [[UIAlertView alloc]initWithTitle:nil message:@"邮箱格式错误" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
                                            [fieldalert show];
                                        }
                                        else{
                                            [self getpassenger];
                                        }
                                        
                                    }
                                }
                                
                            }
                            
                            //军官张判定
                            if ([labelcertificateType.text isEqualToString:@"军官证"]) {
                                if ([nationlityLabel.text isEqualToString:@"中国大陆"]) {
                                    if ([Utils isnumberandenglish:fieldCertificateNumber.text]) {
                                        if (![Utils isValidatePhoneNum:fieldPhone.text]) {
                                            UIAlertView *fieldalert = [[UIAlertView alloc]initWithTitle:nil message:@"手机号码格式错误" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
                                            [fieldalert show];
                                        }
                                        else{
                                            if (![Utils ismailbox:fieldEmail.text]) {
                                                UIAlertView *fieldalert = [[UIAlertView alloc]initWithTitle:nil message:@"邮箱格式错误" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
                                                [fieldalert show];
                                            }
                                            else{
                                                [self getpassenger];
                                            }
                                            
                                        }
                                        
                                    }
                                    else{
                                        UIAlertView *fieldalert = [[UIAlertView alloc]initWithTitle:nil message:@"军官证号码为空或格式不匹配(只能输入数字和英文字母)" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
                                        [fieldalert show];
                                    }
                                    
                                }
                                else{
                                    UIAlertView *fieldalert = [[UIAlertView alloc]initWithTitle:nil message:@"国籍与证件类型不匹配" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
                                    [fieldalert show];
                                    
                                }
                                
                            }
                            //回乡证判
                            if ([labelcertificateType.text isEqualToString:@"回乡证"]) {
                                if ([nationlityLabel.text isEqualToString:@"中国台湾"]) {
                                    if ([Utils isnumberandenglish:fieldCertificateNumber.text]) {
                                        if ([Utils isnumberandenglish:fieldCertificateNumber.text]) {
                                            if (![Utils isValidatePhoneNum:fieldPhone.text]) {
                                                UIAlertView *fieldalert = [[UIAlertView alloc]initWithTitle:nil message:@"手机号码格式错误" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
                                                [fieldalert show];
                                            }
                                            else{
                                                if (![Utils ismailbox:fieldEmail.text]) {
                                                    UIAlertView *fieldalert = [[UIAlertView alloc]initWithTitle:nil message:@"邮箱格式错误" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
                                                    [fieldalert show];
                                                }
                                                else{
                                                    [self getpassenger];
                                                }
                                                
                                            }
                                            
                                        }
                                        
                                    }
                                    else{
                                        UIAlertView *fieldalert = [[UIAlertView alloc]initWithTitle:nil message:@"回乡证号码为空或格式不匹配(只能输入数字或英文字母)" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
                                        [fieldalert show];
                                    }
                                }
                                else{
                                    UIAlertView *fieldalert = [[UIAlertView alloc]initWithTitle:nil message:@"国籍与证件类型不匹配" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
                                    [fieldalert show];
                                }
                            }
                            //港澳通行证判定
                            if ([labelcertificateType.text isEqualToString:@"港澳通行证"]) {
                                if ([nationlityLabel.text isEqualToString:@"中国香港"]||[nationlityLabel.text isEqualToString:@"中国澳门"]) {
                                    if ([Utils isnumberandenglish:fieldCertificateNumber.text]) {
                                        if ([Utils isnumberandenglish:fieldCertificateNumber.text]) {
                                            if (![Utils isValidatePhoneNum:fieldPhone.text]) {
                                                UIAlertView *fieldalert = [[UIAlertView alloc]initWithTitle:nil message:@"手机号码格式错误" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
                                                [fieldalert show];
                                            }
                                            else{
                                                if (![Utils ismailbox:fieldEmail.text]) {
                                                    UIAlertView *fieldalert = [[UIAlertView alloc]initWithTitle:nil message:@"邮箱格式错误" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
                                                    [fieldalert show];
                                                }
                                                else{
                                                    [self getpassenger];
                                                }
                                                
                                            }
                                            
                                        }
                                        
                                    }
                                    else{
                                        UIAlertView *fieldalert = [[UIAlertView alloc]initWithTitle:nil message:@"港澳通行证号码为空或格式不匹配(只能输入数字或英文字母)" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
                                        [fieldalert show];
                                    }
                                }
                                else{
                                    UIAlertView *fieldalert = [[UIAlertView alloc]initWithTitle:nil message:@"国籍与证件类型不匹配" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
                                    [fieldalert show];
                                }
                            }
                            //台胞证件判定
                            if ([labelcertificateType.text isEqualToString:@"台胞证"]) {
                                if ([nationlityLabel.text isEqualToString:@"中国台湾"]) {
                                    if ([Utils isnumberandenglishandkuo:fieldCertificateNumber.text]) {
                                        
                                        if (![Utils isValidatePhoneNum:fieldPhone.text]) {
                                            UIAlertView *fieldalert = [[UIAlertView alloc]initWithTitle:nil message:@"手机号码格式错误" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
                                            [fieldalert show];
                                        }
                                        else{
                                            if (![Utils ismailbox:fieldEmail.text]) {
                                                UIAlertView *fieldalert = [[UIAlertView alloc]initWithTitle:nil message:@"邮箱格式错误" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
                                                [fieldalert show];
                                            }
                                            else{
                                                [self getpassenger];
                                            }
                                            
                                        }
                                        
                                        
                                        
                                    }
                                    else{
                                        UIAlertView *fieldalert = [[UIAlertView alloc]initWithTitle:nil message:@"台胞证号码为空或格式不匹配(只能输入数字,英文字母或括号)" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
                                        [fieldalert show];
                                    }
                                }
                                else{
                                    UIAlertView *fieldalert = [[UIAlertView alloc]initWithTitle:nil message:@"国籍与证件类型不匹配" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
                                    [fieldalert show];
                                }
                            }
                            
                            
                            //其他
                            if ([labelcertificateType.text isEqualToString:@"其他"]) {
                                
                                
                                if ([Utils isnumberandenglish:fieldCertificateNumber.text]) {
                                    if (![Utils isValidatePhoneNum:fieldPhone.text]) {
                                        UIAlertView *fieldalert = [[UIAlertView alloc]initWithTitle:nil message:@"手机号码格式错误" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
                                        [fieldalert show];
                                    }
                                    else{
                                        if (![Utils ismailbox:fieldEmail.text]) {
                                            UIAlertView *fieldalert = [[UIAlertView alloc]initWithTitle:nil message:@"邮箱格式错误" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
                                            [fieldalert show];
                                        }
                                        else{
                                            [self getpassenger];
                                        }
                                        
                                    }
                                    
                                }
                                else{
                                    UIAlertView *fieldalert = [[UIAlertView alloc]initWithTitle:nil message:@"其他号码为空或格式不匹配(只能输入数字,英文字母)" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
                                    [fieldalert show];
                                }
                                
                                
                                
                            }
                            //分割领
                            
                        }
                        
                    }
                }
                else{
                    UIAlertView *fieldalert = [[UIAlertView alloc]initWithTitle:nil message:@"英文姓名(Last name)中包含非法字符,请检查请" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
                    [fieldalert show];
                }
                
                
            }
            else{
                UIAlertView *fieldalert = [[UIAlertView alloc]initWithTitle:nil message:@"英文姓名(Middler name)中包含非法字符,请检查请" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
                [fieldalert show];
            }
            
        }
        else{
            UIAlertView *fieldalert = [[UIAlertView alloc]initWithTitle:nil message:@"英文姓名(First name)中包含非法字符,请检查请" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [fieldalert show];
        }
        
    }
}
-(void)getpassenger{
    if (panduan==0) {
        NSLog(@"发送常用出行人请求");
        SavePassengerListRequest *request = [[SavePassengerListRequest alloc]initWidthBusinessType:BUSINESS_ACCOUNT methodName:@"SavePassengerList"];
        if (!_passengerInfomation) {
            _passengerInfomation =[[SavePassengerResponse alloc]init];
            _passengerInfomation.PassengerID=[NSNumber numberWithInt:0];
            _passengerInfomation.CorpUID=@"";
            _passengerInfomation.IsEmoloyee=[NSNumber numberWithBool:NO];
            _passengerInfomation.IsServer=[NSNumber numberWithBool:NO];
            _passengerInfomation.Name=fieldName.text;
            _passengerInfomation.LastName=fieldFirstName.text;
            _passengerInfomation.FirstName=fieldFirstName.text;
            _passengerInfomation.MiddleName=fieldMiddlerName.text;
            _passengerInfomation.FullENName=@"";
            _passengerInfomation.Email=fieldEmail.text;
            NSString *country =nationlityLabel.text;
            NSString *countryName = nil;
            for (Nation *nation in [[SqliteManager shareSqliteManager] mappingNationInfo]) {
                if ([nation.china_name isEqualToString:country]) {
                    countryName = [nation abb_name];
                    continue;
                }
            }
            _passengerInfomation.Country=countryName;
            _passengerInfomation.Birthday=dateOFbirthlabel.text;
            _passengerInfomation.LastUseDate=@"";
        }
        MemberIDcardResponse *IDCard =[[MemberIDcardResponse alloc]init];
        [IDCard setUID:@""];
        
        if ([labelcertificateType.text isEqualToString:@"身份证"]) {
            num=[NSNumber numberWithInt:0];
        }
        if ([labelcertificateType.text isEqualToString:@"护照"]) {
            num=[NSNumber numberWithInt:1];
        }
        if ([labelcertificateType.text isEqualToString:@"军官证"]) {
            num =[NSNumber numberWithInt:2];
        }
        if ([labelcertificateType.text isEqualToString:@"回乡证"]) {
            num =[NSNumber numberWithInt:3];
        }
        if ([labelcertificateType.text isEqualToString:@"港澳通行证"]) {
            num =[NSNumber numberWithInt:4];
        }
        if ([labelcertificateType.text isEqualToString:@"台胞证"]) {
            num =[NSNumber numberWithInt:5];
        }
        if ([labelcertificateType.text isEqualToString:@"其他"]) {
            num =[NSNumber numberWithInt:9];
        }
        [IDCard setCardType:num];
        [IDCard setCardNumber:fieldCertificateNumber.text];
        [IDCard setIsDefault:@"T"];
        _passengerInfomation.IDCardList=[NSArray arrayWithObject:IDCard];
        [_passengerInfomation setTelephone:@""];
        [_passengerInfomation setFax:[NSNumber numberWithInt:0]];
        [_passengerInfomation setContactConfirmType:@""];
        [_passengerInfomation setMobilePhone:fieldPhone.text];
        [_passengerInfomation setType:[NSNumber numberWithInteger:0]];
        request.Passengers = [NSArray arrayWithObjects:_passengerInfomation,nil];
        [self.requestManager sendRequest:request];
    }
    if (panduan==1) {
        NSLog(@"发送常用出行人请求");
        SavePassengerListRequest *request = [[SavePassengerListRequest alloc]initWidthBusinessType:BUSINESS_ACCOUNT methodName:@"SavePassengerList"];
        if (!_passengerInfomation) {
            _passengerInfomation =[[SavePassengerResponse alloc]init];
            _passengerInfomation.PassengerID=[_param objectForKey:@"PassengerID"];
            _passengerInfomation.CorpUID=@"";
            _passengerInfomation.IsEmoloyee=[NSNumber numberWithBool:NO];
            _passengerInfomation.IsServer=[NSNumber numberWithBool:NO];
            _passengerInfomation.Name=fieldName.text;
            _passengerInfomation.LastName=fieldFirstName.text;
            _passengerInfomation.FirstName=fieldFirstName.text;
            _passengerInfomation.MiddleName=fieldMiddlerName.text;
            _passengerInfomation.FullENName=@"";
            _passengerInfomation.Email=fieldEmail.text;
            NSString *country =nationlityLabel.text;
            NSString *countryName = nil;
            for (Nation *nation in [[SqliteManager shareSqliteManager] mappingNationInfo]) {
                if ([nation.china_name isEqualToString:country]) {
                    countryName = [nation abb_name];
                    continue;
                }
            }
            _passengerInfomation.Country=countryName;
            _passengerInfomation.Birthday=dateOFbirthlabel.text;
            _passengerInfomation.LastUseDate=@"";
        }
        MemberIDcardResponse *IDCard =[[MemberIDcardResponse alloc]init];
        [IDCard setUID:@""];
        
        if ([labelcertificateType.text isEqualToString:@"身份证"]) {
            num=[NSNumber numberWithInt:0];
        }
        if ([labelcertificateType.text isEqualToString:@"护照"]) {
            num=[NSNumber numberWithInt:1];
        }
        if ([labelcertificateType.text isEqualToString:@"军官证"]) {
            num =[NSNumber numberWithInt:2];
        }
        if ([labelcertificateType.text isEqualToString:@"回乡证"]) {
            num =[NSNumber numberWithInt:3];
        }
        if ([labelcertificateType.text isEqualToString:@"港澳通行证"]) {
            num =[NSNumber numberWithInt:4];
        }
        if ([labelcertificateType.text isEqualToString:@"台胞证"]) {
            num =[NSNumber numberWithInt:5];
        }
        if ([labelcertificateType.text isEqualToString:@"其他"]) {
            num =[NSNumber numberWithInt:9];
        }
        [IDCard setCardType:num];
        [IDCard setCardNumber:fieldCertificateNumber.text];
        [IDCard setIsDefault:@"T"];
        _passengerInfomation.IDCardList=[NSArray arrayWithObject:IDCard];
        [_passengerInfomation setTelephone:@""];
        [_passengerInfomation setFax:[NSNumber numberWithInt:0]];
        [_passengerInfomation setContactConfirmType:@""];
        [_passengerInfomation setMobilePhone:fieldPhone.text];
        [_passengerInfomation setType:[NSNumber numberWithInteger:0]];
        request.Passengers = [NSArray arrayWithObjects:_passengerInfomation,nil];
        [self.requestManager sendRequest:request];
    }
    
}


/**
 *  请求成功
 *
 *  @param response
 */
-(void)requestDone:(BaseResponseModel *) response{
    if (response) {
        NSLog(@"请求成功");
        
        
        [self popViewControllerTransitionType:TransitionPush completionHandler:^{
            [self.tripDelegate savepassengersDone];
           
        }];
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





//UItableView实现的方法

//这个方法返回   对应的section有多少个元素，也就是多少行。
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(tableView.tag==1001){
        return [nationlitydata count];
    }
    else{
        return [certificatedata count];
    }
    
}
//这个方法返回指定的 row 的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath*)indexPath{
    if (tableView.tag==1001) {
        return 40;
    }
    else{
        return 40;
    }
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{  if(tableView.tag==1001){
    static NSString *CellIdentifier =@"CellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell ==nil) {
        cell =[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    Nation *nationly= [nationlitydata objectAtIndex:indexPath.row];
    cell.textLabel.text = nationly.china_name;
    cell.textLabel.font = [UIFont fontWithName:@"Arial" size:15];
    return cell;}
else{
    static NSString *CellIdentifier =@"CellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell ==nil) {
        cell =[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    cell.textLabel.text = [certificatedata objectAtIndex:indexPath.row];
    cell.textLabel.font = [UIFont fontWithName:@"Arial" size:15];
    return cell;
}
}

//响应事件
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.tag==1001) {
        for (int i=0; i<=[nationlitydata count];i++) {
            if(indexPath.row==i){
                [nationlityView removeFromSuperview];
                [effectView removeFromSuperview];
                [alphaView removeFromSuperview];
                [effectBackgroundView.view removeFromSuperview];
            }
        }
        Nation *nation= [nationlitydata objectAtIndex:indexPath.row];
        nationlityLabel.text=nation.china_name;

    }
    else{
        for (int j=0; j<=[certificatedata count]; j++) {
            if (indexPath.row==j) {
                [effectOtherView removeFromSuperview];
                [certificateTypeView removeFromSuperview];
                [alphaView removeFromSuperview];
                [effectBackgroundView.view removeFromSuperview];
            }
        }
        labelcertificateType.text=[certificatedata objectAtIndex:indexPath.row];
        
      
        
    }
    
}


@end
