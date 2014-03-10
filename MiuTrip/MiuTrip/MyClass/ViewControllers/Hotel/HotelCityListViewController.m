//
//  HotelCityListViewController.m
//  MiuTrip
//
//  Created by chengxd on 14-2-15.
//  Copyright (c) 2014年 michael. All rights reserved.
//

#import "HotelCityListViewController.h"
#import "SqliteManager.h"
#import "HotelDataCache.h"

@interface HotelCityListViewController ()

@end

@implementation HotelCityListViewController

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
        [self setupView];
    }
    return self;
}


-(void)setupView
{
    
    int width = self.contentView.frame.size.width;
    int height = self.contentView.frame.size.height;
    
    NSArray *citys = [SqliteManager shareSqliteManager].mappingCityInfo;
    _sections = @[@"热门城市", @"A", @"B", @"C",
                @"D", @"E", @"F", @"G",
                @"H", @"J", @"K",
                @"L", @"M", @"N",
                @"P", @"Q", @"R", @"S",
                @"T", @"W",
                @"X", @"Y", @"Z"];
    
    _citysData = [[NSMutableDictionary alloc] init];
    NSMutableArray *hotCityArray = [[NSMutableArray alloc] init];
    for (CityDTO *city in citys) {
        if([city.isHot boolValue]){
            [hotCityArray addObject:city];
        }
    }
    [_citysData setObject:hotCityArray forKey:@"热门城市"];
    for (CityDTO *city in citys) {
        NSString *firstLetter = city.CityCode;
        id data = [_citysData objectForKey:firstLetter];
        if(data){
            NSMutableArray *array = data;
            [array addObject:city];
        }else{
            NSMutableArray *array = [[NSMutableArray alloc] init];
            [array addObject:city];
            [_citysData setObject:array forKey:firstLetter];
        }
    }
    
    [self addTitleWithTitle:@"城市选择" withRightView:Nil];
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 40, self.contentView.frame.size.width, height-75)];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [self.view addSubview:_tableView];
    
    _indexBar = [[AIMTableViewIndexBar alloc] initWithFrame:CGRectMake(width-24, 41, 24, height-76)];
    _indexBar.delegate = self;
    [self.view addSubview:_indexBar];
}


#pragma mark city UItableView datasource and delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    [_indexBar setIndexes:_sections];
    return [_sections count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSString *firstLetter = [_sections objectAtIndex:section];
    NSArray *array = [_citysData objectForKey:firstLetter];
    return array.count+1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if(indexPath.row == 0){
        return 30;
    }
    return 44;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *cell = @"cityCell";
    static NSString *letterCell = @"firstLetterCell";
    NSString *firstLetter = [_sections objectAtIndex:indexPath.section];
    UITableViewCell *tableCellView = nil;
    if(indexPath.row == 0){
        tableCellView = (UITableViewCell*)[tableView dequeueReusableCellWithIdentifier:letterCell];
        if(!tableCellView){
           tableCellView = [[UITableViewCell  alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:letterCell];
        }
        tableCellView.textLabel.text = firstLetter;
        tableCellView.backgroundColor = UIColorFromRGB(0xdddddd);
        tableCellView.textLabel.textColor = color(whiteColor);
    }else{
        tableCellView = (UITableViewCell*)[tableView dequeueReusableCellWithIdentifier:cell];
        if(!tableCellView){
            tableCellView = [[UITableViewCell  alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cell];
        }
        NSArray *array = [_citysData objectForKey:firstLetter];
        CityDTO *city = [array objectAtIndex:indexPath.row-1];
        tableCellView.textLabel.text = [city.CityName stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    }
    
    return tableCellView;

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.row == 0){
        return;
    }
    
    NSString *firstLetter = [_sections objectAtIndex:indexPath.section];
    NSArray *array = [_citysData objectForKey:firstLetter];
    CityDTO *city = [array objectAtIndex:indexPath.row-1];
    HotelDataCache *hotelData = [HotelDataCache sharedInstance];
    hotelData.checkInCityId = [city.CityID integerValue];
    hotelData.checkInCityName = city.CityName;
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - AIMTableViewIndexBarDelegate

- (void)tableViewIndexBar:(AIMTableViewIndexBar*)indexBar didSelectSectionAtIndex:(NSInteger)index
{
    if(index == NSIntegerMax) index = 0;
    if ([_tableView numberOfSections] > index && index > -1){
        [_tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:index]
                              atScrollPosition:UITableViewScrollPositionTop
                                      animated:YES];
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
