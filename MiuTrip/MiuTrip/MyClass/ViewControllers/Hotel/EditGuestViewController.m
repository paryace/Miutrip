//
//  EditGuestViewController.m
//  MiuTrip
//
//  Created by apple on 14-3-14.
//  Copyright (c) 2014年 michael. All rights reserved.
//

#import "EditGuestViewController.h"



#define editView_width        appBounds.size.width - 20
#define editView_height       101
#define editView_tag          104
#define costCentre_label_tag  102
#define shareAmount_label_tag 103


@interface EditGuestViewController ()

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

- (id)init
{
    if (self = [super init]) {
        _costCentre = @"选择成本中心";
        _ShareAmount = @"选择分摊方式";
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


- (void)setSubView
{
    [self addTitleWithTitle:@"编辑入住人" withRightView:nil];
    //[self addLoadingView];
    
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
    
    _userName = [[UITextField alloc] initWithFrame:CGRectMake(name.frame.size.width + 5, 0, 100, 33)];
    _userName.placeholder = @"请输入姓名";
    _userName.font = [UIFont systemFontOfSize:13];
    _userName.textColor = color(darkGrayColor);
    [editView addSubview:_userName];
    
  
    //成本中心
    UILabel *cost = [[UILabel alloc] initWithFrame:CGRectMake(0, 34, 80, editView_height / 3)];
    cost.textAlignment = NSTextAlignmentCenter;
    cost.textColor = [UIColor darkGrayColor];
    [self setUpLabel:cost withText:@"成本中心"];
    [editView addSubview:cost];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(cost.frame.size.width + 5, 34, 80, editView_height / 3);
    UILabel *buttonL = [[UILabel alloc] initWithFrame:button.frame];
    buttonL.tag = costCentre_label_tag;
   [self setUpLabel:buttonL withText:_costCentre];
    buttonL.textAlignment = NSTextAlignmentLeft;
   // [button setTitle:_costCentre forState:UIControlStateNormal];
    [editView addSubview:buttonL];
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
    
    UILabel *buttonS = [[UILabel alloc] initWithFrame:shareBtn.frame];
    buttonS.tag = shareAmount_label_tag;
    [self setUpLabel:buttonS withText:_ShareAmount];
    buttonS.textAlignment = NSTextAlignmentLeft;
    [editView addSubview:buttonS];
    [shareBtn addTarget:self action:@selector(shareAmountChoose:) forControlEvents:UIControlEventTouchUpInside];
    [editView addSubview:shareBtn];
}


- (void)createCostCentreView
{
    _costCentreArray = [[NSMutableArray alloc] initWithObjects:@"销售部",@"行政部",@"资源部",@"运营部",@"财务部",@"技术部",@"市场部", nil];
    
    
     _costCentreList = [[UITableView alloc] initWithFrame:CGRectMake(50, 50, appFrame.size.width - 100, _costCentreArray.count * 27) style:UITableViewStylePlain];
    _costCentreList.delegate = self;
    _costCentreList.dataSource = self;
    _costCentreList.showsVerticalScrollIndicator = NO;
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _costCentreList.frame.size.width, 27)];
    view.backgroundColor = [UIColor blackColor];
    UILabel *viewLabel = [[UILabel alloc] initWithFrame:view.bounds];
    viewLabel.backgroundColor = color(clearColor);
    [viewLabel setText:@"选择成本中心"];
    viewLabel.textAlignment = NSTextAlignmentCenter;
    viewLabel.textColor = color(whiteColor);
    viewLabel.font = [UIFont systemFontOfSize:14];
    [view addSubview:viewLabel];
    _costCentreList.tableHeaderView = view;

    
    
    [self.view addSubview:_costCentreList];
    _costCentreList.hidden = YES;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _costCentreArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CostCentre"];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CostCentre"];
    }
    
    cell.textLabel.text = [_costCentreArray objectAtIndex:indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIView *editView = (UIView *)[self.view viewWithTag:editView_tag];
    UILabel *costlabel = (UILabel *)[editView viewWithTag:costCentre_label_tag];
    
    NSString *oneCost = [_costCentreArray objectAtIndex:indexPath.row];
    _costCentre = oneCost;
  
    NSLog(@"%@",_costCentre);
    costlabel.text = _costCentre;
    _costCentreList.hidden = YES;
    
    self.selectResult(_userName.text,costlabel.text,nil);
}


- (void)selectCostCentre:(UIButton *)btn
{
    _costCentreList.hidden = NO;
    NSLog(@"1111");
}



- (void)shareAmountChoose:(UIButton *)btn
{
       NSLog(@"1111");
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
