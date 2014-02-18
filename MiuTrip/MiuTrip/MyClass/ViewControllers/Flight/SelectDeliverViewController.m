//
//  SelectDeliverViewController.m
//  MiuTrip
//
//  Created by apple on 14-2-13.
//  Copyright (c) 2014年 michael. All rights reserved.
//

#import "SelectDeliverViewController.h"

@interface SelectDeliverViewController ()

@property (strong, nonatomic) NSArray       *dataSource;
@property (strong, nonatomic) UITableView   *theTableView;

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

#pragma mark - request handle
- (void)getMemberDeliverList:(id)policyPerson
{
    GetMemberDeliverListRequest *request = [self getRequestWithPolicy:policyPerson];
    if (request) {
        [self.requestManager sendRequest:request];
    }
}

- (GetMemberDeliverListRequest*)getRequestWithPolicy:(id)policy
{
    GetMemberDeliverListRequest *request = [[GetMemberDeliverListRequest alloc]initWidthBusinessType:BUSINESS_ACCOUNT methodName:@"GetMemberDeliverList"];
//    if ([policy isKindOfClass:[BookPassengersResponse class]]) {
//        BookPassengersResponse *passenger = policy;
//        [request setUid:passenger.CorpUID];
//    }else if ([policy isKindOfClass:[GetLoginUserInfoResponse class]]){
//        GetLoginUserInfoResponse *loginfo = policy;
//        [request setUid:loginfo.UID];
//    }else{
//        request = nil;
//        [[Model shareModel] showPromptText:@"联系人UID不正确" model:YES];
//    }
    return request;
}

- (void)getMemberDeliverListDone:(GetMemberDeliverListResponse*)response
{
    [response getObjects];
    _dataSource = response.delivers;
    [_theTableView reloadData];
}

- (void)requestDone:(BaseResponseModel *)response
{
    if ([response isKindOfClass:[GetMemberDeliverListResponse class]]) {
        [self getMemberDeliverListDone:(GetMemberDeliverListResponse*)response];
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
    MemberDeliverDTO *deliverDTO = [_dataSource objectAtIndex:indexPath.row];
    [cell.textLabel setText:[NSString stringWithFormat:@"收件人:%@\t邮编:%@",deliverDTO.RecipientName,deliverDTO.ZipCode]];
    [cell.detailTextLabel setText:[NSString stringWithFormat:@"地址:%@(省)%@(市)%@(区)%@",deliverDTO.ProvinceName,deliverDTO.CityName,deliverDTO.Canton_Name,deliverDTO.Address]];
    
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
