//
//  HotelpassengerDetailCell.m
//  MiuTrip
//
//  Created by pingguo on 14-1-16.
//  Copyright (c) 2014年 michael. All rights reserved.
//

#import "HotelpassengerDetailCell.h"

@implementation HotelpassengerDetailCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        [self setUpViews];
    }
    return self;
}

- (void)setUpViews{
    _userName = [[UILabel alloc]initWithFrame:CGRectMake(5,self.frame.size.height/8, self.frame.size.width, 30)];
    [_userName setText:@"========"];
    [_userName setBackgroundColor:color(clearColor)];
    [self addSubview:_userName];
    
    //    _itemBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    //    [_itemBtn setFrame:CGRectMake(5,self.frame.size.height/8, self.frame.size.width, 30)];
    //    [_itemBtn setBackgroundColor:color(clearColor)];
    //    [self addSubview:_itemBtn];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
