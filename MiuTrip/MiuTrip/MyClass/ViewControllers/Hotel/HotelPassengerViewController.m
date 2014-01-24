//
//  HotelPassengerViewController.m
//  MiuTrip
//
//  Created by pingguo on 14-1-16.
//  Copyright (c) 2014年 michael. All rights reserved.
//

#import "HotelPassengerViewController.h"
#import "HotelpassengerDetailCell.h"
#import "GetContactRequest.h"
#import "GetContactResponse.h"
#import "HotelChooseViewController.h"
@interface HotelPassengerViewController ()

@end

@implementation HotelPassengerViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(id)init{
    if (self = [super init]) {
        [self setUpViews];
    }
    return self;
}
- (id)initWithFrame:(CGRect)frame{
    self= [super init];
    if (self) {
        self.view.frame = frame;
        [self setUpViews];
        _array = [[NSMutableArray alloc]init];
        
    }
    return self;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [_dataSource count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 30;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *indentifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:indentifier];
    if (cell == nil) {
        cell = [[HotelpassengerDetailCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:indentifier];
    }
    HotelpassengerDetailCell *hotel = (HotelpassengerDetailCell*)cell;
    hotel.userName.text= [(NSDictionary*)[_dataSource objectAtIndex:[indexPath row] ] objectForKey:@"UserName"];
    [_array addObject:hotel.userName.text];
    NSLog(@"%@－－－－－－－－－－－－－",_array);
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"456");
    //    HotelpassengerDetailCell *cell =(HotelpassengerDetailCell*)[tableView cellForRowAtIndexPath:indexPath];
    [self.view setHidden:YES];
    [self.delegate clickedRow:[indexPath row]];
    
    
    
}

- (void)setUpViews{
    //    [self.view setBackgroundColor:color(redColor)];
    [self.view setCornerRadius:3.0];
    [self.view setAlpha:0.9];
    
    UILabel *head = [[UILabel alloc ]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 40)];
    [head setBackgroundColor:color(blackColor)];
    [head setText:@"政策执行人"];
    [head setTextColor:color(whiteColor)];
    [head setTextAlignment:NSTextAlignmentLeft];
    [self.view addSubview:head];
    [self sendRequest];
    
    
}
- (void)sendRequest{
    GetContactRequest *contact  = [[GetContactRequest alloc]initWidthBusinessType:BUSINESS_ACCOUNT methodName:@"GetContact"];
    contact.CorpID = @"21";
    [self.requestManager sendRequest:contact];
    
}
- (void)requestDone:(BaseResponseModel *)response{
    GetContactResponse *contact= (GetContactResponse*)response;
    _dataSource= contact.result;
    
    [self setSubjoinViewFrame];
}

- (void)setSubjoinViewFrame{
    _theTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 40,self.view.frame.size.width ,self.view.frame.size.height )];
    
    [_theTableView setDataSource:self];
    [_theTableView setDelegate:self];
    [_theTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    //    [_theTableView setBackgroundColor:color(blueColor)];
    [self.view addSubview:_theTableView];
}
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.delegate touchesEnded:touches withEvent:event];
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
