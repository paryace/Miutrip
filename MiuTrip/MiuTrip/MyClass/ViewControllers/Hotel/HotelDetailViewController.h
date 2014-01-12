//
//  HotelDetailViewController.h
//  MiuTrip
//
//  Created by stevencheng on 13-12-14.
//  Copyright (c) 2013年 michael. All rights reserved.
//

#import "BaseUIViewController.h"
#import "GetHotelDetailResponse.h"

@interface HotelDetailViewController : BaseUIViewController<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) GetHotelDetailResponse *detailResponse;
@property (nonatomic,strong) NSArray *trafficData;
@property (nonatomic)        BOOL isExpanded;
@property (nonatomic)        int selectedRow;
@property (nonatomic)        int expandedRow;

@end

@interface TrafficTableViewCell : UITableViewCell

@property (nonatomic,strong) UILabel *type;
@property (nonatomic,strong) UILabel *name;
@property (nonatomic,strong) UILabel *distance;
@property (nonatomic,strong) UIView  *line;

@end

@interface TrafficDescTableViewCell : UITableViewCell

@property (nonatomic,strong) UILabel *desc;

@end

@interface HotelInfoCellView : UITableViewCell

@property (nonatomic,strong) UILabel *address;
@property (nonatomic,strong) UILabel *around;

@end

@interface HotelDescCellView : UITableViewCell

@property (nonatomic,strong) UILabel *desc;

@end

@interface HotelServiceCellView : UITableViewCell

@property (nonatomic,strong) UILabel *title;
@property (nonatomic,strong) UILabel *info;

@end
