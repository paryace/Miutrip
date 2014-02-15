//
//  ImageAndTextTilteView.h
//  MiuTrip
//
//  Created by stevencheng on 13-12-4.
//  Copyright (c) 2013年 michael. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ImageAndTextTilteView : UIView<UITextFieldDelegate>

@property (strong,nonatomic) NSString *imageName;
@property (nonatomic,strong) NSString *labelText;
@property (nonatomic,strong) NSString *valueText;
@property (nonatomic) BOOL isValueEditeble;

@property (nonatomic,strong) UILabel *valueView;
@property (nonatomic,strong) UITextField *editableValue;

-(id)initWithFrame:(CGRect)frame withImageName:(NSString*)imageName withLabelName:(NSString*)
labelName isValueEditabel:(BOOL) editable;

-(void)setValue:(NSString*)value;

@end

