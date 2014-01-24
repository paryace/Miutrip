//
//  HotelChooseViewController.m
//  MiuTrip
//
//  Created by pingguo on 14-1-13.
//  Copyright (c) 2014年 michael. All rights reserved.
//

#import "HotelChooseViewController.h"
#import "HotelSelectViewController.h"
#import "HomeChooseDetailCell.h"
#import "HotelPassengerViewController.h"
#import "HotelpassengerDetailCell.h"
#import "HotelAddViewController.h"
@interface HotelChooseViewController ()

@end

@implementation HotelChooseViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)init{
    self = [super init];
    if (self) {
        [self setupViews];
        _data = [[NSMutableArray alloc]init];
        _hotelSelect = [[HotelSelectViewController alloc]init];
        [_hotelSelect setDelegate:self];
        
    }
    return self;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return HotelChooseViewCellHeight;
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSLog(@"YYYYYYYYYYYY%d",[_data count]);
    return [_data count];
}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *indentifierstr = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:indentifierstr];
    if (cell==nil) {
        cell = [[HomeChooseDetailCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:indentifierstr];
    }
    HomeChooseDetailCell *hotelCell= (HomeChooseDetailCell*)cell;
    NSDictionary *dic = [_data objectAtIndex:indexPath.row];
    hotelCell.userName.text = [dic objectForKey:@"UserName"];
    hotelCell.policy.text = [NSString stringWithFormat:@"差旅政策:%@",[dic objectForKey:@"HotelPolicyTitle"]];
    NSString *cost = [dic objectForKey:@"DeptName"];
    hotelCell.cost.text = [NSString stringWithFormat:@"%@",cost];
    
    
    if (_show) {
        [hotelCell.imageview setHidden:NO];
        [hotelCell.arrow setHidden:NO];
    }
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    HomeChooseDetailCell *cell= (HomeChooseDetailCell*) [tableView cellForRowAtIndexPath:indexPath];
    NSDictionary *dic = [_data objectAtIndex:indexPath.row];
    BOOL show = ![[dic objectForKey:@"show"]boolValue];
    [dic setValue:[NSNumber numberWithBool:show] forKey:@"show"];
    
    if (_show) {
        HotelCompileViewController *comp = [HotelCompileViewController sharedHotelCompile];
        [self pushViewController:comp transitionType:TransitionPush completionHandler:^(void){
            comp.nameTextField.text = cell.userName.text;
            comp.costCenterNameLabel.text = cell.cost.text;
        }];
        
    }
}
- (void)setupViews{
    [self setBackGroundImage:imageNameAndType(@"home_bg", nil)];
    [self setTitle:@"选择入住人"];
    [self setTopBarBackGroundImage:imageNameAndType(@"topbar", nil)];
    
    UIButton *returnBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [returnBtn setBackgroundColor:[UIColor clearColor]];
    [returnBtn setImage:imageNameAndType(@"return", nil) forState:UIControlStateNormal];
    [returnBtn setFrame:CGRectMake(0, 0, self.topBar.frame.size.height, self.topBar.frame.size.height)];
    [self setReturnButton:returnBtn];
    [self.view addSubview:returnBtn];
    
    _contentview = [[UIView alloc]initWithFrame:CGRectMake(6, controlYLength(returnBtn)+6, appFrame.size.width - 12, HotelChooseViewCellHeight+ 25 +15)];
    [_contentview setBackgroundColor:color(whiteColor)];
    [_contentview.layer setCornerRadius:3.0];
    [_contentview.layer setBorderColor:color(grayColor).CGColor];
    [_contentview.layer setBorderWidth:0.3];
    [self.contentView addSubview:_contentview];
    
    UILabel *title = [[UILabel alloc]initWithFrame:CGRectMake(5, 5, self.contentView.frame.size.width/2 - 10, 20)];
    [title setText:@"已选入住人"];
    [title setTextColor:color(grayColor)];
    [_contentview addSubview:title];
    
    UIButton *selectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [selectBtn setFrame:CGRectMake(controlXLength(title), 5, _contentview.frame.size.width/7, 25)];
    [selectBtn setTag:666];
    [selectBtn setBackgroundImage:imageNameAndType(@"set_sgitem_l_normal", nil) forState:UIControlStateNormal];
    [selectBtn setBackgroundImage:imageNameAndType(@"set_sgitem_l_select", nil) forState:UIControlStateHighlighted];
    [selectBtn setTintColor:color(whiteColor)];
    [selectBtn setTitle:@"选择" forState:UIControlStateNormal];
    [selectBtn addTarget:self action:@selector(choosePassenger) forControlEvents:UIControlEventTouchUpInside];
    [_contentview addSubview:selectBtn];
    
    UIButton *compileBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [compileBtn setFrame:CGRectMake(controlXLength(selectBtn) , 5, _contentview.frame.size.width/7, 25)];
    [compileBtn setTag:777];
    [compileBtn setBackgroundImage:imageNameAndType(@"set_sgitem_normal", nil) forState:UIControlStateNormal];
    [compileBtn setBackgroundImage:imageNameAndType(@"set_sgitem_select", nil) forState:UIControlStateHighlighted];
    [compileBtn setTintColor:color(whiteColor)];
    [compileBtn setTitle:@"编辑" forState:UIControlStateNormal];
    [compileBtn addTarget:self action:@selector(doSomethingToPassenger:) forControlEvents:UIControlEventTouchUpInside];
    [_contentview addSubview:compileBtn];
    
    UIButton *addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [addBtn setFrame:CGRectMake(controlXLength(compileBtn) , 5, _contentview.frame.size.width/7, 25)];
    [addBtn setTag:888];
    [addBtn setBackgroundImage:imageNameAndType(@"set_sgitem_r_normal", nil) forState:UIControlStateNormal];
    [addBtn setBackgroundImage:imageNameAndType(@"set_sgitem_r_select", nil) forState:UIControlStateHighlighted];
    [addBtn setTintColor:color(whiteColor)];
    [addBtn setTitle:@"新增" forState:UIControlStateNormal];
    [addBtn addTarget:self action:@selector(doSomethingToPassenger:) forControlEvents:UIControlEventTouchUpInside];
    [_contentview addSubview:addBtn];
    
    
    _placeHolder =  [UIButton buttonWithType:UIButtonTypeCustom];
    [_placeHolder setFrame:CGRectMake(5,controlYLength(title)+10, self.contentView.frame.size.width-24, HotelChooseViewCellHeight)];
    [_placeHolder setBackgroundColor:[UIColor colorWithRed:0/255.0 green:0/255.0 blue:250/255.0 alpha:0.1]];
    [_placeHolder setTitle:@"点击进入姓名库选择" forState:UIControlStateNormal];
    [_placeHolder.layer setCornerRadius:3.0];
    [_placeHolder.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [_placeHolder setTitleColor:color(grayColor) forState:UIControlStateNormal];
    [_placeHolder addTarget:self action:@selector(choosePassenger) forControlEvents:UIControlEventTouchUpInside];
    [_contentview addSubview:_placeHolder];
    
    _alertView  = [[UIView alloc]initWithFrame:CGRectMake(6, controlYLength(_contentview) +10, self.contentview.frame.size.width , 80)];
    [_alertView setBackgroundColor:color(whiteColor)];
    [_alertView.layer setCornerRadius:3.0];
    [_alertView.layer setBorderColor:color(grayColor).CGColor];
    [_alertView.layer setBorderWidth:0.3];
    
    [self.contentView addSubview:_alertView];
    
    _userName = [[UILabel alloc]initWithFrame:CGRectMake(self.view.frame.size.width/3, 0, self.view.frame.size.width/3, 40)];
    [_userName setBackgroundColor:color(clearColor)];
    [_userName setTextAlignment:NSTextAlignmentLeft];
    [_alertView addSubview:_userName];
    
    UIImageView *arrow = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"arrow"]];
    [arrow setFrame:CGRectMake(self.contentview.frame.size.width*7/8, 0, self.contentview.frame.size.width/7, 40)];
    [arrow setScaleX:0.2 scaleY:0.2];
    [_alertView addSubview:arrow];
    
    UIButton * managerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [managerBtn setFrame:CGRectMake(5, 0, self.contentview.frame.size.width, 40)];
    [managerBtn setBackgroundColor:color(clearColor)];
    
    [self createLineWithParams:imageNameAndType(@"setting_line", nil) frame:CGRectMake(0, controlYLength(managerBtn), self.contentview.frame.size.width,1.0) view:_alertView];
    [managerBtn setTitle:@"政策执行人" forState:UIControlStateNormal];
    //    [managerBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0,self.contentview.frame.size.width*2/3)];
    [managerBtn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [managerBtn setTitleColor:color(grayColor) forState:UIControlStateNormal];
    [managerBtn addTarget:self action:@selector(alerWindowView) forControlEvents:UIControlEventTouchUpInside];
    [_alertView addSubview:managerBtn];
    
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, controlYLength(managerBtn), self.contentview.frame.size.width, 40)];
    [label setText:@"请确认本订单中的乘客可由相同的审核人授权，否则需要分开预定"];
    [label setNumberOfLines:2];
    [label setTextAlignment:NSTextAlignmentCenter];
    [label setFont:[UIFont fontWithName:@"ArialMT" size:12]];
    [_alertView addSubview:label];
    
    UIButton *next = [UIButton buttonWithType:UIButtonTypeCustom];
    [next setFrame:CGRectMake(self.view.frame.size.width/4, controlYLength(_alertView)+20, self.view.frame.size.width/2, 50)];
    [next setTag:999];
    [next setBackgroundImage:imageNameAndType(@"done_btn_normal", nil) forState:UIControlStateNormal];
    [next setBackgroundImage:imageNameAndType(@"done_btn_press", nil) forState:UIControlStateHighlighted];
    [next setTitle:@"下一步" forState:UIControlStateNormal];
    [self.contentView addSubview:next];
    
    _theTableView = [[UITableView alloc]initWithFrame:CGRectMake(_placeHolder.frame.origin.x,_placeHolder.frame.origin.y  , _placeHolder.frame.size.width , 0)];
    [_theTableView setDataSource:self];
    [_theTableView setDelegate:self];
    [_theTableView setBackgroundColor:color(clearColor)];
    [_theTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.contentview addSubview:_theTableView];
    
}
- (void)setSubjoinViewFrame{
    [_placeHolder setHidden:YES];
    
    [UIView animateWithDuration:0.25 animations:^{
        [_theTableView setFrame:CGRectMake(_theTableView.frame.origin.x, _theTableView.frame.origin.y
                                           , _theTableView.frame.size.width,HotelChooseViewCellHeight * [_data count])];
        [_contentview setFrame:CGRectMake(_contentview.frame.origin.x
                                          , _contentview.frame.origin.y, _contentview.frame.size.width, controlYLength(_theTableView)+5)];
        
        [_alertView setFrame:CGRectMake(6, controlYLength(_contentview) +10, self.contentview.frame.size.width , 80)];
        
        UIButton *btn = (UIButton*)[self.contentView viewWithTag:999];
        [btn setFrame:CGRectMake(self.view.frame.size.width/4, controlYLength(_alertView)+20, self.view.frame.size.width/2, 50)];
    } completion:^(BOOL finished){
        [self.contentView resetContentSize];
        [_theTableView reloadData];
    }];
    
    
}

- (void)alerWindowView{
    _passenger = [[HotelPassengerViewController alloc]initWithFrame:CGRectMake(self.view.frame.size.width/10, self.view.frame.size.height*2/5, self.view.frame.size.width*4/5, self.view.frame.size.height/5)];
    [_passenger setDelegate:self];
    
    [self.view addSubview:_passenger.view];
    
}
- (void)choosePassenger{
    [self pushViewController:_hotelSelect transitionType:TransitionPush completionHandler:nil];
}

- (void)doSomethingToPassenger:(UIButton*)sender{
    switch (sender.tag) {
        case 777:{
            _show = !_show;
            if (_show)
                for (NSIndexPath *cellIndex in [_theTableView indexPathsForVisibleRows]){
                    HomeChooseDetailCell *cell = (HomeChooseDetailCell*)[_theTableView cellForRowAtIndexPath:cellIndex];
                    
                    NSDictionary *dic = [_data objectAtIndex:cellIndex.row];
                    BOOL show = ![[dic objectForKey:@"show"]boolValue];
                    [dic setValue:[NSNumber numberWithBool:show] forKey:@"show"];
                    [cell showItem:[_data objectAtIndex:cellIndex.row]];
                }
            else
                for (NSIndexPath *cellIndex in [_theTableView indexPathsForVisibleRows]){
                    HomeChooseDetailCell *cell = (HomeChooseDetailCell*)[_theTableView cellForRowAtIndexPath:cellIndex];
                    [cell.imageview setHidden:!_show];
                    [cell.arrow setHidden:!_show];
                }
            
            break;}
        case 888:{
            HotelAddViewController *add = [[HotelAddViewController alloc]init];
            [add setDelegate:self];
            [self pushViewController:add transitionType:TransitionPush completionHandler:nil];
            break;}
        default:
            break;
    }
}
- (void)createLineWithParams:(UIImage*)image frame:(CGRect)frame view:(UIView*)view{
    UIImageView *line = [[UIImageView alloc]initWithFrame:frame];
    [line setImage:image];
    [view addSubview:line];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    NSSet *allTouches = [event allTouches];
    if ([allTouches count]==1) {
        [_passenger.view setHidden:YES];
    }
    
}
- (void)clickedRow:(NSInteger)integer{
    NSString *userName = [_passenger.array objectAtIndex:integer];
    //    NSLog(@"%@=======",_passenger.array);
    _userName.text = userName;
}

- (void)getparamsByArray:(NSArray*)array{
    NSLog(@"-----------------------------%d-------------",[array count]);
    for (NSDictionary *subDic in array) {
        for (NSDictionary *sub in _data) {
            if (subDic == sub) {
                [_data removeObject:sub];
            }
        }
    }
    [_data addObjectsFromArray:array];
    
    for (NSDictionary *dic in _data) {
        [dic setValue:[NSNumber numberWithBool:NO] forKey:@"show"];
    }
    [self setSubjoinViewFrame];
    if ([_data count]==0) {
        [_placeHolder setHidden:NO];
        [_contentview setFrame:CGRectMake(_contentview.frame.origin.x, _contentview.frame.origin.y, _contentview.frame.size.width, HotelChooseViewCellHeight+ 25+15)];
        [_alertView setFrame:CGRectMake(6, controlYLength(_contentview) +10, self.contentview.frame.size.width , 80)];
        
        UIButton *btn = (UIButton*)[self.contentView viewWithTag:999];
        [btn setFrame:CGRectMake(self.view.frame.size.width/4, controlYLength(_alertView)+20, self.view.frame.size.width/2, 50)];
        
        
    }
    
}
- (void)saveLiveInfo:(NSDictionary *)dic{
    [_data addObject:dic];
    [self setSubjoinViewFrame];
    NSLog(@"cccccccccccc%@",_data);
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

