//
//  Model.h
//  Recruitment
//
//  Created by M J on 13-10-16.
//  Copyright (c) 2013年 M J. All rights reserved.
//

#import <Foundation/Foundation.h>

@class BaseUIViewController;

@interface Model : NSObject

+ (Model*)shareModel;

@property (strong, nonatomic) BaseUIViewController      *mainView;
@property (strong, nonatomic) UIWindow                  *subWindow;
@property (nonatomic, retain) UIButton                  *tipView;

- (void)showPromptText:(NSString*)text model:(BOOL)model;

@end
