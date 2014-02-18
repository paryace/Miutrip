//
//  CommonlyNameViewController.m
//  MiuTrip
//
//  Created by SuperAdmin on 13-11-15.
//  Copyright (c) 2013年 michael. All rights reserved.
//

#import "CommonlyNameViewController.h"
#import "CommonlyName.h"
#import "CustomBtn.h"
#import "Account.h"

@interface CommonlyNameViewController ()

@property (strong, nonatomic) id        selectContact;

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

//        [self.requestManager getContact:nil];
    }
    return self;
}

- (void)pressRightBtn:(UIButton*)sender
{
    [self popViewControllerTransitionType:TransitionPush completionHandler:^{
        [self.delegate contactSelectDone:_selectContact];
    }];
}

#pragma mark - request handle
- (void)getContact
{
    GetContactRequest *request = [[GetContactRequest alloc]initWidthBusinessType:BUSINESS_ACCOUNT methodName:@"getContact"];
    [request setCorpID:[UserDefaults shareUserDefault].loginInfo.CorpID];
    [self.requestManager sendRequest:request];
}

- (void)getContactDone:(GetContactResponse *)response
{
    [response getObjects];
    _dataSource = [NSMutableArray arrayWithArray:response.result];
    [_theTableView reloadData];
}


- (void)requestDone:(BaseResponseModel *)response
{
    if ([response isKindOfClass:[GetContactResponse class]]) {
        [self getContactDone:(GetContactResponse*)response];
    }
}

- (void)requestFailedWithErrorCode:(NSNumber *)errorCode withErrorMsg:(NSString *)errorMsg
{
    
}

#pragma mark - tableview handle
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BookPassengersResponse *contactDetail = [_dataSource objectAtIndex:indexPath.row];
    if ([contactDetail.unfold boolValue]) {
        return CommonlyNameViewCellHeight * 6;
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
        [cell.selectBtn addTarget:self action:@selector(pressSelectBtn:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    BookPassengersResponse *contactDetail = [_dataSource objectAtIndex:indexPath.row];
    
    cell.isSelect = _selectContact == contactDetail;
    
    [cell setContentWithParams:contactDetail];
    [cell.selectBtn setIndexPath:indexPath];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    CommonlyNameViewCell *cell = (CommonlyNameViewCell*)[tableView cellForRowAtIndexPath:indexPath];
    BookPassengersResponse *contactDetail = [_dataSource objectAtIndex:indexPath.row];
    BOOL unfold = [contactDetail.unfold boolValue];
    contactDetail.unfold = [NSNumber numberWithBool:!unfold];
//    [cell subviewUnfold:unfold];
    [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
}

- (void)pressSelectBtn:(CustomBtn*)sender
{
    BookPassengersResponse *contactDetail = [_dataSource objectAtIndex:sender.indexPath.row];
    _selectContact = contactDetail;
    [_theTableView reloadData];
}

#pragma mark - view init
- (void)setSubviewFrame
{
    [self setBackGroundImage:imageNameAndType(@"home_bg", nil)];
    [self setTitle:@"选择联系人"];
    [self setTopBarBackGroundImage:imageNameAndType(@"topbar", nil)];
    
    UIButton *returnBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [returnBtn setBackgroundColor:color(clearColor)];
    [returnBtn setImage:imageNameAndType(@"return", nil) forState:UIControlStateNormal];
    [returnBtn setFrame:CGRectMake(0, 0, self.topBar.frame.size.height, self.topBar.frame.size.height)];
    [self setReturnButton:returnBtn];
    [self.view addSubview:returnBtn];
    
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightBtn setBackgroundColor:color(clearColor)];
    [rightBtn setImage:imageNameAndType(@"abs__ic_cab_done_holo_dark", nil) forState:UIControlStateNormal];
    [rightBtn setImage:imageNameAndType(@"abs__ic_cab_done_holo_light", nil) forState:UIControlStateHighlighted];
    [rightBtn setFrame:CGRectMake(self.topBar.frame.size.width - self.topBar.frame.size.height, 0, self.topBar.frame.size.height, self.topBar.frame.size.height)];
    [rightBtn setScaleX:0.65 scaleY:0.65];
    [rightBtn addTarget:self action:@selector(pressRightBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:rightBtn];
    
    [self setSubjoinViewFrame];
}

- (void)setSubjoinViewFrame
{
    if (!_theTableView) {
        _theTableView = [[UITableView alloc]initWithFrame:CGRectMake(10, controlYLength(self.topBar) + 15, self.view.frame.size.width - 20, self.bottomBar.frame.origin.y - controlYLength(self.topBar) - 20)];
        [_theTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        [_theTableView setBackgroundColor:color(clearColor)];
        [_theTableView setDelegate:self];
        [_theTableView setDataSource:self];
        [self.view addSubview:_theTableView];
    }
    
//    [self.contentView setHidden:NO];
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

@property (strong, nonatomic) UIButton                      *leftImage;

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

- (void)setContentWithParams:(BookPassengersResponse*)contactDetail
{
    [self subviewUnfold:[contactDetail.unfold boolValue]];
    [_userName setText:[Utils NULLToEmpty:contactDetail.UserName]];
    [_unfoldUserName setText:[Utils NULLToEmpty:contactDetail.UserName]];
    [_nationality setText:[Utils NULLToEmpty:contactDetail.Country]];
    MemberIDcardResponse *IDCard = [contactDetail getDefaultIDCard];
    [_cardType setText:[IDCard getCardTypeName]];
    [_cardNum setText:IDCard.CardNumber];
    [_phoneNum setText:[Utils NULLToEmpty:contactDetail.Mobilephone]];
}

- (void)setIsSelect:(BOOL)isSelect
{
    [_leftImage setHighlighted:isSelect];
}

- (BOOL)isSelect
{
    return _leftImage.highlighted;
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
    
    _leftImage = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, CommonlyNameViewCellHeight, CommonlyNameViewCellHeight)];
    [_leftImage setFrame:CGRectMake(0, 0, CommonlyNameViewCellHeight, CommonlyNameViewCellHeight)];
    [_leftImage setImage:imageNameAndType(@"autolog_normal", nil) forState:UIControlStateNormal];
    [_leftImage setImage:imageNameAndType(@"autolog_select", nil) forState:UIControlStateHighlighted];
    [_leftImage setScaleX:0.5 scaleY:0.5];
    [self.contentView addSubview:_leftImage];
    
    _selectBtn = [CustomBtn buttonWithType:UIButtonTypeCustom];
    [_selectBtn setBackgroundColor:color(clearColor)];
    [_selectBtn setFrame:CGRectMake(0, 0, CommonlyNameViewCellHeight * 1.5, CommonlyNameViewCellHeight)];
    [self.contentView addSubview:_selectBtn];
    
    _userName = [[UILabel alloc]initWithFrame:CGRectMake(controlXLength(_selectBtn), 0, appFrame.size.width - controlXLength(_selectBtn), CommonlyNameViewCellHeight)];
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
    
//    [_unfoldView addSubview:[self createLineWithFrame:CGRectMake(_unfoldUserName.frame.origin.x, controlYLength(_phoneNum), _unfoldUserName.frame.size.width, 1)]];
    [_unfoldView addSubview:_phoneNum];
    
//    CustomStatusBtn *passengersBtn = [[CustomStatusBtn alloc]initWithFrame:CGRectMake(_phoneNum.frame.origin.x, controlYLength(_phoneNum), _phoneNum.frame.size.width/3, _phoneNum.frame.size.height)];
//    [passengersBtn setTag:300];
//    [passengersBtn addTarget:self action:@selector(pressBtn:) forControlEvents:UIControlEventTouchUpInside];
//    [passengersBtn setImage:imageNameAndType(@"cname_item_normal", nil) selectedImage:imageNameAndType(@"cname_item_select", nil)];
//    [passengersBtn setLeftViewScaleX:0.65 scaleY:0.65];
//    [passengersBtn setDetail:@"默认乘机人"];
//    [_unfoldView addSubview:passengersBtn];
//    [_optionBtnArray addObject:passengersBtn];
//    
//    CustomStatusBtn *checkInBtn = [[CustomStatusBtn alloc]initWithFrame:CGRectMake(controlXLength(passengersBtn), passengersBtn.frame.origin.y, passengersBtn.frame.size.width, passengersBtn.frame.size.height)];
//    [checkInBtn setTag:301];
//    [checkInBtn addTarget:self action:@selector(pressBtn:) forControlEvents:UIControlEventTouchUpInside];
//    [checkInBtn setImage:imageNameAndType(@"cname_item_normal", nil) selectedImage:imageNameAndType(@"cname_item_select", nil)];
//    [checkInBtn setLeftViewScaleX:0.65 scaleY:0.65];
//    [checkInBtn setDetail:@"默认入住人"];
//    [_unfoldView addSubview:checkInBtn];
//    [_optionBtnArray addObject:checkInBtn];
//    
//    CustomStatusBtn *contactsBtn = [[CustomStatusBtn alloc]initWithFrame:CGRectMake(controlXLength(checkInBtn), checkInBtn.frame.origin.y, passengersBtn.frame.size.width, passengersBtn.frame.size.height)];
//    [contactsBtn setTag:302];
//    [contactsBtn addTarget:self action:@selector(pressBtn:) forControlEvents:UIControlEventTouchUpInside];
//    [contactsBtn setImage:imageNameAndType(@"cname_item_normal", nil) selectedImage:imageNameAndType(@"cname_item_select", nil)];
//    [contactsBtn setLeftViewScaleX:0.65 scaleY:0.65];
//    [contactsBtn setDetail:@"默认联系人"];
//    [_unfoldView addSubview:contactsBtn];
//    [_optionBtnArray addObject:contactsBtn];
//    
//    [_unfoldView addSubview:[self createLineWithFrame:CGRectMake(_unfoldUserName.frame.origin.x, controlYLength(passengersBtn), _unfoldUserName.frame.size.width, 1)]];
//    [_unfoldView addSubview:_phoneNum];
//    
//    CustomBtn *deleteBtn = [CustomBtn buttonWithType:UIButtonTypeCustom];
//    [deleteBtn setBackgroundColor:color(clearColor)];
//    [deleteBtn setTag:303];
//    [deleteBtn setFrame:CGRectMake(_phoneNum.frame.size.width/6, controlYLength(passengersBtn) + passengersBtn.frame.size.height/2, passengersBtn.frame.size.width,passengersBtn.frame.size.height)];
//    [deleteBtn setImage:imageNameAndType(@"cname_delete_normal", nil) highlightImage:imageNameAndType(@"cname_delete_press", nil) forState:ButtonImageStateBottom];
//    [deleteBtn setTitle:@"删除" forState:UIControlStateNormal];
//    [_unfoldView addSubview:deleteBtn];
//    
//    CustomBtn *saveBtn = [CustomBtn buttonWithType:UIButtonTypeCustom];
//    [saveBtn setBackgroundColor:color(clearColor)];
//    [saveBtn setTag:304];
//    [saveBtn setFrame:CGRectMake(_unfoldView.frame.size.width - controlXLength(deleteBtn), deleteBtn.frame.origin.y, deleteBtn.frame.size.width, deleteBtn.frame.size.height)];
//    [saveBtn setImage:imageNameAndType(@"cname_save_normal", nil) highlightImage:imageNameAndType(@"cname_save_press", nil) forState:ButtonImageStateBottom];
//    [saveBtn setTitle:@"保存" forState:UIControlStateNormal];
//    [_unfoldView addSubview:saveBtn];
//
//    
//    [deleteBtn addTarget:self action:@selector(pressBtn:) forControlEvents:UIControlEventTouchUpInside];
//    [saveBtn   addTarget:self action:@selector(pressBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    [_unfoldView setFrame:CGRectMake(_unfoldView.frame.origin.x, _unfoldView.frame.origin.y, _unfoldView.frame.size.width, controlYLength(_phoneNum))];
    
    
    
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




































