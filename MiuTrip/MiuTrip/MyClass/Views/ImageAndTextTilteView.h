//
//  ImageAndTextTilteView.h
//  MiuTrip
//
//  Created by stevencheng on 13-12-4.
//  Copyright (c) 2013年 michael. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ImageAndTextTilteView : UIView

@property (strong,nonatomic) NSString *imageName;
@property (nonatomic,strong) NSString *labelText;
@property (nonatomic,strong) NSString *valueText;

@property (nonatomic,strong) UILabel *valueView;

-(id)initWithFrame:(CGRect)frame withImageName:(NSString*)imageName withLabelName:(NSString*)
labelName;

-(void)setValue:(NSString*)value;

@end

