//
//  Model.m
//  Recruitment
//
//  Created by M J on 13-10-16.
//  Copyright (c) 2013年 M J. All rights reserved.
//

#import "Model.h"
#import "Utils.h"
#import "AppDelegate.h"
#import <QuartzCore/QuartzCore.h>
#import "HotelAndAirOrderViewController.h"
#import "LittleMiuViewController.h"

static      Model       *shareModel;

@interface Model ()

@property (assign, nonatomic) BOOL                      showCoverView;
@property (strong, nonatomic) NSTimer                   *timer;

@end

@implementation Model

+ (Model*)shareModel
{
    @synchronized(self){
        if (!shareModel) {
            shareModel = [[Model alloc]init];
        }
    }
    return shareModel;
}

- (id)init
{
    self = [super init];
    if (self) {
        _showCoverView = NO;
    }
    return self;
}

- (void)showPromptText:(NSString*)text model:(BOOL)model
{
    _showCoverView = YES;
    AppDelegate *appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    UIView *view = appDelegate.window;
    
    if (!_tipView) {
        _tipView = [UIButton buttonWithType:UIButtonTypeCustom];
        _tipView.enabled = NO;
        [_tipView setBackgroundImage:stretchImage(@"tipImage", nil) forState:UIControlStateNormal];
        [_tipView.titleLabel setNumberOfLines:0];
        [_tipView.titleLabel setTextAlignment:NSTextAlignmentCenter];
        UIView *tipBGView = [[UIView alloc]init];
        [tipBGView setTag:100];
        [tipBGView setCornerRadius:10];
        [tipBGView setBackgroundColor:color(blackColor)];
        [tipBGView setAlpha:0.5];
        [_tipView insertSubview:tipBGView belowSubview:_tipView.titleLabel];
        [_tipView.titleLabel setLineBreakMode:NSLineBreakByWordWrapping];
        [_tipView.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:13]];
        [_tipView setBackgroundColor:color(clearColor)];
    }
    CGFloat height = [Utils heightForWidth:appFrame.size.width*2/3 - 10 text:text font:_tipView.titleLabel.font];
    height = height < 30?30:height;
    _tipView.frame = CGRectMake(0, 0, appFrame.size.width*2/3, height + 10);
    UIView *tipBGView = [_tipView viewWithTag:100];
    [tipBGView setFrame:_tipView.bounds];
    _tipView.center = CGPointMake(appFrame.size.width/2, appFrame.size.height*2/3);
    [_tipView setTitle:text forState:UIControlStateNormal];
    
    if (_timer) {
        [_timer invalidate];
        _timer = nil;
    }
    
    if (_showCoverView) {
        [view addSubview:_tipView];
        [UIView animateWithDuration:0.3f
                         animations:^{
                             _tipView.alpha = 1.0f;
                         }completion:^(BOOL finished){
                             _showCoverView = NO;
                             //                             [self performSelector:@selector(tipHide:) withObject:[NSNumber numberWithBool:model] afterDelay:1.50f];
                             _timer = [NSTimer scheduledTimerWithTimeInterval:2.50f target:self selector:@selector(tipHide:) userInfo:[NSNumber numberWithBool:model] repeats:NO];
                         }];
    }
}
- (void)tipHide:(NSNumber*)number
{
    if (!_showCoverView) {
        [UIView animateWithDuration:0.5f
                         animations:^{
                             _tipView.alpha = 0.0f;
                         }
                         completion:^(BOOL finished) {
                             if (_tipView.superview) {
                                 [_tipView removeFromSuperview];
                             }
                             if (_subWindow.superview) {
                                 [_subWindow removeFromSuperview];
                             }
                         }];
    }
}

- (void)setUserInteractionEnabled:(BOOL)enabled
{
    AppDelegate *appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    [appDelegate.window setUserInteractionEnabled:enabled];
}

- (void)goToAirOrderList
{
    AppDelegate *appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    if (appDelegate.window.rootViewController.presentedViewController) {
        HotelAndAirOrderViewController *airOrderViewController = [[HotelAndAirOrderViewController alloc]initWithOrderType:OrderTypeAir];
        UIViewController *viewController = appDelegate.window.rootViewController.presentedViewController;
        if ([viewController isKindOfClass:[UINavigationController class]]) {
            UINavigationController *navigationController = (UINavigationController*)viewController;
            [navigationController pushViewController:airOrderViewController animated:YES];
        }else{
            [viewController presentViewController:airOrderViewController animated:YES completion:nil];
        }
    }else{
        HotelAndAirOrderViewController *airOrderViewController = [[HotelAndAirOrderViewController alloc]initWithOrderType:OrderTypeAir];
        UIViewController *viewController = appDelegate.window.rootViewController;
        if ([viewController isKindOfClass:[UINavigationController class]]) {
            UINavigationController *navigationController = (UINavigationController*)viewController;
            [navigationController pushViewController:airOrderViewController animated:YES];
        }else{
            [viewController presentViewController:airOrderViewController animated:YES completion:nil];
        }
    }
}

- (void)goToLittleMiu
{
    AppDelegate *appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    if (appDelegate.window.rootViewController.presentedViewController) {
        LittleMiuViewController *littleMiuViewController = [[LittleMiuViewController alloc]init];
        UIViewController *viewController = appDelegate.window.rootViewController.presentedViewController;
        if ([viewController isKindOfClass:[UINavigationController class]]) {
            UINavigationController *navigationController = (UINavigationController*)viewController;
            [navigationController pushViewController:littleMiuViewController animated:YES];
        }else{
            [viewController presentViewController:littleMiuViewController animated:YES completion:nil];
        }
    }else{
        LittleMiuViewController *littleMiuViewController = [[LittleMiuViewController alloc]init];
        UIViewController *viewController = appDelegate.window.rootViewController;
        if ([viewController isKindOfClass:[UINavigationController class]]) {
            UINavigationController *navigationController = (UINavigationController*)viewController;
            [navigationController pushViewController:littleMiuViewController animated:YES];
        }else{
            [viewController presentViewController:littleMiuViewController animated:YES completion:nil];
        }
    }
}
@end
