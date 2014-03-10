//
//  SelectPostTypeViewController.h
//  MiuTrip
//
//  Created by apple on 14-2-13.
//  Copyright (c) 2014年 michael. All rights reserved.
//

#import "BaseUIViewController.h"

@class PostType;

@protocol SelectPostTypeDelegate <NSObject>

- (void)selectPostTypeDone:(PostType*)postType;

@end

@interface SelectPostTypeViewController : BaseUIViewController<UITableViewDataSource,UITableViewDelegate,BusinessDelegate>

@property (assign, nonatomic) id<SelectPostTypeDelegate> delegate;

- (void)getMailConfigRequest;

@end
