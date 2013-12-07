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
#import "BaseRequestModel.h"
#import "RequestManager.h"


@class BaseContentView;

/**
 error code:
    5:用户不存在
    6：用户名密码不匹配
    7：密码必须修改
    90：需要强制升级
    91：缺少token
    92：参数异常
    93：参数验证异常
    94: 无效Token
    95: 无效DeviceID
    96: Token 过期
    97: 手机用户登录失败
 */

typedef NS_OPTIONS(NSInteger, RequestType){
    //RequestGet,
    RequestPost,
    RequestLogIn,
    RequestLogOut
};

@interface BaseUIViewController : UIViewController<UIGestureRecognizerDelegate,BaseContentViewDelegate,BusinessDelegate>

@property (strong, nonatomic)                       BaseContentView                 *contentView;
@property (strong, nonatomic, setter = setTopBar:)  UIImageView                     *topBar;
@property (strong, nonatomic)                       UIButton                        *bottomBar;
@property (strong, nonatomic)                       RequestManager                  *requestManager;

- (void)setSubjoinViewFrame;

- (void)setBackGroundImage:(UIImage*)image;

- (void)setTopBarBackGroundImage:(UIImage*)image;

- (void)setBottomBarBackGroundImage:(UIImage*)image;
- (void)setBottomBarBackGroundColor:(UIColor*)color;
- (void)setBottomBarItems:(NSArray*)items;

- (void)setReturnButton:(UIButton*)button;
- (void)setPopToMainViewButton:(UIButton*)button;

- (UIView *)findKeyboard;

-(void)sendRequestWithRequest:(BaseRequestModel *)request;
- (void)sendRequestWithURL:(NSString*)URLString params:(NSDictionary*)params requestMethod:(RequestType)requestType userInfo:(NSDictionary*)userInfo;
- (void)requestDone:(NSDictionary*)responseData;
- (void)requestError:(ASIHTTPRequest*)request;
- (void)requestSuccess:(NSString*)responseData;

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

