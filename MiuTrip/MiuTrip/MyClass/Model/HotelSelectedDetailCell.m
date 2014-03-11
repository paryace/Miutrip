//
//  HotelSelectedDetailCell.m
//  MiuTrip
//
//  Created by pingguo on 14-1-15.
//  Copyright (c) 2014年 michael. All rights reserved.
//

#import "HotelSelectedDetailCell.h"
#import "UserDefaults.h"
@implementation HotelSelectedDetailCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        [self setupViews];
    }
    return self;
}

- (void)setLeftImageHighlighted:(BOOL)leftImageHighlighted
{
    UIButton *checkBox = (UIButton*)[self viewWithTag:20];
    [checkBox setHighlighted:leftImageHighlighted];
}

-(void)setupViews{
    
    UIImageView *checkBox = [[UIImageView alloc]initWithFrame:CGRectMake(10 , 10, 15, 15)];
    [checkBox setImage:imageNameAndType(@"autolog_normal", nil)];
    [checkBox setHighlightedImage:imageNameAndType(@"autolog_select", nil)];
    [checkBox setTag:20];
    [self addSubview:checkBox];
    
    _userName = [[UILabel alloc]initWithFrame:CGRectMake(controlXLength(checkBox)+5, self.frame.size.height/3, self.frame.size.width/5, self.frame.size.height/3)];
    [_userName setBackgroundColor:color(clearColor)];
    [_userName setText:@"游乐场"];
    [_userName setTextAlignment:NSTextAlignmentLeft];
    [_userName setFont:[UIFont systemFontOfSize:14]];
    [self addSubview:_userName];
    
    _UID = [[UILabel alloc]initWithFrame:CGRectMake(controlXLength(_userName)+5, _userName.frame.origin.y
                                                    , self.frame.size.width/4, _userName.frame.size.height)];
    [_UID setText:@"游乐场"];
    [_UID setBackgroundColor:color(clearColor)];
    [_UID setTextAlignment:NSTextAlignmentLeft];
    [_UID setFont:[UIFont systemFontOfSize:14]];
    [self addSubview:_UID];
    
    _deptName =[[UILabel alloc]initWithFrame:CGRectMake(controlXLength(_UID)+5, _userName.frame.origin.y
                                                        , self.frame.size.width/3, _userName.frame.size.height)];
    [_deptName setText:@"游乐场"];
    [_deptName setBackgroundColor:color(clearColor)];
    [_deptName setTextAlignment:NSTextAlignmentLeft];
    [_deptName setFont:[UIFont systemFontOfSize:14]];
    [self addSubview:_deptName];
    
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
