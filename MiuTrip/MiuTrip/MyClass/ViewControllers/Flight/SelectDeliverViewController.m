//
//  SelectDeliverViewController.m
//  MiuTrip
//
//  Created by apple on 14-2-13.
//  Copyright (c) 2014年 michael. All rights reserved.
//

#import "SelectDeliverViewController.h"
#import "GetCorpInfoRequest.h"

@interface SelectDeliverViewController ()

@property (strong, nonatomic) NSArray       *dataSource;
@property (strong, nonatomic) UITableView   *theTableView;

@property (assign, nonatomic) DeliverType   deliverType;

@end

@implementation SelectDeliverViewController

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
        [self setSubviewFrame];
    }
    return self;
}

- (id)initWithDeliverType:(DeliverType)deliverType
{
    self = [super init];
    if (self) {
        _deliverType = deliverType;
        [self setSubviewFrame];
    }
    return self;
}

#pragma mark - request handle
- (void)getDeliverList:(id)policyPerson
{
    if (_deliverType == DeliverAtRegular) {
        [self getCorpDeliverList:policyPerson];
    }else if (_deliverType == DeliverCommon){
        [self getMemberDeliverList:policyPerson];
    }
}

- (void)getMemberDeliverList:(id)policyPerson
{
    GetMemberDeliverListRequest *request = (GetMemberDeliverListRequest*)[self getRequestWithPolicy:policyPerson];
    if (request) {
        [self.requestManager sendRequest:request];
    }
}

- (void)getMemberDeliverListDone:(GetMemberDeliverListResponse*)response
{
    [response getObjects];
    _dataSource = response.delivers;
    [_theTableView reloadData];
}

- (void)getCorpDeliverList:(id)policyPerson
{
    GetCorpInfoRequest *request = (GetCorpInfoRequest*)[self getRequestWithPolicy:policyPerson];
    if (request) {
        [self.requestManager sendRequest:request];
    }
}

- (void)getCorpDeliverDone:(GetCorpInfoResponse*)response
{
    [response getObjects];
    _dataSource = response.Corp_AddressList;
    [_theTableView reloadData];
}

- (BaseRequestModel*)getRequestWithPolicy:(id)policy
{
    if (_deliverType == DeliverAtRegular) {
        GetCorpInfoRequest *request = [[GetCorpInfoRequest alloc]initWidthBusinessType:BUSINESS_ACCOUNT methodName:@"GetCorpInfo"];
        [request setCorpID:[NSString stringWithFormat:@"%@",[UserDefaults shareUserDefault].loginInfo.CorpID]];
        
        return request;
    }else{
        GetMemberDeliverListRequest *request = [[GetMemberDeliverListRequest alloc]initWidthBusinessType:BUSINESS_ACCOUNT methodName:@"GetMemberDeliverList"];
        return request;
    }
    
}

- (void)requestDone:(BaseResponseModel *)response
{
    if ([response isKindOfClass:[GetMemberDeliverListResponse class]]) {
        [self getMemberDeliverListDone:(GetMemberDeliverListResponse*)response];
    }else if ([response isKindOfClass:[GetCorpInfoResponse class]]){
        [self getCorpDeliverDone:(GetCorpInfoResponse*)response];
    }
}

- (void)requestFailedWithErrorCode:(NSNumber *)errorCode withErrorMsg:(NSString *)errorMsg
{
    
}

#pragma mark - table view handle
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50.0f;
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
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuseIdentifier];
        [cell.textLabel setAutoSize:YES];
        [cell.detailTextLabel setAutoSize:YES];
    }
    id deliverDTO = [_dataSource objectAtIndex:indexPath.row];
    if ([deliverDTO isKindOfClass:[MemberDeliverDTO class]]) {
        MemberDeliverDTO *memberDeliver = deliverDTO;
        [cell.textLabel setText:[NSString stringWithFormat:@"收件人:%@\t邮编:%@",memberDeliver.RecipientName,memberDeliver.ZipCode]];
        [cell.detailTextLabel setText:[NSString stringWithFormat:@"地址:%@(省)%@(市)%@(区)%@",memberDeliver.ProvinceName,memberDeliver.CityName,memberDeliver.Canton_Name,memberDeliver.Address]];
    }else if ([deliverDTO isKindOfClass:[Corp_AddressResponse class]]){
        Corp_AddressResponse *corpDeliver = deliverDTO;
        [cell.textLabel setText:[NSString stringWithFormat:@"收件人:%@\t邮编:%@",corpDeliver.RecipientName,corpDeliver.ZipCode]];
        [cell.detailTextLabel setText:[NSString stringWithFormat:@"地址:%@(省)%@(市)%@(区)%@",corpDeliver.ProvinceName,corpDeliver.CityName,corpDeliver.CantonName,corpDeliver.Address]];
    }
    
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    MemberDeliverDTO *deliverDTO = [_dataSource objectAtIndex:indexPath.row];
    [self popViewControllerTransitionType:TransitionPush completionHandler:^{
        [self.delegate selectDeliverDone:deliverDTO];
    }];
}

#pragma mark - view init
- (void)setSubviewFrame
{
    [self setBackGroundImage:imageNameAndType(@"home_bg", nil)];
    [self setTitle:@"选择配送地址"];
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
    _theTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, controlYLength(self.topBar), self.view.frame.size.width, self.view.frame.size.height - controlYLength(self.topBar) - self.bottomBar.frame.size.height)];
    [_theTableView setBackgroundColor:color(whiteColor)];
    [_theTableView setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
    [_theTableView setDelegate:self];
    [_theTableView setDataSource:self];
    [self.view addSubview:_theTableView];
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
