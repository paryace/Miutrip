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

-(id)initWidthFrame:(CGRect)frame widthdata:(HotelDataCache*)data;

-(void)setPriceRange:(NSString *) rangeText;
/**
 *  设置酒店所在区
 *
 *  @param hotelCanton 
 */
-(void)setHotelCanton:(NSString *) hotelCanton;

/**
 *  设置酒店所在区
 *
 *  @param hotelCanton
 */
-(void)updateDate;

@end
