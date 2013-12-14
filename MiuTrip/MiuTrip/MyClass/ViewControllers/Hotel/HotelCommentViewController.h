//
//  HotelCommentViewController.h
//  MiuTrip
//
//  Created by stevencheng on 13-12-14.
//  Copyright (c) 2013年 michael. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PullRefreshTableViewController.h"
#import "RequestManager.h"
#import "GetCommentListRequest.h"
#import "BaseUIViewController.h"

@interface HotelCommentViewController : BaseUIViewController<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,assign) NSArray *commentData;

@end

@interface HotelCommentTabelViewCell : UITableViewCell

@property (nonatomic,strong) UILabel *title;
@property (nonatomic,strong) UILabel *time;
@property (nonatomic,strong) UIImageView *timeIcon;
@property (nonatomic,strong) UILabel *content;


@end