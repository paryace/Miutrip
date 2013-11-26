//
//  BaseUIViewController.h
//  MiuTrip
//
//  Created by SuperAdmin on 11/13/13.
//  Copyright (c) 2013 michael. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ASIHTTPRequest.h"
#import "SBJson.h"
#import "ASIFormDataRequest.h"
#import "ASINetworkQueue.h"
#import "CustomMethod.h"

@class BaseContentView;

typedef NS_OPTIONS(NSInteger, RequestType){
    //RequestGet,
    RequestPost,
    RequestLogIn,
    RequestLogOut
};

@interface BaseUIViewController : UIViewController<UIGestureRecognizerDelegate,BaseContentViewDelegate>

@property (strong, nonatomic)                       BaseContentView                 *contentView;
@property (strong, nonatomic, setter = setTopBar:)  UIImageView                     *topBar;
@property (strong, nonatomic)                       UIButton                        *bottomBar;

- (void)setSubjoinViewFrame;

- (void)setBackGroundImage:(UIImage*)image;

- (void)setTopBarBackGroundImage:(UIImage*)image;

- (void)setBottomBarBackGroundImage:(UIImage*)image;
- (void)setBottomBarBackGroundColor:(UIColor*)color;
- (void)setBottomBarItems:(NSArray*)items;

- (void)setReturnButton:(UIButton*)button;
- (void)setPopToMainViewButton:(UIButton*)button;

- (UIView *)findKeyboard;

- (void)sendRequestWithURL:(NSString*)URLString params:(NSDictionary*)params requestMethod:(RequestType)requestType userInfo:(NSDictionary*)userInfo;
- (void)requestDone:(ASIHTTPRequest*)request;
- (void)requestError:(ASIHTTPRequest*)request;

- (void)pushViewController:(BaseUIViewController*)_viewController transitionType:(TransitionType)_transitionType completionHandler:(void (^) (void))_compleHandler;
- (void)popViewControllerTransitionType:(TransitionType)_transitionType completionHandler:(void (^) (void))_compleHandler;
- (void)popToMainViewControllerTransitionType:(TransitionType)_transitionType completionHandler:(void (^) (void))_compleHandler;

- (void)pushViewController:(BaseUIViewController*)_viewController transitionType:(TransitionType)_transitionType Direction:(Direction)_direction completionHandler:(void (^) (void))_compleHandler;

- (void)pushViewControllers:(NSArray*)viewControllers transitionType:(TransitionType)_transitionType completionHandler:(void (^) (void))_compleHandler;

- (void)keyBoardWillShow:(NSNotification *)notification;
- (void)keyBoardWillHide:(NSNotification *)notification;
- (void)keyBoardChangeFrame:(NSNotification *)notification;

- (UIImageView *)createLineWithParam:(NSObject*)param frame:(CGRect)frame;

@end



