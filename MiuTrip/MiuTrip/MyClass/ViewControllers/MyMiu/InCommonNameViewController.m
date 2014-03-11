//
//  InCommonNameViewController.m
//  MiuTrip
//
//  Created by GX on 13-12-23.
//  Copyright (c) 2013年 michael. All rights reserved.
//
#import "InCommonNameViewController.h"
#import "RequestManager.h"
#import "ASIHTTPRequest.h"
#import "SBJson.h"
#import "ASIFormDataRequest.h"
#import "ASINetworkQueue.h"
#import "UserDefaults.h"
#import "Utils.h"
#import "Model.h"
#import "AppDelegate.h"
#import "SearchPassengersRequest.h"
#import "SearchPassengersResponse.h"
#import "GetContactRequest.h"
#import "GetContactResponse.h"
#import "DeleteMemberPassengerRequest.h"
#import "SqliteManager.h"
#import "Nation.h"
#import "CustomMethod.h"
#import "TrippersonController.h"
#import "ContactController.h"
#import "CustomBtn.h"
@interface InCommonNameViewController (){
    
    
    
    UIView *myView;
    UIView *myrightView;
    UILabel *nameandlabel;
    UILabel *nationlityandlabel;
    UILabel *certificateTypeandlabel;
    UILabel *moviePhoneNumberandlabel;
    UILabel *certificateNumberandlabel;
    NSMutableArray *passengers;
    NSMutableArray *getContactresponses;
    
    NSDictionary *dicc;
    
    UILabel *rightnameandlabel;
    UILabel *rightmoviePhoneNumberandlabel;
    UILabel *rightemail;
    UILabel *change;
    
    NSInteger bian;
    UILabel *celllabel;
    
}

@property (strong, nonatomic) NSObject  *editObject;
@property (strong, nonatomic) NSObject  *passeditObject;
@property (strong, nonatomic) NSIndexPath   *currentIndexPath;
@end

@implementation InCommonNameViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
    }
    return self;
}
-(id)init{
    if (self = [super init]) {
        
        [self setSubviewFrame];
        [self getPassengers];
        [_showtableView reloadData];
        
    }
    return self;
    
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


- (void)setSubviewFrame
{
    [self setBackGroundImage:imageNameAndType(@"home_bg", nil)];
    [self setTitle:@"常用姓名"];
    [self setTopBarBackGroundImage:imageNameAndType(@"topbar", nil)];
    
    UIButton *returnBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [returnBtn setBackgroundColor:color(clearColor)];
    [returnBtn setImage:imageNameAndType(@"return", nil) forState:UIControlStateNormal];
    [returnBtn setFrame:CGRectMake(0, 0, self.topBar.frame.size.height, self.topBar.frame.size.height)];
    [self setReturnButton:returnBtn];
    [self.view addSubview:returnBtn];
    
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightBtn setBackgroundColor:color(clearColor)];
    [rightBtn setImage:imageNameAndType(@"cname_add", nil) forState:UIControlStateNormal];
    [rightBtn setFrame:CGRectMake(self.topBar.frame.size.width - self.topBar.frame.size.height, 0, self.topBar.frame.size.height, self.topBar.frame.size.height)];
    [rightBtn addTarget:self action:@selector(pressRightBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:rightBtn];
    //分段开关
    NSArray *arr =[[NSArray alloc]initWithObjects:@"常用出行人",@"常用联系人", nil];
    UISegmentedControl *mySegmentedControl = [ [ UISegmentedControl alloc ] initWithItems:arr];
    mySegmentedControl.segmentedControlStyle = UISegmentedControlStylePlain;
    [mySegmentedControl setFrame:CGRectMake(0, returnBtn.frame.size.height, self.view.frame.size.width, returnBtn.frame.size.height)];
    [mySegmentedControl setBackgroundColor:[UIColor lightGrayColor]];
    UIColor *myTint =[UIColor darkGrayColor];
    mySegmentedControl.tintColor = myTint;
    [mySegmentedControl setBorderColor:color(lightGrayColor) width:2.0];
    
    [mySegmentedControl addTarget:self action:@selector(mypressSegment:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:mySegmentedControl];
    
    //tableView
    _showtableView =[[UITableView alloc]initWithFrame:CGRectMake(0,mySegmentedControl.frame.origin.y+mySegmentedControl.frame.size.height, self.view.frame.size.width, self.view.frame.size.height-self.topBar.frame.size.height-mySegmentedControl.frame.size.height-self.bottomBar.frame.size.height)];
    [_showtableView setTag:100];
    //去掉线
    //    [_showtableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    _showtableView.bounces =NO;
    [_showtableView setDataSource:self];
    [_showtableView setDelegate:self];
    [self.view addSubview:_showtableView];
    
    
    
    
}
- (void)pressRightBtn:(UIButton*)sender
{
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"证件类型" message:nil delegate:self cancelButtonTitle:@"出行人" otherButtonTitles:@"联系人", nil];
    [alert setTag:1000];
    [alert show];
    
}
- (void)backbutton:(UIButton*)sender{
    
    if (sender.tag==1000) {
        [myView removeFromSuperview];
    }
    else{
        [myrightView removeFromSuperview];
    }
}

- (void)deleteButton:(CustomBtn*)sender{
    _currentIndexPath = sender.indexPath;
    if (sender.tag==100) {
        UIAlertView *tripalert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"确认要删除该出行人" delegate:self cancelButtonTitle:@"是" otherButtonTitles:@"否", nil];
        [tripalert setTag:1001];
        [tripalert show];
        
        
    }
    if (sender.tag==103) {
        UIAlertView *tripalert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"确认要删除该联系人" delegate:self cancelButtonTitle:@"是" otherButtonTitles:@"否", nil];
        [tripalert setTag:1003];
        [tripalert show];
    }
    
    
}
-(void)compileButton:(UIButton*)sender{
    if (sender.tag==104) {
        
        ContactController *contactView = [[ContactController alloc]initWithParamss:(NSDictionary*)_passeditObject];
        
        [contactView setContactDelegate:self];
        
        [self pushViewController:contactView transitionType:TransitionPush completionHandler:nil];
    }
    else{
        
        
        TrippersonController *tripView = [[TrippersonController alloc]initWithParams:(NSDictionary*)_passeditObject];
        [tripView setTripDelegate:self];
        [self pushViewController:tripView transitionType:TransitionPush completionHandler:nil];
    }
}


- (void)saveContactsDone
{    [self getContacts];
    
}

- (void)savepassengersDone
{    [self getPassengers];
    
    
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag==1000) {
        if (buttonIndex != [alertView cancelButtonIndex]) {
            ContactController *contact = [[ContactController alloc]init];
            contact.ContactDelegate=self;
            [self.navigationController pushViewController:contact animated:YES];   }
        else{
            TrippersonController *trippersonView = [[TrippersonController alloc]init];
            trippersonView.tripDelegate=self;
            [self.navigationController pushViewController:trippersonView animated:YES];
            
        }
    }
    if (alertView.tag==1001) {
        if (buttonIndex != [alertView cancelButtonIndex]) {
            
            
        }
        else{
            [self getdeletepassenger];
        }
        
    }
    
    if (alertView.tag==1003) {
        if (buttonIndex != [alertView cancelButtonIndex]) {
            
            
        }
        else{
            [self getdeletecontact];
        }
        
    }
    
}
-(void)mypressSegment:(UISegmentedControl*)sender{
    UISegmentedControl* control = (UISegmentedControl*)sender;
    switch (control.selectedSegmentIndex) {
        case 0:
            
            if ([passengers count] == 0) {
                [self getPassengers];
            }else{
                _currentDataSource = passengers;
                [_showtableView reloadData];
            }
            break;
        case 1:
            
            if ([getContactresponses count] == 0) {
                [self getContacts];
            }
            else{
                _currentDataSource = getContactresponses;
                [_showtableView reloadData];
            }
            
            break;
            
            
    }
}

-(void)getdeletepassenger{
    DeleteMemberPassengerRequest *deleterequest =[[DeleteMemberPassengerRequest alloc] initWidthBusinessType:BUSINESS_ACCOUNT methodName:@"DeleteMemberPassenger"];
    deleterequest.PassengerID =[(NSDictionary*)_passeditObject objectForKey:@"PassengerID"];//出行人id
    [self.requestManager sendRequest:deleterequest];
}
-(void)getdeletecontact{
    DeleteMemberPassengerRequest *deleterequest =[[DeleteMemberPassengerRequest alloc] initWidthBusinessType:BUSINESS_ACCOUNT methodName:@"DeleteMemberPassenger"];
    deleterequest.PassengerID =[(NSDictionary*)_passeditObject objectForKey:@"PassengerID"];//联系人id
    [self.requestManager sendRequest:deleterequest];
}

- (void)getPassengers
{
    SearchPassengersRequest *passengersrequest =[[SearchPassengersRequest alloc] initWidthBusinessType:BUSINESS_ACCOUNT methodName:@"SearchPassengers"];
    passengersrequest.CorpID =[NSNumber numberWithInt:22];
    passengersrequest.keys =@"";
    [self.requestManager sendRequest:passengersrequest];
}

- (void)getPassengersDone:(SearchPassengersResponse*)response
{
    passengers = [NSMutableArray arrayWithArray:response.result];
    for (NSDictionary *dic in passengers) {
        [dic setValue:[NSNumber numberWithBool:NO] forKey:@"unfold"];
    }
    _currentDataSource = passengers;
    [_showtableView reloadData];
    
    
}

- (void)getContacts
{
    GetContactRequest *getContactrequest =[[GetContactRequest alloc] initWidthBusinessType:BUSINESS_ACCOUNT methodName:@"GetContact"];
    getContactrequest.CorpID =[NSNumber numberWithInt:22];
    [self.requestManager sendRequest:getContactrequest];
}

- (void)getContactsDone:(GetContactResponse*)response
{
    getContactresponses = [NSMutableArray arrayWithArray:response.result];
    for (NSDictionary *dic in getContactresponses) {
        [dic setValue:[NSNumber numberWithBool:NO] forKey:@"unfold"];
    }
    _currentDataSource = getContactresponses;
    [_showtableView reloadData];
}
//可删除默认为1
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
    
}
//这个方法返回   对应的section有多少个元素，也就是多少行。
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSLog(@"count = %u",[_currentDataSource count]);
    return [_currentDataSource count];
}
//这个方法返回指定的 row 的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath*)indexPath{
    
    _editObject = [_currentDataSource objectAtIndex:indexPath.row];
    BOOL unfold = [[(NSDictionary*)_editObject objectForKey:@"unfold"] boolValue];
    if (_currentDataSource==passengers) {
        if (unfold) {
            return TripCellUnfoldHeight;
        }
        else{
            return CellHeight;
        }
        
    }
    else{
        if (unfold) {
            return ContactCellUnfoleHeight;
        }
        else{
            return CellHeight;
        }
        
    }
    
}




- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    if (_currentDataSource==passengers) {
        static NSString *CellIdentifier =@"Trip";
        
        tripcellview *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (cell ==nil) {
            cell =[[tripcellview alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            
        }
        
        
        [cell.deleteButton setIndexPath:indexPath];//把按钮插入索引
        _editObject= [_currentDataSource objectAtIndex:indexPath.row];
        [cell setContentWithParams:(NSDictionary*)_editObject];
        [cell setRightImageHighlighted:[[(NSDictionary*)_editObject objectForKey:@"unfold"] boolValue]];
        
        
        return cell;
    }
    else{
        static NSString *CellIdentifier =@"Contact";
        
        tripcellview *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (cell ==nil) {
            cell =[[tripcellview alloc]initWithotherStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            
        }
        
        [cell.deleteButton setIndexPath:indexPath];
        _editObject= [_currentDataSource objectAtIndex:indexPath.row];
        [cell setContentWithParamss:(NSDictionary*)_editObject];
        [cell setRightImageHighlighted:[[(NSDictionary*)_editObject objectForKey:@"unfold"] boolValue]];
        
        return cell;
    }
    
}






//响应事件
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    _passeditObject =[_currentDataSource objectAtIndex:indexPath.row];
    _editObject = [_currentDataSource objectAtIndex:indexPath.row];
    BOOL unfold = [[(NSDictionary*)_editObject objectForKey:@"unfold"] boolValue];
    [_editObject setValue:[NSNumber numberWithBool:!unfold] forKey:@"unfold"];
    [_showtableView reloadData];
    [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    
    
    
    
}

//点击传值可无
-(void)passValue:(NSInteger)value
{    self.r = value;
}





- (void)requestDone:(BaseResponseModel *)response{
    
    if ([response isKindOfClass:[SearchPassengersResponse class]]) {
        [self getPassengersDone:(SearchPassengersResponse*)response];
    }
    else if ([response isKindOfClass:[GetContactResponse class]]){
        [self getContactsDone:(GetContactResponse*)response];
    }
    else if ([response isKindOfClass:[DeleteMemberPassengerResponse class]]) {
        NSLog(@"成功lll");
        
        [[Model shareModel] showPromptText:@"删除成功" model:YES];
        [_currentDataSource removeObjectAtIndex:_currentIndexPath.row];
        [_showtableView reloadData];
        
        
        
    }
}

//- (void)timerFireMethod:(NSTimer*)theTimer
//{
//
//        UIAlertView *tripalert = (UIAlertView*)[theTimer userInfo];
//        [tripalert dismissWithClickedButtonIndex:0 animated:NO];
//        tripalert =NULL;
//
//
//}



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


@interface tripcellview(){
    UILabel *celllabel;
    UIView *tripView;
    BOOL unfold;
    UILabel *nameandlabel;
    UILabel *nationlityandlabel;
    UILabel *certificateTypeandlabel;
    UILabel *certificateNumberandlabel;
    UILabel *moviePhoneNumberandlabel;
    UILabel *rightNameandLabel;
    UILabel *rightMoviePhoneNumberAndLabel;
    UILabel *rightEmail;
    NSDictionary *alldic;
    NSDictionary *otheralldic;
}


@end
@implementation tripcellview


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self setSubview];
        
        
    }
    return self;
}

- (void)setRightImageHighlighted:(BOOL)rightImageHighlighted
{
    UIImageView *imageView = (UIImageView*)[self viewWithTag:8086];
    [imageView setHighlighted:rightImageHighlighted];
}

- (id)initWithotherStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self setotherSubview];
        
    }
    return self;
}
-(void)setSubview{
    
    
    UIImageView *imageview =[[UIImageView alloc]initWithFrame:CGRectMake(self.contentView.frame.size.width-20, 15,10, 10)];
    [imageview setTag:8086];
    [imageview setImage:[UIImage imageNamed:@"cell_arrow_down.png"]];
    [imageview setHighlightedImage:[UIImage imageNamed:@"cell_arrow_up.png"]];
    [self.contentView addSubview:imageview];
    
    
    
    [self setSelectionStyle:UITableViewCellSelectionStyleGray];
    
    celllabel =[[UILabel alloc]initWithFrame:CGRectMake(10, 0, self.frame.size.width, 40)];
    NSString *name=[_cellparam objectForKey:@"UserName"];
    [celllabel setAutoSize:YES];
    [celllabel setBackgroundColor:color(clearColor)];
    NSLog(@"name is %@",name);
    [self.contentView addSubview:celllabel];
    
    
    
    tripView =[[UIView alloc]initWithFrame:CGRectMake(10, 40, self.frame.size.width-20, 215)];
    [tripView setBorderColor:[UIColor lightGrayColor] width:0.5];
    [self.contentView addSubview:tripView];
    UIView *lineOneView =[[UIView alloc]initWithFrame:CGRectMake(0, tripView.frame.size.height/7, tripView.frame.size.width, 0.5)];
    [lineOneView setBackgroundColor:[UIColor lightGrayColor]];
    [tripView addSubview:lineOneView];
    
    UIView *lineTwoView =[[UIView alloc]initWithFrame:CGRectMake(0, tripView.frame.size.height/7*2, tripView.frame.size.width, 0.5)];
    [lineTwoView setBackgroundColor:[UIColor lightGrayColor]];
    [tripView addSubview:lineTwoView];
    
    UIView *lineThreeView =[[UIView alloc]initWithFrame:CGRectMake(0, tripView.frame.size.height/7*3, tripView.frame.size.width, 0.5)];
    [lineThreeView setBackgroundColor:[UIColor lightGrayColor]];
    [tripView addSubview:lineThreeView];
    
    UIView *lineFourView =[[UIView alloc]initWithFrame:CGRectMake(0, tripView.frame.size.height/7*4, tripView.frame.size.width, 0.5)];
    [lineFourView setBackgroundColor:[UIColor lightGrayColor]];
    [tripView addSubview:lineFourView];
    
    UIView *lineFiveView =[[UIView alloc]initWithFrame:CGRectMake(0, tripView.frame.size.height/7*5, tripView.frame.size.width, 0.5)];
    [lineFiveView setBackgroundColor:[UIColor lightGrayColor]];
    [tripView addSubview:lineFiveView];
    
    UIView *lineSixView =[[UIView alloc]initWithFrame:CGRectMake(0, tripView.frame.size.height/7*6, tripView.frame.size.width, 0.5)];
    [lineSixView setBackgroundColor:[UIColor lightGrayColor]];
    [tripView addSubview:lineSixView];
    //静态的label
    UILabel *tripName = [[UILabel alloc]initWithFrame:CGRectMake(0,2,tripView.frame.size.width/3,tripView.frame.size.height/7-4)];
    tripName.text =@"       姓名";
    [tripName setBackgroundColor:color(clearColor)];
    [tripName setTextAlignment:NSTextAlignmentCenter];
    [tripView addSubview:tripName];
    UILabel *nationalitylabel  = [[UILabel alloc]initWithFrame:CGRectMake(0,tripView.frame.size.height/7+2,tripView.frame.size.width/3,tripView.frame.size.height/7-4)];
    [nationalitylabel setText:@"       国籍"];
    [nationalitylabel setBackgroundColor:color(clearColor)];
    [nationalitylabel setTextAlignment:NSTextAlignmentCenter];
    [tripView  addSubview:nationalitylabel];
    
    UILabel *certificateTypeLabel = [[UILabel alloc]initWithFrame:CGRectMake(0,tripView.frame.size.height/7*2+2,tripView.frame.size.width/3,tripView.frame.size.height/7-4)];
    [certificateTypeLabel setText:@"证件类型"];
    [certificateTypeLabel setBackgroundColor:color(clearColor)];
    [certificateTypeLabel setTextAlignment:NSTextAlignmentCenter];
    [tripView addSubview:certificateTypeLabel];
    
    UILabel *certificateNumberlabel = [[UILabel alloc]initWithFrame:CGRectMake(0,tripView.frame.size.height/7*3+2,tripView.frame.size.width/3,tripView.frame.size.height/7-4)];
    [certificateNumberlabel setText:@"证件号码"];
    [certificateNumberlabel setBackgroundColor:color(clearColor)];
    [certificateNumberlabel setTextAlignment:NSTextAlignmentCenter];
    [tripView addSubview:certificateNumberlabel];
    
    UILabel *moviePhoneNumberLabel = [[UILabel alloc]initWithFrame:CGRectMake(0,tripView.frame.size.height/7*4+2,tripView.frame.size.width/3,tripView.frame.size.height/7-4)];
    [moviePhoneNumberLabel setText:@"手机号码"];
    [moviePhoneNumberLabel setBackgroundColor:color(clearColor)];
    [moviePhoneNumberLabel setTextAlignment:NSTextAlignmentCenter];
    [tripView addSubview:moviePhoneNumberLabel];
    
    UIImageView *iconView = [[UIImageView alloc]initWithImage: [UIImage imageNamed:@"cname_item_select"]];
    [iconView setFrame:CGRectMake(15,tripView.frame.size.height/7*5+tripView.frame.size.height/30,tripView.frame.size.width/15,tripView.frame.size.height/12)];
    [tripView addSubview:iconView];
    
    UILabel *commonpreson = [[UILabel alloc]initWithFrame:CGRectMake(40,tripView.frame.size.height/7*5+2,tripView.frame.size.width/3,tripView.frame.size.height/7-4)];
    [commonpreson setText:@"常用出行人"];
    commonpreson.numberOfLines=5;
    [commonpreson setBackgroundColor:color(clearColor)];
    [tripView addSubview:commonpreson];
    
    //删除和编辑按钮
    _deleteButton = [CustomBtn buttonWithType:UIButtonTypeCustom];
    [_deleteButton setFrame:CGRectMake(70,tripView.frame.size.height/7*6+2,tripView.frame.size.width/4,tripView.frame.size.height/7-4 )];
    [_deleteButton setBackgroundImage:[UIImage imageNamed:@"cname_delete_normal"] forState:UIControlStateNormal];
    [_deleteButton setTitle:@"删除" forState:UIControlStateNormal];
    [_deleteButton setTag:100];
    [_deleteButton setBackgroundImage:[UIImage imageNamed:@"cname_delete_press"] forState:UIControlStateHighlighted];
    [_deleteButton setTitle:@"删除" forState:UIControlStateHighlighted];
    _deleteButton.contentHorizontalAlignment=UIControlContentHorizontalAlignmentCenter ;
    [_deleteButton addTarget:self.superview action:@selector(deleteButton:) forControlEvents:UIControlEventTouchUpInside];
    [tripView addSubview:_deleteButton];
    
    UIButton *compileButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [compileButton setFrame:CGRectMake(150,tripView.frame.size.height/7*6+2,tripView.frame.size.width/4,tripView.frame.size.height/7-4)];
    [compileButton setBackgroundImage:[UIImage imageNamed:@"cname_save_normal"] forState:UIControlStateNormal];
    [compileButton setTitle:@"编辑" forState:UIControlStateNormal];
    [compileButton setBackgroundImage:[UIImage imageNamed:@"cname_save_press"] forState:UIControlStateHighlighted];
    [compileButton setTitle:@"编辑" forState:UIControlStateHighlighted];
    compileButton.contentHorizontalAlignment=UIControlContentHorizontalAlignmentCenter ;
    [compileButton setTag:101];
    [compileButton addTarget:self.superview action:@selector(compileButton:) forControlEvents:UIControlEventTouchUpInside];
    [tripView addSubview:compileButton];
    //动态label
    nameandlabel = [[UILabel alloc]initWithFrame:CGRectMake(tripView.frame.size.width/3,2,tripView.frame.size.width/3*2,tripView.frame.size.height/7-4)];
    [nameandlabel setAutoSize:YES];
    [nameandlabel setBackgroundColor:color(clearColor)];
    [tripView addSubview:nameandlabel];
    
    nationlityandlabel = [[UILabel alloc]initWithFrame:CGRectMake(tripView.frame.size.width/3,tripView.frame.size.height/7+2,tripView.frame.size.width/3*2,tripView.frame.size.height/7-4)];
    [nationlityandlabel setAutoSize:YES];
    [nationlityandlabel setBackgroundColor:color(clearColor)];
    [tripView addSubview:nationlityandlabel];
    
    certificateTypeandlabel = [[UILabel alloc]initWithFrame:CGRectMake(tripView.frame.size.width/3,tripView.frame.size.height/7*2+2,tripView.frame.size.width/3*2,tripView.frame.size.height/7-4)];
    [certificateTypeandlabel setAutoSize:YES];
    [certificateTypeandlabel setBackgroundColor:color(clearColor)];
    [tripView addSubview:certificateTypeandlabel];
    
    certificateNumberandlabel=[[UILabel alloc]initWithFrame:CGRectMake(tripView.frame.size.width/3,tripView.frame.size.height/7*3+2,tripView.frame.size.width/3*2,tripView.frame.size.height/7-4)];
    [certificateNumberandlabel setAutoSize:YES];
    [certificateNumberandlabel setBackgroundColor:color(clearColor)];
    [tripView addSubview:certificateNumberandlabel];
    
    moviePhoneNumberandlabel =[[UILabel alloc]initWithFrame:CGRectMake(tripView.frame.size.width/3,tripView.frame.size.height/7*4+2,tripView.frame.size.width/3*2,tripView.frame.size.height/7-4)];
    [moviePhoneNumberandlabel setAutoSize:YES];
    [moviePhoneNumberandlabel setBackgroundColor:color(clearColor)];
    [tripView addSubview:moviePhoneNumberandlabel];
    
}
-(void)setotherSubview{
    
    UIImageView *imageview =[[UIImageView alloc]initWithFrame:CGRectMake(self.contentView.frame.size.width-20, 15,10, 10)];
    [imageview setTag:8086];
    [imageview setImage:[UIImage imageNamed:@"cell_arrow_down.png"]];
    [imageview setHighlightedImage:[UIImage imageNamed:@"cell_arrow_up.png"]];
    [self.contentView addSubview:imageview];
    
    celllabel =[[UILabel alloc]initWithFrame:CGRectMake(10, 0, self.frame.size.width, 40)];
    [celllabel setAutoSize:YES];
    [celllabel setBackgroundColor:[UIColor clearColor]];
    NSString *name=[_cellparam objectForKey:@"UserName"];
    NSLog(@"name is %@",name);
    //celllabel.text =name;
    [self.contentView addSubview:celllabel];
    
    tripView =[[UIView alloc]initWithFrame:CGRectMake(10, 40, self.frame.size.width-20, 155)];
    [tripView setBorderColor:[UIColor lightGrayColor] width:0.5];
    [self.contentView addSubview:tripView];
    UIView *lineOneView =[[UIView alloc]initWithFrame:CGRectMake(0, tripView.frame.size.height/5, tripView.frame.size.width, 0.5)];
    [lineOneView setBackgroundColor:[UIColor lightGrayColor]];
    [tripView addSubview:lineOneView];
    
    UIView *lineTwoView =[[UIView alloc]initWithFrame:CGRectMake(0, tripView.frame.size.height/5*2, tripView.frame.size.width, 0.5)];
    [lineTwoView setBackgroundColor:[UIColor lightGrayColor]];
    [tripView addSubview:lineTwoView];
    
    UIView *lineThreeView =[[UIView alloc]initWithFrame:CGRectMake(0, tripView.frame.size.height/5*3, tripView.frame.size.width, 0.5)];
    [lineThreeView setBackgroundColor:[UIColor lightGrayColor]];
    [tripView addSubview:lineThreeView];
    
    UIView *lineFourView =[[UIView alloc]initWithFrame:CGRectMake(0, tripView.frame.size.height/5*4, tripView.frame.size.width, 0.5)];
    [lineFourView setBackgroundColor:[UIColor lightGrayColor]];
    [tripView addSubview:lineFourView];
    //    //静态lable
    UILabel *rightNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(0,2,tripView.frame.size.width/3,tripView.frame.size.height/5-4)];
    [rightNameLabel setBackgroundColor:color(clearColor)];
    [rightNameLabel setTextAlignment:NSTextAlignmentCenter];
    [rightNameLabel setText:@"       姓名"];
    [tripView addSubview:rightNameLabel];
    
    UILabel *rightMoviePhoneNumberlabel = [[UILabel alloc]initWithFrame:CGRectMake(0,tripView.frame.size.height/5+2,tripView.frame.size.width/3,tripView.frame.size.height/5-4)];
    [rightMoviePhoneNumberlabel setText:@"手机号码"];
    [rightMoviePhoneNumberlabel setBackgroundColor:color(clearColor)];
    [rightMoviePhoneNumberlabel setTextAlignment:NSTextAlignmentCenter];
    [tripView addSubview:rightMoviePhoneNumberlabel];
    
    UILabel *emailLabel =[[UILabel alloc]initWithFrame:CGRectMake(0,tripView.frame.size.height/5*2+2,tripView.frame.size.width/3,tripView.frame.size.height/5-4)];
    [emailLabel setBackgroundColor:color(clearColor)];
    [emailLabel setTextAlignment:NSTextAlignmentCenter];
    [emailLabel setText:@"电子邮件"];
    [tripView addSubview:emailLabel];
    
    UIImageView *iconView = [[UIImageView alloc]initWithImage: [UIImage imageNamed:@"cname_item_select"]];
    [iconView setFrame:CGRectMake(15,tripView.frame.size.height/5*3+6,tripView.frame.size.width/15,tripView.frame.size.height/8)];
    [tripView addSubview:iconView];
    
    UILabel *commonpreson = [[UILabel alloc]initWithFrame:CGRectMake(40,tripView.frame.size.height/5*3+2,tripView.frame.size.width/3,tripView.frame.size.height/5-4)];
    [commonpreson setText:@"常用出行人"];
    [commonpreson setBackgroundColor:color(clearColor)];
    commonpreson.numberOfLines=5;
    [tripView addSubview:commonpreson];
    //button
    CustomBtn *rightdeletebutton = [CustomBtn buttonWithType:UIButtonTypeCustom];
    [rightdeletebutton setFrame:CGRectMake(70,tripView.frame.size.height/5*4+2,tripView.frame.size.width/4,tripView.frame.size.height/5-4 )];
    [rightdeletebutton setBackgroundImage:[UIImage imageNamed:@"cname_delete_normal"] forState:UIControlStateNormal];
    [rightdeletebutton setTitle:@"删除" forState:UIControlStateNormal];
    [rightdeletebutton setTag:103];
    [rightdeletebutton setBackgroundImage:[UIImage imageNamed:@"cname_delete_press"] forState:UIControlStateHighlighted];
    [rightdeletebutton setTitle:@"删除" forState:UIControlStateHighlighted];
    rightdeletebutton.contentHorizontalAlignment=UIControlContentHorizontalAlignmentCenter ;
    [rightdeletebutton addTarget:self.superview action:@selector(deleteButton:) forControlEvents:UIControlEventTouchUpInside];
    [tripView addSubview:rightdeletebutton];
    
    UIButton *rightcompilebutton = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightcompilebutton setFrame:CGRectMake(150,tripView.frame.size.height/5*4+2,tripView.frame.size.width/4,tripView.frame.size.height/5-4)];
    [rightcompilebutton setBackgroundImage:[UIImage imageNamed:@"cname_save_normal"] forState:UIControlStateNormal];
    [rightcompilebutton setTitle:@"编辑" forState:UIControlStateNormal];
    [rightcompilebutton setBackgroundImage:[UIImage imageNamed:@"cname_save_press"] forState:UIControlStateHighlighted];
    [rightcompilebutton setTitle:@"编辑" forState:UIControlStateHighlighted];
    rightcompilebutton.contentHorizontalAlignment=UIControlContentHorizontalAlignmentCenter ;
    [rightcompilebutton setTag:104];
    [rightcompilebutton addTarget:self.superview action:@selector(compileButton:) forControlEvents:UIControlEventTouchUpInside];
    [tripView addSubview:rightcompilebutton];
    //动态label
    
    rightNameandLabel =[[UILabel alloc]initWithFrame:CGRectMake(tripView.frame.size.width/3,2,tripView.frame.size.width/3*2,tripView.frame.size.height/5-4)];
    [rightNameandLabel setBackgroundColor:color(clearColor)];
    [rightNameandLabel setAutoSize:YES];
    [tripView addSubview:rightNameandLabel];
    
    rightMoviePhoneNumberAndLabel =[[UILabel alloc]initWithFrame:CGRectMake(tripView.frame.size.width/3,tripView.frame.size.height/5+2,tripView.frame.size.width/3*2,tripView.frame.size.height/5-4)];
    [rightMoviePhoneNumberAndLabel setAutoSize:YES];
    [rightMoviePhoneNumberAndLabel setBackgroundColor:color(clearColor)];
    [tripView addSubview:rightMoviePhoneNumberAndLabel];
    rightEmail = [[UILabel alloc] initWithFrame:CGRectMake(tripView.frame.size.width/3,tripView.frame.size.height/5*2+2,tripView.frame.size.width/3*2,tripView.frame.size.height/5-4)];
    [rightEmail setAutoSize:YES];
    [rightEmail setBackgroundColor:color(clearColor)];
    [tripView addSubview:rightEmail];
    
}

- (void)setContentWithParams:(NSDictionary*)params
{
    unfold = [[params objectForKey:@"unfold"] boolValue];
    NSLog(@"params = %@",params);
    
    [celllabel setText:[params objectForKey:@"UserName"]];
    [tripView setHidden:!unfold];
    alldic=params;
    nameandlabel.text=[alldic objectForKey:@"UserName"];
    NSString *country = [alldic objectForKey:@"Country"];
    
    if ([country isKindOfClass:[NSNull class]]) {
        [nationlityandlabel setText:@"中国大陆"];
    }
    else{
        NSLog(@"country = %@",country);
        NSString *countryName = nil;
        for (Nation *nation in [[SqliteManager shareSqliteManager] mappingNationInfo]) {
            if ([nation.abb_name isEqualToString:country]) {
                countryName = [nation china_name];
                continue;
            }
        }
        [nationlityandlabel setText:countryName];
    }
    NSString *moviePhoneNumber =[alldic objectForKey:@"Mobilephone"];
    if ([moviePhoneNumber isKindOfClass:[NSNull class]]) {
        [moviePhoneNumberandlabel setText:@""];
    }
    else{
        [moviePhoneNumberandlabel setText:moviePhoneNumber];
    }
    
    NSArray *array= [alldic objectForKey:@"IDCardList"];
    if ([array count]==0) {
        [certificateTypeandlabel setText:@"身份证"];
        [certificateNumberandlabel setText:@""];
        if ([country isKindOfClass:[NSNull class]]) {
            [nationlityandlabel setText:@"中国大陆"];
        }
        else{
            
            [nationlityandlabel setText:country];
            
        }
        
        NSString *moviePhoneNumber =[alldic objectForKey:@"Mobilephone"];
        if ([moviePhoneNumber isKindOfClass:[NSNull class]]) {
            [moviePhoneNumberandlabel setText:@""];
        }
        else{
            [moviePhoneNumberandlabel setText:moviePhoneNumber];
            
        }
        
    }
    else{ NSLog(@"array is %@",array);
        NSDictionary *dicc =[array objectAtIndex:0];
        NSString *cardnumber =[dicc objectForKey:@"CardNumber"];
        NSNumber *cardtype =[dicc objectForKey:@"CardType"];
        NSString *cardtypestring =[[NSString alloc]init];
        cardtypestring =[cardtype stringValue];
        NSString *cardtypeid =[[NSString alloc]init];
        if ([cardtypestring isEqual:@"0"]) {
            cardtypeid=@"身份证";
        }
        if ([cardtypestring isEqual:@"1"]) {
            cardtypeid =@"护照";
        }
        if ([cardtypestring isEqual:@"2"]) {
            cardtypeid =@"军官证";
        }
        if ([cardtypestring isEqual:@"3"]) {
            cardtypeid=@"回乡证";
        }
        if ([cardtypestring isEqual:@"4"]) {
            cardtypeid = @"港澳通行证";
        }
        if ([cardtypestring isEqual:@"5"]) {
            cardtypeid =@"台胞证";
        }
        if ([cardtypestring isEqual:@"9"]) {
            cardtypeid=@"其他";
        }
        if ([cardnumber isKindOfClass:[NSNull class]]) {
            [certificateNumberandlabel setText:@""];
        }
        else{
            [certificateNumberandlabel setText:cardnumber];
        }
        
        if ([cardtypestring isKindOfClass:[NSNull class]]) {
            [certificateTypeandlabel setText:@"身份证"];
        }
        else{
            [certificateTypeandlabel setText:cardtypeid];
        }
    }
}

-(void)setContentWithParamss:(NSDictionary*)paramss{
    unfold = [[paramss objectForKey:@"unfold"] boolValue];
    NSLog(@"params = %@",paramss);
    
    [celllabel setText:[paramss objectForKey:@"UserName"]];
    [tripView setHidden:!unfold];
    otheralldic=paramss;
    
    rightNameandLabel.text=[otheralldic objectForKey:@"UserName"];
    
    NSString *name = [otheralldic objectForKey:@"UserName"];
    [rightNameandLabel setText:name];
    NSString *moviePhoneNumber =[otheralldic objectForKey:@"Mobilephone"];
    if ([moviePhoneNumber isKindOfClass:[NSNull class]]) {
        [rightMoviePhoneNumberAndLabel setText:@""];
    }
    else{
        [rightMoviePhoneNumberAndLabel setText:moviePhoneNumber];
        
    }
    
    NSString *email = [otheralldic objectForKey:@"Email" ];
    if ([email isKindOfClass:[NSNull class]]) {
        [rightEmail setText:@""];
    }
    else{
        [rightEmail setText:email];
    }
    
}


@end





