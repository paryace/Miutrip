//
//  PassengerListViewController.m
//  MiuTrip
//
//  Created by Samrt_baot on 14-1-17.
//  Copyright (c) 2014年 michael. All rights reserved.
//

#import "PassengerListViewController.h"
#import "Common.h"

@interface PassengerListViewController ()

@property (strong, nonatomic) UITableView       *theTableView;
@property (strong, nonatomic) NSMutableArray    *allDataSource;
@property (strong, nonatomic) NSMutableArray    *usDataSource;
@property (strong, nonatomic) NSMutableArray    *commonDataSource;
@property (strong, nonatomic) NSMutableArray    *dataSource;

@property (strong, nonatomic) NSMutableArray  *segmentItems;


@end

@implementation PassengerListViewController

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
    self = [super init];
    if (self) {
        _selectedPassengers = [NSMutableArray array];
        [self setSubviewFrame];
    }
    return self;
}

- (void)getContacts
{
    [self addLoadingView];
    if (![UserDefaults shareUserDefault].loginInfo) {
        
    }
    GetContactRequest *request = [[GetContactRequest alloc]initWidthBusinessType:BUSINESS_ACCOUNT methodName:@"GetContact"];
    [request setCorpID:[UserDefaults shareUserDefault].loginInfo.CorpID];
    [self.requestManager sendRequest:request];
}

- (void)removeAllContacts
{
    
}

- (void)getContactsDone:(GetContactResponse*)response
{
    [self removeLoadingView];
    [response getObjects];
    _commonDataSource = [NSMutableArray arrayWithArray:response.result];
    _dataSource = _commonDataSource;
    [_theTableView reloadData];
}

- (void)getAllCorpStaff
{
    [self addLoadingView];
    GetCorpStaffRequest *request = [[GetCorpStaffRequest alloc]initWidthBusinessType:BUSINESS_ACCOUNT methodName:@"GetCorpStaff"];
    [request setCorpID:[UserDefaults shareUserDefault].loginInfo.CorpID];
    [self.requestManager sendRequest:request];
}

- (void)removeAllCorpStaff
{
    
}

- (void)getAllCorpStaffDone:(GetCorpStaffResponse*)response
{
    [self removeLoadingView];
    [response getObjects];
    _allDataSource = [NSMutableArray arrayWithArray:response.customers];
    _dataSource = _allDataSource;
    if (!_usDataSource) {
        _usDataSource = [NSMutableArray array];
    }
    [_usDataSource removeAllObjects];
    for (CorpStaffDTO *staff in response.customers) {
        if ([staff.DeptID integerValue] == [[UserDefaults shareUserDefault].loginInfo.DeptID integerValue]) {
            [_usDataSource addObject:staff];
        }
    }
    
    [_theTableView reloadData];
}

- (void)requestDone:(BaseResponseModel *)response
{
    if ([response isKindOfClass:[GetContactResponse class]]) {
        [self getContactsDone:(GetContactResponse*)response];
    }else if ([response isKindOfClass:[GetCorpStaffResponse class]]){
        [self getAllCorpStaffDone:(GetCorpStaffResponse*)response];
    }
}

-(void)requestFailedWithErrorCode:(NSNumber *)errorCode withErrorMsg:(NSString *)errorMsg
{
    
}

- (void)segmentedChangeSelectedIndex:(UISegmentedControl*)sender
{
    NSInteger selectedIndex = sender.selectedSegmentIndex;
    [self changeContactPage:selectedIndex];
}

- (void)changeContactPage:(NSInteger)pageNum
{
    for (UIButton *btn in _segmentItems) {
        [btn setHighlighted:(btn.tag - 300) == pageNum];
    }

    switch (pageNum) {
        case 0:{
            if ([_usDataSource count] == 0) {
                [self getAllCorpStaff];
            }else{
                _dataSource = _usDataSource;
                [_theTableView reloadData];
            }
            break;
        }case 1:{
            if ([_allDataSource count] == 0) {
                [self getAllCorpStaff];
            }else{
                _dataSource = _allDataSource;
                [_theTableView reloadData];
            }
            break;
        }case 2:{
            if ([_commonDataSource count] == 0) {
                [self getContacts];
            }else{
                _dataSource = _commonDataSource;
                [_theTableView reloadData];
            }
            break;
        }
        default:
            break;
    }
}

- (void)pressRightBtn:(UIButton*)sender
{
    [self popViewControllerTransitionType:TransitionPush completionHandler:^{
        [self.delegate selectDone:_selectedPassengers];
    }];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 35.0f;
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
    }
    
    id object = [_dataSource objectAtIndex:indexPath.row];
    if ([object isKindOfClass:[CorpStaffDTO class]]) {
        CorpStaffDTO *corpStaff = object;
        cell.Name = corpStaff.UserName;
        cell.UID = corpStaff.CorpUID;
        cell.DeptName = corpStaff.DeptName;
        cell.leftImageHighlighted = [self dataSource:_selectedPassengers containsObject:object];
    }else if ([object isKindOfClass:[BookPassengersResponse class]]){
        BookPassengersResponse *contact = object;
        cell.Name = contact.UserName;
        cell.UID = contact.CorpUID;
        cell.DeptName = contact.DeptName;
        cell.leftImageHighlighted = [self dataSource:_selectedPassengers containsObject:object];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //...
    id object = [_dataSource objectAtIndex:indexPath.row];
    
    if (![self dataSource:_selectedPassengers containsObject:object]) {
        [_selectedPassengers addObject:object];
    }
    else {
        [self dataSource:_selectedPassengers removeObject:object];
    }
    
    [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
}


- (void)dataSource:(NSMutableArray*)dataSource removeObject:(id)object
{
    if ([object isKindOfClass:[CorpStaffDTO class]]) {
        CorpStaffDTO *staff = object;
        staff.CorpUID = [Utils NULLToEmpty:staff.CorpUID];
        NSMutableArray *removeObjects = [NSMutableArray array];
        for (id subObject in dataSource) {
            if ([subObject isKindOfClass:[CorpStaffDTO class]]) {
                CorpStaffDTO *subStaff = subObject;
                if ([staff.CorpUID isEqualToString:subStaff.CorpUID]) {
                    [removeObjects addObject:subObject];
                }
            }else if ([subObject isKindOfClass:[BookPassengersResponse class]]){
                BookPassengersResponse *passenger = subObject;
                if ([passenger.CorpUID isEqualToString:staff.CorpUID]) {
                    [removeObjects addObject:subObject];
                }
            }else if ([subObject isKindOfClass:[GetLoginUserInfoResponse class]]){
                GetLoginUserInfoResponse *logInfo = subObject;
                if ([logInfo.UID isEqualToString:staff.CorpUID]) {
                    [removeObjects addObject:logInfo];
                }
            }
        }
        
        for (id removeObject in removeObjects) {
            if ([dataSource containsObject:removeObject]) {
                [dataSource removeObject:removeObject];
            }
        }
        
    }else if ([object isKindOfClass:[BookPassengersResponse class]]){
        BookPassengersResponse *passenger = object;
        passenger.CorpUID = [Utils NULLToEmpty:passenger.CorpUID];
        NSMutableArray *removeObjects = [NSMutableArray array];
        for (id subObject in dataSource) {
            if ([subObject isKindOfClass:[CorpStaffDTO class]]) {
                CorpStaffDTO *subStaff = subObject;
                if ([passenger.CorpUID isEqualToString:subStaff.CorpUID]) {
                    [removeObjects addObject:subObject];
                }
            }else if ([subObject isKindOfClass:[BookPassengersResponse class]]){
                BookPassengersResponse *subPassenger = subObject;
                if ([passenger.CorpUID isEqualToString:subPassenger.CorpUID]) {
                    [removeObjects addObject:subObject];
                }
            }else if ([subObject isKindOfClass:[GetLoginUserInfoResponse class]]){
                GetLoginUserInfoResponse *logInfo = subObject;
                if ([logInfo.UID isEqualToString:passenger.CorpUID]) {
                    [removeObjects addObject:logInfo];
                }
            }
        }
        
        for (id removeObject in removeObjects) {
            if ([dataSource containsObject:removeObject]) {
                [dataSource removeObject:removeObject];
            }
        }
    }
}

- (BOOL)dataSource:(NSMutableArray*)dataSource containsObject:(id)object
{
    BOOL contains = NO;
    if ([object isKindOfClass:[CorpStaffDTO class]]) {
        CorpStaffDTO *staff = object;
        staff.CorpUID = [Utils NULLToEmpty:staff.CorpUID];
        for (id subObject in dataSource) {
            if ([subObject isKindOfClass:[CorpStaffDTO class]]) {
                CorpStaffDTO *subStaff = subObject;
                if ([staff.CorpUID isEqualToString:subStaff.CorpUID]) {
                    contains = YES;
                }
            }else if ([subObject isKindOfClass:[BookPassengersResponse class]]){
                BookPassengersResponse *passenger = subObject;
                if ([passenger.CorpUID isEqualToString:staff.CorpUID]) {
                    contains = YES;
                }
            }else if ([subObject isKindOfClass:[GetLoginUserInfoResponse class]]){
                GetLoginUserInfoResponse *subLogInfo = subObject;
                if ([staff.CorpUID isEqualToString:subLogInfo.UID]) {
                    contains = YES;
                }
            }
        }
    }else if ([object isKindOfClass:[BookPassengersResponse class]]){
        BookPassengersResponse *passenger = object;
        passenger.CorpUID = [Utils NULLToEmpty:passenger.CorpUID];
        for (id subObject in dataSource) {
            if ([subObject isKindOfClass:[CorpStaffDTO class]]) {
                CorpStaffDTO *subStaff = subObject;
                if ([passenger.CorpUID isEqualToString:subStaff.CorpUID]) {
                    contains = YES;
                }
            }else if ([subObject isKindOfClass:[BookPassengersResponse class]]){
                BookPassengersResponse *subPassenger = subObject;
                if ([passenger.CorpUID isEqualToString:subPassenger.CorpUID]) {
                    contains = YES;
                }
            }else if ([subObject isKindOfClass:[GetLoginUserInfoResponse class]]){
                GetLoginUserInfoResponse *subLogInfo = subObject;
                if ([passenger.CorpUID isEqualToString:subLogInfo.UID]) {
                    contains = YES;
                }
            }
        }
    }
    
    return contains;
}

#pragma mark - view init
- (void)setSubviewFrame
{
    [self setBackGroundImage:imageNameAndType(@"home_bg", nil)];
    [self setTitle:@"选择乘客"];
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
    if (!_segmentItems) {
        _segmentItems = [NSMutableArray array];
    }
    [_segmentItems removeAllObjects];
    
    UIButton *usPageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [usPageBtn setFrame:CGRectMake(0, controlYLength(self.topBar), appFrame.size.width/3, 40)];
    [usPageBtn setBackgroundColor:color(clearColor)];
    [usPageBtn setTag:300];
    [usPageBtn setBackgroundImage:imageNameAndType(@"tab_no_selected", nil) forState:UIControlStateNormal];
    [usPageBtn setBackgroundImage:imageNameAndType(@"tab_selected", nil) forState:UIControlStateHighlighted];
    [usPageBtn.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [usPageBtn setTitle:@"本部门员工" forState:UIControlStateNormal];
    [usPageBtn setTitleColor:color(blackColor) forState:UIControlStateNormal];
    [usPageBtn setTitleColor:color(whiteColor) forState:UIControlStateHighlighted];
    [self.view addSubview:usPageBtn];
    [_segmentItems addObject:usPageBtn];
    
    UIButton *allPageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [allPageBtn setFrame:CGRectMake(controlXLength(usPageBtn), usPageBtn.frame.origin.y, usPageBtn.frame.size.width, usPageBtn.frame.size.height)];
    [allPageBtn setBackgroundColor:color(clearColor)];
    [allPageBtn setTag:301];
    [allPageBtn setBackgroundImage:imageNameAndType(@"tab_no_selected", nil) forState:UIControlStateNormal];
    [allPageBtn setBackgroundImage:imageNameAndType(@"tab_selected", nil) forState:UIControlStateHighlighted];
    [allPageBtn.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [allPageBtn setTitle:@"全部员工" forState:UIControlStateNormal];
    [allPageBtn setTitleColor:color(blackColor) forState:UIControlStateNormal];
    [allPageBtn setTitleColor:color(whiteColor) forState:UIControlStateHighlighted];
    [self.view addSubview:allPageBtn];
    [_segmentItems addObject:allPageBtn];
    
    UIButton *commonPageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [commonPageBtn setFrame:CGRectMake(controlXLength(allPageBtn), usPageBtn.frame.origin.y, usPageBtn.frame.size.width, usPageBtn.frame.size.height)];
    [commonPageBtn setBackgroundColor:color(clearColor)];
    [commonPageBtn setTag:302];
    [commonPageBtn setBackgroundImage:imageNameAndType(@"tab_no_selected", nil) forState:UIControlStateNormal];
    [commonPageBtn setBackgroundImage:imageNameAndType(@"tab_selected", nil) forState:UIControlStateHighlighted];
    [commonPageBtn.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [commonPageBtn setTitle:@"常用联系人" forState:UIControlStateNormal];
    [commonPageBtn setTitleColor:color(blackColor) forState:UIControlStateNormal];
    [commonPageBtn setTitleColor:color(whiteColor) forState:UIControlStateHighlighted];
    [self.view addSubview:commonPageBtn];
    [_segmentItems addObject:commonPageBtn];
    
    UISegmentedControl *segmentedControl = [[UISegmentedControl alloc]initWithItems:@[@"",@"",@""]];
    [segmentedControl setFrame:CGRectMake(0, controlYLength(self.topBar), self.view.frame.size.width, usPageBtn.frame.size.height)];
    [segmentedControl setBackgroundColor:color(clearColor)];
    [segmentedControl setAlpha:0.1];
    [segmentedControl setTintColor:color(clearColor)];
    [segmentedControl addTarget:self action:@selector(segmentedChangeSelectedIndex:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:segmentedControl];
    
    _theTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, controlYLength(segmentedControl), self.view.frame.size.width, self.view.frame.size.height - self.bottomBar.frame.size.height - controlYLength(segmentedControl))];
    [_theTableView setDataSource:self];
    [_theTableView setDelegate:self];
    [_theTableView setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
    [self.view addSubview:_theTableView];
    
    [self changeContactPage:1];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [_theTableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

@interface PassengerListCustomCell ()

@end

@implementation PassengerListCustomCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setSubviewFrame];
    }
    return self;
}

- (void)setSubviewFrame
{
    UIImageView *leftImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, PassengerCustomCellHeight, PassengerCustomCellHeight)];
    [leftImageView setBackgroundColor:color(clearColor)];
    [leftImageView setTag:250];
    [leftImageView setImage:imageNameAndType(@"autolog_normal", nil)];
    [leftImageView setHighlightedImage:imageNameAndType(@"autolog_select", nil)];
    [self.contentView addSubview:leftImageView];
    
    UILabel *nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(controlXLength(leftImageView), 0, (appFrame.size.width - controlXLength(leftImageView))/3, PassengerCustomCellHeight)];
    [nameLabel setBackgroundColor:color(clearColor)];
    [nameLabel setTextAlignment:NSTextAlignmentLeft];
    [nameLabel setFont:[UIFont systemFontOfSize:13]];
    [nameLabel setTag:200];
    [nameLabel setAutoSize:YES];
    [self.contentView addSubview:nameLabel];
    
    UILabel *UIDLabel = [[UILabel alloc]initWithFrame:CGRectMake(controlXLength(nameLabel), nameLabel.frame.origin.y, nameLabel.frame.size.width, nameLabel.frame.size.height)];
    [UIDLabel setBackgroundColor:color(clearColor)];
    [UIDLabel setTextAlignment:NSTextAlignmentLeft];
    [UIDLabel setFont:[UIFont systemFontOfSize:13]];
    [UIDLabel setTag:201];
    [UIDLabel setAutoSize:YES];
    [self.contentView addSubview:UIDLabel];
    
    UILabel *deptIDLabel = [[UILabel alloc]initWithFrame:CGRectMake(controlXLength(UIDLabel), nameLabel.frame.origin.y, nameLabel.frame.size.width, nameLabel.frame.size.height)];
    [deptIDLabel setBackgroundColor:color(clearColor)];
    [deptIDLabel setTextAlignment:NSTextAlignmentLeft];
    [deptIDLabel setFont:[UIFont systemFontOfSize:13]];
    [deptIDLabel setTag:202];
    [deptIDLabel setAutoSize:YES];
    [self.contentView addSubview:deptIDLabel];
    
    [leftImageView setScaleX:0.6 scaleY:0.6];
}

- (void)setName:(NSString *)name
{
    if (_Name != name) {
        _Name = name;
    }
    UILabel *nameLabel = (UILabel*)[self.contentView viewWithTag:200];
    [nameLabel setText:[Utils NULLToEmpty:name]];
}

- (void)setUID:(NSString *)UID
{
    if (_UID != UID) {
        _UID = UID;
    }
    UILabel *UIDLabel = (UILabel*)[self.contentView viewWithTag:201];
    [UIDLabel setText:[Utils NULLToEmpty:UID]];
}

- (void)setDeptName:(NSString *)DeptName
{
    if (_DeptName != DeptName) {
        _DeptName = DeptName;
    }
    UILabel *deptIDLabel = (UILabel*)[self.contentView viewWithTag:202];
    [deptIDLabel setText:[Utils NULLToEmpty:DeptName]];
}

- (void)setLeftImageHighlighted:(BOOL)leftImageHighlighted
{
    if (_leftImageHighlighted !=  leftImageHighlighted) {
        _leftImageHighlighted = leftImageHighlighted;
    }
    UIImageView *imageView = (UIImageView*)[self.contentView viewWithTag:250];
    [imageView setHighlighted:leftImageHighlighted];
}

- (void)setWithoutLeftImage:(BOOL)withoutLeftImage
{
    UIView *leftImageView = [self.contentView viewWithTag:250];
    [leftImageView setHidden:withoutLeftImage];
    
    if (withoutLeftImage) {
        
        UIView *nameLabel = [self.contentView viewWithTag:200];
        [nameLabel setFrame:CGRectMake(0, nameLabel.frame.origin.y, nameLabel.frame.size.width, nameLabel.frame.size.height)];
        
        UIView *UIDLabel = [self.contentView viewWithTag:201];
        [UIDLabel setFrame:CGRectMake(controlXLength(nameLabel), UIDLabel.frame.origin.y, UIDLabel.frame.size.width * 2, UIDLabel.frame.size.height)];
        
        UIView *DeptNameLabel = [self.contentView viewWithTag:202];
        [DeptNameLabel setHidden:YES];
    }else{
        
        UIView *nameLabel = [self.contentView viewWithTag:200];
        [nameLabel setFrame:CGRectMake(controlXLength(leftImageView), nameLabel.frame.origin.y, nameLabel.frame.size.width, nameLabel.frame.size.height)];
        
        UIView *UIDLabel = [self.contentView viewWithTag:201];
        [UIDLabel setFrame:CGRectMake(controlXLength(nameLabel), UIDLabel.frame.origin.y, UIDLabel.frame.size.width, UIDLabel.frame.size.height)];
        
        UIView *DeptNameLabel = [self.contentView viewWithTag:202];
        [DeptNameLabel setHidden:NO];
        [DeptNameLabel setFrame:CGRectMake(controlXLength(UIDLabel), DeptNameLabel.frame.origin.y, DeptNameLabel.frame.size.width, DeptNameLabel.frame.size.height)];
    }
}

@end
