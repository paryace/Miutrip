//
//  HotelSearchView.h
//  MiuTrip
//
//  Created by stevencheng on 13-12-6.
//  Copyright (c) 2013年 michael. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HotelDataCache.h"
#import "ImageAndTextTilteView.h"

@interface HotelSearchView : UIView

@property (nonatomic,strong) HotelDataCache *data;
@property (nonatomic,strong) ImageAndTextTilteView *priceRangeView;
@property (nonatomic,strong) ImageAndTextTilteView *hotelLoactionView;

@property (nonatomic,strong) UILabel *checkInDate;
@property (nonatomic,strong) UILabel *checkInDateWeek;
@property (nonatomic,strong) UILabel *checkInDateYear;

@property (nonatomic,strong) UILabel *checkOutDate;
@property (nonatomic,strong) UILabel *checkOutDateWeek;
@property (nonatomic,strong) UILabel *checkOutDateYear;

@property (nonatomic,strong) NSString *checkInCityName;

-(id)initWidthFrame:(CGRect)frame widthdata:(HotelDataCache*)data;

-(void)setPriceRange:(NSString *) rangeText;
/**
 *  设置酒店所在区
 *
 *  @param hotelCanton 
 */
-(void)setHotelCanton:(NSString *) hotelCanton;


-(void)updateDate;

-(void)updateCity;

@end
