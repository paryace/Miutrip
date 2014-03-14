//
//  SiftCorpCell.h
//  MiuTrip
//
//  Created by apple on 14-3-6.
//  Copyright (c) 2014年 michael. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kCELLHEIGHT  41.5f

@interface SiftCorpCell : UITableViewCell

@property (nonatomic, strong) UIImageView *btnImage;
@property (nonatomic, strong) UILabel *airCorpName;

@property (strong, nonatomic) NSString    *detail;

@property (nonatomic, assign) BOOL isSelected;

@end
