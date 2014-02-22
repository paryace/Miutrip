//
//  PostAddressController.m
//  MiuTrip
//
//  Created by GX on 14-1-23.
//  Copyright (c) 2014年 michael. All rights reserved.
//

#import "PostAddressController.h"
#import "SettingViewController.h"
#import "GetCorpInfoRequest.h"
#import "GetCorpInfoResponse.h"
@interface PostAddressController (){
    NSMutableArray *postArrayData;
    UITableView *PostView;
}

@end

@implementation PostAddressController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(id)init{
    if (self =[super init]) {
        [self postRequest];
        
        
    }
    return self;
}
-(void)subView{
    [self setBackGroundImage:imageNameAndType(@"home_bg", nil)];
    [self setTitle:@"选择邮递地址"];
    [self setTopBarBackGroundImage:imageNameAndType(@"topbar", nil)];
    UIButton *returnBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [returnBtn setBackgroundColor:color(clearColor)];
    [returnBtn setImage:imageNameAndType(@"return", nil) forState:UIControlStateNormal];
    [returnBtn setFrame:CGRectMake(0, 0, self.topBar.frame.size.height, self.topBar.frame.size.height)];
    [self setReturnButton:returnBtn];
    [self.view addSubview:returnBtn];
    
     PostView =[[UITableView alloc]initWithFrame:CGRectMake(0, self.topBar.frame.size.height, self.view.frame.size.width, self.view.frame.size.height-self.topBar.frame.size.height)];
    [PostView setDelegate:self];
    [PostView setDataSource:self];
    PostView.showsVerticalScrollIndicator=NO;
    PostView.bounces=NO;
    PostView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:PostView];


}

-(void)postRequest{
    GetCorpInfoRequest *postForRequest =[[GetCorpInfoRequest alloc]initWidthBusinessType:BUSINESS_ACCOUNT methodName:@"GetCorpInfo"];
    postForRequest.CorpID=@"22";
    [self.requestManager sendRequest:postForRequest];
}
- (void)requestDone:(GetCorpInfoResponse *)response{
    if (response) {
        postArrayData =[NSMutableArray arrayWithArray:response.Corp_AddressList];
        [self subView];
    }
    if (response==nil) {
        [self subView];
    }
}
//请求失败
-(void)requestFailedWithErrorCode:(NSNumber *)errorCode withErrorMsg:(NSString *)errorMsg
{
    NSLog(@"error = %@",errorMsg);
    
}
-(BaseResponseModel*) getResponseFromRequestClassName:(NSString*) requestClassName{
    
    if(requestClassName == nil || requestClassName.length == 0){
        return nil;
    }
    
    if([requestClassName hasSuffix:@"Request"]){
        //替换字符串生成对应的RESPONSE类名称
        NSString *responseClassName = [requestClassName stringByReplacingOccurrencesOfString:@"Request" withString:@"Response"];
        //反射出对应的类
        Class responseClass = NSClassFromString(responseClassName);
        //没找到该类，或出错
        if(!responseClass){
            return nil;
        }
        //生成对应的对象
        return [[responseClass alloc] init];
    }
    
    return nil;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return [postArrayData count];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath*)indexPath{
    NSString *provinceStr=[[postArrayData objectAtIndex:indexPath.row] objectForKey:@"ProvinceName"];
    NSString *City= [[postArrayData objectAtIndex:indexPath.row] objectForKey:@"CityName"];
    NSString *Canton =[[postArrayData objectAtIndex:indexPath.row] objectForKey:@"CantonName"];
    NSString *Address =[[postArrayData objectAtIndex:indexPath.row] objectForKey:@"Address"];
    NSString *Name =[[postArrayData objectAtIndex:indexPath.row] objectForKey:@"RecipientName"];
    NSString *ZipCode =[[postArrayData objectAtIndex:indexPath.row] objectForKey:@"ZipCode"];
    NSString *str =[NSString stringWithFormat:@"%@   %@%@%@   %@   收邮编%@",provinceStr,City,Canton,Address,Name,ZipCode];
    CGSize size = [str sizeWithFont:[UIFont systemFontOfSize:20] constrainedToSize:CGSizeMake(300, 1000) lineBreakMode:NSLineBreakByCharWrapping];
    
    
    return size.height+10;
//    return size.height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    static NSString *CellIdentifier =@"StartCity";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell ==nil) {
        cell =[[ UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        
    }
    NSString *provinceStr=[[postArrayData objectAtIndex:indexPath.row] objectForKey:@"ProvinceName"];
    NSString *City= [[postArrayData objectAtIndex:indexPath.row] objectForKey:@"CityName"];
    NSString *Canton =[[postArrayData objectAtIndex:indexPath.row] objectForKey:@"CantonName"];
    NSString *Address =[[postArrayData objectAtIndex:indexPath.row] objectForKey:@"Address"];
    NSString *Name =[[postArrayData objectAtIndex:indexPath.row] objectForKey:@"RecipientName"];
    NSString *ZipCode =[[postArrayData objectAtIndex:indexPath.row] objectForKey:@"ZipCode"];
    NSString *str  =[NSString stringWithFormat:@"%@ %@%@%@ %@ 收邮编%@",provinceStr,City,Canton,Address,Name,ZipCode];
    cell.textLabel.text=str;
    cell.textLabel.numberOfLines=0;
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    for (int i=0; i<=[postArrayData count];i++) {
        if(indexPath.row==i){
            [self popViewControllerTransitionType:TransitionPush completionHandler:^{
                self.postAddress([[postArrayData objectAtIndex:indexPath.row] objectForKey:@"ProvinceName"]);
                [[UserDefaults shareUserDefault] setPostAddress:[[postArrayData objectAtIndex:indexPath.row] objectForKey:@"ProvinceName"]];
            }];
        }
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
