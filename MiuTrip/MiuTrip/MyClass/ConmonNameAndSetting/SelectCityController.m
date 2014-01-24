//
//  StartCityController.m
//  MiuTrip
//
//  Created by GX on 14-1-22.
//  Copyright (c) 2014年 michael. All rights reserved.
//

#import "SelectCityController.h"
#import "SqliteManager.h"
#import "HotCityData.h"
#import "SelectShopCityData.h"
@interface SelectCityController (){
NSArray *selectIndexData;
    NSArray *hotCityData;
    NSArray *wineShopData;
    NSMutableArray *cellData;
}
@end

@implementation SelectCityController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(id)init{
    if (self=[super init]) {
        selectIndexData=[NSArray arrayWithObjects:@"热点城市",@"A",@"B",@"C",@"D",@"E",@"F",@"G",@"H",@"J",@"K",@"L",@"M",@"N",@"P",@"Q",@"R",@"S",@"T",@"W",@"X",@"Y",@"Z", nil];
        hotCityData=[[SqliteManager shareSqliteManager] mappingHotCityInfo];
        wineShopData=[[SqliteManager shareSqliteManager] mappingWineShopCityInfo];
        [self selelct:hotCityData indexData:wineShopData];
        [self setSubviewFrame];
    }
    return self;
}
-(id)initWithParams{
    if (self=[super init]) {
        selectIndexData=[NSArray arrayWithObjects:@"热门城市",@"A",@"B",@"C",@"D",@"E",@"F",@"G",@"H",@"J",@"K",@"L",@"M",@"N",@"P",@"Q",@"R",@"S",@"T",@"W",@"X",@"Y",@"Z", nil];
        hotCityData=[[SqliteManager shareSqliteManager] mappingHotCityInfo];
        wineShopData=[[SqliteManager shareSqliteManager] mappingWineShopCityInfo];
        [self selelct:hotCityData indexData:wineShopData];

        [self setOtherSubviewFrame];
    }
    return self;
}
- (void)setSubviewFrame
{
    [self setBackGroundImage:imageNameAndType(@"home_bg", nil)];
    [self setTitle:@"选择出发城市"];
    [self setTopBarBackGroundImage:imageNameAndType(@"topbar", nil)];
    
    UIButton *returnBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [returnBtn setBackgroundColor:color(clearColor)];
    [returnBtn setImage:imageNameAndType(@"return", nil) forState:UIControlStateNormal];
    [returnBtn setFrame:CGRectMake(0, 0, self.topBar.frame.size.height, self.topBar.frame.size.height)];
    [self setReturnButton:returnBtn];
    [self.view addSubview:returnBtn];
    
    UITableView *startTableView =[[UITableView alloc]initWithFrame:CGRectMake(0, self.topBar.frame.size.height, self.view.frame.size.width, self.view.frame.size.height-self.topBar.frame.size.height-self.bottomBar.frame.size.height)];
    startTableView.showsVerticalScrollIndicator=NO;
    [startTableView setTag:1000];
    startTableView.bounces=NO;
    [startTableView setDelegate:self];
    [startTableView setDataSource:self];
    if (deviceVersion>=7.0) {
        startTableView.sectionIndexBackgroundColor = [UIColor clearColor];//section索引的背景色
    }
    else{
        startTableView.sectionIndexTrackingBackgroundColor = [UIColor clearColor];
    }
    [self.view addSubview:startTableView];
    
}
-(void)setOtherSubviewFrame{
          [self setBackGroundImage:imageNameAndType(@"home_bg", nil)];
        [self setTitle:@"选择入住城市"];
        [self setTopBarBackGroundImage:imageNameAndType(@"topbar", nil)];
        
        UIButton *returnBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [returnBtn setBackgroundColor:color(clearColor)];
        [returnBtn setImage:imageNameAndType(@"return", nil) forState:UIControlStateNormal];
        [returnBtn setFrame:CGRectMake(0, 0, self.topBar.frame.size.height, self.topBar.frame.size.height)];
        [self setReturnButton:returnBtn];
        [self.view addSubview:returnBtn];
        
        UITableView *goalTableView =[[UITableView alloc]initWithFrame:CGRectMake(0, self.topBar.frame.size.height, self.view.frame.size.width, self.view.frame.size.height-self.topBar.frame.size.height-self.bottomBar.frame.size.height)];
        goalTableView.showsVerticalScrollIndicator=NO;
        goalTableView.bounces=NO;
        [goalTableView setDelegate:self];
        [goalTableView setDataSource:self];
        [goalTableView setTag:1001];
        if (deviceVersion>=7.0) {
            goalTableView.sectionIndexBackgroundColor = [UIColor clearColor];//section索引的背景色
        }
        else{
            goalTableView.sectionIndexTrackingBackgroundColor = [UIColor clearColor];
        }
        [self.view addSubview:goalTableView];
        
}


-(void)selelct:(NSArray*)hotCity indexData:(NSArray*)abc{
    cellData =[NSMutableArray array];
    [cellData addObject:hotCityData];
    for (int i='A';i<='Z';i++) {
        NSMutableArray *changeData =[NSMutableArray array];
        for (SelectShopCityData *wineCitydata in abc) {
            if (([wineCitydata.StartChar isEqualToString:[NSString stringWithFormat:@"%c",i]])) {
                [changeData addObject:wineCitydata];
            }
        }
        if (changeData.count != 0) {
            [cellData addObject:changeData];
        }
 
    }
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return [cellData count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [[cellData objectAtIndex:section] count];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath*)indexPath{
    return 40;
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return @"热门城市";
    }else
    {
    return [[[cellData objectAtIndex:section] lastObject] StartChar];
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 30;
}
- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView{
    return selectIndexData;

}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
        static NSString *CellIdentifier =@"StartCity";
        
       UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (cell ==nil) {
            cell =[[ UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            
        }
    cell.textLabel.text =[[[cellData objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] CityName];
    
        return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView.tag==1000) {
        SelectShopCityData *StartwineShopData=[[cellData objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
        self.selectCity(StartwineShopData.CityName);
        [self.navigationController popViewControllerAnimated:YES];
        [[UserDefaults shareUserDefault] setStartCity:StartwineShopData.CityName];
    }
    if (tableView.tag==1001) {
        SelectShopCityData *GoalwineShopData=[[cellData objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
        self.selectCity(GoalwineShopData.CityName);
        [self.navigationController popViewControllerAnimated:YES];
        [[UserDefaults shareUserDefault] setGoalCity:GoalwineShopData.CityName];
    }
    
    
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
