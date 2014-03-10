//
//  PostTypeViewController.h
//  MiuTrip
//
//  Created by apple on 14-2-12.
//  Copyright (c) 2014年 michael. All rights reserved.
//

#import "BaseUIViewController.h"
#import "SelectDeliverViewController.h"
#import "SelectAddressViewController.h"
#import "SelectPostTypeViewController.h"

@class DeliveryTypeDTO;

@protocol PostTypeDelegate <NSObject>

- (void)selectPostDone:(DeliveryTypeDTO*)postType mailCode:(TC_APIMImInfo*)mailCode address:(NSString*)address;

@end

@interface PostTypeViewController : BaseUIViewController<UITextFieldDelegate,SelectDeliverDelegate,SelectAddressDelegate,SelectPostTypeDelegate>

@property (assign, nonatomic) id<PostTypeDelegate> delegate;
@property (strong, nonatomic) id policyExecutor;

@end

@interface PostType : NSObject

@property (strong, nonatomic) NSNumber      *postCode;      //配送码
@property (strong, nonatomic) NSString      *postDesc;      //配送描述

+ (NSArray*)getPostTypes;

@end