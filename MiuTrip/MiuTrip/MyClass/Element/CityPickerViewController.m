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

#define     CityPickerViewCellHeight        40.0f

@interface CityPickerViewController ()

@property (strong, nonatomic) UIView                *selectionView;
@property (strong, nonatomic) UITableView           *theTableView;
@property (strong, nonatomic) NSMutableDictionary   *dataSource;
@property (strong, nonatomic) NSMutableArray        *keyArray;

@property (strong, nonatomic) RequestManager    *requestManager;
@property (strong, nonatomic) SqliteManager     *sqliteManager;

@property (strong, nonatomic) UILabel               *selectionTitle;

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
        _requestManager = [[RequestManager alloc]init];
        [_requestManager setDelegate:self];
        _sqliteManager = [[SqliteManager alloc]init];
        
        [self setSubviewFrame];
    }
    return self;
}
- (void)fire
{
    if ([[UserDefaults shareUserDefault].allCity count] != 0) {
        if ([self.dataSource count] == 0) {
            self.dataSource = [self parshCityData:[UserDefaults shareUserDefault].allCity];
        }
        [_theTableView setFrame:CGRectMake(_theTableView.frame.origin.x, _theTableView.frame.origin.y, _theTableView.frame.size.width, 0)];
        if (_selectionView) {
            [_selectionView removeFromSuperview];
            _selectionView = nil;
        }
        _selectionView = [[UIView alloc]initWithFrame:CGRectMake(controlXLength(_theTableView), _theTableView.frame.origin.y, self.view.frame.size.width - controlXLength(_theTableView), self.view.frame.size.height - 100)];
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(selectionTap:)];
        [_selectionView addGestureRecognizer:tapGesture];
        [self.view addSubview:_selectionView];
        for (int i = 0;i<[_keyArray count];i++) {
            NSString *key = [_keyArray objectAtIndex:i];
            
            UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, _selectionView.frame.size.height * i/[_keyArray count], _selectionView.frame.size.width, _selectionView.frame.size.height/[_keyArray count])];
            [label setFont:[UIFont systemFontOfSize:14]];
            [label setTextAlignment:NSTextAlignmentCenter];
            [label setText:key];
            [_selectionView addSubview:label];
        }
        
        [self.view setHidden:NO];
        [self.view setAlpha:1];
        [self.view.superview bringSubviewToFront:self.view];
        [UIView animateWithDuration:0.25
                         animations:^{
                             [_theTableView setFrame:CGRectMake(_theTableView.frame.origin.x, _theTableView.frame.origin.y, _theTableView.frame.size.width, self.view.frame.size.height - 100)];
                         }completion:^(BOOL finished){
                             [self reloadData];
                         }];
    }else{
        [self getAllCity];
    }
    
}

- (void)selectionTap:(UITapGestureRecognizer*)tapGesture
{
    CGPoint point = [tapGesture locationInView:_selectionView];
    NSInteger index = -1;
    for (int i = 0; i<[_keyArray count]; i++) {
        if (point.y >= _selectionView.frame.size.height * i/[_keyArray count] && point.y < _selectionView.frame.size.height * (i + 1)/[_keyArray count]) {
            index = i;
            break;
        }
    }
    if (index >= 0) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:index];
        [_theTableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
        [self showSelectionTitle:index];
    }
    
}

- (void)showSelectionTitle:(NSInteger)index
{
    if (!_selectionTitle) {
        _selectionTitle = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 60, 50)];
        [_selectionTitle setCenter:_theTableView.center];
        [_selectionTitle setBackgroundColor:color(darkGrayColor)];
        [_selectionTitle setFont:[UIFont boldSystemFontOfSize:18]];
        [_selectionTitle setTextAlignment:NSTextAlignmentCenter];
        [_selectionTitle setHidden:YES];
    }
    if (_selectionTitle.superview) {
        [_selectionTitle removeFromSuperview];
    }
    [_selectionTitle setText:[_keyArray objectAtIndex:index]];
    [self.view addSubview:_selectionTitle];
    [_selectionTitle setAlpha:1];
    [_selectionTitle setHidden:NO];
    [self performSelector:@selector(hiddenSelectionTitle) withObject:nil afterDelay:2.0];
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

- (void)reloadData
{
    [self.theTableView reloadData];
//    NSString *str = [_keyArray componentsJoinedByString:@"\n"];
}

- (void)getAllCity
{
//    GetAllCityRequest *request = [[GetAllCityRequest alloc]initWidthBusinessType:BUSINESS_COMMON methodName:@"GetAllCity"];
//    [[Model shareModel] setUserInteractionEnabled:NO];
//    [self.requestManager sendRequest:request];
    [UserDefaults shareUserDefault].allCity = [self.sqliteManager mappingCityInfo];
    [self fire];
}

- (void)requestDone:(BaseResponseModel *)response
{
    [[Model shareModel] setUserInteractionEnabled:YES];
    if ([response isKindOfClass:[GetAllCityResponse class]]) {
        [self getAllCityDone:(GetAllCityResponse*)response];
    }
}

- (void)getAllCityDone:(GetAllCityResponse*)response
{
    [UserDefaults shareUserDefault].allCity = response.cities;
    [self fire];
}

- (NSMutableDictionary*)parshCityData:(NSArray*)data
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
    
    _keyArray = [NSMutableArray arrayWithArray:[dict allKeys]];
    [_keyArray sortUsingComparator:^(NSString *str1, NSString *str2){
        if ([[str1 uppercaseString]  characterAtIndex:0] < [[str2 uppercaseString]  characterAtIndex:0]) {
            return NSOrderedAscending;
        }else if ([[str1 uppercaseString]  characterAtIndex:0] > [[str2 uppercaseString]  characterAtIndex:0]){
            return NSOrderedDescending;
        }else{
            return NSOrderedSame;
        }
    }];
    
    for (NSString *key in _keyArray) {
        NSMutableArray *array = [dict objectForKey:key];
        [array sortedArrayUsingComparator:^NSComparisonResult(CityDTO *city1, CityDTO *city2){
            if ([city1.CityNameEn uppercaseString] < [city2.CityNameEn uppercaseString]) {
                return NSOrderedAscending;
            }else if ([city1.CityNameEn uppercaseString] > [city2.CityNameEn uppercaseString]){
                return NSOrderedDescending;
            }else{
                return NSOrderedSame;
            }
        }];
    }
    return dict;
}

- (void)requestFailedWithErrorCode:(NSNumber *)errorCode withErrorMsg:(NSString *)errorMsg
{
    [[Model shareModel] setUserInteractionEnabled:YES];
}


#pragma mark - the tableview handle
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return CityPickerViewCellHeight;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray *array = [_dataSource objectForKey:[_keyArray objectAtIndex:section]];
    return [array count];
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
    }

    NSArray *array = [_dataSource objectForKey:[_keyArray objectAtIndex:indexPath.section]];
    CityDTO *city = [array objectAtIndex:indexPath.row];
    
    [cell.textLabel setText:city.CityName];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
     NSArray *array = [_dataSource objectForKey:[_keyArray objectAtIndex:indexPath.section]];
    [self pickerFinished:[array objectAtIndex:indexPath.row]];
}

#pragma mark - view init
- (void)setSubviewFrame
{
    UIView *backgroundView = [[UIView alloc]initWithFrame:self.view.bounds];
    [backgroundView setBackgroundColor:color(blackColor)];
    [backgroundView setAlpha:0.35];
    [self.view addSubview:backgroundView];
    
    _theTableView = [[UITableView alloc]initWithFrame:CGRectMake(30, 50, self.view.frame.size.width - 60, self.view.frame.size.height - 100)];
    [_theTableView setDelegate:self];
    [_theTableView setDataSource:self];
//    [_theTableView setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
    [self.view.layer setBorderColor:color(darkGrayColor).CGColor];
    [self.view.layer setBorderWidth:0.5];
    [self.view.layer setShadowColor:color(darkGrayColor).CGColor];
    [self.view.layer setShadowOffset:CGSizeMake(4, 4)];
    [self.view.layer setShadowOpacity:1];
    [self.view.layer setShadowRadius:2.5];
    [self.view addSubview:_theTableView];
    
    [self.view setHidden:YES];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesEnded:touches withEvent:event];
    [self pickerCancel];
}

- (void)pickerFinished:(CityDTO*)city
{
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
    [UIView animateWithDuration:0.25
                     animations:^{
                         [self.view setAlpha:0.0];
                     }completion:^(BOOL finished){
                         [self.view setHidden:YES];
                         [self.delegate cityPickerCancel];
                     }];
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
