//
//  SiftCorpCell.m
//  MiuTrip
//
//  Created by apple on 14-3-6.
//  Copyright (c) 2014年 michael. All rights reserved.
//

#import "SiftCorpCell.h"

@implementation SiftCorpCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        [self setUpAirCorpCellUI];
    }
    return self;
}

- (void)setUpAirCorpCellUI
{

    _btnImage = [[UIImageView alloc] initWithFrame:CGRectMake(7.5, 7, 28, 28)];
    
    _btnImage.image = [UIImage imageNamed:@"set_item_normal"];
    [self.contentView addSubview:_btnImage];
    
    _airCorpName = [[UILabel alloc] initWithFrame:CGRectMake(controlXLength(_btnImage) + 5, _btnImage.frame.origin.y, 250, _btnImage.bounds.size.height)];
    _airCorpName.backgroundColor = color(clearColor);
    _airCorpName.textAlignment = NSTextAlignmentLeft;
    _airCorpName.font = [UIFont systemFontOfSize:13];
    [self.contentView addSubview:_airCorpName];
    
    self.isSelected = NO;
    
    //添加分割线
    [self grayLineOfSeparator];
}

//设置灰色线条
- (void)grayLineOfSeparator
{
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 41.0f, self.bounds.size.width, 0.7f)];
    line.backgroundColor = [UIColor grayColor];
    [self.contentView addSubview:line];
}


- (void)setIsSelected:(BOOL)isSelected
{
    _isSelected = isSelected;
    if (_isSelected) {
        self.btnImage.image = [UIImage imageNamed:@"set_item_select"];
    }else
    {
        self.btnImage.image = [UIImage imageNamed:@"set_item_normal"];
        
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
//    if (selected) {
//        self.btnImage.image = [UIImage imageNamed:@"set_item_select"];
//    }else
//    {
//        self.btnImage.image = [UIImage imageNamed:@"set_item_normal"];
//        
//    }
}

@end
