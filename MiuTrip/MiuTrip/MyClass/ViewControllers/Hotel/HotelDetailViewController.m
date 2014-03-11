//
//  HotelDetailViewController.m
//  MiuTrip
//
//  Created by stevencheng on 13-12-14.
//  Copyright (c) 2013年 michael. All rights reserved.
//

#import "HotelDetailViewController.h"
#import "GetHotelDetailRequest.h"
#import "GetHotelDetailResponse.h"
#import "HotelDataCache.h"
#import "GetHotelTrafficlnfoRequest.h"
#import "GetHotelTrafficInfoResponse.h"
#import "Utils.h"

@interface HotelDetailViewController ()

@end

@implementation HotelDetailViewController

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
        [self setSubView];
    }
    return self;
}


-(void)setSubView{
    _isExpanded = NO;
    _selectedRow = -1;
    [self addTitleWithTitle:@"酒店详情" withRightView:nil];
    [self addLoadingView];
    [self getHotelDetail];
    
}

-(void)initView
{

    [self.contentView setBackgroundColor:UIColorFromRGB(0xffe9e9e9)];
    
    int width = self.contentView.frame.size.width;
    int height = self.contentView.frame.size.height;
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 40, width, height)];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.contentView addSubview:_tableView];
 
}


-(void)getHotelDetail{
    
    GetHotelDetailRequest *request = [[GetHotelDetailRequest alloc] initWidthBusinessType:BUSINESS_HOTEL methodName:@"GetHotelDetail"];
    
    request.hotelId = [NSNumber numberWithInt:[HotelDataCache sharedInstance].selectedHotelId];
    
    [self.requestManager sendRequest:request];
}

-(void)getHotelTrafficInfo{
    GetHotelTrafficlnfoRequest *request  = [[GetHotelTrafficlnfoRequest alloc] initWidthBusinessType:BUSINESS_HOTEL methodName:@"GetHotelTrafficInfo"];
    request.hotelId = [NSNumber numberWithInt:[HotelDataCache sharedInstance].selectedHotelId];
    [self.requestManager sendRequest:request];
}

-(void)requestDone:(BaseResponseModel *)response
{
 
    if(!response){
        return;
    }
    
    if([response isKindOfClass:[GetHotelDetailResponse class]]){
        _detailResponse = (GetHotelDetailResponse*)response;
        [self getHotelTrafficInfo];
    }else{
        GetHotelTrafficlnfoResponse *trafficInfoResponse = (GetHotelTrafficlnfoResponse*)response;
        _trafficData = trafficInfoResponse.Data;
        [self removeLoadingView];
        [self initView];
    }
}

#pragma ---mark UITableview handel
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch(section){
        case 0:
            return 1;
        case 1:
            return 1;
        case 2:
            return 5;
        case 3:
            if(_isExpanded){
                return _trafficData.count + 1;
            }else{
                return _trafficData.count;
            }
    }
    return 0;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    CGRect frame = CGRectMake(0, 0, 320, 30);
    UIView *customView = [[UIView alloc] initWithFrame:frame];
    UILabel *sectionTitle = [[UILabel alloc] init];
    [customView addSubview:sectionTitle];
    [customView setBackgroundColor:color(clearColor)];
    frame.origin.x = 10; //move the frame over..this adds the padding!
    frame.size.width = self.view.bounds.size.width - frame.origin.x;
    
    sectionTitle.frame = frame;
    switch(section){
        case 0:
            sectionTitle.text = [_detailResponse.Data objectForKey:@"hotelName"];
            sectionTitle.numberOfLines = 2;
            break;
        case 1:
            sectionTitle.text = @"酒店简介";
            sectionTitle.numberOfLines = 1;
            break;
        case 2:
            sectionTitle.text = @"服务设施";
            sectionTitle.numberOfLines = 1;
            break;
        case 3:
            sectionTitle.text = @"周边交通";
            sectionTitle.numberOfLines = 1;
            break;
    }

    sectionTitle.font = [UIFont boldSystemFontOfSize:15];
    sectionTitle.backgroundColor = [UIColor clearColor];
    sectionTitle.textColor = [UIColor darkGrayColor];
    
    return customView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0){
        return 70;
    }
    
    if(indexPath.section == 1){
        return 80;
    }
    
    if(indexPath.section == 2){
        int row = indexPath.row;
        NSString *str = @"";
        switch (row) {
            case 0:
                str = [_detailResponse.Data objectForKey:@"service"];
                break;
            case 1:
                str = [_detailResponse.Data objectForKey:@"facility"];
                break;
            case 2:
                str = [_detailResponse.Data objectForKey:@"catering"];
                break;
            case 3:
                str = [_detailResponse.Data objectForKey:@"recreation"];
                break;
            case 4:
                str = [_detailResponse.Data objectForKey:@"creditCard"];
                break;
            default:
                break;
        }
        float height = [Utils heightForWidth:200 text:str font:[UIFont systemFontOfSize:12]]+1;
        if(height < 30){
            height = 30;
        }
        return height;
    }
    
    if(indexPath.section == 3){
        int row = indexPath.row;
        if(_isExpanded && row == _expandedRow){
            NSDictionary *dic = [_trafficData objectAtIndex:_selectedRow];
            NSString *str = [dic objectForKey:@"arrivalWay"];
            float height = [Utils heightForWidth:300 text:str font:[UIFont systemFontOfSize:12]]+4;
            return height;
        }
    }
    
   return 44;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section != 3){
        return;
    }
    
    if(_isExpanded == NO && _selectedRow == -1){
        [self insertExpandRow:indexPath];
        return;
    }
    
    if(indexPath.row == _selectedRow){
        [self deleteExpandRow];
        return;
    }else{
        [self deleteExpandRow];
        [self insertExpandRow:indexPath];
    }
    
   
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *infoCellId = @"hotelInfoCell";
    static NSString *descCellId = @"descCell";
    static NSString *serviceCellId = @"serviceCell";
    static NSString *aroundCellId = @"aroundCell";
    static NSString *aroundExpandCellId = @"aroundExpandCell";
    
    int section = indexPath.section;
    int row = indexPath.row;
    if(section == 0){
        UITableViewCell *cellView = [tableView dequeueReusableCellWithIdentifier:infoCellId];
        HotelInfoCellView *cell = nil;
        if(cellView){
            cell = (HotelInfoCellView*)cellView;
        }else{
            cell = [[HotelInfoCellView alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:infoCellId];
        }
        
        NSString *addstr = [NSString stringWithFormat:@"地址：%@%@%@%@",[_detailResponse.Data objectForKey:@"cityName"],[_detailResponse.Data objectForKey:@"sectionName"],[_detailResponse.Data objectForKey:@"street"],[_detailResponse.Data objectForKey:@"streetAddr"]];
        cell.address.text = addstr;
        cell.around.text = [NSString stringWithFormat:@"周边：%@",[_detailResponse.Data objectForKey:@"nearby"]];
        return cell;
    }
    
    if(section == 1){
        UITableViewCell *cellView = [tableView dequeueReusableCellWithIdentifier:descCellId];
        HotelDescCellView *cell = nil;
        if(cellView){
            cell = (HotelDescCellView*)cellView;
        }else{
            cell = [[HotelDescCellView alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:descCellId];
        }
        
        NSString *intro = [NSString stringWithFormat:@"%@年开业 %@年装修 \n %@",
                        [_detailResponse.Data objectForKey:@"openingDate"], [_detailResponse.Data objectForKey:@"decoDate"],[_detailResponse.Data objectForKey:@"intro"]];
        cell.desc.text = intro;
        return cell;
    }
    
    if(section == 2){
        UITableViewCell *cellView = [tableView dequeueReusableCellWithIdentifier:serviceCellId];
        HotelServiceCellView *cell = nil;
        if(cellView){
            cell = (HotelServiceCellView*)cellView;
        }else{
            cell = [[HotelServiceCellView alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:serviceCellId];
        }
        NSString *text = @"";
        switch(row){
            case 0:
                cell.title.text = @"服务项目";
                text = [_detailResponse.Data objectForKey:@"service"];
                break;
            case 1:
                cell.title.text = @"房间设施";
                text = [_detailResponse.Data objectForKey:@"facility"];
                break;
            case 2:
                cell.title.text = @"餐饮设施";
                text = [_detailResponse.Data objectForKey:@"catering"];
                break;
            case 3:
                cell.title.text = @"休闲娱乐";
                text = [_detailResponse.Data objectForKey:@"recreation"];
                break;
            case 4:
                cell.title.text = @"可用信用卡";
                text = [_detailResponse.Data objectForKey:@"creditCard"];
                break;
        }
        
        float height = [Utils heightForWidth:200 text:text font:[UIFont systemFontOfSize:12]];
        if(height < 30){
            height = 30;
        }
        cell.title.frame = CGRectMake(15,0,75,height);
        cell.info.frame = CGRectMake(90, 0, 200, height);
        cell.info.text = text;
        return cell;
    }
    
    if(indexPath.section == 3){
        
        if(_isExpanded && indexPath.row == _expandedRow){
            UITableViewCell *cellView = [tableView dequeueReusableCellWithIdentifier:aroundExpandCellId];
            TrafficDescTableViewCell *cell = nil;
            if(cellView){
                cell = (TrafficDescTableViewCell*)cellView;
            }else{
                cell = [[TrafficDescTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:aroundExpandCellId];
            }
            NSDictionary *dic = [_trafficData objectAtIndex:_selectedRow];
            cell.desc.text = [dic objectForKey:@"arrivalWay"];
            
            return cell;
        }else{
            NSDictionary *dic = [_trafficData objectAtIndex:indexPath.row];
            UITableViewCell *cellView = [tableView dequeueReusableCellWithIdentifier:aroundCellId];
            TrafficTableViewCell *cell  = nil;
            if(cellView){
                cell = (TrafficTableViewCell*)cellView;
            }else{
                cell = [[TrafficTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:aroundCellId];
            }
            id sl = [dic objectForKey:@"startLocation"];
            if([sl isEqual:[NSNull null]]){
                cell.type.text = @"";
            }else{
                cell.type.text = [dic objectForKey:@"startLocation"];
            }
            cell.name.text = [dic objectForKey:@"locationName"];
            float dictance = [[dic objectForKey:@"distance"] floatValue];
            NSString *distanceStr = [NSString stringWithFormat:@"%.1f",dictance];
            NSString *str = [NSString stringWithFormat:@"距离酒店%@公里",distanceStr];
            cell.distance.text = str;
            
            if(indexPath.row == _trafficData.count-1){
                cell.line.hidden = YES;
            }else{
                cell.line.hidden = NO;
            }
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
      }
    }
    
    return nil;
    
}

-(void)insertExpandRow:(NSIndexPath *) indexPath{
    
    _selectedRow = indexPath.row;
    _expandedRow = indexPath.row + 1;
    indexPath = [NSIndexPath indexPathForRow:_expandedRow inSection:3];
    NSArray *array = [NSArray arrayWithObjects:indexPath, nil];
    [self.tableView beginUpdates];
    [self.tableView insertRowsAtIndexPaths:array withRowAnimation:UITableViewRowAnimationTop];
    _isExpanded = YES;
    [self.tableView endUpdates];

}

-(void)deleteExpandRow
{
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:_expandedRow inSection:3];
    NSArray *array = [NSArray arrayWithObjects:indexPath, nil];
    [self.tableView beginUpdates];
    [self.tableView deleteRowsAtIndexPaths:array withRowAnimation:UITableViewRowAnimationTop];
    _isExpanded = NO;
    _expandedRow = -1;
    _selectedRow = -1;
    [self.tableView endUpdates];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

@implementation TrafficTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if(self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]){
        [self setupView];
    }
    return self;
}

- (void)setupView
{
    
    [self setBackgroundColor:color(clearColor)];
    int width = self.frame.size.width;
    int height = self.frame.size.height;
    
    UIFont *font = [UIFont systemFontOfSize:12];
    _type = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 60, height)];
    [_type setBackgroundColor:color(clearColor)];
    [_type setFont:font];
    [_type setNumberOfLines:2];
    [_type setTextColor:color(darkGrayColor)];
    [self addSubview:_type];
    
    _name = [[UILabel alloc] initWithFrame:CGRectMake(75, 0, 100, height)];
    [_name setFont:font];
    [_name setBackgroundColor:color(clearColor)];
    [_name setNumberOfLines:2];
    [_name setTextColor:color(darkGrayColor)];
    [self addSubview:_name];
    
    _distance = [[UILabel alloc] initWithFrame:CGRectMake(180, 0, width-190, height)];
    [_distance setFont:font];
    [_distance setNumberOfLines:2];
    [_distance setBackgroundColor:color(clearColor)];
    [_distance setLineBreakMode:NSLineBreakByCharWrapping];
    [_distance setTextColor:color(darkGrayColor)];
    [self addSubview:_distance];
    
    _line = [[UIView alloc] initWithFrame:CGRectMake(10, height-2, 300, 1)];
    [_line setBackgroundColor:color(grayColor)];
    [self addSubview:_line];
}

@end

@implementation TrafficDescTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if(self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]){
        [self setupView];
    }
    return self;
}

-(void)setupView
{
    int width = self.frame.size.width;
    int height = self.frame.size.height;
    [self setBackgroundColor:color(lightGrayColor)];
    
    _desc = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, width-20, height)];
    [_desc setBackgroundColor:color(clearColor)];
    [_desc setFont:[UIFont systemFontOfSize:12]];
    [_desc setTextColor:color(darkGrayColor)];
    [_desc setNumberOfLines:0];
    [self addSubview:_desc];
}
@end

@implementation HotelInfoCellView

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if(self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]){
        [self setupView];
    }
    return self;
}

-(void)setupView
{
    int width = self.frame.size.width;
    int height = self.frame.size.height;
    
    //酒店图片
    UIImageView *hotelImage = [[UIImageView alloc] initWithFrame:CGRectMake(10,0,60,70)];
    [hotelImage setBackgroundColor:color(grayColor)];
    [self addSubview:hotelImage];
    
    //地址
    _address = [[UILabel alloc] initWithFrame:CGRectMake(75,0,width-85,16)];
    [_address setTextColor:color(blackColor)];
    [_address setBackgroundColor:color(clearColor)];
    [_address setFont:[UIFont systemFontOfSize:13]];
    [self addSubview:_address];
    
    //周边
    _around = [[UILabel alloc] initWithFrame:CGRectMake(75,height+13,width - 85,15)];
    [_around setBackgroundColor:color(clearColor)];
    [_around setTextColor:color(blackColor)];
    [_around setFont:[UIFont systemFontOfSize:13]];
    [self addSubview:_around];

}

@end

@implementation HotelDescCellView

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if(self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]){
        [self setupView];
    }
    return self;
}

-(void)setupView{
    
    int width = self.frame.size.width;
    UIFont *font = [UIFont systemFontOfSize:12];
    
    CGRect rect =  CGRectMake(10, 0, width-20, 80);
    UIImageView *introBgView = [[UIImageView alloc]initWithFrame:rect];
    [introBgView setBackgroundColor:color(whiteColor)];
    [introBgView setBorderColor:color(lightGrayColor) width:1.0];
    [introBgView setCornerRadius:5.0];
    [self addSubview:introBgView];
    
    _desc = [[UILabel alloc] initWithFrame:CGRectMake(13, 0, width-26, 78)];
    [_desc setBackgroundColor:color(clearColor)];
    [_desc setFont:font];
    [_desc setTextColor:color(darkGrayColor)];
    [_desc setNumberOfLines:5];
    [self addSubview:_desc];
}

@end

@implementation HotelServiceCellView

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setUpView];
    }
    return self;
}

-(void)setUpView
{
  
    int width = self.frame.size.width;
    int height = self.bounds.size.height;
    
    NSLog(@"cell height = %d",height);
//    UIImageView *serviceBgView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 0, width-20, height)];
//    [serviceBgView setBackgroundColor:color(whiteColor)];
//    [serviceBgView setBorderColor:color(lightGrayColor) width:1.0];
//    [serviceBgView setCornerRadius:5.0];
//    [self addSubview:serviceBgView];
    
    _title = [[UILabel alloc] initWithFrame:CGRectMake(15,0, 75, 15)];
    [_title setFont:[UIFont systemFontOfSize:13]];
    [_title setBackgroundColor:color(clearColor)];
    [_title setTextColor:color(darkGrayColor)];
    [self addSubview:_title];
    
    _info = [[UILabel alloc] initWithFrame:CGRectMake(90, 0, width-98, height)];
    [_info setFont:[UIFont systemFontOfSize:12]];
    [_info setTextColor:color(darkGrayColor)];
    [_info setBackgroundColor:color(clearColor)];
    [_info setLineBreakMode:NSLineBreakByCharWrapping];
    [_info setNumberOfLines:0];
    [self addSubview:_info];
}

@end
