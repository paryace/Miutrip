//
//  HotelMapViewControlerViewController.h
//  MiuTrip
//
//  Created by stevencheng on 14-1-4.
//  Copyright (c) 2014年 michael. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "BaseUIViewController.h"


@interface HotelMapViewControler : BaseUIViewController<MKMapViewDelegate,UITableViewDataSource,UITableViewDelegate>

@property (nonatomic) int mapType;
@property (nonatomic,strong) NSArray *hotelListData;
@property (nonatomic,strong) NSDictionary *hotelData;

@property (strong, nonatomic) IBOutlet MKMapView *mapView;
@property (nonatomic,strong) UITableView *tableView;

- (id)initWithType:(int)type withData:(id) data;

@end

@interface HotelLocationAnnotation : MKPointAnnotation

//标题
@property (nonatomic,assign) NSString    *title;
@property (nonatomic)        int         index;

//初始化方法
-(id)initWithCoordinate:(CLLocationCoordinate2D)c andTitle:(NSString*)t;
@end