//
//  CustomMethod.h
//  MiuTrip
//
//  Created by SuperAdmin on 13-11-21.
//  Copyright (c) 2013年 michael. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserDefaults.h"
#import "Model.h"
#import "Utils.h"

//BaseContentView delegate method
@protocol BaseContentViewDelegate <NSObject>

@optional
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event;

@end

//NSString Category
@interface NSString (OAURLEncodingAdditions)

- (NSString*)URLEncodedString;
- (NSString*)URLDecodedString;

@end

typedef NS_OPTIONS(NSInteger, ButtonImageState){
    ButtonImageStateTop,
    ButtonImageStateBottom
};


@interface BaseContentView : UIScrollView

@property (assign, nonatomic) id <BaseContentViewDelegate>      superResponder;
@property (assign, nonatomic) CGRect                            baseRect;
@property (strong, nonatomic) UIView                            *largeWidth;
@property (strong, nonatomic) UIView                            *largeHeight;

- (void)removeSubview:(UIView*)subview;
- (void)removeAllSubview;

- (void)resetContentSize;

@end

@interface UIView (UIViewCustomMethod)

- (void)setScaleX:(CGFloat)sx scaleY:(CGFloat)sy;
- (void)setShaowColor:(UIColor*)color offset:(CGSize)offset opacity:(CGFloat)opacity radius:(CGFloat)radius;//设置阴影
- (void)setBorderColor:(UIColor*)color width:(CGFloat)width;//设置边框
- (void)setCornerRadius:(CGFloat)radius;

- (void)createLineWithParam:(NSObject*)param frame:(CGRect)frame;

@end

@interface UIButton (UIButtonCustomMethod)

- (void)setImage:(UIImage*)image highlightImage:(UIImage*)highlightImage forState:(ButtonImageState)imageState;

@end

@interface UILabel (UILabelAutoSize)

- (void)setAutoSize:(BOOL)yesOrNo;
- (void)setAutoBreakLine:(BOOL)yesOrNo;

@end


@interface CustomStatusBtn : UIControl

@property (assign, nonatomic) BOOL                  select;

- (void)setDetail:(NSString*)detail;
- (void)setTextColor:(UIColor*)color;
- (void)setImage:(UIImage*)image selectedImage:(UIImage*)selectedImage;
- (void)setLeftViewScaleX:(CGFloat)sx scaleY:(CGFloat)sy;

- (void)setHighlighteds:(BOOL)highLighted;

- (void)addTarget:(id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents;
- (void)removeTarger:(id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents;

@end

#define CustomProgressAnimationRate             (200.0/1.18)

@interface CustomProgressView : UIView<UIGestureRecognizerDelegate>

- (id)initWithItems:(NSArray*)items;//items can be NSStrings or UIImages. control is automatically sized to fit content
@property(nonatomic) float progress;

@property(nonatomic, retain) UIColor* progressTintColor     NS_AVAILABLE_IOS(5_0) UI_APPEARANCE_SELECTOR;
@property(nonatomic, retain) UIColor* trackTintColor        NS_AVAILABLE_IOS(5_0) UI_APPEARANCE_SELECTOR;
@property(nonatomic, retain) UIImage* progressImage         NS_AVAILABLE_IOS(5_0) UI_APPEARANCE_SELECTOR;
@property(nonatomic, retain) UIImage* trackImage            NS_AVAILABLE_IOS(5_0) UI_APPEARANCE_SELECTOR;

@property(nonatomic, retain) UIImage* thumbImage;

- (void)setProgress:(float)progress;

- (void)setProgress:(float)progress animated:(BOOL)animated;

@end

