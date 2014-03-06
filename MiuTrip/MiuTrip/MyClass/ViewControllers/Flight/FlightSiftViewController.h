//
//  FlightSiftViewController.h
//  MiuTrip
//
//  Created by Samrt_baot on 14-1-16.
//  Copyright (c) 2014年 michael. All rights reserved.
//

#import "BaseUIViewController.h"

@protocol FlightSiftViewDelegate <NSObject>

- (void)siftDone:(NSDictionary *)params;

@end

@interface FlightSiftViewController : BaseUIViewController<UITableViewDataSource,UITableViewDelegate>

@property (assign, nonatomic) id<FlightSiftViewDelegate> delegate;

@property (strong, nonatomic) NSMutableArray    *airCompanyBtnArray;


@end

@interface FlightSiftViewCustomBtn : UIButton

@property (strong, nonatomic) UIImageView   *subjoinImageView;
@property (assign, nonatomic) BOOL          leftImageHighlighted;

- (void)setLeftImage:(UIImage*)leftImage LeftHighlightedImage:(UIImage*)highlightImage;

@end