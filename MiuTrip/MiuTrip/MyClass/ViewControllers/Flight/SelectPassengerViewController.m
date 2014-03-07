//
//  SelectPassengerViewController.m
//  MiuTrip
//
//  Created by Samrt_baot on 14-1-17.
//  Copyright (c) 2014年 michael. All rights reserved.
//

#import "SelectPassengerViewController.h"
#import "AddNewPassengerViewController.h"

@interface SelectPassengerViewController ()

@property (strong, nonatomic) UITableView    *theTableView;
@property (strong, nonatomic) NSMutableArray *dataSource;

@property (strong, nonatomic) PassengerListViewController *passengerListViewController;
@property (strong, nonatomic) SelectProlicyViewController *selectProlicyViewController;

@property (strong, nonatomic) id             policyData;

@end

@implementation SelectPassengerViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(id)initWithBusinessType:(int)type
{
    self = [super init];
    if (self) {
        [self setSubviewFrameWithType:type];
    }
    return self;
}


- (void)pressNextStepBtn:(UIButton*)sender
{
    if ([_dataSource count] == 0) {
        [[Model shareModel] showPromptText:@"请选择乘客" model:NO];
    }else if (!_policyData){
        [[Model shareModel] showPromptText:@"请选择政策执行人" model:NO];
    }else{
        if ([self checkIDNumValidateWithData:_dataSource]) {
            [self popViewControllerTransitionType:TransitionNone completionHandler:^{
                [self.delegate selectPassengerDone:_dataSource policyName:_policyData bussinessType:_businessType];
            }];
        }
    }
}

#pragma  mark - select passenger handle
- (void)selectPassenger:(UIButton*)sender
{
    switch (sender.tag) {
        case 200:{
            if (!_passengerListViewController) {
                _passengerListViewController = [[PassengerListViewController alloc]init];
                [_passengerListViewController setDelegate:self];
            }
            [self pushViewController:_passengerListViewController transitionType:TransitionPush completionHandler:nil];
            break;
        }case 201:{
            [_theTableView setEditing:!_theTableView.editing animated:YES];
            break;
        }case 202:{
            AddNewPassengerViewController *viewController = [[AddNewPassengerViewController alloc]init];
            [self pushViewController:viewController transitionType:TransitionPush completionHandler:nil];
            break;
        }
        default:
            break;
    }
}

- (void)selectDone:(NSMutableArray*)array
{
    _dataSource = array;
    UIView *topBGView = [self.contentView viewWithTag:100];
    UIView *bottomBGView = [self.contentView viewWithTag:101];
    UIView *selectNameBtn = [topBGView viewWithTag:203];
    BOOL hidden = [array count] != 0;
    [selectNameBtn setHidden:hidden];
    [_theTableView setHidden:!hidden];
    
    [UIView animateWithDuration:0.25
                     animations:^{
                         if ([array count] != 0) {
                             [_theTableView setFrame:CGRectMake(_theTableView.frame.origin.x, _theTableView.frame.origin.y, _theTableView.frame.size.width, PassengerCustomCellHeight * [array count])];
                         }else{
                             [_theTableView setFrame:selectNameBtn.frame];
                         }
                         
                         [topBGView setFrame:CGRectMake(topBGView.frame.origin.x, topBGView.frame.origin.y, topBGView.frame.size.width, controlYLength(_theTableView) + 10)];
                         [bottomBGView setFrame:CGRectMake(bottomBGView.frame.origin.x, controlYLength(topBGView) + 5, bottomBGView.frame.size.width, bottomBGView.frame.size.height)];
                         
                     }completion:^(BOOL finished){
                         [_theTableView reloadData];
                         if (_passengerListViewController) {
                             if (![_passengerListViewController dataSource:_dataSource containsObject:_policyData]) {
                                 [self setPolicyData:nil];
                             }
                         }
                         [self.contentView resetContentSize];
                     }];
    
}


- (BOOL)checkIDNumValidateWithData:(NSArray*)data
{
    BOOL isValidate = YES;
    NSMutableString *promptText = [NSMutableString string];
    for (id object in data) {
        if (promptText.length != 0) {
            [promptText appendFormat:@"\n"];
        }
        BOOL objectIsValidate = NO;
        if ([object isKindOfClass:[GetLoginUserInfoResponse class]]) {
            GetLoginUserInfoResponse *userInfo = object;
            NSString *cardNumber = [userInfo getDefaultIDCard].CardNumber;
            NSLog(@"name = %@",cardNumber);
            objectIsValidate = [Utils isValidateIdNum:cardNumber];
            if (!objectIsValidate) {
                [promptText appendFormat:@"%@身份证号:%@",userInfo.UserName,[userInfo getDefaultIDCard].CardNumber];
                isValidate = objectIsValidate;
            }
        }else if ([object isKindOfClass:[BookPassengersResponse class]]){
            BookPassengersResponse *passenger = object;
            NSString *cardNumber = [passenger getDefaultIDCard].CardNumber;
            NSLog(@"name = %@",cardNumber);
            objectIsValidate = [Utils isValidateIdNum:cardNumber];
            if (!objectIsValidate) {
                [promptText appendFormat:@"%@身份证号:%@",passenger.UserName,[passenger getDefaultIDCard].CardNumber];
                isValidate = objectIsValidate;
            }
        }
    }
    if (!isValidate) {
        [[Model shareModel]showPromptText:[NSString stringWithFormat:@"下列用户身份证号码不正确\n%@\n请修改或重新选择",promptText] model:YES];
    }
    return isValidate;
}


#pragma mark - select prolicy
- (void)selectPolicy:(UIButton*)sender
{
    if (!_selectProlicyViewController) {
        _selectProlicyViewController = [[SelectProlicyViewController alloc]init];
        [_selectProlicyViewController setDelegate:self];
        [_selectProlicyViewController.view setHidden:YES];
        [self.view addSubview:_selectProlicyViewController.view];
    }
    
    if ([_dataSource count] != 0) {
        [_selectProlicyViewController setDataSource:_dataSource];
        [_selectProlicyViewController fire];
    }else{
        [[Model shareModel] showPromptText:@"请先选择乘客" model:NO];
    }
    
}

- (void)selectPolicyDone:(id)policy
{
    [self setPolicyData:policy];
    
}

- (void)selectPolicyCancel
{
    
}

- (void)setPolicyData:(id)policyData
{
    if (_policyData != policyData) {
        _policyData = policyData;
    }
    
    UIView *BottomBGView = [self.contentView viewWithTag:101];
    UIView *bottomBG     = [BottomBGView viewWithTag:102];
    UIButton *policyBtn  = (UIButton*)[BottomBGView viewWithTag:500];
    UILabel *policyLb    = (UILabel*)[BottomBGView viewWithTag:501];
    UIView *promptLabel  = [BottomBGView viewWithTag:502];
    UIView *nextBtn      = [BottomBGView viewWithTag:503];
    UILabel *policyShowLabel = (UILabel*)[BottomBGView viewWithTag:504];
    if (policyData) {
        [policyLb setHidden:NO];
        [policyBtn setTitle:nil forState:UIControlStateNormal];
        
        if ([policyData isKindOfClass:[CorpStaffDTO class]]) {
            CorpStaffDTO *corpStaff = policyData;
            [policyLb setText:[NSString stringWithFormat:@"政策执行人:%@",corpStaff.UserName]];
        }else if ([policyData isKindOfClass:[BookPassengersResponse class]]){
            BookPassengersResponse *contact = policyData;
            [policyLb setText:[NSString stringWithFormat:@"政策执行人:%@",contact.UserName]];
        }
        
        NSString *policyText = nil;
        if ([policyData isKindOfClass:[CorpStaffDTO class]]) {
            CorpStaffDTO *corpStaff = policyData;
            policyText = [NSString stringWithFormat:@"该用户所应用的机票预订差旅政策规则:%@",corpStaff.PolicyName];
        }else if ([policyData isKindOfClass:[BookPassengersResponse class]]){
            BookPassengersResponse *contact = policyData;
            policyText = [NSString stringWithFormat:@"该用户所应用的机票预订差旅政策规则:%@",contact.PolicyName];
        }
        CGFloat showLabelHeight = [Utils heightForWidth:promptLabel.frame.size.width text:policyText font:[UIFont systemFontOfSize:14]] > 40?[Utils heightForWidth:promptLabel.frame.size.width text:policyText font:[UIFont systemFontOfSize:14]]:40;
        
        if (!policyShowLabel) {
            policyShowLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, controlYLength(promptLabel), promptLabel.frame.size.width, 0)];
            [policyShowLabel setBackgroundColor:color(clearColor)];
            [policyShowLabel setFont:[UIFont systemFontOfSize:14]];
            [policyShowLabel setTextColor:color(blueColor)];
            [policyShowLabel setTag:504];
            [policyShowLabel setTextAlignment:NSTextAlignmentCenter];
            [policyShowLabel setAutoBreakLine:YES];
            [BottomBGView addSubview:policyShowLabel];
        }
        [policyShowLabel setAlpha:1];
        [UIView animateWithDuration:0.25
                         animations:^{
                             [policyShowLabel setFrame:CGRectMake(policyShowLabel.frame.origin.x, policyShowLabel.frame.origin.y, policyShowLabel.frame.size.width, showLabelHeight)];
                             [bottomBG setFrame:CGRectMake(bottomBG.frame.origin.x, bottomBG.frame.origin.y, bottomBG.frame.size.width,controlYLength(policyShowLabel))];
                             [nextBtn setFrame:CGRectMake(nextBtn.frame.origin.x, controlYLength(policyShowLabel) + 20, nextBtn.frame.size.width, nextBtn.frame.size.height)];
                             [BottomBGView setFrame:CGRectMake(BottomBGView.frame.origin.x, BottomBGView.frame.origin.y, BottomBGView.frame.size.width, controlYLength(nextBtn))];
                         }completion:^(BOOL finished){
                             [policyShowLabel setText:policyText];
                         }];
        
    }else{
        [policyLb setHidden:YES];
        [policyBtn setTitle:@"政策执行人" forState:UIControlStateNormal];
        
        [UIView animateWithDuration:0.25
                         animations:^{
                             [policyShowLabel setAlpha:0];
                             [bottomBG setFrame:CGRectMake(bottomBG.frame.origin.x, bottomBG.frame.origin.y, bottomBG.frame.size.width,controlYLength(promptLabel))];
                             [nextBtn setFrame:CGRectMake(nextBtn.frame.origin.x, controlYLength(promptLabel) + 20, nextBtn.frame.size.width, nextBtn.frame.size.height)];
                             [BottomBGView setFrame:CGRectMake(BottomBGView.frame.origin.x, BottomBGView.frame.origin.y, BottomBGView.frame.size.width, controlYLength(nextBtn))];
                         }completion:^(BOOL finished){
                             [policyShowLabel setText:nil];
                         }];
    }
    
    
}

#pragma mark - tableview handle
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return PassengerCustomCellHeight;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_dataSource count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *reuseIdentifier = @"cell";
    PassengerListCustomCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if (cell == nil) {
        cell = [[PassengerListCustomCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
        cell.withoutLeftImage = YES;
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    
    id object = [_dataSource objectAtIndex:indexPath.row];
    if ([object isKindOfClass:[CorpStaffDTO class]]) {
        CorpStaffDTO *corpStaff = object;
        cell.Name = corpStaff.UserName;
        
        MemberIDcardResponse *IDCardInfo = nil;
        for (MemberIDcardResponse *SubIDCardInfo in corpStaff.IDCardList) {
            if ([SubIDCardInfo.IsDefault isEqualToString:@"T"]) {
                IDCardInfo = SubIDCardInfo;
                break;
            }
        }
        
        if (IDCardInfo == nil) {
            if ([corpStaff.IDCardList count] != 0) {
                IDCardInfo = [corpStaff.IDCardList objectAtIndex:0];
            }
        }
        
        if (IDCardInfo != nil) {
            cell.UID = [NSString stringWithFormat:@"%@:%@",[IDCardInfo getCardTypeName],IDCardInfo.CardNumber];
        }
        
    }else if ([object isKindOfClass:[BookPassengersResponse class]]){
        BookPassengersResponse *contact = object;
        cell.Name = contact.UserName;
        
        MemberIDcardResponse *IDCardInfo = nil;
        for (MemberIDcardResponse *SubIDCardInfo in contact.IDCardList) {
            if ([SubIDCardInfo.IsDefault isEqualToString:@"T"]) {
                IDCardInfo = SubIDCardInfo;
                break;
            }
        }
        
        if (IDCardInfo == nil) {
            if ([contact.IDCardList count] != 0) {
                IDCardInfo = [contact.IDCardList objectAtIndex:0];
            }
        }
        
        if (IDCardInfo != nil) {
            cell.UID = [NSString stringWithFormat:@"%@:%@",[IDCardInfo getCardTypeName],IDCardInfo.CardNumber];
        }
    }
    
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        id editObject = [_dataSource objectAtIndex:indexPath.row];
        
        
        if (_passengerListViewController) {
            if ([_passengerListViewController dataSource:_dataSource containsObject:editObject]) {
                [_passengerListViewController dataSource:_dataSource removeObject:editObject];
            }
        }
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        
        [self selectDone:_dataSource];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    id object = [_dataSource objectAtIndex:indexPath.row];
    BookPassengersResponse *passenger = [self getPassengerWithParams:object];
    AddNewPassengerViewController *viewController = [[AddNewPassengerViewController alloc]initWithParams:passenger];
    [self pushViewController:viewController transitionType:TransitionPush completionHandler:nil];
}

- (BookPassengersResponse *)getPassengerWithParams:(id)params
{
    BookPassengersResponse *passenger = nil;
    if ([params isKindOfClass:[CorpStaffDTO class]]) {
        NSLog(@"params jsonDescription = %@",[params JSONRepresentation]);
        passenger = [[BookPassengersResponse alloc]init];
        [passenger parshJsonToResponse:[[params JSONRepresentation] JSONValue]];
    }else{
        passenger = params;
    }
    return passenger;
}

#pragma mark - view init
- (void)setSubviewFrameWithType:(int) type
{
    [self setBackGroundImage:imageNameAndType(@"home_bg", nil)];
    _businessType = type;
    if(type == 0){
        [self setTitle:@"选择乘客"];
    }else{
        [self setTitle:@"选择入住人"];
    }
    [self setTopBarBackGroundImage:imageNameAndType(@"topbar", nil)];
    
    UIButton *returnBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [returnBtn setBackgroundColor:color(clearColor)];
    [returnBtn setImage:imageNameAndType(@"return", nil) forState:UIControlStateNormal];
    [returnBtn setFrame:CGRectMake(0, 0, self.topBar.frame.size.height, self.topBar.frame.size.height)];
    [self setReturnButton:returnBtn];
    [self.view addSubview:returnBtn];
    
    [self setSubjoinViewFrame];
}

- (void)setSubjoinViewFrame
{
    [self.contentView setHidden:NO];
    
    UIView *topBGView = [[UIView alloc]initWithFrame:CGRectMake(10, controlYLength(self.topBar) + 10, appFrame.size.width - 20, 0)];
    [topBGView setBackgroundColor:color(whiteColor)];
    [topBGView setTag:100];
    [topBGView setBorderColor:color(lightGrayColor) width:1];
    [topBGView setCornerRadius:5];
    [self.contentView addSubview:topBGView];
    
    UILabel *selectedPassengerLb = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, topBGView.frame.size.width/3, 40)];
    [selectedPassengerLb setBackgroundColor:color(clearColor)];
    [selectedPassengerLb setTextColor:color(darkGrayColor)];
    [selectedPassengerLb setText:@"已选乘客"];
    [selectedPassengerLb setFont:[UIFont systemFontOfSize:13]];
    [topBGView addSubview:selectedPassengerLb];
    
    UIButton *selectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [selectBtn setFrame:CGRectMake(controlXLength(selectedPassengerLb), 5, (topBGView.frame.size.width - controlXLength(selectedPassengerLb) - 10)/3, 40 - 10)];
    [selectBtn setBackgroundImage:imageNameAndType(@"flight_btn_bg", nil) forState:UIControlStateNormal];
    [selectBtn setBackgroundImage:imageNameAndType(@"flight_btn_selected", nil) forState:UIControlStateHighlighted];
    [selectBtn setTitle:@"选择" forState:UIControlStateNormal];
    [selectBtn.titleLabel setFont:[UIFont systemFontOfSize:13]];
    [selectBtn setTag:200];
    [selectBtn addTarget:self action:@selector(selectPassenger:) forControlEvents:UIControlEventTouchUpInside];
    [selectBtn setTitleColor:color(blackColor) forState:UIControlStateNormal];
    [topBGView addSubview:selectBtn];
    
    UIButton *editBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [editBtn setFrame:CGRectMake(controlXLength(selectBtn), selectBtn.frame.origin.y, selectBtn.frame.size.width, selectBtn.frame.size.height)];
    [editBtn setBackgroundImage:imageNameAndType(@"flight_btn_bg", nil) forState:UIControlStateNormal];
    [editBtn setBackgroundImage:imageNameAndType(@"flight_btn_selected", nil) forState:UIControlStateHighlighted];
    [editBtn setTitle:@"编辑" forState:UIControlStateNormal];
    [editBtn.titleLabel setFont:[UIFont systemFontOfSize:13]];
    [editBtn setTag:201];
    [editBtn addTarget:self action:@selector(selectPassenger:) forControlEvents:UIControlEventTouchUpInside];
    [editBtn setTitleColor:color(blackColor) forState:UIControlStateNormal];
    [topBGView addSubview:editBtn];
    
    UIButton *addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [addBtn setFrame:CGRectMake(controlXLength(editBtn), selectBtn.frame.origin.y, selectBtn.frame.size.width, selectBtn.frame.size.height)];
    [addBtn setBackgroundImage:imageNameAndType(@"flight_btn_bg", nil) forState:UIControlStateNormal];
    [addBtn setBackgroundImage:imageNameAndType(@"flight_btn_selected", nil) forState:UIControlStateHighlighted];
    [addBtn setTitle:@"新增" forState:UIControlStateNormal];
    [addBtn.titleLabel setFont:[UIFont systemFontOfSize:13]];
    [addBtn setTag:202];
//    [addBtn setHidden:YES];
    [addBtn addTarget:self action:@selector(selectPassenger:) forControlEvents:UIControlEventTouchUpInside];
    [addBtn setTitleColor:color(blackColor) forState:UIControlStateNormal];
    [topBGView addSubview:addBtn];
    
    UIButton *selectNameBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [selectNameBtn setFrame:CGRectMake(selectedPassengerLb.frame.origin.x, controlYLength(selectedPassengerLb), topBGView.frame.size.width - selectedPassengerLb.frame.origin.x * 2, 50)];
    [selectNameBtn setBorderColor:color(lightGrayColor) width:0.5];
    [selectNameBtn setCornerRadius:2.5];
    [selectNameBtn setTag:203];
    [selectNameBtn setBackgroundColor:color(colorWithRed:237.0/255.0 green:245.0/255.0 blue:254.0/255.0 alpha:1)];
    [selectNameBtn setTitle:@"点击进入姓名库选取" forState:UIControlStateNormal];
    [selectNameBtn setTitleColor:color(darkGrayColor) forState:UIControlStateNormal];
    [topBGView addSubview:selectNameBtn];
    
    _theTableView = [[UITableView alloc]initWithFrame:selectNameBtn.frame];
    [_theTableView setBackgroundColor:color(clearColor)];
    [_theTableView setDataSource:self];
    [_theTableView setDelegate:self];
    [_theTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [_theTableView setScrollEnabled:NO];
    [_theTableView setHidden:YES];
    [topBGView addSubview:_theTableView];
    
    [topBGView setFrame:CGRectMake(topBGView.frame.origin.x, topBGView.frame.origin.y, topBGView.frame.size.width, controlYLength(_theTableView) + 10)];
    
    UIView *buttomBGView = [[UIView alloc]initWithFrame:CGRectMake(topBGView.frame.origin.x, controlYLength(topBGView) + 5, topBGView.frame.size.width, 0)];
    [buttomBGView setBackgroundColor:color(clearColor)];
    [buttomBGView setTag:101];
    [self.contentView addSubview:buttomBGView];
    
    UIView *buttomBG = [[UIView alloc]initWithFrame:CGRectMake(0, 0, buttomBGView.frame.size.width, 0)];
    [buttomBG setBorderColor:color(lightGrayColor) width:1];
    [buttomBG setCornerRadius:5];
    [buttomBG setTag:102];
    [buttomBG setBackgroundColor:color(whiteColor)];
    [buttomBGView addSubview:buttomBG];
    
    UIButton *selectPolicyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [selectPolicyBtn setFrame:CGRectMake(selectNameBtn.frame.origin.x, 0, buttomBGView.frame.size.width - 20, 40)];
    [selectPolicyBtn setBackgroundColor:color(clearColor)];
    [selectPolicyBtn setTitle:@"政策执行人" forState:UIControlStateNormal];
    [selectPolicyBtn setTitleColor:color(darkGrayColor) forState:UIControlStateNormal];
    [selectPolicyBtn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [selectPolicyBtn.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [selectPolicyBtn setTag:500];
    [selectPolicyBtn addTarget:self action:@selector(selectPolicy:) forControlEvents:UIControlEventTouchUpInside];
    [buttomBGView addSubview:selectPolicyBtn];
    
    UILabel *policyLb = [[UILabel alloc]initWithFrame:CGRectMake(selectPolicyBtn.frame.origin.x, selectPolicyBtn.frame.origin.y - 1.0, selectPolicyBtn.frame.size.width - 10, selectPolicyBtn.frame.size.height)];
    [policyLb setBackgroundColor:color(clearColor)];
    [policyLb setTextColor:color(darkGrayColor)];
    [policyLb setFont:[UIFont systemFontOfSize:14]];
    [policyLb setAutoSize:YES];
    [policyLb setHidden:YES];
    [policyLb setTag:501];
    [buttomBGView addSubview:policyLb];
    
    [buttomBG createLineWithParam:color(grayColor) frame:CGRectMake(0, controlYLength(selectPolicyBtn), buttomBG.frame.size.width, 0.5)];
    
    NSString *propmtText = [NSString stringWithFormat:@"%@\n%@",@"请确认本订单中的乘客可由相同的审核人授权",@"否则需要分开预定"];
    CGFloat promptLbHeight = [Utils heightForWidth:selectNameBtn.frame.size.width text:propmtText font:[UIFont systemFontOfSize:14]] > 40?[Utils heightForWidth:selectPolicyBtn.frame.size.width text:propmtText font:[UIFont systemFontOfSize:14]]:40;
    UILabel *promptTextLb = [[UILabel alloc]initWithFrame:CGRectMake(selectNameBtn.frame.origin.x, controlYLength(selectPolicyBtn), selectNameBtn.frame.size.width, promptLbHeight)];
    [promptTextLb setFont:[UIFont systemFontOfSize:14]];
    [promptTextLb setTextColor:color(darkGrayColor)];
    [promptTextLb setAutoBreakLine:YES];
    [promptTextLb setTag:502];
    [promptTextLb setTextAlignment:NSTextAlignmentCenter];
    [promptTextLb setText:propmtText];
    [buttomBGView addSubview:promptTextLb];
    
    [buttomBG setFrame:CGRectMake(buttomBG.frame.origin.x, buttomBG.frame.origin.y, buttomBG.frame.size.width, controlYLength(promptTextLb))];
    
    UIButton *nextStepBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [nextStepBtn setBackgroundColor:color(clearColor)];
    [nextStepBtn setTitle:@"下一步" forState:UIControlStateNormal];
    [nextStepBtn setTag:503];
    [nextStepBtn addTarget:self action:@selector(pressNextStepBtn:) forControlEvents:UIControlEventTouchUpInside];
    [nextStepBtn setFrame:CGRectMake(self.view.frame.size.width/4, controlYLength(buttomBG) + 20, self.view.frame.size.width/2, 40)];
    [nextStepBtn setBackgroundImage:imageNameAndType(@"hotel_done_nromal", nil) forState:UIControlStateNormal];
    [nextStepBtn setBackgroundImage:imageNameAndType(@"hotel_done_press", nil) forState:UIControlStateHighlighted];
    [buttomBGView addSubview:nextStepBtn];
    
    [buttomBGView setFrame:CGRectMake(buttomBGView.frame.origin.x, buttomBGView.frame.origin.y, buttomBGView.frame.size.width, controlYLength(nextStepBtn))];
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

@interface SelectProlicyViewController ()

@property (strong, nonatomic) UITableView   *theTableView;

@property (assign, nonatomic) CGAffineTransform transform;

@end

#define SelectPolicyCellHeight     40.0f
#define SelectPolicyHeaderHeight   40.0f

@implementation SelectProlicyViewController

- (id)init
{
    self = [super init];
    if (self) {
        [self setSubviewFrame];
    }
    return self;
}

- (void)fire
{
    [_theTableView setTransform:CGAffineTransformMakeScale(1, 0)];
    
    [self.view setHidden:NO];
    [self.view setAlpha:1];
    [self.view.superview bringSubviewToFront:self.view];
    [UIView animateWithDuration:0.25
                     animations:^{
                         [_theTableView setTransform:_transform];
                     }];
}

- (void)setDataSource:(NSArray *)dataSource
{
    _dataSource = dataSource;
    
    CGFloat tableViewHeight = SelectPolicyCellHeight * ([_dataSource count] + 1) > (self.view.frame.size.height - 150)?(self.view.frame.size.height - 150):SelectPolicyCellHeight * ([_dataSource count] + 1);
    [_theTableView setFrame:CGRectMake(0, 0, _theTableView.frame.size.width, tableViewHeight)];
    [_theTableView setCenter:self.view.center];
    [_theTableView reloadData];
}

- (void)selectProlicyNameDone:(id)prolicyName
{
    [UIView animateWithDuration:0.25
                     animations:^{
                         [self.view setAlpha:0.0];
                     }completion:^(BOOL finished){
                         [self.view setHidden:YES];
                         [self.delegate selectPolicyDone:prolicyName];
                     }];
}

- (void)selectProlicyNameCancel
{
    [UIView animateWithDuration:0.25
                     animations:^{
                         [self.view setAlpha:0.0];
                     }completion:^(BOOL finished){
                         [self.view setHidden:YES];
                         [self.delegate selectPolicyCancel];
                     }];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return SelectPolicyCellHeight;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_dataSource count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *reuseIdentifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
        [cell setSelectionStyle:UITableViewCellSelectionStyleGray];
        [cell.textLabel setAutoSize:YES];
        [cell.textLabel setFont:[UIFont systemFontOfSize:13]];
        [cell.textLabel setTextAlignment:NSTextAlignmentCenter];
        [cell setBackgroundColor:color(whiteColor)];
    }
    
    id object = [_dataSource objectAtIndex:indexPath.row];
    if ([object isKindOfClass:[CorpStaffDTO class]]) {
        CorpStaffDTO *corpStaff = object;
        [cell.textLabel setText:[NSString stringWithFormat:@"%@(%@)",corpStaff.UserName,corpStaff.PolicyName]];
    }else if ([object isKindOfClass:[BookPassengersResponse class]]){
        BookPassengersResponse *contact = object;
        [cell.textLabel setText:[NSString stringWithFormat:@"%@(%@)",contact.UserName,contact.PolicyName]];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    id object = [_dataSource objectAtIndex:indexPath.row];
    [self selectProlicyNameDone:object];
}

- (void)setSubviewFrame
{
    UIView *backGroundView = [[UIView alloc]initWithFrame:self.view.bounds];
    [backGroundView setBackgroundColor:color(blackColor)];
    [backGroundView setAlpha:0.35];
    [self.view addSubview:backGroundView];
    
    UILabel *headerView = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width - 100, 40)];
    [headerView setBackgroundColor:color(colorWithRed:35.0/255.0 green:55.0/255.0 blue:125.0/255.0 alpha:1)];
    [headerView setTextAlignment:NSTextAlignmentCenter];
    [headerView setText:@"政策执行人"];
    [headerView setTextColor:color(whiteColor)];
    _theTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, headerView.frame.size.width, [_dataSource count])];
    [_theTableView setBackgroundColor:color(clearColor)];
    [_theTableView setCenter:self.view.center];
    [_theTableView setDelegate:self];
    [_theTableView setDataSource:self];
    [_theTableView setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
    [_theTableView setTableHeaderView:headerView];
    _transform = _theTableView.transform;
    [self.view addSubview:_theTableView];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self selectProlicyNameCancel];
}

@end

