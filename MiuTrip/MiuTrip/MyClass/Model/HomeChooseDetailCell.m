//
//  HomeChooseDetailCell.m
//  MiuTrip
//
//  Created by pingguo on 14-1-15.
//  Copyright (c) 2014年 michael. All rights reserved.
//

#import "HomeChooseDetailCell.h"

@implementation HomeChooseDetailCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        [self createItem];
    }
    return self;
}

- (void)createItem{
    _viewItem = [[UIView alloc]initWithFrame:CGRectMake(0,0, self.contentView.frame.size.width-24, HotelChooseViewCellHeight)];
    [_viewItem setBackgroundColor:[UIColor colorWithRed:0/255.0 green:0/255.0 blue:250/255.0 alpha:0.1]];
    [_viewItem.layer setCornerRadius:3.0];
    
    [self addSubview:_viewItem];
    
    _imageview = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, self.viewItem.frame.size.width/10, self.viewItem.frame.size.height)];
    UIImage *image =[UIImage imageNamed:@"d1"];
    [_imageview setImage:image forState:UIControlStateNormal];
    [_imageview setHidden:YES];
    [self.viewItem addSubview:_imageview];
    
    
    _userName = [[UILabel alloc]initWithFrame:CGRectMake(controlXLength(_imageview)+5,self.viewItem.frame.size.height/3 ,self.viewItem.frame.size.width/5, self.viewItem.frame.size.height/3)];
    [_userName setBackgroundColor:color(clearColor)];
    [_userName setText:@"欧凯"];
    [_userName setTextAlignment:NSTextAlignmentLeft];
    [_viewItem addSubview:_userName];
    
    _policy = [[UILabel alloc]initWithFrame:CGRectMake(controlXLength(_userName)+10, self.viewItem.frame.size.height/6, self.viewItem.frame.size.width*2/3, self.viewItem.frame.size.height/3)];
    [_policy setText:@"差旅政策"];
    [_policy setFont:[UIFont fontWithName:@"ArialMT" size:13]];
    [_policy setTextAlignment:NSTextAlignmentLeft];
    [_viewItem addSubview:_policy];
    
    UILabel *Center = [[UILabel alloc]initWithFrame:CGRectMake(controlXLength(_userName)+10, self.viewItem.frame.size.height/2, self.viewItem.frame.size.width/5, self.viewItem.frame.size.height/3)];
    [Center setText:@"成本中心:"];
    [Center setFont:[UIFont fontWithName:@"ArialMT" size:13]];
    [Center setTextAlignment:NSTextAlignmentLeft];
    [_viewItem addSubview:Center];
    
    _cost = [[UILabel alloc]initWithFrame:CGRectMake(controlXLength(Center), self.viewItem.frame.size.height/2, self.viewItem.frame.size.width*2/3, self.viewItem.frame.size.height/3)];
    [_cost setFont:[UIFont fontWithName:@"ArialMT" size:13]];
    [_cost setTextAlignment:NSTextAlignmentLeft];
    [_viewItem addSubview:_cost];
    
    _arrow = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"arrow"]];
    [_arrow setFrame:CGRectMake(self.viewItem.frame.size.width*8/9, 5, self.viewItem.frame.size.width/7, 40)];
    CGAffineTransform current = self.transform;
    CGAffineTransform new = CGAffineTransformScale(current,0.2, 0.2);
    [_arrow setTransform:new];
    [_arrow setHidden:YES];
    [_viewItem addSubview:_arrow];
    [self createLineWithParams:imageNameAndType(@"setting_line", nil) frame:CGRectMake(0,self.viewItem.frame.size.height-6, self.viewItem.frame.size.width, 0.5) view:_viewItem];
    
}
- (void)showItem:(NSDictionary *)dic{
    BOOL show= [[dic objectForKey:@"show"]boolValue];
    if (show) {
        if (_viewItem) {
            [_imageview setHidden:show];
            [_arrow setHidden:show];
        }
    }
    [_imageview setHidden:!show];
    [_arrow setHidden:!show];
}

- (void)createLineWithParams:(UIImage*)image frame:(CGRect)frame view:(UIView*)view{
    UIImageView *line = [[UIImageView alloc]initWithFrame:frame];
    [line setImage:image];
    [view addSubview:line];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
