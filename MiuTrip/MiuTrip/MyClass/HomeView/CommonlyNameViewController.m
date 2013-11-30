//
//  CommonlyNameViewController.m
//  MiuTrip
//
//  Created by SuperAdmin on 13-11-15.
//  Copyright (c) 2013年 michael. All rights reserved.
//

#import "CommonlyNameViewController.h"
#import "CommonlyName.h"
#import "BookPassengersDTO.h"
#import "CustomBtn.h"

@interface CommonlyNameViewController ()

@end

@implementation CommonlyNameViewController

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
    if (self = [super init]) {
        [self setSubviewFrame];

        [self.requestManager getContact:nil];
    }
    return self;
}

- (void)pressRightBtn:(UIButton*)sender
{
    [self.requestManager getContact:nil];
}

#pragma mark - request handle
- (void)getContactDone:(NSArray *)contacts
{
    _dataSource = [NSMutableArray arrayWithArray:contacts];
    [_theTableView reloadData];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BookPassengersDTO *passengerDetail = [_dataSource objectAtIndex:indexPath.row];
    if (passengerDetail.unfold) {
        return CommonlyNameViewCellHeight * 9;
    }else
        return CommonlyNameViewCellHeight;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_dataSource count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifierStr = @"cell";
    CommonlyNameViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifierStr];
    if (cell == nil) {
        cell = [[CommonlyNameViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifierStr];
    }
    CustomBtn *deleteBtn = (CustomBtn*)[cell viewWithTag:303];
    CustomBtn *saveBtn   = (CustomBtn*)[cell viewWithTag:304];
    
    BookPassengersDTO *passengerDetail = [_dataSource objectAtIndex:indexPath.row];
    
    [cell setContentWithParams:passengerDetail];
    
    [deleteBtn setIndexPath:indexPath];
    [saveBtn   setIndexPath:indexPath];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    CommonlyNameViewCell *cell = (CommonlyNameViewCell*)[tableView cellForRowAtIndexPath:indexPath];
    BookPassengersDTO *passengerDetail = [_dataSource objectAtIndex:indexPath.row];
    passengerDetail.unfold = !passengerDetail.unfold;
    [cell subviewUnfold:passengerDetail.unfold];
    [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
}

- (void)setSubviewFrame
{
    [self setBackGroundImage:imageNameAndType(@"home_bg", nil)];
    [self setTitle:@"常用姓名"];
    [self setTopBarBackGroundImage:imageNameAndType(@"topbar", nil)];
    
    UIButton *returnBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [returnBtn setBackgroundColor:color(clearColor)];
    [returnBtn setImage:imageNameAndType(@"return", nil) forState:UIControlStateNormal];
    [returnBtn setFrame:CGRectMake(0, 0, self.topBar.frame.size.height, self.topBar.frame.size.height)];
    [self setReturnButton:returnBtn];
    [self.view addSubview:returnBtn];
    
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightBtn setBackgroundColor:color(clearColor)];
    [rightBtn setImage:imageNameAndType(@"cname_add", nil) forState:UIControlStateNormal];
    [rightBtn setFrame:CGRectMake(self.topBar.frame.size.width - self.topBar.frame.size.height, 0, self.topBar.frame.size.height, self.topBar.frame.size.height)];
    [rightBtn addTarget:self action:@selector(pressRightBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:rightBtn];
}

- (void)setSubjoinViewFrame
{
    if (!_theTableView) {
        _theTableView = [[UITableView alloc]initWithFrame:CGRectMake(10, controlYLength(self.topBar) + 15, self.view.frame.size.width - 20, self.bottomBar.frame.origin.y - controlYLength(self.topBar) - 20)];
        [_theTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        [_theTableView setBackgroundColor:color(clearColor)];
        [_theTableView setDelegate:self];
        [_theTableView setDataSource:self];
        [_theTableView.layer setMasksToBounds:YES];
        [_theTableView.layer setCornerRadius:10];
        [self.contentView addSubview:_theTableView];
    }
    
    [self.contentView setHidden:NO];
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

@interface CommonlyNameViewCell ()


@property (strong, nonatomic) UILabel                       *userName;
@property (strong, nonatomic) UITextField                   *unfoldUserName;
@property (strong, nonatomic) UITextField                   *nationality;
@property (strong, nonatomic) UITextField                   *cardType;
@property (strong, nonatomic) UITextField                   *cardNum;
@property (strong, nonatomic) UITextField                   *phoneNum;

@property (strong, nonatomic) UIView                        *unfoldView;

@property (strong, nonatomic) UIImageView                   *backGroundImageView;

@property (strong, nonatomic) NSMutableArray                *optionBtnArray;

@end

@implementation CommonlyNameViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _optionBtnArray = [NSMutableArray array];
        [self setSubviewFrame];
    }
    return self;
}

- (void)setContentWithParams:(BookPassengersDTO*)passengerDetail
{
    [_userName setText:passengerDetail.UserName];
    [_unfoldUserName setText:passengerDetail.UserName];
    [_nationality setText:[Utils NULLToEmpty:passengerDetail.Country]];
    [_phoneNum setText:passengerDetail.Mobilephone];
}

- (void)subviewUnfold:(BOOL)show
{
    if (show) {
        if (!_unfoldView.superview) {
            [self.contentView addSubview:_unfoldView];
        }
        [_unfoldView setHidden:NO];
    }else{
        [_unfoldView setHidden:NO];
    }
}

- (void)setBackGroundImage:(UIImage*)image
{
    if (!_backGroundImageView) {
        _backGroundImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, appFrame.size.width, CommonlyNameViewCellHeight)];
        [_backGroundImageView setBackgroundColor:color(clearColor)];
        if (self.userName) {
            [self.contentView insertSubview:_backGroundImageView belowSubview:_userName];
        }else{
            [self.contentView addSubview:_backGroundImageView];
        }
    }
    [_backGroundImageView setImage:image];
}

- (void)setSubviewFrame
{
    [self setBackGroundImage:imageNameAndType(@"cname_box_bg", nil)];
    
    _userName = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, appFrame.size.width - 40, CommonlyNameViewCellHeight)];
    [_userName setBackgroundColor:color(clearColor)];
    [self.contentView addSubview:_userName];
    
    _unfoldView = [[UIView alloc]initWithFrame:CGRectMake(0, controlYLength(_userName), appFrame.size.width - 20, 0)];
    [_unfoldView setTag:300];
    [_unfoldView setBackgroundColor:color(colorWithRed:231.0/255.0 green:235.0/255.0 blue:241.0/255.0 alpha:1)];
    [self.contentView addSubview:_unfoldView];
    
    UILabel *unfoldUserNameLeft = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, _unfoldView.frame.size.width/4, CommonlyNameViewCellHeight)];
    [unfoldUserNameLeft setBackgroundColor:color(clearColor)];
    [unfoldUserNameLeft setTextAlignment:NSTextAlignmentRight];
    [unfoldUserNameLeft setText:@"姓名："];
    [unfoldUserNameLeft setAutoSize:YES];
    [unfoldUserNameLeft setTextColor:color(grayColor)];
    _unfoldUserName = [[UITextField alloc]initWithFrame:CGRectMake(0, 0, _unfoldView.frame.size.width, unfoldUserNameLeft.frame.size.height)];
    [_unfoldUserName setBackgroundColor:color(clearColor)];
    //[_unfoldUserName setBackground:imageNameAndType(@"cname_unfold_box_bg", nil)];
    [_unfoldUserName setEnabled:NO];
    [_unfoldUserName setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
    [_unfoldUserName setLeftView:unfoldUserNameLeft];
    [_unfoldUserName setLeftViewMode:UITextFieldViewModeAlways];
    [_unfoldView addSubview:_unfoldUserName];
    
    [_unfoldView addSubview:[self createLineWithFrame:CGRectMake(_unfoldUserName.frame.origin.x, controlYLength(_unfoldUserName), _unfoldUserName.frame.size.width, 1)]];
    
    UILabel *nationalityLeft = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, unfoldUserNameLeft.frame.size.width, unfoldUserNameLeft.frame.size.height)];
    [nationalityLeft setBackgroundColor:color(clearColor)];
    [nationalityLeft setTextAlignment:NSTextAlignmentRight];
    [nationalityLeft setText:@"国籍："];
    [nationalityLeft setAutoSize:YES];
    [nationalityLeft setTextColor:color(grayColor)];
    _nationality = [[UITextField alloc]initWithFrame:CGRectMake(_unfoldUserName.frame.origin.x, controlYLength(_unfoldUserName), _unfoldUserName.frame.size.width, _unfoldUserName.frame.size.height)];
    [_nationality setBackgroundColor:color(clearColor)];
    //[_nationality setBackground:imageNameAndType(@"cname_unfold_box_bg", nil)];
    [_nationality setEnabled:NO];
    [_nationality setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
    [_nationality setLeftView:nationalityLeft];
    [_nationality setLeftViewMode:UITextFieldViewModeAlways];
    [_unfoldView addSubview:_nationality];
    
    [_unfoldView addSubview:[self createLineWithFrame:CGRectMake(_unfoldUserName.frame.origin.x, controlYLength(_nationality), _unfoldUserName.frame.size.width, 1)]];
    
    UILabel *cardTypeLeft = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, unfoldUserNameLeft.frame.size.width, unfoldUserNameLeft.frame.size.height)];
    [cardTypeLeft setBackgroundColor:color(clearColor)];
    [cardTypeLeft setTextAlignment:NSTextAlignmentRight];
    [cardTypeLeft setText:@"证件类型："];
    [cardTypeLeft setAutoSize:YES];
    [cardTypeLeft setTextColor:color(grayColor)];
    _cardType = [[UITextField alloc]initWithFrame:CGRectMake(_unfoldUserName.frame.origin.x, controlYLength(_nationality), _unfoldUserName.frame.size.width, _unfoldUserName.frame.size.height)];
    [_cardType setBackgroundColor:color(clearColor)];
    //[_cardType setBackground:imageNameAndType(@"cname_unfold_box_bg", nil)];
    [_cardType setEnabled:NO];
    [_cardType setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
    [_cardType setLeftView:cardTypeLeft];
    [_cardType setLeftViewMode:UITextFieldViewModeAlways];
    [_unfoldView addSubview:_cardType];
    
    [_unfoldView addSubview:[self createLineWithFrame:CGRectMake(_unfoldUserName.frame.origin.x, controlYLength(_cardType), _unfoldUserName.frame.size.width, 1)]];
    
    UILabel *cardNumLeft = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, unfoldUserNameLeft.frame.size.width, unfoldUserNameLeft.frame.size.height)];
    [cardNumLeft setBackgroundColor:color(clearColor)];
    [cardNumLeft setTextAlignment:NSTextAlignmentRight];
    [cardNumLeft setText:@"证件号码："];
    [cardNumLeft setAutoSize:YES];
    [cardNumLeft setTextColor:color(grayColor)];
    _cardNum = [[UITextField alloc]initWithFrame:CGRectMake(_unfoldUserName.frame.origin.x, controlYLength(_cardType), _unfoldUserName.frame.size.width, _unfoldUserName.frame.size.height)];
    [_cardNum setBackgroundColor:color(clearColor)];
    //[_cardNum setBackground:imageNameAndType(@"cname_unfold_box_bg", nil)];
    [_cardNum setEnabled:NO];
    [_cardNum setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
    [_cardNum setLeftView:cardNumLeft];
    [_cardNum setLeftViewMode:UITextFieldViewModeAlways];
    [_unfoldView addSubview:_cardNum];
    
    [_unfoldView addSubview:[self createLineWithFrame:CGRectMake(_unfoldUserName.frame.origin.x, controlYLength(_cardNum), _unfoldUserName.frame.size.width, 1)]];
    
    UILabel *phoneNumLeft = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, unfoldUserNameLeft.frame.size.width, unfoldUserNameLeft.frame.size.height)];
    [phoneNumLeft setBackgroundColor:color(clearColor)];
    [phoneNumLeft setTextAlignment:NSTextAlignmentRight];
    [phoneNumLeft setText:@"手机号码："];
    [phoneNumLeft setAutoSize:YES];
    [phoneNumLeft setTextColor:color(grayColor)];
    _phoneNum = [[UITextField alloc]initWithFrame:CGRectMake(_unfoldUserName.frame.origin.x, controlYLength(_cardNum), _unfoldUserName.frame.size.width, _unfoldUserName.frame.size.height)];
    [_phoneNum setBackgroundColor:color(clearColor)];
    //[_phoneNum setBackground:imageNameAndType(@"cname_unfold_box_bg", nil)];
    [_phoneNum setEnabled:NO];
    [_phoneNum setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
    [_phoneNum setLeftView:phoneNumLeft];
    [_phoneNum setLeftViewMode:UITextFieldViewModeAlways];
    
    [_unfoldView addSubview:[self createLineWithFrame:CGRectMake(_unfoldUserName.frame.origin.x, controlYLength(_phoneNum), _unfoldUserName.frame.size.width, 1)]];
    [_unfoldView addSubview:_phoneNum];
    
    CustomStatusBtn *passengersBtn = [[CustomStatusBtn alloc]initWithFrame:CGRectMake(_phoneNum.frame.origin.x, controlYLength(_phoneNum), _phoneNum.frame.size.width/3, _phoneNum.frame.size.height)];
    [passengersBtn setTag:300];
    [passengersBtn addTarget:self action:@selector(pressBtn:) forControlEvents:UIControlEventTouchUpInside];
    [passengersBtn setImage:imageNameAndType(@"cname_item_normal", nil) selectedImage:imageNameAndType(@"cname_item_select", nil)];
    [passengersBtn setLeftViewScaleX:0.65 scaleY:0.65];
    [passengersBtn setDetail:@"默认乘机人"];
    [_unfoldView addSubview:passengersBtn];
    [_optionBtnArray addObject:passengersBtn];
    
    CustomStatusBtn *checkInBtn = [[CustomStatusBtn alloc]initWithFrame:CGRectMake(controlXLength(passengersBtn), passengersBtn.frame.origin.y, passengersBtn.frame.size.width, passengersBtn.frame.size.height)];
    [checkInBtn setTag:301];
    [checkInBtn addTarget:self action:@selector(pressBtn:) forControlEvents:UIControlEventTouchUpInside];
    [checkInBtn setImage:imageNameAndType(@"cname_item_normal", nil) selectedImage:imageNameAndType(@"cname_item_select", nil)];
    [checkInBtn setLeftViewScaleX:0.65 scaleY:0.65];
    [checkInBtn setDetail:@"默认入住人"];
    [_unfoldView addSubview:checkInBtn];
    [_optionBtnArray addObject:checkInBtn];
    
    CustomStatusBtn *contactsBtn = [[CustomStatusBtn alloc]initWithFrame:CGRectMake(controlXLength(checkInBtn), checkInBtn.frame.origin.y, passengersBtn.frame.size.width, passengersBtn.frame.size.height)];
    [contactsBtn setTag:302];
    [contactsBtn addTarget:self action:@selector(pressBtn:) forControlEvents:UIControlEventTouchUpInside];
    [contactsBtn setImage:imageNameAndType(@"cname_item_normal", nil) selectedImage:imageNameAndType(@"cname_item_select", nil)];
    [contactsBtn setLeftViewScaleX:0.65 scaleY:0.65];
    [contactsBtn setDetail:@"默认联系人"];
    [_unfoldView addSubview:contactsBtn];
    [_optionBtnArray addObject:contactsBtn];
    
    [_unfoldView addSubview:[self createLineWithFrame:CGRectMake(_unfoldUserName.frame.origin.x, controlYLength(passengersBtn), _unfoldUserName.frame.size.width, 1)]];
    [_unfoldView addSubview:_phoneNum];
    
    CustomBtn *deleteBtn = [CustomBtn buttonWithType:UIButtonTypeCustom];
    [deleteBtn setBackgroundColor:color(clearColor)];
    [deleteBtn setTag:303];
    [deleteBtn setFrame:CGRectMake(_phoneNum.frame.size.width/6, controlYLength(passengersBtn) + passengersBtn.frame.size.height/2, passengersBtn.frame.size.width,passengersBtn.frame.size.height)];
    [deleteBtn setImage:imageNameAndType(@"cname_delete_normal", nil) highlightImage:imageNameAndType(@"cname_delete_press", nil) forState:ButtonImageStateBottom];
    [deleteBtn setTitle:@"删除" forState:UIControlStateNormal];
    [_unfoldView addSubview:deleteBtn];
    
    CustomBtn *saveBtn = [CustomBtn buttonWithType:UIButtonTypeCustom];
    [saveBtn setBackgroundColor:color(clearColor)];
    [saveBtn setTag:304];
    [saveBtn setFrame:CGRectMake(_unfoldView.frame.size.width - controlXLength(deleteBtn), deleteBtn.frame.origin.y, deleteBtn.frame.size.width, deleteBtn.frame.size.height)];
    [saveBtn setImage:imageNameAndType(@"cname_save_normal", nil) highlightImage:imageNameAndType(@"cname_save_press", nil) forState:ButtonImageStateBottom];
    [saveBtn setTitle:@"保存" forState:UIControlStateNormal];
    [_unfoldView addSubview:saveBtn];

    
    [deleteBtn addTarget:self action:@selector(pressBtn:) forControlEvents:UIControlEventTouchUpInside];
    [saveBtn   addTarget:self action:@selector(pressBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    [_unfoldView setFrame:CGRectMake(_unfoldView.frame.origin.x, _unfoldView.frame.origin.y, _unfoldView.frame.size.width, controlYLength(deleteBtn) + deleteBtn.frame.size.height/2)];
    
    
    {
//    
//    UIImageView *passengerBackImage = [[UIImageView alloc]initWithFrame:CGRectMake(_phoneNum.frame.origin.x, controlYLength(_phoneNum), _phoneNum.frame.size.width, _phoneNum.frame.size.height)];
//    [passengerBackImage setBackgroundColor:color(clearColor)];
//    [passengerBackImage setImage:imageNameAndType(@"cname_unfold_box_bg", nil)];
//    [_unfoldView addSubview:passengerBackImage];
//    
//    UIButton *leftImageView1 = [UIButton buttonWithType:UIButtonTypeCustom];
//    [leftImageView1 setFrame:CGRectMake(_unfoldView.frame.origin.x + _phoneNum.frame.origin.x, _unfoldView.frame.origin.y + controlYLength(_phoneNum), _phoneNum.frame.size.height, _phoneNum.frame.size.height)];
//    [leftImageView1 setBackgroundColor:color(clearColor)];
//    [leftImageView1 setTag:200];
//    [leftImageView1 setImage:imageNameAndType(@"cname_item_normal", nil) highlightImage:imageNameAndType(@"cname_item_select", nil) forState:ButtonImageStateTop];
//    [self addSubview:leftImageView1];
//    
//    UILabel *detailLabel1 = [[UILabel alloc]initWithFrame:CGRectMake(controlXLength(leftImageView1), leftImageView1.frame.origin.y, _phoneNum.frame.size.width/3 - controlXLength(leftImageView1), leftImageView1.frame.size.height)];
//    [detailLabel1 setBackgroundColor:color(clearColor)];
//    [detailLabel1 setFont:[UIFont systemFontOfSize:12]];
//    [detailLabel1 setAdjustsFontSizeToFitWidth:YES];
//    [detailLabel1 setAdjustsLetterSpacingToFitWidth:YES];
//    [detailLabel1 setBaselineAdjustment:UIBaselineAdjustmentAlignBaselines];
//    [detailLabel1 setMinimumScaleFactor:0.3];
//    [detailLabel1 setText:@"默认乘机人"];
//    [self addSubview:detailLabel1];
//    
//    UIButton *btn1 = [UIButton buttonWithType:UIButtonTypeCustom];
//    [btn1 setFrame:CGRectMake(leftImageView1.frame.origin.x, leftImageView1.frame.origin.y, _phoneNum.frame.size.width/3, _phoneNum.frame.size.height)];
//    [btn1 setBackgroundColor:color(clearColor)];
//    [btn1 setTag:300];
//    [btn1 addTarget:self action:@selector(pressBtn:) forControlEvents:UIControlEventTouchUpInside];
//    [self addSubview:btn1];
//    
//    UIButton *leftImageView2 = [UIButton buttonWithType:UIButtonTypeCustom];
//    [leftImageView2 setFrame:CGRectMake(controlXLength(btn1), leftImageView1.frame.origin.y, leftImageView1.frame.size.width, leftImageView1.frame.size.height)];
//    [leftImageView2 setBackgroundColor:color(clearColor)];
//    [leftImageView2 setTag:201];
//    [leftImageView2 setImage:imageNameAndType(@"cname_item_normal", nil) highlightImage:imageNameAndType(@"cname_item_select", nil) forState:ButtonImageStateTop];
//    [self addSubview:leftImageView2];
//    
//    UILabel *detailLabel2 = [[UILabel alloc]initWithFrame:CGRectMake(controlXLength(leftImageView2), leftImageView2.frame.origin.y, detailLabel1.frame.size.width, detailLabel1.frame.size.height)];
//    [detailLabel2 setBackgroundColor:color(clearColor)];
//    [detailLabel2 setFont:[UIFont systemFontOfSize:12]];
//    [detailLabel2 setAdjustsFontSizeToFitWidth:YES];
//    [detailLabel2 setAdjustsLetterSpacingToFitWidth:YES];
//    [detailLabel2 setBaselineAdjustment:UIBaselineAdjustmentAlignBaselines];
//    [detailLabel2 setMinimumScaleFactor:0.3];
//    [detailLabel2 setText:@"默认入住人"];
//    [self addSubview:detailLabel2];
//    
//    UIButton *btn2 = [UIButton buttonWithType:UIButtonTypeCustom];
//    [btn2 setFrame:CGRectMake(leftImageView2.frame.origin.x, btn1.frame.origin.y, btn1.frame.size.width, btn1.frame.size.height)];
//    [btn2 setBackgroundColor:color(clearColor)];
//    [btn2 setTag:301];
//    [btn2 addTarget:self action:@selector(pressBtn:) forControlEvents:UIControlEventTouchUpInside];
//    [self addSubview:btn2];
//    
//    UIButton *leftImageView3 = [UIButton buttonWithType:UIButtonTypeCustom];
//    [leftImageView3 setFrame:CGRectMake(controlXLength(btn2), leftImageView1.frame.origin.y, leftImageView1.frame.size.width, leftImageView1.frame.size.height)];
//    [leftImageView3 setBackgroundColor:color(clearColor)];
//    [leftImageView3 setTag:202];
//    [leftImageView3 setImage:imageNameAndType(@"cname_item_normal", nil) highlightImage:imageNameAndType(@"cname_item_select", nil) forState:ButtonImageStateTop];
//    [self addSubview:leftImageView3];
//    
//    UILabel *detailLabel3 = [[UILabel alloc]initWithFrame:CGRectMake(controlXLength(leftImageView3), leftImageView2.frame.origin.y, detailLabel2.frame.size.width, detailLabel2.frame.size.height)];
//    [detailLabel3 setBackgroundColor:color(clearColor)];
//    [detailLabel3 setFont:[UIFont systemFontOfSize:12]];
//    [detailLabel3 setAdjustsFontSizeToFitWidth:YES];
//    [detailLabel3 setAdjustsLetterSpacingToFitWidth:YES];
//    [detailLabel3 setBaselineAdjustment:UIBaselineAdjustmentAlignBaselines];
//    [detailLabel3 setMinimumScaleFactor:0.3];
//    [detailLabel3 setText:@"默认联系人"];
//    [self addSubview:detailLabel3];
//    
//    UIButton *btn3 = [UIButton buttonWithType:UIButtonTypeCustom];
//    [btn3 setFrame:CGRectMake(leftImageView3.frame.origin.x, btn1.frame.origin.y, btn1.frame.size.width, btn1.frame.size.height)];
//    [btn3 setBackgroundColor:color(clearColor)];
//    [btn3 setTag:302];
//    [btn3 addTarget:self action:@selector(pressBtn:) forControlEvents:UIControlEventTouchUpInside];
//    [self addSubview:btn3];
//    
//    [leftImageView1 setScaleX:0.65 scaleY:0.65];
//    [leftImageView2 setScaleX:0.65 scaleY:0.65];
//    [leftImageView3 setScaleX:0.65 scaleY:0.65];
//    
//    UIImageView *contactsEditBackImage = [[UIImageView alloc]initWithFrame:CGRectMake(passengerBackImage.frame.origin.x, controlYLength(passengerBackImage), passengerBackImage.frame.size.width, passengerBackImage.frame.size.height * 2)];
//    [contactsEditBackImage setBackgroundColor:color(clearColor)];
//    [contactsEditBackImage setImage:stretchImage(@"cname_unfold_box_bg", nil)];
//    [_unfoldView addSubview:contactsEditBackImage];
//    
//    CustomBtn *deleteBtn = [CustomBtn buttonWithType:UIButtonTypeCustom];
//    [deleteBtn setBackgroundColor:color(clearColor)];
//    [deleteBtn setTag:303];
//    [deleteBtn setFrame:CGRectMake(self.contentView.frame.size.width/7, controlYLength(_unfoldView) + contactsEditBackImage.frame.origin.y + contactsEditBackImage.frame.size.height/4, self.contentView.frame.size.width * 2/7, passengerBackImage.frame.size.height)];
//    [deleteBtn setImage:imageNameAndType(@"cname_delete_normal", nil) highlightImage:imageNameAndType(@"cname_delete_press", nil) forState:ButtonImageStateBottom];
//    [deleteBtn addTarget:self action:@selector(pressBtn:) forControlEvents:UIControlEventTouchUpInside];
//    [deleteBtn setTitle:@"删除" forState:UIControlStateNormal];
//    [self.contentView addSubview:deleteBtn];
//    
//    CustomBtn *saveBtn = [CustomBtn buttonWithType:UIButtonTypeCustom];
//    [saveBtn setBackgroundColor:color(clearColor)];
//    [saveBtn setTag:304];
//    [saveBtn setFrame:CGRectMake(self.contentView.frame.size.width * 4/7, deleteBtn.frame.origin.y, deleteBtn.frame.size.width, deleteBtn.frame.size.height)];
//    [saveBtn setImage:imageNameAndType(@"cname_save_normal", nil) highlightImage:imageNameAndType(@"cname_save_press", nil) forState:ButtonImageStateBottom];
//    [saveBtn addTarget:self action:@selector(pressBtn:) forControlEvents:UIControlEventTouchUpInside];
//    [saveBtn setTitle:@"保存" forState:UIControlStateNormal];
//    [self.contentView addSubview:saveBtn];
//    
//    [self subviewUnfold:NO];
    }
}

- (UIImageView *)createLineWithFrame:(CGRect)frame
{
    UIImageView *line = [[UIImageView alloc]initWithFrame:frame];
    [line setBackgroundColor:color(lightGrayColor)];
    [line setAlpha:0.5];
    return line;
}

- (void)pressBtn:(CustomStatusBtn*)sender
{
    if (sender.tag == 300 || sender.tag == 301 || sender.tag == 302) {
        for (CustomStatusBtn *btn in _optionBtnArray) {
            [btn setHighlighteds:(btn.tag == sender.tag)];
        }
    }else{
        NSLog(@"sender tag = %d",sender.tag);
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated
{
    [super setHighlighted:highlighted animated:animated];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesEnded:touches withEvent:event];
}

@end




































