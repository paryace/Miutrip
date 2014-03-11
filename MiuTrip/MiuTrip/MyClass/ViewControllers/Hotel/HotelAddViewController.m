//
//  HotelAddViewController.m
//  MiuTrip
//
//  Created by Y on 14-1-22.
//  Copyright (c) 2014年 michael. All rights reserved.
//

#import "HotelAddViewController.h"
//#import "GetCorpCostRequest.h"
//#import "GetCorpCostResponse.h"
#import "GetCorpCostRequest.h"
#import "GetCorpCostResponse.h"
@interface HotelAddViewController ()

@end

@implementation HotelAddViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(id)init
{
    self = [super init];
    if (self) {
        [self setSubviewFrame];
    }
    return self;
}

-(void) selectDone:(NSArray *)params Path:(NSIndexPath *)indexPath
{
    NSString * partnameString = [params objectAtIndex:indexPath.row];
    [_costCenterNameLabel setText:partnameString];
}

- (void)setSubviewFrame
{
    [self setBackGroundImage:imageNameAndType(@"home_bg", nil)];
    [self setTitle:@"添加入住人"];
    [self setTopBarBackGroundImage:imageNameAndType(@"topbar", nil)];
    
    UIButton *returnBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [returnBtn setBackgroundColor:color(clearColor)];
    [returnBtn setImage:imageNameAndType(@"return", nil) forState:UIControlStateNormal];
    [returnBtn setFrame:CGRectMake(0, 0, self.topBar.frame.size.height, self.topBar.frame.size.height)];
    [self setReturnButton:returnBtn];
    [self.view addSubview:returnBtn];
    
    UIButton *saveBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.topBar.frame.size.height*5+20, 0, self.topBar.frame.size.height, self.topBar.frame.size.height)];
    [saveBtn setTitle:@"保存" forState:UIControlStateNormal];
    [saveBtn.titleLabel setFont:[UIFont systemFontOfSize:15]];
    [saveBtn addTarget:self action:@selector(savePassenger) forControlEvents:UIControlEventTouchUpInside];
    [saveBtn setTintColor:[UIColor whiteColor]];
    [saveBtn setTag:777];
    [self.view addSubview:saveBtn];
    
    [self setSubjoinViewFrame];
    
}

-(void)setSubjoinViewFrame{
    
    UIImageView *bgImgView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"cname_box_bg"] ];
    [bgImgView setFrame:CGRectMake(5, self.topBar.frame.size.height +5, self.topBar.frame.size.width - 10, self.topBar.frame.size.height/2+20)];
    [self.contentView addSubview:bgImgView];
    
    UILabel *nameLabel = [[UILabel alloc]init];
    [nameLabel setFrame:CGRectMake(bgImgView.frame.origin.x+10, bgImgView.frame.origin.y+5, self.topBar.frame.size.width/6 + 10, self.topBar.frame.size.height/2+10)];
    [nameLabel setText:@"姓      名"];
    [nameLabel setBackgroundColor:color(clearColor)];
    [nameLabel setFont:[UIFont systemFontOfSize:14]];
    [self.contentView addSubview:nameLabel];
    
    UILabel *imageLabel = [[UILabel alloc]initWithFrame:CGRectMake(controlXLength(nameLabel) + 5, nameLabel.frame.origin.y, 5, self.topBar.frame.size.height/2+10)];
    [imageLabel setText:@"*"];
    [imageLabel setBackgroundColor:color(clearColor)];
    [imageLabel setTextColor:[UIColor redColor]];
    [imageLabel setFont:[UIFont systemFontOfSize:18]];
    [self.contentView addSubview:imageLabel];
    
    
    _nameTextField = [[UITextField alloc]initWithFrame:CGRectMake(controlXLength(imageLabel)+10, imageLabel.frame.origin.y, self.view.frame.size.width*2/3, bgImgView.frame.size.height-10)];
    [_nameTextField setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
    [_nameTextField setBorderStyle:UITextBorderStyleLine];
    [_nameTextField setBorderColor:[UIColor lightTextColor] width:1.0];
    [_nameTextField setDelegate:self];
    [self.contentView addSubview:_nameTextField];
    
    
    UIImageView *bgImgView2 = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"cname_box_bg"] ];
    [bgImgView2 setFrame:CGRectMake(bgImgView.frame.origin.x, controlYLength(bgImgView), bgImgView.frame.size.width, bgImgView.frame.size.height)];
    [self.contentView addSubview:bgImgView2];
    
    UILabel *costCenterLabel = [[UILabel alloc]initWithFrame:CGRectMake(nameLabel.frame.origin.x, bgImgView2.frame.origin.y +5, nameLabel.frame.size.width, nameLabel.frame.size.height)];
    [costCenterLabel setText:@"成本中心"];
    [costCenterLabel setBackgroundColor:color(clearColor)];
    [costCenterLabel setFont:[UIFont systemFontOfSize:14]];
    [self.contentView addSubview:costCenterLabel];
    
    _costCenterNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(controlXLength(costCenterLabel) + 50 , costCenterLabel.frame.origin.y, costCenterLabel.frame.size.width*2, costCenterLabel.frame.size.height)];
    [_costCenterNameLabel setFont:[UIFont systemFontOfSize:14]];
    [_costCenterNameLabel setBackgroundColor:color(clearColor)];
    [self.contentView addSubview:_costCenterNameLabel];
    
    
    UIImageView *image = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"arrow"]];
    [image setFrame:CGRectMake(self.view.frame.size.width/10*9, costCenterLabel.frame.origin.y-5 +15, 10, 15)];
    [self.contentView addSubview:image];
    
    UIButton *picBtn = [[UIButton alloc] initWithFrame:CGRectMake(bgImgView2.frame.origin.x, bgImgView2.frame.origin.y, bgImgView2.frame.size.width, bgImgView2.frame.size.height) ];
    [picBtn setImage:[UIImage imageNamed:@"bottombar"] forState:UIControlStateHighlighted];
    [picBtn setAlpha:0.5];
    [picBtn addTarget:self action:@selector(pressPicBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:picBtn];
}
- (void)savePassenger{
    [self popViewControllerTransitionType:TransitionPush completionHandler:^(void){
        NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
        [dic setValue:_nameTextField.text forKey:@"UserName"];
        [dic setValue:_costCenterNameLabel.text forKey:@"DeptName"];
        [self.delegate saveLiveInfo:dic];
    }];
}
- (void)pressPicBtn:(UIButton *)sender
{
    CoseCenterController *costView = [[CoseCenterController alloc] init];
    [costView setDelegate:self];
    [self.view addSubview:costView.view];
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





@interface CoseCenterController ()

@property (strong, nonatomic) UITableView   *theTableView;

@property (strong, nonatomic) RequestManager *requestManager;

@property (strong , nonatomic) NSArray *dataArray;

@property (strong , nonatomic) NSString *nameSrting;

@end

@implementation CoseCenterController

- (id)init
{
    if (self = [super init]) {
        
        UIImageView *backGroundView = [[UIImageView alloc]initWithFrame:self.view.bounds];
        [backGroundView setBackgroundColor:color(blackColor)];
        [backGroundView setAlpha:0.40];
        [self.view addSubview:backGroundView];
        [self.view setBackgroundColor:[UIColor clearColor]];
        
        _requestManager = [[RequestManager alloc]init];
        [_requestManager setDelegate:self];
        
        [self setSubjoinViewFrame];
        [self getCost];
        
    }
    return self;
}

- (void)setSubjoinViewFrame
{
    UIImageView *bgView = [[UIImageView alloc]initWithFrame:CGRectMake(40, 80, self.view.frame.size.width-80, self.view.frame.size.height-170)];
    [bgView setBackgroundColor:color(whiteColor)];
    bgView.layer.borderWidth = 1;
    bgView.layer.borderColor = [[UIColor darkGrayColor]CGColor];
    [self.view addSubview:bgView];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(bgView.frame.origin.x,bgView.frame.origin.y,bgView.frame.size.width,40)];
    [titleLabel setText:@"   成本中心"];
    [titleLabel setTextColor:[UIColor whiteColor]];
    [titleLabel setBackgroundColor:[UIColor colorWithRed:0.2 green:0.4 blue:0.57 alpha:1]];
    [self.view addSubview:titleLabel];
    
    _theTableView = [[UITableView alloc]initWithFrame:CGRectMake(bgView.frame.origin.x,controlYLength(titleLabel),bgView.frame.size.width,bgView.frame.size.height-40)];
    [_theTableView setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
    [_theTableView setBackgroundColor:[UIColor clearColor]];
    [_theTableView setDelegate:self];
    [_theTableView setDataSource:self];
    [self.view addSubview:_theTableView];
}

- (void)getCost{
    GetCorpCostRequest *costRequest = [[GetCorpCostRequest alloc]initWidthBusinessType:BUSINESS_ACCOUNT methodName:@"GetCorpCost"];
    costRequest.corpId = [NSNumber numberWithInt:22];
    [self.requestManager sendRequest:costRequest];
}

- (void)requestDone:(BaseResponseModel *)response{
    if ([response isKindOfClass:[GetCorpCostResponse class]]) {
        GetCorpCostResponse *costRespone = (GetCorpCostResponse *)response;
        NSLog(@"costRespone = %@",costRespone);
        
        NSArray *cost = costRespone.costs;
        NSMutableArray *partname = [[NSMutableArray alloc] init];
        for (NSDictionary *dic in cost) {
            NSDictionary * part = [dic objectForKey:@"SelectItem"];
            for (NSDictionary *dic2 in part) {
                NSString *   partnamestring = [dic2 objectForKey:@"ItemText"];
                [partname addObject:partnamestring];
                
            }
        }
        _dataArray = partname;
        //        NSLog(@"partname = %@",partname);
        [_theTableView reloadData];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat rowHeight = 40;
    return rowHeight;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_dataArray count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *selectOtherIdentifierStr = @"costCell";
    
    CostCell *cell = nil;
    cell = [tableView dequeueReusableCellWithIdentifier:selectOtherIdentifierStr];
    if (cell == nil) {
        cell = [[CostCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:selectOtherIdentifierStr];
    }
    NSString *string = [_dataArray objectAtIndex:indexPath.row];
    [cell setViewContentWithParams:string];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.view.hidden = YES;
    [self.delegate selectDone:_dataArray Path:indexPath ];
    
}

@end


@interface CostCell ()

@end

@implementation CostCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        [self setSubviewFrame];
    }
    return self;
}

- (void)setSubviewFrame
{
    [self setSelectionStyle:UITableViewCellSelectionStyleNone];
    [self setBackgroundColor:color(clearColor)];
    
    _cost = [[UILabel alloc]initWithFrame:CGRectMake(10, 5, (appFrame.size.width - 50)/4+50, 40)];
    [_cost setFont:[UIFont systemFontOfSize:14]];
    [_cost setBackgroundColor:color(clearColor)];
    [self.contentView addSubview:_cost];
}

- (void)setViewContentWithParams:(NSString*)string
{
    [_cost setText:string];
}

@end




