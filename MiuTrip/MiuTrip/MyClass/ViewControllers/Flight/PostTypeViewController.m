//
//  PostTypeViewController.m
//  MiuTrip
//
//  Created by apple on 14-2-12.
//  Copyright (c) 2014年 michael. All rights reserved.
//

#import "PostTypeViewController.h"
#import "DBProvince.h"
#import "OnLineAllClass.h"

@interface PostTypeViewController ()

@property (strong, nonatomic) UITextField   *postDescTf;        //配送地址描述        //cover btn tag  100
@property (strong, nonatomic) UILabel       *postAddressLb;     //选择配送地址        //cover btn tag  101
@property (strong, nonatomic) UITextField   *recipientTf;       //收件人
@property (strong, nonatomic) UITextField   *provinceTf;        //省地址             //cover btn tag  102
@property (strong, nonatomic) UITextField   *cityTf;            //市地址             //cover btn tag  103
@property (strong, nonatomic) UITextField   *cantonTf;          //区地址             //cover btn tag  104
@property (strong, nonatomic) UITextField   *addressDetailTf;   //详细地址
@property (strong, nonatomic) UITextField   *zipCodeTf;         //邮编
@property (strong, nonatomic) UITextField   *telTf;             //电话号码
@property (assign, nonatomic) BOOL          saveAddress;        //保存到常用地址       //cover btn tag  105

@property (strong, nonatomic) MemberDeliverDTO  *memberDeliverDTO;  //配送地址信息

@property (strong, nonatomic) TC_APIMImInfo *postType;
@property (strong, nonatomic) DBProvince    *province;
@property (strong, nonatomic) CityDTO       *city;
@property (strong, nonatomic) CantonDTO     *canton;

@property (strong, nonatomic) SelectPostTypeViewController *selectPostTypeView;

@end

@implementation PostTypeViewController

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
    self = [super init];
    if (self) {
        _saveAddress = YES;
        [self setSubviewFrame];
        
        _selectPostTypeView = [[SelectPostTypeViewController alloc]init];
        [_selectPostTypeView setDelegate:self];
        [self.view addSubview:_selectPostTypeView.view];
    }
    return self;
}

- (void)pressSaveContact:(CustomStatusBtn*)sender
{
    _saveAddress = !_saveAddress;
    [sender setSelect:_saveAddress];
}

- (void)pressNextBtn:(UIButton*)sender
{
    DeliveryTypeDTO *deliverDTO = [self getDeliverDTO];
    if ([self checkDeliverDetail:deliverDTO]) {
        if (_postType) {
            if ([_postType.mCode integerValue] == 0) {
                deliverDTO = [[DeliveryTypeDTO alloc]init];
            }
        }
        [self popViewControllerTransitionType:TransitionPush completionHandler:^{
            [self.delegate selectPostDone:deliverDTO mailCode:_postType];
        }];
    }
}

#pragma mark - get deliverDTO
- (DeliveryTypeDTO*)getDeliverDTO
{
    DeliveryTypeDTO *deliverDTO = [[DeliveryTypeDTO alloc]init];
    if (!_postType) {
        [[Model shareModel] showPromptText:@"请选择配送方式" model:YES];
        return nil;
    }else{
        if ([_postType.mCode integerValue] == 0) {
            deliverDTO.IsNeed = [NSNumber numberWithInt:0];
        }else{
            deliverDTO.IsNeed = [NSNumber numberWithInt:1];
        }
    }
    if (_memberDeliverDTO) {
        deliverDTO.Province = _memberDeliverDTO.Province;
        deliverDTO.City     = _memberDeliverDTO.City;
        deliverDTO.Canton   = _memberDeliverDTO.Canton;
        deliverDTO.Address  = _memberDeliverDTO.Address;
        deliverDTO.AddID    = _memberDeliverDTO.AddID;
        deliverDTO.ZipCode  = _memberDeliverDTO.ZipCode;
        deliverDTO.RecipientName = _memberDeliverDTO.RecipientName;
        if (![Utils textIsEmpty:_memberDeliverDTO.Mobile]) {
            [deliverDTO setTel:[Utils NULLToEmpty:_memberDeliverDTO.Mobile]];
        }else if (![Utils textIsEmpty:_memberDeliverDTO.Tel]){
            [deliverDTO setTel:[Utils NULLToEmpty:_memberDeliverDTO.Tel]];
        }
    }else{
//        if ([Utils textIsEmpty:_recipientTf.text]) {
//            [[Model shareModel] showPromptText:@"请输入收件人姓名" model:YES];
//            return nil;
//        }else if (!_province){
//            [[Model shareModel] showPromptText:@"请选择配送省份" model:YES];
//            return nil;
//        }else if (!_city){
//            [[Model shareModel] showPromptText:@"请选择配送城市" model:YES];
//            return nil;
//        }else if (!_canton){
//            [[Model shareModel] showPromptText:@"请选择配送区域" model:YES];
//            return nil;
//        }else if ([Utils textIsEmpty:_addressDetailTf.text]){
//            [[Model shareModel] showPromptText:@"请输入街道地址" model:YES];
//            return nil;
//        }else if ([Utils textIsEmpty:_zipCodeTf.text]){
//            [[Model shareModel] showPromptText:@"请输入邮政编码" model:YES];
//            return nil;
//        }else if ([Utils textIsEmpty:_telTf.text]){
//            [[Model shareModel] showPromptText:@"请输入电话号码" model:YES];
//            return nil;
//        }else if (![Utils isValidatePhoneNum:_telTf.text]){
//            [[Model shareModel] showPromptText:@"电话号码格式不正确" model:YES];
//            return nil;
//        }else{
            deliverDTO.RecipientName = _recipientTf.text;
            deliverDTO.Province = [NSNumber numberWithInteger:[_province.ProvinceID integerValue]];
            deliverDTO.City     = _city.CityID;
            deliverDTO.Canton   = _canton.CID;
            deliverDTO.Address  = _addressDetailTf.text;
            deliverDTO.ZipCode  = _zipCodeTf.text;
            deliverDTO.Tel      = _telTf.text;
//        }
        
        
    }
    return deliverDTO;
}

- (BOOL)checkDeliverDetail:(DeliveryTypeDTO*)deliver
{
    BOOL isValidate = YES;
    
//    if (_postType) {
//        if ([_postType.postCode integerValue] == 0) {
//            return YES;
//        }
//    }
    
    if (!deliver) {
        return NO;
    }else{
        if ([Utils textIsEmpty:deliver.RecipientName]) {
            [[Model shareModel] showPromptText:@"请输入收件人姓名" model:YES];
            return NO;
        }else if ([Utils isEmpty:deliver.Province]){
            [[Model shareModel] showPromptText:@"请选择配送省份" model:YES];
            return NO;
        }else if ([Utils isEmpty:deliver.City]){
            [[Model shareModel] showPromptText:@"请选择配送城市" model:YES];
            return NO;
        }else if ([Utils isEmpty:deliver.Canton]){
            [[Model shareModel] showPromptText:@"请选择配送区域" model:YES];
            return NO;
        }else if ([Utils textIsEmpty:deliver.Address]){
            [[Model shareModel] showPromptText:@"请输入街道地址" model:YES];
            return NO;
        }else if ([Utils textIsEmpty:deliver.ZipCode]){
            [[Model shareModel] showPromptText:@"请输入邮政编码" model:YES];
            return NO;
        }else if ([Utils textIsEmpty:deliver.Tel]){
            [[Model shareModel] showPromptText:@"请输入电话号码" model:YES];
            return NO;
        }else if (![Utils isValidatePhoneNum:deliver.Tel]){
            [[Model shareModel] showPromptText:@"电话号码格式不正确" model:YES];
            return NO;
        }
    }
    
    return isValidate;
}

#pragma mark - select post detail
- (void)pressBtnItem:(UIButton*)sender
{
    NSLog(@"tag = %d",sender.tag);
    switch (sender.tag) {
        case 100:{
            [_selectPostTypeView fire];
            break;
        }case 101:{
            SelectDeliverViewController *viewController = [[SelectDeliverViewController alloc]init];
            [viewController setDelegate:self];
            [self pushViewController:viewController transitionType:TransitionPush completionHandler:^{
                [viewController getMemberDeliverList:_policyExecutor];
            }];
            break;
        }case 102:{
            SelectAddressViewController *viewController = [[SelectAddressViewController alloc]init];
            [viewController setDelegate:self];
            [self pushViewController:viewController transitionType:TransitionPush completionHandler:^{
                [viewController getAddressList];
            }];
            break;
        }case 103:{
            if (!_province) {
                [[Model shareModel] showPromptText:@"请先选择省份" model:YES];
                return;
            }
            SelectAddressViewController *viewController = [[SelectAddressViewController alloc]initWithObject:_province];
            [viewController setDelegate:self];
            [self pushViewController:viewController transitionType:TransitionPush completionHandler:^{
                [viewController getAddressList];
            }];
            break;
        }case 104:{
            if (!_city) {
                [[Model shareModel] showPromptText:@"请先选择城市" model:YES];
                return;
            }
            SelectAddressViewController *viewController = [[SelectAddressViewController alloc]initWithObject:_city];
            [viewController setDelegate:self];
            [self pushViewController:viewController transitionType:TransitionPush completionHandler:^{
                [viewController getAddressList];
            }];
            break;
        }
        default:
            break;
    }
}

#pragma mark - select deliver
- (void)selectDeliverDone:(MemberDeliverDTO *)deliverDTO
{
    _memberDeliverDTO = deliverDTO;
    [self setViewContentWithParams:deliverDTO];
}

#pragma mark - select address
- (void)selectAddressDone:(id)address
{
    [self setViewContentWithParams:address];
}

- (void)setViewContentWithParams:(id)object
{
    
    if ([object isKindOfClass:[MemberDeliverDTO class]]) {
        MemberDeliverDTO *deliver = object;
        [_postAddressLb setText:[NSString stringWithFormat:@"%@(省)%@(市)%@(区)%@",deliver.ProvinceName,deliver.CityName,deliver.Canton_Name,deliver.Address]];
        [_recipientTf setText:deliver.RecipientName];
        [_provinceTf setText:deliver.ProvinceName];
        [_cityTf setText:deliver.CityName];
        [_cantonTf setText:deliver.Canton_Name];
        [_addressDetailTf setText:deliver.Address];
        [_zipCodeTf setText:deliver.ZipCode];
        if (![Utils isEmpty:deliver.Mobile]) {
            [_telTf setText:[Utils NULLToEmpty:deliver.Mobile]];
        }else if (![Utils isEmpty:deliver.Tel]){
            [_telTf setText:[Utils NULLToEmpty:deliver.Tel]];
        }
    }else{
        NSMutableString *string = [NSMutableString string];
        if (([object isKindOfClass:[DBProvince class]]) ) {
            _province = object;
            [_provinceTf setText:_province.ProvinceName];
            _city = nil;
            [_cityTf setText:nil];
            _canton = nil;
            [_cantonTf setText:nil];
            [string appendFormat:@"%@(省)",_province.ProvinceName];
        }else if ([object isKindOfClass:[CityDTO class]]){
            _city = object;
            [_cityTf setText:_city.CityName];
            _canton = nil;
            [_cantonTf setText:nil];
            [string appendFormat:@"%@(省)%@(市)",_province.ProvinceName,_city.CityName];
        }else if ([object isKindOfClass:[CantonDTO class]]){
            _canton = object;
            [_cantonTf setText:_canton.Canton_Name];
            [string appendFormat:@"%@(省)%@(市)%@(区)",_province.ProvinceName,_city.CityName,_canton.Canton_Name];
        }
        if (![Utils textIsEmpty:[_addressDetailTf text]]) {
            [string appendFormat:@"%@",_addressDetailTf.text];
        }
        [_postAddressLb setText:string];
    }
}

#pragma mark - select post type
- (void)selectPostTypeDone:(TC_APIMImInfo*)postType
{
    _postType = postType;
    [_postDescTf setText:[NSString stringWithFormat:@"%@(%@)",postType.mName,postType.rPrice]];
}


#pragma mark - view init
- (void)setSubviewFrame
{
    [self setBackGroundImage:imageNameAndType(@"home_bg", nil)];
    [self setTitle:@"配送地址"];
    [self setTopBarBackGroundImage:imageNameAndType(@"topbar", nil)];
    
    UIButton *returnBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [returnBtn setBackgroundColor:color(clearColor)];
    [returnBtn setImage:imageNameAndType(@"return", nil) forState:UIControlStateNormal];
    [returnBtn setFrame:CGRectMake(0, 0, self.topBar.frame.size.height, self.topBar.frame.size.height)];
    [self setReturnButton:returnBtn];
    [self.view addSubview:returnBtn];
    
    [self setSubjoinViewFrame];
}

- (void)setSubjoinViewFrame
{
    UIView *contentBGView = [[UIView alloc]initWithFrame:CGRectMake(10, controlYLength(self.topBar) + 10, self.view.frame.size.width - 20, 0)];
    [contentBGView setBackgroundColor:color(whiteColor)];
    [contentBGView setShaowColor:color(lightGrayColor) offset:CGSizeMake(4, 4) opacity:1 radius:5];
    [contentBGView setCornerRadius:5.0];
    [self.contentView addSubview:contentBGView];
    
    UILabel *postDescLeftLb = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, contentBGView.frame.size.width * 0.28, 40)];
    [postDescLeftLb setBackgroundColor:color(clearColor)];
    [postDescLeftLb setFont:[UIFont systemFontOfSize:13]];
    [postDescLeftLb setTextColor:color(grayColor)];
    [postDescLeftLb setText:@"配送方式"];
    [postDescLeftLb setTextAlignment:NSTextAlignmentRight];
    [contentBGView addSubview:postDescLeftLb];
    _postDescTf = [[UITextField alloc]initWithFrame:CGRectMake(controlXLength(postDescLeftLb) + 10, 0, contentBGView.frame.size.width - controlXLength(postDescLeftLb) - 10, postDescLeftLb.frame.size.height)];
    [_postDescTf setFont:postDescLeftLb.font];
    [_postDescTf setEnabled:NO];
    [_postDescTf setDelegate:self];
    [_postDescTf setBackgroundColor:color(clearColor)];
    [contentBGView addSubview:_postDescTf];
    UIButton *postTypeSelectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [postTypeSelectBtn setFrame:_postDescTf.frame];
    [postTypeSelectBtn setTag:100];
    [postTypeSelectBtn addTarget:self action:@selector(pressBtnItem:) forControlEvents:UIControlEventTouchUpInside];
    [contentBGView addSubview:postTypeSelectBtn];
    [self createRightViewWithTitle:nil superView:_postDescTf];
    
    [contentBGView createLineWithParam:color(lightGrayColor) frame:CGRectMake(0, controlYLength(_postDescTf), contentBGView.frame.size.width, 0.5)];
    
    UILabel *selectPostAddressLeft = [[UILabel alloc]initWithFrame:CGRectMake(postDescLeftLb.frame.origin.x, controlYLength(_postDescTf), postDescLeftLb.frame.size.width, postDescLeftLb.frame.size.height)];
    [selectPostAddressLeft setBackgroundColor:color(clearColor)];
    [selectPostAddressLeft setFont:[UIFont systemFontOfSize:12]];
    [selectPostAddressLeft setTextColor:color(grayColor)];
    [selectPostAddressLeft setText:@"选择配送地址"];
    [selectPostAddressLeft setTextAlignment:NSTextAlignmentRight];
    [contentBGView addSubview:selectPostAddressLeft];
    _postAddressLb = [[UILabel alloc]initWithFrame:CGRectMake(_postDescTf.frame.origin.x, controlYLength(_postDescTf), _postDescTf.frame.size.width - _postDescTf.frame.size.height * 1.5, _postDescTf.frame.size.height)];
    [_postAddressLb setFont:postDescLeftLb.font];
    [_postAddressLb setTextColor:color(blackColor)];
    [_postAddressLb setAutoBreakLine:YES];
    [contentBGView addSubview:_postAddressLb];
    UIButton *postAddressSelectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [postAddressSelectBtn setFrame:CGRectMake(_postAddressLb.frame.origin.x, _postAddressLb.frame.origin.y, _postDescTf.frame.size.width, _postAddressLb.frame.size.height)];
    [postAddressSelectBtn setTag:101];
    [postAddressSelectBtn addTarget:self action:@selector(pressBtnItem:) forControlEvents:UIControlEventTouchUpInside];
    [contentBGView addSubview:postAddressSelectBtn];
    [self createRightViewWithTitle:nil superView:postAddressSelectBtn];
    
    [contentBGView createLineWithParam:color(lightGrayColor) frame:CGRectMake(0, controlYLength(_postAddressLb), contentBGView.frame.size.width, 0.5)];
    
    UILabel *recipientLeft = [[UILabel alloc]initWithFrame:CGRectMake(postDescLeftLb.frame.origin.x, controlYLength(_postAddressLb), postDescLeftLb.frame.size.width, postDescLeftLb.frame.size.height)];
    [recipientLeft setBackgroundColor:color(clearColor)];
    [recipientLeft setFont:[UIFont systemFontOfSize:13]];
    [recipientLeft setTextColor:color(grayColor)];
    [recipientLeft setText:@"收件人"];
    [recipientLeft setTextAlignment:NSTextAlignmentRight];
    [contentBGView addSubview:recipientLeft];
    _recipientTf = [[UITextField alloc]initWithFrame:CGRectMake(_postDescTf.frame.origin.x, controlYLength(_postAddressLb), _postDescTf.frame.size.width, _postDescTf.frame.size.height)];
    [_recipientTf setFont:postDescLeftLb.font];
    [_recipientTf setDelegate:self];
    [contentBGView addSubview:_recipientTf];
    
    [contentBGView createLineWithParam:color(lightGrayColor) frame:CGRectMake(0, controlYLength(_recipientTf), contentBGView.frame.size.width, 0.5)];
    
    UILabel *provinceLeft = [[UILabel alloc]initWithFrame:CGRectMake(postDescLeftLb.frame.origin.x, controlYLength(_recipientTf), postDescLeftLb.frame.size.width, postDescLeftLb.frame.size.height)];
    [provinceLeft setBackgroundColor:color(clearColor)];
    [provinceLeft setFont:[UIFont systemFontOfSize:13]];
    [provinceLeft setTextColor:color(grayColor)];
    [provinceLeft setText:@"收件地址"];
    [provinceLeft setTextAlignment:NSTextAlignmentRight];
    [contentBGView addSubview:provinceLeft];
    _provinceTf = [[UITextField alloc]initWithFrame:CGRectMake(_postDescTf.frame.origin.x, controlYLength(_recipientTf), _postDescTf.frame.size.width, _postDescTf.frame.size.height)];
    [_provinceTf setFont:postDescLeftLb.font];
    [_provinceTf setDelegate:self];
    [_provinceTf setEnabled:NO];
    [contentBGView addSubview:_provinceTf];
    UIButton *provinceSelectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [provinceSelectBtn setFrame:_provinceTf.frame];
    [provinceSelectBtn setTag:102];
    [provinceSelectBtn addTarget:self action:@selector(pressBtnItem:) forControlEvents:UIControlEventTouchUpInside];
    [contentBGView addSubview:provinceSelectBtn];
    [self createRightViewWithTitle:@"省" superView:_provinceTf];
    
    [contentBGView createLineWithParam:color(lightGrayColor) frame:CGRectMake(0, controlYLength(_provinceTf), contentBGView.frame.size.width, 0.5)];
    
    _cityTf = [[UITextField alloc]initWithFrame:CGRectMake(_postDescTf.frame.origin.x, controlYLength(_provinceTf), _postDescTf.frame.size.width, _postDescTf.frame.size.height)];
    [_cityTf setFont:postDescLeftLb.font];
    [_cityTf setDelegate:self];
    [_cityTf setEnabled:NO];
    [contentBGView addSubview:_cityTf];
    [self createRightViewWithTitle:@"市" superView:_cityTf];
    UIButton *citySelectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [citySelectBtn setFrame:_cityTf.frame];
    [citySelectBtn setTag:103];
    [citySelectBtn addTarget:self action:@selector(pressBtnItem:) forControlEvents:UIControlEventTouchUpInside];
    [contentBGView addSubview:citySelectBtn];
    
    [contentBGView createLineWithParam:color(lightGrayColor) frame:CGRectMake(0, controlYLength(_cityTf), contentBGView.frame.size.width, 0.5)];
    
    _cantonTf = [[UITextField alloc]initWithFrame:CGRectMake(_postDescTf.frame.origin.x, controlYLength(_cityTf), _postDescTf.frame.size.width, _postDescTf.frame.size.height)];
    [_cantonTf setFont:postDescLeftLb.font];
    [_cantonTf setDelegate:self];
    [_cantonTf setEnabled:NO];
    [contentBGView addSubview:_cantonTf];
    [self createRightViewWithTitle:@"区" superView:_cantonTf];
    UIButton *cantonSelectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [cantonSelectBtn setFrame:_cantonTf.frame];
    [cantonSelectBtn setTag:104];
    [cantonSelectBtn addTarget:self action:@selector(pressBtnItem:) forControlEvents:UIControlEventTouchUpInside];
    [contentBGView addSubview:cantonSelectBtn];
    
    [contentBGView createLineWithParam:color(lightGrayColor) frame:CGRectMake(0, controlYLength(_cantonTf), contentBGView.frame.size.width, 0.5)];
    
    UILabel *addressDetailLeft = [[UILabel alloc]initWithFrame:CGRectMake(postDescLeftLb.frame.origin.x, controlYLength(_cantonTf), postDescLeftLb.frame.size.width, postDescLeftLb.frame.size.height)];
    [addressDetailLeft setBackgroundColor:color(clearColor)];
    [addressDetailLeft setFont:[UIFont systemFontOfSize:13]];
    [addressDetailLeft setTextColor:color(grayColor)];
    [addressDetailLeft setText:@"街道地址"];
    [addressDetailLeft setTextAlignment:NSTextAlignmentRight];
    [contentBGView addSubview:addressDetailLeft];
    _addressDetailTf = [[UITextField alloc]initWithFrame:CGRectMake(_postDescTf.frame.origin.x, controlYLength(_cantonTf), _postDescTf.frame.size.width, _postDescTf.frame.size.height)];
    [_addressDetailTf setFont:postDescLeftLb.font];
    [_addressDetailTf setDelegate:self];
    [contentBGView addSubview:_addressDetailTf];
    
    [contentBGView createLineWithParam:color(lightGrayColor) frame:CGRectMake(0, controlYLength(_addressDetailTf), contentBGView.frame.size.width, 0.5)];
    
    UILabel *zipCodeLeft = [[UILabel alloc]initWithFrame:CGRectMake(postDescLeftLb.frame.origin.x, controlYLength(_addressDetailTf), postDescLeftLb.frame.size.width, postDescLeftLb.frame.size.height)];
    [zipCodeLeft setBackgroundColor:color(clearColor)];
    [zipCodeLeft setFont:[UIFont systemFontOfSize:13]];
    [zipCodeLeft setTextColor:color(grayColor)];
    [zipCodeLeft setText:@"邮政编码"];
    [zipCodeLeft setTextAlignment:NSTextAlignmentRight];
    [contentBGView addSubview:zipCodeLeft];
    _zipCodeTf = [[UITextField alloc]initWithFrame:CGRectMake(_postDescTf.frame.origin.x, controlYLength(_addressDetailTf), _postDescTf.frame.size.width, _postDescTf.frame.size.height)];
    [_zipCodeTf setFont:postDescLeftLb.font];
    [_zipCodeTf setDelegate:self];
    [contentBGView addSubview:_zipCodeTf];
    
    [contentBGView createLineWithParam:color(lightGrayColor) frame:CGRectMake(0, controlYLength(_zipCodeTf), contentBGView.frame.size.width, 0.5)];
    
    UILabel *telLeft = [[UILabel alloc]initWithFrame:CGRectMake(postDescLeftLb.frame.origin.x, controlYLength(_zipCodeTf), postDescLeftLb.frame.size.width, postDescLeftLb.frame.size.height)];
    [telLeft setBackgroundColor:color(clearColor)];
    [telLeft setFont:[UIFont systemFontOfSize:13]];
    [telLeft setTextColor:color(grayColor)];
    [telLeft setText:@"电话号码"];
    [telLeft setTextAlignment:NSTextAlignmentRight];
    [contentBGView addSubview:telLeft];
    _telTf = [[UITextField alloc]initWithFrame:CGRectMake(_postDescTf.frame.origin.x, controlYLength(_zipCodeTf), _postDescTf.frame.size.width, _postDescTf.frame.size.height)];
    [_telTf setFont:postDescLeftLb.font];
    [_telTf setDelegate:self];
    [contentBGView addSubview:_telTf];
    
    [contentBGView createLineWithParam:color(lightGrayColor) frame:CGRectMake(0, controlYLength(_telTf), contentBGView.frame.size.width, 0.5)];
    
    CustomStatusBtn *saveContactBtn = [[CustomStatusBtn alloc]initWithFrame:CGRectMake(postDescLeftLb.frame.origin.x, controlYLength(_telTf), postDescLeftLb.frame.size.width * 2, postDescLeftLb.frame.size.height)];
    [saveContactBtn setLeftViewScaleX:0.55 scaleY:0.55];
    [saveContactBtn setImage:imageNameAndType(@"autolog_normal", nil) selectedImage:imageNameAndType(@"autolog_select", nil)];
    [saveContactBtn setDetail:@"保存到常用地址"];
    [saveContactBtn setHighlighteds:_saveAddress];
    [saveContactBtn setTag:105];
    [saveContactBtn addTarget:self action:@selector(pressSaveContact:) forControlEvents:UIControlEventTouchUpInside];
    [contentBGView addSubview:saveContactBtn];
    
    [contentBGView setFrame:CGRectMake(contentBGView.frame.origin.x, contentBGView.frame.origin.y, contentBGView.frame.size.width, controlYLength(saveContactBtn))];
    
    UIButton *nextBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [nextBtn setFrame:CGRectMake(self.contentView.frame.size.width/6, controlYLength(contentBGView) + 20, self.contentView.frame.size.width * 2/3, 40)];
    [nextBtn setBackgroundImage:imageNameAndType(@"done_btn_normal", nil) forState:UIControlStateNormal];
    [nextBtn setBackgroundImage:imageNameAndType(@"done_btn_press", nil) forState:UIControlStateHighlighted];
    [nextBtn setTitle:@"下一步" forState:UIControlStateNormal];
    [nextBtn addTarget:self action:@selector(pressNextBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:nextBtn];
}

- (void)createRightViewWithTitle:(NSString*)title superView:(UIView*)view
{
    UIView *rightView = [[UIView alloc]initWithFrame:CGRectMake(view.frame.size.width - view.frame.size.height * 1.5, 0, view.frame.size.height * 1.5, view.frame.size.height)];
    [rightView setBackgroundColor:color(clearColor)];
    UIImageView *rightImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, rightView.frame.size.height/4, rightView.frame.size.height/3)];
    [rightImage setCenter:CGPointMake(rightView.frame.size.width - rightImage.frame.size.width, rightView.frame.size.height/2)];
    [rightImage setImage:imageNameAndType(@"arrow", nil)];
    [rightView addSubview:rightImage];
    
    if (title) {
        UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, rightView.frame.size.height, rightView.frame.size.height)];
        [titleLabel setBackgroundColor:color(clearColor)];
        [titleLabel setFont:[UIFont systemFontOfSize:13]];
        [titleLabel setAutoSize:YES];
        [titleLabel setText:title];
        [titleLabel setTextAlignment:NSTextAlignmentCenter];
        [rightView addSubview:titleLabel];
    }
    
    [view addSubview:rightView];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self clearKeyBoard];
}

- (BOOL)clearKeyBoard
{
    BOOL canResignFirstResponder = NO;
    if ([_postDescTf isFirstResponder]) {
        [_postDescTf resignFirstResponder];
        canResignFirstResponder = YES;
    }else if ([_postAddressLb isFirstResponder]){
        [_postAddressLb resignFirstResponder];
        canResignFirstResponder = YES;
    }else if ([_recipientTf isFirstResponder]){
        [_recipientTf resignFirstResponder];
        canResignFirstResponder = YES;
    }else if ([_provinceTf isFirstResponder]){
        [_provinceTf resignFirstResponder];
        canResignFirstResponder = YES;
    }else if ([_cityTf isFirstResponder]){
        [_cityTf resignFirstResponder];
        canResignFirstResponder = YES;
    }else if ([_cantonTf isFirstResponder]){
        [_cantonTf resignFirstResponder];
        canResignFirstResponder = YES;
    }else if ([_addressDetailTf isFirstResponder]){
        [_addressDetailTf resignFirstResponder];
    }else if ([_zipCodeTf isFirstResponder]){
        [_zipCodeTf resignFirstResponder];
        canResignFirstResponder = YES;
    }else if ([_telTf isFirstResponder]){
        [_telTf resignFirstResponder];
        canResignFirstResponder = YES;
    }
    
    return canResignFirstResponder;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if ([textField isFirstResponder]) {
        [textField resignFirstResponder];
    }
    return YES;
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

@implementation PostType

+ (NSArray*)getPostTypes
{
    NSDictionary *postTypeData = [NSDictionary dictionaryWithObjectsAndKeys:
                                  @"不需要行程单",            @"0",
                                  @"平邮",                  @"1",
                                  @"快递",                  @"2",
                                  @"EMS",                   @"3",
                                  nil];
    NSArray *allKeys = [postTypeData allKeys];
    NSMutableArray *postTypes = [NSMutableArray array];
    for (NSString *key in allKeys) {
        PostType *postType = [[PostType alloc]init];
        postType.postCode = [NSNumber numberWithInteger:[key integerValue]];
        postType.postDesc = [postTypeData objectForKey:key];
        [postTypes addObject:postType];
    }
    return postTypes;
}

@end
