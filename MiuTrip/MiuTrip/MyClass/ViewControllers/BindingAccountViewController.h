//
//  BindingAccountViewController.h
//  MiuTrip
//
//  Created by Y on 14-2-25.
//  Copyright (c) 2014年 michael. All rights reserved.
//

#import "BaseUIViewController.h"

@interface BindingAccountViewController : BaseUIViewController

@property (assign, nonatomic)BOOL saveState;

@end


#pragma mark --记住登陆状态按钮自定义

@interface MarkState : UIButton

@property (nonatomic, strong)UIImageView *mark;
@property (nonatomic, strong)UILabel *mTitle;

@end