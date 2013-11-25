//
//  TripCareerViewController.h
//  MiuTrip
//
//  Created by SuperAdmin on 13-11-20.
//  Copyright (c) 2013年 michael. All rights reserved.
//

/**
 * 商旅生涯页面
 */

#import "BaseUIViewController.h"


@interface TripCareerViewController : BaseUIViewController

@end

@interface TripCareerItem : UIView

@property (strong, nonatomic, readonly) UIImageView               *leftImageView;
@property (strong, nonatomic, readonly) UILabel                   *titleAsLabel;
@property (strong, nonatomic, readonly) UIImageView               *titleAsImage;
@property (strong, nonatomic, readonly) UILabel                   *contentLabel;

- (void)setTitleImage:(UIImage*)image;
- (void)setTitle:(NSObject*)title;//items can be NSStrings or UIImages. control is automatically sized to fit content
- (void)setContentText:(NSString*)text;

@end