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

static      Model       *shareModel;

@interface Model ()

@property (assign, nonatomic) BOOL                      showCoverView;

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
//
//- (void)showPromptText:(NSString*)text model:(BOOL)model
//{
//    _showCoverView = YES;
//    AppDelegate *appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
//    UIViewController *viewController = nil;
//    if (appDelegate.window.rootViewController.presentedViewController) {
//        viewController = appDelegate.window.rootViewController.presentedViewController;
//    }else{
//        viewController = appDelegate.window.rootViewController;
//    }
//    
//    if (!_tipView) {
//        _tipView = [UIButton buttonWithType:UIButtonTypeCustom];
//        _tipView.enabled = NO;
//        [_tipView setBackgroundImage:stretchImage(@"tipImage", nil) forState:UIControlStateNormal];
//        [_tipView.titleLabel setNumberOfLines:0];
//        [_tipView.layer setMasksToBounds:YES];
//        [_tipView.layer setCornerRadius:10.0f];
//        [_tipView.titleLabel setTextAlignment:NSTextAlignmentCenter];
//        [_tipView.titleLabel setLineBreakMode:NSLineBreakByWordWrapping];
//        [_tipView.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:13]];
//        [_tipView setBackgroundColor:color(darkGrayColor)];
//        _tipView.alpha = 0.0;
//    }
//    CGFloat height = [Utils heightForWidth:appFrame.size.width*2/3 - 10 text:text font:_tipView.titleLabel.font];
//    height = height < 30?30:height;
//    _tipView.frame = CGRectMake(0, 0, appFrame.size.width*2/3, height + 10);
//    _tipView.center = CGPointMake(appFrame.size.width/2, appFrame.size.height*2/3);
//    [_tipView setTitle:text forState:UIControlStateNormal];
//        
//    if (_showCoverView) {
//        [viewController.view addSubview:_tipView];
//        [UIView animateWithDuration:0.3f
//                         animations:^{
//                             _tipView.alpha = 1.0f;
//                         }completion:^(BOOL finished){
//                             _showCoverView = NO;
//                             [self performSelector:@selector(tipHide:) withObject:[NSNumber numberWithBool:model] afterDelay:1.50f];
//                         }];
//    }
//}

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
        [_tipView.layer setMasksToBounds:YES];
        [_tipView.layer setCornerRadius:10.0f];
        [_tipView.titleLabel setTextAlignment:NSTextAlignmentCenter];
        [_tipView.titleLabel setLineBreakMode:NSLineBreakByWordWrapping];
        [_tipView.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:13]];
        [_tipView setBackgroundColor:color(darkGrayColor)];
        _tipView.alpha = 0.0;
    }
    CGFloat height = [Utils heightForWidth:appFrame.size.width*2/3 - 10 text:text font:_tipView.titleLabel.font];
    height = height < 30?30:height;
    _tipView.frame = CGRectMake(0, 0, appFrame.size.width*2/3, height + 10);
    _tipView.center = CGPointMake(appFrame.size.width/2, appFrame.size.height*2/3);
    [_tipView setTitle:text forState:UIControlStateNormal];
    
    if (_showCoverView) {
        [view addSubview:_tipView];
        [UIView animateWithDuration:0.3f
                         animations:^{
                             _tipView.alpha = 1.0f;
                         }completion:^(BOOL finished){
                             _showCoverView = NO;
                             [self performSelector:@selector(tipHide:) withObject:[NSNumber numberWithBool:model] afterDelay:1.50f];
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

@end
