//
//  EditGuestViewController.m
//  MiuTrip
//
//  Created by apple on 14-3-14.
//  Copyright (c) 2014年 michael. All rights reserved.
//

#import "EditGuestViewController.h"
#import "GetCorpCostRequest.h"
#import "GetCorpCostResponse.h"
#import "HotelDataCache.h"


#define editView_width        appBounds.size.width - 20
#define editView_height       101
#define editView_tag          104
#define costCentre_label_tag  102
#define shareAmount_label_tag 103


@interface EditGuestViewController ()
{
    BOOL isCostCentre;
    UIView *shadowView;
}

@property (strong, nonatomic) GetCorpCostResponse *costCenter;
@property (strong, nonatomic) UILabel      *costCenterLb;
@property (strong, nonatomic) UILabel      *shareAcLb;

@property (strong, nonatomic) HotelCustomerModel *customer;

@end

@implementation EditGuestViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initWithIndex:(NSInteger)index
{
    if (self = [super init]) {
        _customerIndex = index;
        if (index != -1) {
            _customer = [[HotelDataCache sharedInstance].customers objectAtIndex:index];
        }
        
        _shareAmount = -1;
        _shareAmountArray = [[NSArray alloc] initWithObjects:@"不承担费用",@"承担半价",@"承担全价", nil];

        [self sendRequest];
        [self.view setHidden:NO];
        [self setSubView];
        [self createCostCentreView];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)pressRightBtn:(UIButton*)sender
{
    if (_customer) {
        if (![Utils textIsEmpty:_userName.text]) {
            _customer.name = _userName.text;
        }
        if (_costCentre) {
            [HotelDataCache sharedInstance].centerItem = _costCentre;
            _customer.costCenter = _costCentre.ItemText;
        }
        if (_shareAmount >= 0 && _shareAmount <= 1) {
            _customer.apportionRate = _shareAmount;
        }
    }else{
        if ([Utils textIsEmpty:_userName.text]) {
            [[Model shareModel] showPromptText:@"请输入姓名" model:YES];
            return;
        }else if (!_costCentre){
            [[Model shareModel] showPromptText:@"请选择成本中心" model:YES];
            return;
        }else if (_shareAmount == -1){
            [[Model shareModel] showPromptText:@"请选择费用分摊比例" model:YES];
            return;
        }
        HotelCustomerModel *customer = [[HotelCustomerModel alloc]init];
        customer.name = _userName.text;
        [HotelDataCache sharedInstance].centerItem = _costCentre;
        customer.costCenter = _costCentre.ItemText;
        customer.apportionRate = _shareAmount;
        [[HotelDataCache sharedInstance].customers addObject:customer];
    }
    
    [self popViewControllerTransitionType:TransitionPush completionHandler:^{
        [self.delegate editGuestDone:_customerIndex];
    }];
}

- (void)setSubView
{
    [self addTitleWithTitle:@"编辑入住人" withRightView:nil];
    //[self addLoadingView];
    HotelCustomerModel *customer = _customer;
    
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightBtn setBackgroundColor:color(clearColor)];
    [rightBtn setFrame:CGRectMake(appFrame.size.width - 40, 0, 40, 40)];
    [rightBtn setScaleX:0.7 scaleY:0.7];
    [rightBtn setImage:imageNameAndType(@"abs__ic_cab_done_holo_dark", nil) forState:UIControlStateNormal];
    [rightBtn setImage:imageNameAndType(@"abs__ic_cab_done_holo_light", nil) forState:UIControlStateHighlighted];
    [rightBtn addTarget:self action:@selector(pressRightBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:rightBtn];
    
    //UIView *editView = [[UIView alloc] initWithFrame:CGRectMake(10, self.topBar.frame.size.height+ 10 ,appBounds.size.width - 20, 100)];
    UIView *editView = [[UIView alloc] initWithFrame:CGRectMake(10, 40+ 10 ,editView_width, 101)];
    editView.tag = editView_tag;
    //editView.image = imageBox;
    editView.backgroundColor = color(whiteColor);
    [editView.layer setCornerRadius:5.0f];
    [editView.layer setShadowColor:color(lightGrayColor).CGColor];
    [editView.layer setBorderWidth:0.5f];
    [self.view addSubview:editView];
    
    //细线
    UIView *lineView1 = [[UIView alloc] initWithFrame:CGRectMake(0, 34, editView_width, 1)];
    lineView1.backgroundColor = color(lightGrayColor);
    [editView addSubview:lineView1];
    UIView *lineView2 = [[UIView alloc] initWithFrame:CGRectMake(0, 67, editView_width, 1)];
    lineView2.backgroundColor = color(lightGrayColor);
    [editView addSubview:lineView2];

    
    //姓名
    UILabel *name = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 80, editView_height / 3)];
    name.textAlignment = NSTextAlignmentCenter;
    name.textColor = [UIColor darkGrayColor];
    [self setUpLabel:name withText:@"姓名"];
    
    UILabel *xing = [[UILabel alloc] initWithFrame:CGRectMake(name.frame.size.width - 20, name.frame.origin.y + 10, 20, 20)];
    xing.text = @"*";
    xing.textColor = color(redColor);
    xing.adjustsFontSizeToFitWidth = YES;
    xing.backgroundColor = color(clearColor);
    [name addSubview:xing];
    
    [editView addSubview:name];
    
    _userName = [[UITextField alloc] initWithFrame:CGRectMake(name.frame.size.width + 5, 2, 100, 30)];
    _userName.placeholder = @"请输入姓名";
    _userName.font = [UIFont systemFontOfSize:13];
    _userName.textColor = color(darkGrayColor);
    _userName.delegate = self;
    _userName.borderStyle = UITextBorderStyleRoundedRect;
    [_userName setText:customer.name];
    _userName.clearButtonMode = UITextFieldViewModeWhileEditing;
    [editView addSubview:_userName];
    
  
    //成本中心
    UILabel *cost = [[UILabel alloc] initWithFrame:CGRectMake(0, 34, 80, editView_height / 3)];
    cost.textAlignment = NSTextAlignmentCenter;
    cost.textColor = [UIColor darkGrayColor];
    [self setUpLabel:cost withText:@"成本中心"];
    [editView addSubview:cost];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(cost.frame.size.width + 5, 34, 80, editView_height / 3);
    _costCenterLb = [[UILabel alloc] initWithFrame:button.frame];
    _costCenterLb.tag = costCentre_label_tag;
   [self setUpLabel:_costCenterLb withText:[self getCostCenterDesc]];
    _costCenterLb.textAlignment = NSTextAlignmentLeft;
   // [button setTitle:_costCentre forState:UIControlStateNormal];
    [editView addSubview:_costCenterLb];
    [button addTarget:self action:@selector(selectCostCentre:) forControlEvents:UIControlEventTouchUpInside];
    [editView addSubview:button];
    
    
    
    //分摊费用
    UILabel *share = [[UILabel alloc] initWithFrame:CGRectMake(0, 68, 80, editView_height / 3)];
    share.textAlignment = NSTextAlignmentCenter;
    share.textColor = [UIColor darkGrayColor];
    [self setUpLabel:share withText:@"费用分摊"];
    [editView addSubview:share];
    
    UIButton *shareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    //[shareBtn setTitle:_ShareAmount forState:UIControlStateNormal];
    shareBtn.frame = CGRectMake(share.frame.size.width + 5, 68, 80, editView_height / 3);
    
    UILabel *shareAcLb = [[UILabel alloc] initWithFrame:shareBtn.frame];
    shareAcLb.tag = shareAmount_label_tag;
    [self setUpLabel:shareAcLb withText:[self getShareAmountDesc]];
    shareAcLb.textAlignment = NSTextAlignmentLeft;
    [editView addSubview:shareAcLb];
    [shareBtn addTarget:self action:@selector(shareAmountChoose:) forControlEvents:UIControlEventTouchUpInside];
    [editView addSubview:shareBtn];
}

- (NSString *)getCostCenterDesc
{
    if (![Utils textIsEmpty:_customer.costCenter]) {
        return _customer.costCenter;
    }else{
        return @"选择成本中心";
    }
}

- (NSString *)getShareAmountDesc
{
    if (_customer) {
        if (_customer.apportionRate == 0.0) {
            return [_shareAmountArray objectAtIndex:0];
        }else if (_customer.apportionRate == 0.5) {
            return [_shareAmountArray objectAtIndex:1];
        }else if (_customer.apportionRate == 1.0){
            return [_shareAmountArray objectAtIndex:2];
        }
    }
    
    return @"选择分摊方式";
}

- (void)createShadowView
{
    shadowView = [[UIView alloc] initWithFrame:self.view.bounds];
    shadowView.alpha = 0.0f;
    shadowView.backgroundColor = [UIColor darkGrayColor];
    [self.view addSubview:shadowView];
}

- (void)createCostCentreView
{
    [self createShadowView];
    //_costCentreArray = [[NSMutableArray alloc] initWithObjects:@"销售部",@"行政部",@"资源部",@"运营部",@"财务部",@"技术部",@"市场部", nil];
    _costCentreArray = [[NSMutableArray alloc] init];
    
     _costCentreList = [[UITableView alloc] initWithFrame:CGRectMake(50, 70, appFrame.size.width - 100, (_mArray.count+1) * 27) style:UITableViewStylePlain];
    _costCentreList.delegate = self;
    _costCentreList.dataSource = self;
    _costCentreList.showsVerticalScrollIndicator = NO;
    _costCentreList.bounces = NO;
    [_costCentreList.layer setCornerRadius:5.0f];
    [_costCentreList.layer setShadowColor:color(grayColor).CGColor];
    [_costCentreList.layer setShadowOpacity:.1];
    

    [self.view addSubview:_costCentreList];
    _costCentreList.alpha = 0;
}

- (void)tableViewHeadViewWithTitle:(NSString *)title{

    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _costCentreList.frame.size.width, 27)];
    view.backgroundColor = [UIColor colorWithPatternImage: [UIImage imageNamed:@"bg_hotel_cost.png"]];
    UILabel *viewLabel = [[UILabel alloc] initWithFrame:view.bounds];
    viewLabel.backgroundColor = color(clearColor);
    [viewLabel setText:title];
    viewLabel.textAlignment = NSTextAlignmentLeft;
    viewLabel.textColor = color(whiteColor);
    viewLabel.font = [UIFont systemFontOfSize:14];
    [view addSubview:viewLabel];
    _costCentreList.tableHeaderView = view;
}


- (void)sendRequest
{
    [self addLoadingView];
    GetCorpCostRequest *request = [[GetCorpCostRequest alloc] initWidthBusinessType:BUSINESS_ACCOUNT methodName:@"GetCorpCost"];
    request.corpId = [[[UserDefaults shareUserDefault] loginInfo] CorpID];
    [self.requestManager sendRequest:request];
}


- (void)requestDone:(BaseResponseModel *)response
{
    [self removeLoadingView];
    
    GetCorpCostResponse *responseN = (GetCorpCostResponse *)response;
    [responseN getObjects];
    [HotelDataCache sharedInstance].corpCost = responseN;
    if ([responseN.costs count] != 0) {
        CostCenterList *list = [responseN.costs objectAtIndex:0];
        _costCentreArray = list.SelectItem;
    }
    [_costCenterLb setText:[self getCostCenterDesc]];
    
    _costCentreList.frame = CGRectMake(50, 70, appFrame.size.width - 100, (_mArray.count +1)* 27);
    [_costCentreList reloadData];
}

- (void)requestFailedWithErrorCode:(NSNumber *)errorCode withErrorMsg:(NSString *)errorMsg
{
    NSStringFromSelector(_cmd);
    NSLog(@" %@ 失败",NSStringFromSelector(_cmd));
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _mArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CostCentre"];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CostCentre"];
        cell.textLabel.textColor = [UIColor darkGrayColor];
    }
    id object = [_mArray objectAtIndex:indexPath.row];
    if ([object isKindOfClass:[CostCenterItem class]]) {
        CostCenterItem *item = object;
        cell.textLabel.text = item.ItemText;
    }else if ([object isKindOfClass:[NSString class]])
        cell.textLabel.text = [_mArray objectAtIndex:indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIView *editView = (UIView *)[self.view viewWithTag:editView_tag];
    
    if (isCostCentre) {
    UILabel *costlabel = (UILabel *)[editView viewWithTag:costCentre_label_tag];
    
        CostCenterItem *item = [_mArray objectAtIndex:indexPath.row];
        _costCentre = item;
        
        costlabel.text = _costCentre.ItemText;
    }
    //_costCentreList.hidden = YES;
    else if (isCostCentre == NO) {
        UILabel *shareLabel = (UILabel *)[self.view viewWithTag:shareAmount_label_tag];
        NSString *oneShare = [_mArray objectAtIndex:indexPath.row];
        switch (indexPath.row) {
            case 0:{
                _shareAmount = 0.0;
                break;
            }case 1:{
                _shareAmount = 0.5;
                break;
            }case 2:{
                _shareAmount = 1.0;
                break;
            }
            default:
                break;
        }
        shareLabel.text = oneShare;
    }
    
    [self endDisplay];
    
  
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self endDisplay];
}

- (void)viewWillDisappear:(BOOL)animated
{
//    UIView *editView = (UIView *)[self.view viewWithTag:editView_tag];
//    UILabel *costlabel = (UILabel *)[editView viewWithTag:costCentre_label_tag];
//    UILabel *shareLabel = (UILabel *)[self.view viewWithTag:shareAmount_label_tag];
//    self.selectResult(_userName.text,costlabel.text,shareLabel.text);
}

/*
 
 - (void)fadeIn
 {
 self.transform = CGAffineTransformMakeScale(1.3, 1.3);
 self.alpha = 0;
 [UIView animateWithDuration:.35 animations:^{
 self.alpha = 1;
 self.transform = CGAffineTransformMakeScale(1, 1);
 }];
 
 }
 - (void)fadeOut
 {
 [UIView animateWithDuration:.35 animations:^{
 self.transform = CGAffineTransformMakeScale(1.3, 1.3);
 self.alpha = 0.0;
 } completion:^(BOOL finished) {
 if (finished) {
 [_overlayView removeFromSuperview];
 [self removeFromSuperview];
 }
 }];
 }
 */
- (void)grayShowWhenTouch
{
    shadowView.alpha = 0.5f;
    
}
- (void)grayEndShowWhenTouch
{
    shadowView.alpha = 0.0f;

}

- (void)beginDisplay
{
    [self grayShowWhenTouch];


    _costCentreList.transform = CGAffineTransformMakeScale(1.3, 1.3);
    _costCentreList.alpha = 0;
    [UIView animateWithDuration:0.35f animations:^{

        _costCentreList.alpha = 1;
        _costCentreList.transform = CGAffineTransformMakeScale(1, 1);
    }];
    _costCentreList.frame = CGRectMake(_costCentreList.frame.origin.x, _costCentreList.frame.origin.y, appFrame.size.width - 100, (_mArray.count+1) * 27);
    [_costCentreList setCenter:self.view.center];

    
}

- (void)endDisplay
{
    [self grayEndShowWhenTouch];
    [UIView animateWithDuration:0.35f animations:^{
        _costCentreList.transform = CGAffineTransformMakeScale(1.3, 1.3);
        _costCentreList.alpha = 0;

    }];
    //_costCentreList.frame = CGRectMake(50, 50, appFrame.size.width - 100, (_mArray.count+1) * 27);

}

- (void)selectCostCentre:(UIButton *)btn
{
    isCostCentre = YES;
    _mArray = _costCentreArray;
    [self tableViewHeadViewWithTitle:@" 选择成本中心"];
    [_costCentreList reloadData];
    [self beginDisplay];
    NSLog(@"1111");
}



- (void)shareAmountChoose:(UIButton *)btn
{
    isCostCentre = NO;
    _mArray = _shareAmountArray;
    [self tableViewHeadViewWithTitle:@" 选择分摊方式"];
    [_costCentreList reloadData];
    [self beginDisplay];
}

- (void)setUpLabel:(UILabel *)label withText:(NSString *)text
{
    label.backgroundColor = color(clearColor);
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor darkGrayColor];
    label.text = text;
    label.font = [UIFont systemFontOfSize:13];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 27;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [_userName resignFirstResponder];
    return YES;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [_userName resignFirstResponder];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
