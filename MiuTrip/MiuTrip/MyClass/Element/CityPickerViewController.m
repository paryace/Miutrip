//
//  CityPickerViewController.m
//  MiuTrip
//
//  Created by apple on 13-11-30.
//  Copyright (c) 2013年 michael. All rights reserved.
//

#import "CityPickerViewController.h"
#import "UserDefaults.h"
#import "Model.h"
#import "SqliteManager.h"
#import "DBFlightCitys.h"
#import "DBHotCitys.h"
#import "CustomMethod.h"

#define     CityPickerViewCellHeight        40.0f

@interface CityPickerViewController ()

@property (strong, nonatomic) UITableView           *theTableView;
@property (strong, nonatomic) NSMutableDictionary   *dataSource;
@property (strong, nonatomic) NSMutableDictionary   *currentDataSource;
@property (strong, nonatomic) NSMutableArray        *keyArray;

@property (strong, nonatomic) UILabel               *selectionTitle;

@property (strong, nonatomic) UIView                *contentView;
@property (strong, nonatomic) UISearchBar           *searchBar;

@property (assign, nonatomic) CGAffineTransform     transform;

@property (strong, nonatomic) NSTimer               *timer;

@end

@implementation CityPickerViewController

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
        
        _cityPickerMode = CityPickerFlightMode;
        
        [self setSubviewFrame];
    }
    return self;
}

- (void)fire
{
    [_searchBar setText:nil];
    if (_cityPickerMode == CityPickerFlightMode) {
        [self parshDataWithArray:[self getCityData]];
        [_contentView setTransform:CGAffineTransformMakeScale(1, 0)];
        
//        NSArray *allKey = _keyArray;
        
        [self.view setHidden:NO];
        [self.view setAlpha:1];
        [self.view.superview bringSubviewToFront:self.view];
        [UIView animateWithDuration:0.25
                         animations:^{
                             [_contentView setTransform:_transform];
                         }completion:^(BOOL finished){
                             [_theTableView reloadData];
                         }];
    }else{
        
    }
    
}

- (void)reloadData
{
    [self parshDataWithArray:[self getCityData]];
    [_theTableView reloadData];
}

- (NSArray*)getCityData
{
    NSMutableArray *array = [NSMutableArray arrayWithArray:[[SqliteManager shareSqliteManager] mappingCityInfo]];
    [array addObjectsFromArray:[[SqliteManager shareSqliteManager] mappingHotCitysInfo]];
    return array;
}

- (void)parshCityData:(NSArray*)data hotCityData:(NSArray*)hotCitys
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    for (CityDTO *city in data) {
        if (![Utils textIsEmpty:city.CityCode]) {
            NSMutableArray *array = [dict objectForKey:city.CityCode];
            if (array == nil) {
                array = [NSMutableArray array];
                [dict setObject:array forKey:city.CityCode];
            }
            [array addObject:city];
        }
    }
    
    if (hotCitys) {
        [dict setObject:hotCitys forKey:@"热门城市"];
    }
    
    _dataSource = dict;
    
    [self compareDataSource];
}

- (void)parshDataWithArray:(NSArray*)array
{
    NSMutableArray *cityData = [NSMutableArray array];
    NSMutableArray *hotCityData = [NSMutableArray array];
    for (NSObject *objc in array) {
        if ([objc isKindOfClass:[CityDTO class]]) {
            CityDTO *city = (CityDTO*)objc;
            [cityData addObject:city];
        }else if ([objc isKindOfClass:[DBHotCitys class]]) {
            DBHotCitys *city = (DBHotCitys*)objc;
            [hotCityData addObject:city];
        }
    }
    [self parshCityData:cityData hotCityData:hotCityData];
}

- (void)compareDataSource
{
    _keyArray = [NSMutableArray arrayWithArray:[_dataSource allKeys]];

    [_keyArray sortUsingComparator:^(NSString *str1, NSString *str2){
        if ([[str1 uppercaseString]  characterAtIndex:0] < [[str2 uppercaseString]  characterAtIndex:0]) {
            return NSOrderedAscending;
        }else if ([[str1 uppercaseString]  characterAtIndex:0] > [[str2 uppercaseString]  characterAtIndex:0]){
            return NSOrderedDescending;
        }else{
            return NSOrderedSame;
        }
    }];
    [_keyArray bringObjectToFront:@"热门城市"];
}


- (void)showSelectionTitle:(NSString*)title
{
    if (!_selectionTitle) {
        _selectionTitle = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 60, 50)];
        [_selectionTitle setCenter:_contentView.center];
        [_selectionTitle setAutoSize:YES];
        [_selectionTitle setBackgroundColor:color(darkGrayColor)];
        [_selectionTitle setFont:[UIFont boldSystemFontOfSize:18]];
        [_selectionTitle setTextAlignment:NSTextAlignmentCenter];
        [_selectionTitle setHidden:YES];
    }
    if (_selectionTitle.superview) {
        [_selectionTitle removeFromSuperview];
    }
    [_selectionTitle setText:title];
    [self.view addSubview:_selectionTitle];
    [_selectionTitle setAlpha:1];
    [_selectionTitle setHidden:NO];
    
    if (_timer) {
        [_timer invalidate];
    }
    _timer = [NSTimer scheduledTimerWithTimeInterval:1.5f target:self selector:@selector(hiddenSelectionTitle) userInfo:nil repeats:NO];
}

- (void)hiddenSelectionTitle
{
    [UIView animateWithDuration:0.25
                     animations:^{
                         [_selectionTitle setAlpha:0];
                     }completion:^(BOOL finished){
                         [_selectionTitle setHidden:YES];
                     }];
}


#pragma mark - the tableview handle
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return CityPickerViewCellHeight;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [_keyArray objectAtIndex:section];
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    return _keyArray;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray *array = [_dataSource objectForKey:[_keyArray objectAtIndex:section]];
    return [array count];
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
    [self showSelectionTitle:title];
    return index;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [_keyArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifierStr = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifierStr];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifierStr];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    }

    if (indexPath.section == 0) {
        NSArray *array = [_dataSource objectForKey:[_keyArray objectAtIndex:indexPath.section]];
        DBHotCitys *city = [array objectAtIndex:indexPath.row];
        
        [cell.textLabel setText:city.cn_name];
    }else{
        NSArray *array = [_dataSource objectForKey:[_keyArray objectAtIndex:indexPath.section]];
        CityDTO *city = [array objectAtIndex:indexPath.row];
        
        [cell.textLabel setText:city.CityName];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (![self clearKeyBoard]) {
        NSArray *array = [_dataSource objectForKey:[_keyArray objectAtIndex:indexPath.section]];
        if (indexPath.section == 0) {
            DBHotCitys *object = [array objectAtIndex:indexPath.row];
            [self pickerFinished:[[SqliteManager shareSqliteManager] getCityInfoWithCityName:object.cn_name]];
        }else
            [self pickerFinished:[array objectAtIndex:indexPath.row]];
    }
}


#pragma mark - view init
- (void)setSubviewFrame
{
    UIView *backgroundView = [[UIView alloc]initWithFrame:self.view.bounds];
    [backgroundView setBackgroundColor:color(blackColor)];
    [backgroundView setAlpha:0.35];
    [self.view addSubview:backgroundView];
    
    _contentView = [[UIView alloc]initWithFrame:CGRectMake(30, 50, self.view.frame.size.width - 60, self.view.frame.size.height - 100)];
    [_contentView setBackgroundColor:color(clearColor)];
    [self.view addSubview:_contentView];
    
    _transform = _contentView.transform;
    
    _searchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(0, 0, _contentView.frame.size.width, 35)];
    [_searchBar setPlaceholder:@"搜索"];
    [_searchBar setDelegate:self];
    [_searchBar setShowsSearchResultsButton:YES];
    [_contentView addSubview:_searchBar];
    
    _theTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, controlYLength(_searchBar), _searchBar.frame.size.width, _contentView.frame.size.height - controlYLength(_searchBar))];
    [_theTableView setBackgroundColor:color(whiteColor)];
    [_theTableView setDelegate:self];
    [_theTableView setDataSource:self];
//    [_theTableView setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
//    [self.view.layer setBorderColor:color(darkGrayColor).CGColor];
//    [self.view.layer setBorderWidth:0.5];
//    [self.view.layer setShadowColor:color(darkGrayColor).CGColor];
//    [self.view.layer setShadowOffset:CGSizeMake(4, 4)];
//    [self.view.layer setShadowOpacity:1];
//    [self.view.layer setShadowRadius:2.5];
    [_contentView addSubview:_theTableView];
    
    [self.view setHidden:YES];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    NSLog(@"1");
    [self searchDone];
}
- (void)searchBarBookmarkButtonClicked:(UISearchBar *)searchBar
{
    NSLog(@"2");
}
- (void)searchBarCancelButtonClicked:(UISearchBar *) searchBar
{
    NSLog(@"3");
}
- (void)searchBarResultsListButtonClicked:(UISearchBar *)searchBar
{
    NSLog(@"4");
}

- (void)searchDone
{
    [self clearKeyBoard];
    if ([Utils textIsEmpty:_searchBar.text]) {
        [self reloadData];
    }else{
        NSMutableArray *array = [NSMutableArray array];
        NSMutableArray *needRemoveObjects = [NSMutableArray array];
        
        for (NSArray *subArray in [_dataSource allValues]) {
            [array addObjectsFromArray:subArray];
        }
        
        for (NSObject *objc in array) {
            if ([objc isKindOfClass:[CityDTO class]]) {
                CityDTO *city = (CityDTO*)objc;
                if (![Utils string:city.CityName containsString:_searchBar.text] && ![Utils string:city.CityNameEn containsString:_searchBar.text]) {
                    [needRemoveObjects addObject:objc];
                }
            }else if ([objc isKindOfClass:[DBHotCitys class]]) {
                DBHotCitys *city = (DBHotCitys*)objc;
                if (![Utils string:city.cn_name containsString:_searchBar.text] && ![Utils string:city.en_name containsString:_searchBar.text]) {
                    [needRemoveObjects addObject:objc];
                }
            }
        }
        
        for (NSObject *object in needRemoveObjects) {
            if ([array containsObject:object]) {
                [array removeObject:object];
            }
        }
        [self parshDataWithArray:array];
        [_theTableView reloadData];
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesEnded:touches withEvent:event];
    [self pickerCancel];
}

- (void)pickerFinished:(CityDTO*)city
{
    [self clearKeyBoard];
    [UIView animateWithDuration:0.25
                     animations:^{
                         [self.view setAlpha:0.0];
                     }completion:^(BOOL finished){
                         [self.view setHidden:YES];
                         [self.delegate cityPickerFinished:city];
                     }];
}

- (void)pickerCancel
{
    [self clearKeyBoard];
    [UIView animateWithDuration:0.25
                     animations:^{
                         [self.view setAlpha:0.0];
                     }completion:^(BOOL finished){
                         [self.view setHidden:YES];
                         [self.delegate cityPickerCancel];
                     }];
}

- (BOOL)clearKeyBoard
{
    BOOL canResignFirstResponder = NO;
    if ([_searchBar isFirstResponder]) {
        [_searchBar resignFirstResponder];
        canResignFirstResponder  = YES;
    }
    return canResignFirstResponder;
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
