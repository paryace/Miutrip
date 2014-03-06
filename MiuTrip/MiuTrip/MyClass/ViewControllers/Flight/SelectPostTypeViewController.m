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
        _requestManager = [[RequestManager alloc]init];
        [_requestManager setDelegate:self];
        [self setSubviewFrame];
    }
    return self;
}

- (void)fire
{
    void (^fireBlock)(void) = ^{
        [_theTableView setFrame:CGRectMake(0, 0, appFrame.size.width - 20, 40 * ([_dataSource count] + 1))];
        [_theTableView setCenter:self.view.center];
        CGAffineTransform transform = _theTableView.transform;
        [_theTableView setScaleX:1 scaleY:0];
        [_theTableView setHidden:NO];
        [self.view setAlpha:1];
        [self.view setHidden:NO];
        [UIView animateWithDuration:0.25
                         animations:^{
                             [_theTableView setTransform:transform];
                         }completion:^(BOOL finished){
                             
                         }];
    };
    if (!_dataSource || [_dataSource count] == 0) {
            GetMailConfigRequest *request = [self getMailConfigRequest];
            [self.requestManager sendRequest:request];
            [self.view setAlpha:1];
            [self.view setHidden:NO];
    }else{
        fireBlock();
    }
}

- (void)done:(PostType*)postType
{
    [UIView animateWithDuration:0.25
                     animations:^{
                         [_theTableView setHidden:YES];
                         [self.view setAlpha:0];
                     }completion:^(BOOL finished){
                         [self.view setHidden:YES];
                         [self.delegate selectPostTypeDone:postType];
                     }];
}

- (void)cancel
{
    [UIView animateWithDuration:0.25
                     animations:^{
                         [_theTableView setHidden:YES];
                         [self.view setAlpha:0];
                     }completion:^(BOOL finished){
                         [self.view setHidden:YES];
                     }];
}

#pragma mark - getApiMailConfig
- (GetMailConfigRequest*)getMailConfigRequest
{
    [_indicatorView startAnimating];
    GetMailConfigRequest *request = [[GetMailConfigRequest alloc]initWidthBusinessType:BUSINESS_FLIGHT methodName:@"GetAPIMailConfig"];
    [request setOTAType:[UserDefaults shareUserDefault].OTAType];
    
    return request;
}

- (void)getMailConfigDone:(GetMailConfigResponse*)response
{
    if ([response.mList count] != 0) {
        [response getObjects];
        _getDone = YES;
        _dataSource = response.mList;
        [self fire];
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
    TC_APIMImInfo *postType = [_dataSource objectAtIndex:indexPath.row];
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
    UIView *backgroundView = [[UIView alloc]initWithFrame:self.view.bounds];
    [backgroundView setBackgroundColor:color(blackColor)];
    [backgroundView setAlpha:0.35];
    [self.view addSubview:backgroundView];
    
    _indicatorView = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    [_indicatorView setCenter:backgroundView.center];
    [self.view addSubview:_indicatorView];

    _theTableView = [[UITableView alloc]init];
    [_theTableView setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
    [_theTableView setDelegate:self];
    [_theTableView setDataSource:self];
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, appFrame.size.width - 20, 40)];
    [label setBackgroundColor:color(blackColor)];
    [label setText:[NSString stringWithFormat:@"  选择配送方式"]];
    [label setTextColor:color(whiteColor)];
    [_theTableView setTableHeaderView:label];
    [self.view addSubview:_theTableView];
    
    [self.view setHidden:YES];
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
