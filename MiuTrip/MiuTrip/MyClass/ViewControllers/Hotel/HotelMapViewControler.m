//
//  HotelMapViewControlerViewController.m
//  MiuTrip
//
//  Created by stevencheng on 14-1-4.
//  Copyright (c) 2014年 michael. All rights reserved.
//

#import "HotelMapViewControler.h"
#import "HotelDataCache.h"
#import "HotelListRoomCell.h"
#import "HotelListBtnCellView.h"
#import "HotelListCellviewCell.h"

@interface HotelMapViewControler ()

@end

@implementation HotelMapViewControler

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (id)initWithType:(int)type withData:(id) data
{
    self = [super init];
    if (self) {
        _mapType = type;
        if(_mapType == 0){
            _hotelListData = data;
        }else{
            _hotelData = data;
        }
        [self setUpView];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

-(void)setUpView{
    
    [self addTitleWithTitle:@"酒店位置" withRightView:nil];
    
    int width = self.contentView.frame.size.width;
    int height = self.contentView.frame.size.height;
    _mapView = [[MKMapView alloc] initWithFrame:CGRectMake(0, 40, width,height)];
    _mapView.delegate = self;
    
    [self.contentView addSubview:_mapView];

    if(_mapType == 0){
        
        NSMutableArray *array = [[NSMutableArray alloc] init];
        for(int i=0;i<_hotelListData.count;i++){
            NSDictionary *dic = [_hotelListData objectAtIndex:i];
            
            double lat = [[dic objectForKey:@"latitude"] doubleValue];
            double lng = [[dic objectForKey:@"longitude"] doubleValue];
            NSString *price = [NSString stringWithFormat:@"￥%@",[dic objectForKey:@"lowestPrice"]];
            CLLocationCoordinate2D location = CLLocationCoordinate2DMake(lat, lng);
            HotelLocationAnnotation *annotation = [[HotelLocationAnnotation alloc] initWithCoordinate:location andTitle:price];
            annotation.index = i;
            [array addObject:annotation];
        }
         [_mapView addAnnotations:array];
        
    }else{
        double lat = [[_hotelData objectForKey:@"latitude"] doubleValue];
        double lng = [[_hotelData objectForKey:@"longitude"] doubleValue];
        NSString *price = [NSString stringWithFormat:@"￥%@",[_hotelData objectForKey:@"lowestPrice"]];
        
        CLLocationCoordinate2D location = CLLocationCoordinate2DMake(lat, lng);
        HotelLocationAnnotation *annotation = [[HotelLocationAnnotation alloc] initWithCoordinate:location andTitle:price];
        [_mapView addAnnotation:annotation];
        
        MKCoordinateRegion region = _mapView.region;
        region.center = location;
        region.span = MKCoordinateSpanMake(0.1,0.1);
        [_mapView setRegion:region animated:YES];

    }
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, height-270, width, 240)];
    [_tableView setDataSource:self];
    [_tableView setDelegate:self];
    _tableView.hidden = YES;
    [self.contentView addSubview:_tableView];
}

#pragma mark mapDelegte

- (void)mapViewDidFailLoadingMap:(MKMapView *)mapView withError:(NSError *)error{
    
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation{
    
    MKPinAnnotationView *mapPin = nil;
    if(annotation != mapView.userLocation)
    {
        static NSString *defaultPinID = @"defaultPin";
        mapPin = (MKPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:defaultPinID];
        if (mapPin == nil )
        {
            mapPin = [[MKPinAnnotationView alloc] initWithAnnotation:annotation
                                                      reuseIdentifier:defaultPinID];
            mapPin.canShowCallout = YES;
            UIButton *infoButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
            if(_mapType == 0){
                HotelLocationAnnotation *hotelLocationAnnotation = (HotelLocationAnnotation *)annotation;
                infoButton.tag = hotelLocationAnnotation.index;
            }
            [infoButton addTarget:self action:@selector(infoButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
            
            mapPin.rightCalloutAccessoryView = infoButton;
        }
        else
            mapPin.annotation = annotation;
        
    }
    return mapPin;
}


-(void)infoButtonPressed:(UIButton *)sender{
   
    if(_mapType == 0){
        _hotelData = [_hotelListData objectAtIndex:sender.tag];
        [_tableView reloadData];
    }
    _tableView.hidden = NO;
}

#pragma mark  uitabelView handle

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSArray *rooms = [_hotelData objectForKey:@"Rooms"];
    return rooms.count + 2;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.row == 0){
        return 75;
    }else if(indexPath.row == 1){
        return 30;
    }else{
        return 36;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *hotelCell = @"hotelCell";
    static NSString *hotelBtn = @"hotelbtn";
    static NSString *hotelRoomsCell = @"hotelRoomsCell";

    if(indexPath.row == 0){
        UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:hotelCell];
        HotelListCellviewCell *cellView = nil;
        if(cellView){
            cellView = (HotelListCellviewCell*)cell;
            [[AsyncImageLoader sharedLoader] cancelLoadingImagesForTarget:cellView.hotelImage];
        }else{
            cellView = [[HotelListCellviewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:hotelCell];
        }
        
        [cellView.address setText:[_hotelData objectForKey:@"address"]];
        [cellView.hotelName setText:[_hotelData objectForKey:@"hotelName"]];
        NSString *str = [_hotelData objectForKey:@"lowestPrice"];
        NSString *price = [NSString stringWithFormat:@"￥%@起",str];
        [cellView.price setText:price];
        NSString *comment = [NSString stringWithFormat:@"%@好评率 点评%d条",[_hotelData objectForKey:@"score"],[[_hotelData objectForKey:@"commentTotal"]integerValue]];
        [cellView.comment setText:comment];
        cellView.hotelImage.imageURL = [NSURL URLWithString:[_hotelData objectForKey:@"img"]];
        
        [cellView setSelectionStyle:UITableViewCellSelectionStyleGray];
        
        return cellView;

    }else if(indexPath.row == 1){
        
        UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:hotelBtn];
        HotelListBtnCellView *cellView = nil;
        
        if(cell){
            cellView = (HotelListBtnCellView*)cell;
        }else{
            cellView = [[HotelListBtnCellView alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:hotelBtn hasMapBtn:NO];
        }
        cellView.hotelData = _hotelData;
        cellView.hotelId = [[_hotelData objectForKey:@"hotelId"] integerValue];
        cellView.viewController = self;
        [cellView setSelectionStyle:UITableViewCellSelectionStyleNone];
        return cellView;
        
        
    }else{
        
        UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:hotelRoomsCell];
        HotelListRoomCell *cellView = nil;
        if(cell){
            cellView = (HotelListRoomCell*)cell;
        }else{
            cellView = [[HotelListRoomCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:hotelRoomsCell];
        }
        
        NSArray *rooms = [_hotelData objectForKey:@"Rooms"];
        NSDictionary *roomDic = [rooms objectAtIndex:indexPath.row - 2];
        NSArray *pricePolicies = [roomDic objectForKey:@"PricePolicies"];
        NSDictionary *priceDic = [pricePolicies objectAtIndex:0];
        NSArray *priceInfos = [priceDic objectForKey:@"PriceInfos"];
        NSDictionary *roomPriceDic = [priceInfos objectAtIndex:0];
        
        cellView.roomData = roomDic;
        cellView.hotelId = [[_hotelData objectForKey:@"hotelId"] intValue];
        cellView.hotelName = [_hotelData objectForKey:@"hotelName"];
        cellView.roomName.text = [roomDic objectForKey:@"roomName"];
        
        NSString *bed = [roomDic objectForKey:@"bed"];
        NSString *breakfast = [NSString stringWithFormat:@"%@早餐",[roomPriceDic objectForKey:@"Breakfast"]];
        NSString *bb = [NSString stringWithFormat:@"%@\n%@",bed,breakfast];
        
        cellView.bedAndBreakfast.text = bb;
        
        int wifiInt = [[roomDic objectForKey:@"adsl"] integerValue];
        if(wifiInt == 1){
            cellView.wifi.text = @"宽带免费";
        }else{
            cellView.wifi.text = @"";
        }
        cellView.viewController = self;
        cellView.price.text = [NSString stringWithFormat:@"￥%@",[roomPriceDic objectForKey:@"SalePrice"]];
        [cellView setSelectionStyle:UITableViewCellSelectionStyleNone];
        return cellView;
        
    }
 
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end

@implementation HotelLocationAnnotation

-(id)initWithCoordinate:(CLLocationCoordinate2D)c andTitle:(NSString*)t{
    self = [super init];
    if(self){
        self.coordinate = c;
        self.title = t;
    }
    return self;
}




@end
