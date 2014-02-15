//
//  ImageAndTextTilteView.m
//  MiuTrip
//
//  Created by stevencheng on 13-12-4.
//  Copyright (c) 2013年 michael. All rights reserved.
//

#import "ImageAndTextTilteView.h"

@implementation ImageAndTextTilteView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupView];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame withImageName:(NSString*)imageName withLabelName:(NSString*)
    labelName isValueEditabel:(BOOL) editable
{
    self = [super initWithFrame:frame];
    if (self) {
        _imageName = imageName;
        _labelText = labelName;
        _isValueEditeble = editable;
        [self setupView];
    }
    return self;
}

-(void)setupView{
    
    [self setBackgroundColor:color(clearColor)];
    
    //图片
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:_imageName]];
    [imageView setFrame:CGRectMake(0, (self.frame.size.height-40)/2, 40, 40)];
    [imageView setBackgroundColor:color(clearColor)];
    [self addSubview:imageView];
    
    //标题
    UIFont *font = [UIFont systemFontOfSize:13];
    CGSize size = [_labelText sizeWithFont:font];
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(controlXLength(imageView), (self.frame.size.height - size.height)/2, size.width+5, size.height)];
    [title setBackgroundColor:color(clearColor)];
    [title setTextColor:color(darkGrayColor)];
    [title setFont:font];
    [title setText:_labelText];
    [self addSubview:title];
    
    
    if(_isValueEditeble){
        //value
        _editableValue = [[UITextField alloc] initWithFrame:CGRectMake(controlXLength(title)+5,5, self.frame.size.width-controlXLength(title)-13-10, self.frame.size.height-10)];
        _editableValue.delegate = self;
        [_editableValue setBackgroundColor:color(clearColor)];
        [_editableValue setBorderStyle:UITextBorderStyleRoundedRect];
        [_editableValue setFont:[UIFont boldSystemFontOfSize:15]];
        [_editableValue setTextColor:color(darkGrayColor)];
        [self addSubview:_editableValue];
    }else{
        //value
        _valueView = [[UILabel alloc] initWithFrame:CGRectMake(controlXLength(title)+5, 0, self.frame.size.width-controlXLength(title)-13-10, self.frame.size.height)];
        [_valueView setBackgroundColor:color(clearColor)];
        [_valueView setFont:[UIFont boldSystemFontOfSize:15]];
        [_valueView setTextColor:color(darkGrayColor)];
        [self addSubview:_valueView];
    }
    
   
    
    //箭头
    UIImageView *arrow = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"arrow"]];
    [arrow setFrame:CGRectMake(self.frame.size.width - 12 - 5, 12, 12, 16)];
    [arrow setBackgroundColor:color(clearColor)];
    [self addSubview:arrow];
}


-(void)setValue:(NSString*)value{
 
    if(_valueView != nil && value != nil){
        [_valueView setText:value];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
