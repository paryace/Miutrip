//
//  HotelSelectViewController.m
//  MiuTrip
//
//  Created by pingguo on 14-1-13.
//  Copyright (c) 2014年 michael. All rights reserved.
//

#import "HotelSelectViewController.h"
#import "HotelSelectedDetailCell.h"
#import "GetCorpStaffRequest.h"
#import "GetCorpStaffResponse.h"
#import "GetCorpUserBaseInfoRequest.h"
#import "GetCorpUserBaseInfoResponse.h"
#import "GetContactRequest.h"
#import "GetContactResponse.h"
#import "LoginInfoDTO.h"
@interface HotelSelectViewController ()


@end

@implementation HotelSelectViewController

- (id)init{
    self = [super init];
    if (self) {
        _btnArray = [[NSMutableArray alloc]init];
        [self setupViews];
        [self sethigh];
        _array = [[NSMutableArray alloc]init];
    }
    return self;
}

- (void)sethigh{
    UIButton *btn =(UIButton*) [self.view viewWithTag:601];
    [btn setHighlighted:YES];
    
    [self sendAllRequest];
}
- (void)setupViews{
    [self setBackGroundImage:imageNameAndType(@"home_bg", nil)];
    [self setTitle:@"选择入住人"];
    [self setTopBarBackGroundImage:imageNameAndType(@"topbar", nil)];
    
    UIButton *returnBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [returnBtn setFrame:CGRectMake(0, 0, self.topBar.frame.size.height, self.topBar.frame.size.height)];
    [returnBtn setImage:imageNameAndType(@"return", nil) forState:UIControlStateNormal];
    [self setReturnButton:returnBtn];
    [self.view addSubview:returnBtn];
    
    UIButton *insert = [UIButton buttonWithType:UIButtonTypeCustom];
    [insert setFrame:CGRectMake(self.view.frame.size.width -controlXLength(returnBtn), 0, self.topBar.frame.size.height, self.topBar.frame.size.height)];
    [insert setBackgroundImage:imageNameAndType(@"cname_add", nil) forState:UIControlStateNormal];
    [insert addTarget:self action:@selector(addPassenger) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:insert];
    
    UIButton *all = [UIButton buttonWithType:UIButtonTypeCustom];
    [all setFrame:CGRectMake(0, controlYLength(returnBtn)-1, self.view.frame.size.width/3, self.topBar.frame.size.height - 5)];
    [all setBackgroundImage:imageNameAndType(@"subitem_normal", nil) forState:UIControlStateNormal];
    [all setBackgroundImage:imageNameAndType(@"subitem_press", nil) forState:UIControlStateHighlighted];
    [all setTitle:@"所有员工" forState:UIControlStateNormal];
    [all setTag:600];
    //    [all addTarget:self action:@selector(showPasseners:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:all];
    [_btnArray addObject:all ];
    
    
    UIButton *section = [UIButton buttonWithType:UIButtonTypeCustom];
    [section setFrame:CGRectMake(controlXLength(all), controlYLength(returnBtn)-1, self.view.frame.size.width/3, self.topBar.frame.size.height -5)];
    [section setBackgroundImage:imageNameAndType(@"subitem_normal", nil) forState:UIControlStateNormal];
    [section setBackgroundImage:imageNameAndType(@"subitem_press", nil) forState:UIControlStateHighlighted];
    [section setTitle:@"本部门员工" forState:UIControlStateNormal];
    [section setTag:601];
    [self.view addSubview:section];
    [_btnArray addObject:section];
    UIButton *common = [UIButton buttonWithType:UIButtonTypeCustom];
    [common setFrame:CGRectMake(controlXLength(section), controlYLength(returnBtn)-1, self.view.frame.size.width/3, self.topBar.frame.size.height-5)];
    [common setBackgroundImage:imageNameAndType(@"subitem_normal", nil) forState:UIControlStateNormal];
    [common setBackgroundImage:imageNameAndType(@"subitem_press", nil) forState:UIControlStateHighlighted];
    [common setTitle:@"常用姓名" forState:UIControlStateNormal];
    [common setTag:602];
    [self.view addSubview:common];
    [_btnArray addObject:common];
    
    NSMutableArray *segBtn = [[NSMutableArray alloc]init];
    for (int i=0; i<3; i++) {
        NSString *item = [NSString stringWithFormat:@"%d",i];
        [segBtn addObject:item];
    }
    UISegmentedControl *segment = [[UISegmentedControl alloc]initWithItems:segBtn];
    [segment setTag:500];
    [segment setFrame:CGRectMake(0, controlYLength(returnBtn), self.view.frame.size.width, self.topBar.frame.size.height -5)];
    [segment addTarget:self action:@selector(pressSegment:) forControlEvents:UIControlEventValueChanged];
    [segment setAlpha:0.1];
    [segment setBackgroundColor:color(clearColor)];
    [self.view addSubview:segment];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return [_dataSource count];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 30;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //   HotelSelectedDetailCell *hotel= (HotelSelectedDetailCell*)[tableView cellForRowAtIndexPath:indexPath];
    NSDictionary *dic = [_dataSource objectAtIndex:[indexPath row]];
    BOOL isSelected =  ![[dic objectForKey:@"selected"] boolValue];
    [dic setValue:[NSNumber numberWithBool:isSelected] forKey:@"selected"];
    
    if (isSelected) {
        BOOL contains = NO;
        for (NSDictionary *subDic in _array) {
            if ([[dic objectForKey:@"UniqueID"]isEqualToString:[subDic objectForKey:@"UniqueID"]]) {
                contains = YES;
            }
        }
        if (!contains) {
            [_array addObject:dic];
        }
    }else{
        NSMutableArray *needDelete = [NSMutableArray array];
        for (NSDictionary *subDic in _array) {
            if ([[dic objectForKey:@"UniqueID"]isEqualToString:[subDic objectForKey:@"UniqueID"]]) {
                [needDelete addObject:subDic];
            }
        }
        if ([needDelete count] != 0) {
            for (id object in needDelete) {
                [_array removeObject:object];
            }
        }
    }
    
    [self tableViewReloadData:tableView];
    
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *indentifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:indentifier];
    if (cell==nil) {
        cell = [[HotelSelectedDetailCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:indentifier];
    }
    HotelSelectedDetailCell *hotel = (HotelSelectedDetailCell*)cell;
    for (UIButton *btn in _btnArray) {
        
        if (btn.tag == 600) {
            NSDictionary *data=  [_dataSource objectAtIndex:[indexPath row]];
            NSString *userName = [data objectForKey:@"UserName"];
            NSArray *card = [(NSDictionary*)[_dataSource objectAtIndex:0] objectForKey:@"IDCardList"];
            NSString *deptname = [(NSDictionary *)[_dataSource objectAtIndex:indexPath.row]objectForKey:@"DeptName"];
            hotel.deptName.text = [NSString stringWithFormat:@"%@",deptname ];
            hotel.userName.text =userName;
            hotel.UID.text = [(NSDictionary*)[card objectAtIndex:0] objectForKey:@"UID"];
            
            
            //    hotel.deptName.text = deptName;
        }else if (btn.tag == 601){
            NSString *ownDept = [UserDefaults shareUserDefault].loginInfo.DeptName;
            NSLog(@"============");
            if ([hotel.deptName.text isEqualToString:ownDept]) {
                NSLog(@"string");
                hotel.userName.text =  [(NSDictionary*)[_dataSource objectAtIndex:[indexPath row]] objectForKey:@"UserName"];
            }
            
        }else{
            NSString *username= [(NSDictionary*)[_dataSource objectAtIndex:[indexPath row]] objectForKey:@"UserName"];
            hotel.userName.text =username;
            NSArray *card = [(NSDictionary*)[_dataSource objectAtIndex:0] objectForKey:@"IDCardList"];
            BOOL select = [[[_dataSource objectAtIndex:indexPath.row] objectForKey:@"selected"]boolValue];
            //            NSLog(@"select = %d",select);
            [hotel setLeftImageHighlighted:select];
            hotel.UID.text = [(NSDictionary*)[card objectAtIndex:0] objectForKey:@"UID"];
            //            NSLog(@"%@",[(NSDictionary*)[_dataSource objectAtIndex:[indexPath row]] objectForKey:@"UID"]);
        }
        
    }
    return cell;
}

-(void)pressSegment:(UISegmentedControl*)segmentControl{
    NSInteger index =  segmentControl.selectedSegmentIndex +600;
    for (UIButton *btn in _btnArray) {
        [btn setHighlighted:(btn.tag == index)];
        
    }
    switch ( segmentControl.selectedSegmentIndex) {
        case 0:{
            if ([_allDataSource count] == 0) {
                [self sendAllRequest];
            }else{
                _dataSource = _allDataSource;
                [self tableViewReloadData:_thetableView];
            }
            break;
        }
        case 1:{
            if ([_usDataSource count] == 0) {
                [self sendAllRequest];
            }else{
                _dataSource = _usDataSource;
                [self tableViewReloadData:_thetableView];
            }
            break;
        }
        case 2:{
            if ([_commonNameDataSource count] == 0) {
                [self sendCommonRequest];
            }else{
                _dataSource = _commonNameDataSource;
                [self tableViewReloadData:_thetableView];
                
            }
            break;
        }
        default:
            break;
    }
}
- (void)sendAllRequest{
    GetCorpStaffRequest *userBase = [[GetCorpStaffRequest alloc]initWidthBusinessType:BUSINESS_ACCOUNT methodName:@"GetCorpStaff"];
    userBase.CorpID =[NSNumber numberWithInt:16];
    [self.requestManager sendRequest:userBase];
}
- (void)sendCommonRequest{
    GetContactRequest *contct =  [[GetContactRequest alloc]initWidthBusinessType:BUSINESS_ACCOUNT methodName:@"GetContact"];
    contct.CorpID = @"00120012";
    [self.requestManager sendRequest:contct];
}
- (void)requestDone:(BaseResponseModel *)response{
    NSLog(@"ssssss");
    if ([response isKindOfClass:[GetCorpStaffResponse class]]) {
        GetCorpStaffResponse *data =  (GetCorpStaffResponse*)response;
        _allDataSource = data.customers;
        _usDataSource = data.customers;
        _dataSource = data.customers;
        for (NSDictionary *dic in _dataSource) {
            [dic setValue:[NSNumber numberWithBool:NO] forKey:@"selected"];
        }
        for (NSDictionary *dic in _dataSource) {
            [dic setValue:[NSNumber numberWithBool:NO] forKey:@"show"];
        }
        
        for (NSDictionary *dic in _allDataSource) {
            for (NSDictionary *subDic in _array) {
                if ([[dic objectForKey:@"UniqueID"]isEqualToString:[subDic objectForKey:@"UniqueID"]]) {
                    [dic setValue:[NSNumber numberWithBool:[[subDic objectForKey:@"selected"]boolValue]] forKey:@"selected"];
                    
                }
            }
        }
        
        
        [self setSubjoinViewFrame];
        
    }
    if ([response isKindOfClass:[GetContactResponse class]]) {
        GetContactResponse *data = (GetContactResponse*)response;
        _commonNameDataSource = data.result;
        _dataSource = data.result;
        for (NSDictionary *dic in _dataSource) {
            [dic setValue:[NSNumber numberWithBool:NO] forKey:@"selected"];
        }
        for (NSDictionary *dic in _dataSource) {
            [dic setValue:[NSNumber numberWithBool:NO] forKey:@"show"];
        }
        
        for (NSDictionary *dic in _commonNameDataSource) {
            for (NSDictionary *subDic in _array) {
                if ([[dic objectForKey:@"UniqueID"]isEqualToString:[subDic objectForKey:@"UniqueID"]]) {
                    [dic setValue:[NSNumber numberWithBool:[[subDic objectForKey:@"selected"]boolValue]] forKey:@"selected"];
                    
                }
            }
        }
        
        [self setSubjoinViewFrame];
    }
    
}

- (void)tableViewReloadData:(UITableView*)tableView
{
    for (NSDictionary *dic in _dataSource) {
        if ([_array count] != 0) {
            for (NSDictionary *subDic in _array) {
                if ([[dic objectForKey:@"UniqueID"]isEqualToString:[subDic objectForKey:@"UniqueID"]]) {
                    [dic setValue:[NSNumber numberWithBool:YES] forKey:@"selected"];
                }
            }
            
        }else{
            [dic setValue:[NSNumber numberWithBool:NO] forKey:@"selected"];
        }
        
    }
    
    [tableView reloadData];
    
}

- (void)addPassenger{
    [self popViewControllerTransitionType:TransitionPush completionHandler:^(void){
        [self.delegate getparamsByArray:_array];
        
    }];
}
-(void)setSubjoinViewFrame{
    if (!_thetableView) {
        _thetableView = [[UITableView alloc]initWithFrame:CGRectMake(0, self.topBar.frame.size.height*2 -5, self.view.frame.size.width, self.contentView.frame.size.height-3)];
        [_thetableView setDataSource:self];
        [_thetableView setDelegate:self];
        [self.view addSubview:_thetableView];
        
    }
    //    [_thetableView reloadData];
    [self tableViewReloadData:_thetableView];
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
