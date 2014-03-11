//
//  HotelCommentViewController.m
//  MiuTrip
//
//  Created by stevencheng on 13-12-14.
//  Copyright (c) 2013年 michael. All rights reserved.
//

#import "HotelCommentViewController.h"
#import "HotelDataCache.h"
#import "GetCommentListResponse.h"

@implementation HotelCommentViewController

-(id)init{
    if(self = [super init]){
        [self setSubviewFrame];
    }
    return self;
}

-(void)setSubviewFrame{
    
    [self addTitleWithTitle:@"酒店评论" withRightView:nil];
    
    [self addLoadingView];
    
    [self getHotelCommnets];
    
}

-(void)addTableView{
    
    [self removeLoadingView];
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 41, self.view.frame.size.width, self.contentView.frame.size.height - 41)];
    
    tableView.tag = 1002;
    [tableView setDataSource:self];
    [tableView setDelegate:self];
    [self.contentView addSubview:tableView];
    
}


-(void)getHotelCommnets{
    
    GetCommentListRequest *request = [[GetCommentListRequest alloc] initWidthBusinessType:BUSINESS_HOTEL methodName:@"GetCommentList"];
    request.hotelId = [NSNumber numberWithInt:[HotelDataCache sharedInstance].selectedHotelId];
    [self.requestManager sendRequest:request];
    
}

-(void)requestDone:(BaseResponseModel *)response{
    
    if(!response){
        return;
    }
    
    GetCommentListResponse *commentResponse = (GetCommentListResponse*)response;
    _commentData = [commentResponse.Data objectForKey:@"comments"];
    
    [self addTableView];
    
    UITableView *tableView = (UITableView*)[self.contentView viewWithTag:1002];
    [tableView reloadData];
}

-(void)requestFailedWithErrorCode:(NSNumber *)errorCode withErrorMsg:(NSString *)errorMsg{
    NSLog(@"error = %@", errorMsg);
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return _commentData.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *itemDic = [_commentData objectAtIndex:indexPath.row];
    NSString *content = [itemDic objectForKey:@"content"];
    return [self getHeightFromString:content] + 25;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"commentcell";
    UITableViewCell *tabelViewCell = [tableView dequeueReusableCellWithIdentifier:cellId];
    HotelCommentTabelViewCell *cell = nil;
    if(tabelViewCell){
        cell = (HotelCommentTabelViewCell*)tabelViewCell;
    }else{
        cell = [[HotelCommentTabelViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    NSDictionary *itemDic = [_commentData objectAtIndex:indexPath.row];
    int overallRating = [[itemDic objectForKey:@"overallRating"] integerValue];
    switch (overallRating) {
        case 1:
            cell.title.text = @"好评";
            break;
        case 2:
            cell.title.text = @"中评";
            break;
        case 3:
            cell.title.text = @"差评";
            break;
        default:
            cell.title.text = @"好评";
            break;
    }
    cell.time.text = [itemDic objectForKey:@"createDate"];
    
    NSString *content = [itemDic objectForKey:@"content"];
    float height = [self getHeightFromString:content];
    
    cell.content.frame = CGRectMake(10, 20, self.contentView.frame.size.width - 20, height);
    cell.content.text = content;
    return cell;
}

-(CGFloat) getHeightFromString:(NSString *) string
{
    UIFont *font = [UIFont systemFontOfSize:12];
    NSAttributedString *attributedText = [[NSAttributedString alloc] initWithString:
                                          string attributes:@{NSFontAttributeName: font}];
    
    CGRect rect = [attributedText boundingRectWithSize:CGSizeMake(self.contentView.frame.size.width-20, 9999) options:NSStringDrawingUsesLineFragmentOrigin context:nil];
    
    return ceilf(rect.size.height);
}

@end

@implementation HotelCommentTabelViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setUpView];
    }
    return self;
}

-(void)setUpView{
    
    
    //好评、差评
    _title = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 35, 20)];
    [_title setFont:[UIFont boldSystemFontOfSize:15]];
    [_title setTextColor:color(blackColor)];
    [_title setBackgroundColor:color(clearColor)];
    [self addSubview:_title];
    
    _timeIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"comment_time.png"]];
    [_timeIcon setFrame:CGRectMake(self.frame.size.width - 120, 2, 17, 16)];
    [self addSubview:_timeIcon];
    
    //评论时间
    _time = [[UILabel alloc] initWithFrame:CGRectMake(self.frame.size.width - 100, 0, 112, 20)];
    [_time setFont:[UIFont systemFontOfSize:10]];
    [_time setTextColor:color(grayColor)];
    [_time setBackgroundColor:color(clearColor)];
    [self addSubview:_time];
    
    //评论内容
    _content = [[UILabel alloc] init];
    [_content setFont:[UIFont systemFontOfSize:12]];
    [_content setTextColor:color(blackColor)];
    [_content setBackgroundColor:color(clearColor)];
    [_content setLineBreakMode:NSLineBreakByCharWrapping];
    [_content setNumberOfLines:0];
    [self addSubview:_content];
}

@end


