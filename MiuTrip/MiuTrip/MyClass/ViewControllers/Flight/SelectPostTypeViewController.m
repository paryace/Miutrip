//
//  SelectPostTypeViewController.m
//  MiuTrip
//
//  Created by apple on 14-2-13.
//  Copyright (c) 2014年 michael. All rights reserved.
//

#import "SelectPostTypeViewController.h"
#import "PostTypeViewController.h"
#import "CustomMethod.h"

@interface SelectPostTypeViewController ()

@property (strong, nonatomic) UITableView   *theTableView;
@property (strong, nonatomic) NSArray       *dataSource;

@property (strong, nonatomic) RequestManager *requestManager;
@property (strong, nonatomic) UIActivityIndicatorView   *indicatorView;

@property (assign, nonatomic) BOOL          getDone;

@end

@implementation SelectPostTypeViewController

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
        _getDone = NO;
        [self setSubviewFrame];
    }
    return self;
}

- (void)done:(PostType*)postType
{
    [self popViewControllerTransitionType:TransitionPush completionHandler:^{
        [self.delegate selectPostTypeDone:postType];
    }];
}

- (void)cancel
{
    [self popViewControllerTransitionType:TransitionPush completionHandler:nil];
}

#pragma mark - getApiMailConfig
- (void)getMailConfigRequest
{
    [_indicatorView startAnimating];
    GetMailConfigRequest *request = [[GetMailConfigRequest alloc]initWidthBusinessType:BUSINESS_FLIGHT methodName:@"GetAPIMailConfig"];
    [request setOTAType:[UserDefaults shareUserDefault].OTAType];
    
    [self.requestManager sendRequest:request];
}

- (void)getMailConfigDone:(GetMailConfigResponse*)response
{
    if ([response.mList count] != 0) {
        [response getObjects];
        _getDone = YES;
        _dataSource = response.mList;
        [_theTableView reloadData];
    }else{
        [[Model shareModel] showPromptText:@"未找到配送信息" model:YES];
    }
}

- (void)requestDone:(BaseResponseModel *)response
{
    [_indicatorView stopAnimating];
    if ([response isKindOfClass:[GetMailConfigResponse class]]) {
        [self getMailConfigDone:(GetMailConfigResponse*)response];
    }
}

- (void)requestFailedWithErrorCode:(NSNumber *)errorCode withErrorMsg:(NSString *)errorMsg
{
    
}

#pragma mark - table view handle
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40.0f;
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
    }
    TC_APImInfo *postType = [_dataSource objectAtIndex:indexPath.row];
    [cell.textLabel setText:postType.mName];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    PostType *postType = [_dataSource objectAtIndex:indexPath.row];
    [self done:postType];
}




#pragma mark - view init
- (void)setSubviewFrame
{
//    UIView *backgroundView = [[UIView alloc]initWithFrame:self.view.bounds];
//    [backgroundView setBackgroundColor:color(blackColor)];
//    [backgroundView setAlpha:0.35];
//    [self.view addSubview:backgroundView];
    
    [self setBackGroundImage:imageNameAndType(@"home_bg", nil)];
    [self setTitle:@"选择配送方式"];
    [self setTopBarBackGroundImage:imageNameAndType(@"topbar", nil)];
    
    UIButton *returnBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [returnBtn setBackgroundColor:color(clearColor)];
    [returnBtn setImage:imageNameAndType(@"return", nil) forState:UIControlStateNormal];
    [returnBtn setFrame:CGRectMake(0, 0, self.topBar.frame.size.height, self.topBar.frame.size.height)];
    [self setReturnButton:returnBtn];
    [self.view addSubview:returnBtn];
    
//    _indicatorView = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
//    [_indicatorView setCenter:backgroundView.center];
//    [self.view addSubview:_indicatorView];

    _theTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, controlYLength(self.topBar), self.view.frame.size.width, self.view.frame.size.height - controlYLength(self.topBar) - self.bottomBar.frame.size.height)];
    [_theTableView setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
    [_theTableView setDelegate:self];
    [_theTableView setDataSource:self];
//    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, appFrame.size.width - 20, 40)];
//    [label setBackgroundColor:color(blackColor)];
//    [label setText:[NSString stringWithFormat:@"  选择配送方式"]];
//    [label setTextColor:color(whiteColor)];
//    [_theTableView setTableHeaderView:label];
    [self.view addSubview:_theTableView];
    
//    [self.view setHidden:YES];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesEnded:touches withEvent:event];
    NSLog(@"touch");
    [self cancel];
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
