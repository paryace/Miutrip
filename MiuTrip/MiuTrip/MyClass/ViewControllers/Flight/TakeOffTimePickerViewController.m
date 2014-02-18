//
//  TakeOffTimePickerViewController.m
//  MiuTrip
//
//  Created by apple on 14-2-8.
//  Copyright (c) 2014年 michael. All rights reserved.
//

#import "TakeOffTimePickerViewController.h"

@interface TakeOffTimePickerViewController ()


@property (strong, nonatomic) UIView        *contentView;

@property (strong, nonatomic) UITableView   *theTableView;
@property (strong, nonatomic) NSMutableArray    *dataSource;

@property (assign, nonatomic) CGAffineTransform transform;

@end

@implementation TakeOffTimePickerViewController

NSString *takeOffTimes = @"无限制,07:00,08:00,09:00,10:00,11:00,12:00,13:00,14:00,15:00,16:00,17:00,18:00,19:00,20:00,21:00,22:00";

- (id)init
{
    self = [super init];
    if (self) {
        _dataSource = [NSMutableArray arrayWithArray:[takeOffTimes componentsSeparatedByString:@","]];
        [self setSubviewFrame];
    }
    return self;
}

- (void)fire
{
    [self.view setHidden:NO];
    if (self.view.superview) {
        [self.view.superview bringSubviewToFront:self.view];
    }
    CGAffineTransform transform = CGAffineTransformScale(_transform, 1, 0);
    [self.contentView setTransform:transform];
    
    [UIView animateWithDuration:0.25
                     animations:^{
                         [self.view setAlpha:1];

                         [self.contentView setTransform:_transform];
                     }completion:^(BOOL finished){
                         
                     }];
}

- (void)pickerFinished:(NSString*)time
{
    [UIView animateWithDuration:0.15
                     animations:^{
                         [self.view setAlpha:0];
                     }completion:^(BOOL finished){
                         [self.view setHidden:YES];
                         [self.delegate takeOffTimePickerFinished:time];
                     }];
}

- (void)pickerCancel
{
    [UIView animateWithDuration:0.15
                     animations:^{
                         [self.view setAlpha:0];
                     }completion:^(BOOL finished){
                         [self.view setHidden:YES];
                         [self.delegate takeOffTimePickerCancel];
                     }];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40.0f;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_dataSource count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *reuseIdentifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    }
    NSString *timeRange = [_dataSource objectAtIndex:indexPath.row];
    [cell.textLabel setText:timeRange];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *timeRange = [_dataSource objectAtIndex:indexPath.row];
    [self pickerFinished:timeRange];
    NSLog(@"timeRange = %@",timeRange);
}

- (void)setSubviewFrame
{
    [self.view setBackgroundColor:color(clearColor)];
    
    UIView *coverBGView = [[UIView alloc]initWithFrame:self.view.bounds];
    [coverBGView setBackgroundColor:color(blackColor)];
    [coverBGView setAlpha:0.35];
    //    [coverBGView setUserInteractionEnabled:NO];
    [self.view addSubview:coverBGView];
    
    _contentView = [[UIView alloc]initWithFrame:CGRectMake(30, 50, self.view.frame.size.width - 60, appFrame.size.height - 60)];
    [_contentView setBackgroundColor:color(clearColor)];
    //    [_contentView setHidden:YES];
    [self.view addSubview:_contentView];
    
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, _contentView.frame.size.width, 40)];
    [titleLabel setBackgroundColor:color(blackColor)];
    [titleLabel setTextColor:color(whiteColor)];
    [titleLabel setText:[NSString stringWithFormat:@"  %@",@"出发时间"]];
    [_contentView addSubview:titleLabel];
    
    _theTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, controlYLength(titleLabel), _contentView.frame.size.width, _contentView.frame.size.height - controlYLength(titleLabel))];
    [_theTableView setBackgroundColor:color(clearColor)];
    [_theTableView setDelegate:self];
    [_theTableView setDataSource:self];
    [_theTableView setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
    [_contentView addSubview:_theTableView];
    _transform = _contentView.transform;
    
    [self.view setHidden:YES];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    NSLog(@"touch");
    [super touchesEnded:touches withEvent:event];
    [self pickerCancel];
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


