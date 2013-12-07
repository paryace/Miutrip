//
//  CustomMethod.m
//  MiuTrip
//
//  Created by SuperAdmin on 13-11-21.
//  Copyright (c) 2013年 michael. All rights reserved.
//

#import "CustomMethod.h"

@implementation NSString (OAURLEncodingAdditions)
- (NSString *)URLEncodedString
{
    NSString *result = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,(CFStringRef)self,NULL,CFSTR("!*'();:@&=+$,/?%#[]"),kCFStringEncodingUTF8));
    
    return result;
}

- (NSString *)URLDecodedString
{
    NSString *result = (NSString *)CFBridgingRelease(CFURLCreateStringByReplacingPercentEscapesUsingEncoding
                                                     (kCFAllocatorDefault,
                                                      (CFStringRef)self, CFSTR(""),
                                                      kCFStringEncodingUTF8));
    result = [result stringByReplacingOccurrencesOfString:@"+" withString:@" "];
    
    return result;
    /*
     NSString *result = (NSString *)CFURLCreateStringByReplacingPercentEscapesUsingEncoding(kCFAllocatorDefault, (CFStringRef)self, CFSTR("!*'();:@&=+$,/?%#[]"), kCFStringEncodingUTF8);
     [result autorelease];
     return result;*/
}



@end

@implementation BaseContentView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _baseRect = frame;
    }
    return self;
}

- (void)addSubview:(UIView *)view
{
    [super addSubview:view];
    if (!_largeHeight ) {
        _largeHeight = self;
    }if (!_largeWidth) {
        _largeWidth = self;
    }
    if (controlXLength(_largeWidth) < controlXLength(view)) {
        [self setXSize];
    }if (controlYLength(_largeHeight)  - 40 < controlYLength(view)) {
        [self setYSize];
    }
}

- (void)removeSubview:(UIView*)subview
{
    [subview removeFromSuperview];
    [self resetContentSize];
}

- (void)removeAllSubview
{
    for (UIView *subview in self.subviews) {
        [subview removeFromSuperview];
    }
    [self resetContentSize];
}

- (void)resetContentSize
{
    [self setXSize];
    [self setYSize];
}

- (void)setXSize
{
    if ([self.subviews count] != 0) {
        NSComparator cmptr = ^(UIView *obj1, UIView *obj2){
            if (controlXLength(obj1) >= controlXLength(obj2)) {
                return (NSComparisonResult)NSOrderedDescending;
            }
            
            if (controlXLength(obj1) < controlXLength(obj2)) {
                return (NSComparisonResult)NSOrderedAscending;
            }
            return (NSComparisonResult)NSOrderedSame;
        };
        NSArray *array = [self.subviews sortedArrayUsingComparator:cmptr];
        
        _largeWidth = [array lastObject];
        
        CGFloat contentWidth = controlXLength(_largeWidth) > self.frame.size.width?controlXLength(_largeWidth):self.frame.size.width;
        
        [self setContentSize:CGSizeMake(contentWidth,self.contentSize.height)];
    }else{
        [self setContentSize:CGSizeMake(self.frame.size.width, self.frame.size.height)];
    }
}

- (void)setYSize
{
    if ([self.subviews count] != 0) {
        NSComparator cmptr = ^(UIView *obj1, UIView *obj2){
            if (controlYLength(obj1) >= controlYLength(obj2)) {
                return (NSComparisonResult)NSOrderedDescending;
            }
            
            if (controlYLength(obj1) < controlYLength(obj2)) {
                return (NSComparisonResult)NSOrderedAscending;
            }
            return (NSComparisonResult)NSOrderedSame;
        };
        NSArray *array = [self.subviews sortedArrayUsingComparator:cmptr];
        
        _largeHeight = [array lastObject];
        
        CGFloat contentHeight = (controlYLength(_largeHeight) - self.frame.size.height > -40)?controlYLength(_largeHeight) + 40:self.frame.size.width;
        
        [self setContentSize:CGSizeMake(self.contentSize.width, contentHeight)];
    }else{
        [self setContentSize:CGSizeMake(self.frame.size.width, self.frame.size.height)];
    }
}

- (NSInteger)getXPageNum:(UIView*)view
{
    CGFloat pageNum = controlXLength(view)/self.frame.size.width;
    NSInteger integerNum = [[NSString stringWithFormat:@"%.0f",pageNum] integerValue];
    integerNum = pageNum > integerNum ? integerNum + 1 : integerNum;
    
    return integerNum > 0?integerNum:1;
}

- (NSInteger)getYPageNum:(UIView*)view
{
    CGFloat pageNum = controlYLength(view)/self.frame.size.width;
    NSInteger integerNum = [[NSString stringWithFormat:@"%.0f",pageNum] integerValue];
    integerNum = pageNum > integerNum ? integerNum + 1 : integerNum;
    
    return integerNum > 0?integerNum:1;
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.superResponder touchesEnded:touches withEvent:event];
}

@end

@implementation UIView (UIViewCustomMethod)

- (void)setScaleX:(CGFloat)sx scaleY:(CGFloat)sy
{
    CGAffineTransform currentTransform = self.transform;
    CGAffineTransform newTransform     = CGAffineTransformScale(currentTransform, sx, sy);
    [self setTransform:newTransform];
}

- (void)setShaowColor:(UIColor*)color offset:(CGSize)offset opacity:(CGFloat)opacity radius:(CGFloat)radius
{
    [self.layer setShadowColor:color.CGColor];
    [self.layer setShadowOffset:offset];
    [self.layer setShadowOpacity:opacity];
    [self.layer setShadowRadius:radius];
}

- (void)setBorderColor:(UIColor*)color width:(CGFloat)width
{
    [self.layer setBorderColor:color.CGColor];
    [self.layer setBorderWidth:width];
}

- (void)setCornerRadius:(CGFloat)radius
{
    if (radius > 0) {
        [self.layer setMasksToBounds:YES];
        [self.layer setCornerRadius:radius];
    }else{
        [self.layer setMasksToBounds:NO];
        [self.layer setCornerRadius:radius];
    }
}


- (void)createLineWithParam:(NSObject*)param frame:(CGRect)frame
{
    UIImageView *line = [[UIImageView alloc]initWithFrame:frame];
    if ([param isKindOfClass:[UIColor class]]) {
        UIColor *color = (UIColor*)param;
        [line setBackgroundColor:color];
        [line setAlpha:0.5];
    }else if ([param isKindOfClass:[UIImage class]]){
        UIImage *image = (UIImage*)param;
        [line setImage:image];
    }
    [self addSubview:line];
}


@end

@implementation UIButton (UIButtonCustomMethod)

- (void)setImage:(UIImage*)image highlightImage:(UIImage*)highlightImage forState:(ButtonImageState)imageState
{
    if (imageState == ButtonImageStateTop) {
        [self setImage:image forState:UIControlStateNormal];
        [self setImage:highlightImage forState:UIControlStateHighlighted];
        [self setImage:highlightImage forState:UIControlStateSelected];
    }else if (imageState == ButtonImageStateBottom){
        [self setBackgroundImage:image forState:UIControlStateNormal];
        [self setBackgroundImage:highlightImage forState:UIControlStateHighlighted];
        [self setBackgroundImage:highlightImage forState:UIControlStateSelected];
    }else{
        [self setBackgroundImage:image forState:UIControlStateNormal];
        [self setBackgroundImage:highlightImage forState:UIControlStateHighlighted];
        [self setBackgroundImage:highlightImage forState:UIControlStateSelected];
    }
}

@end

@implementation UILabel (UILabelAutoSize)

- (void)setAutoSize:(BOOL)yesOrNo
{
    [self setAdjustsFontSizeToFitWidth:yesOrNo];
    [self setAdjustsLetterSpacingToFitWidth:yesOrNo];
    if (yesOrNo) {
        [self setBaselineAdjustment:UIBaselineAdjustmentAlignBaselines];
        [self setMinimumScaleFactor:0.3];
    }
}

- (void)setAutoBreakLine:(BOOL)yesOrNo
{
    if (yesOrNo) {
        [self setNumberOfLines:0];
        [self setLineBreakMode:NSLineBreakByWordWrapping];
    }else{
        [self setNumberOfLines:1];
        [self setLineBreakMode:NSLineBreakByTruncatingTail];
    }
}

@end

@interface CustomStatusBtn ()

@property (strong, nonatomic) UIButton              *btn;
@property (strong, nonatomic) UIButton              *leftImageView;
@property (strong, nonatomic) UILabel               *detailLabel;

@end

@implementation CustomStatusBtn

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        _select = NO;
        [self setSubviewFrame];
    }
    return self;
}

- (void)setLeftViewScaleX:(CGFloat)sx scaleY:(CGFloat)sy
{
    CGAffineTransform currentTransform = self.leftImageView.transform;
    CGAffineTransform newTransform     = CGAffineTransformScale(currentTransform, sx, sy);
    [self.leftImageView setTransform:newTransform];
}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    CGAffineTransform currentTransform = self.transform;
    CGAffineTransform newTransform     = CGAffineTransformScale(currentTransform, frame.size.width/self.frame.size.width, frame.size.height/self.frame.size.height);
    [self setTransform:newTransform];
}

- (void)setDetail:(NSString*)detail
{
    [_detailLabel setText:detail];
}

- (void)setTextColor:(UIColor*)color
{
    [_detailLabel setTextColor:color];
}

- (void)setImage:(UIImage*)image selectedImage:(UIImage*)selectedImage
{
    [_leftImageView setImage:image forState:UIControlStateNormal];
    [_leftImageView setImage:selectedImage forState:UIControlStateHighlighted];
}

- (void)setSubviewFrame
{
    _leftImageView = [UIButton buttonWithType:UIButtonTypeCustom];
    [_leftImageView setFrame:CGRectMake(0, 0, self.frame.size.height, self.frame.size.height)];
    [_leftImageView setBackgroundColor:color(clearColor)];
    [self addSubview:_leftImageView];
    
    _detailLabel = [[UILabel alloc]initWithFrame:CGRectMake(controlXLength(_leftImageView), 0, self.frame.size.width - controlXLength(_leftImageView), _leftImageView.frame.size.height)];
    [_detailLabel setBackgroundColor:color(clearColor)];
    [_detailLabel setFont:[UIFont systemFontOfSize:12]];
    [_detailLabel setAdjustsFontSizeToFitWidth:YES];
    [_detailLabel setAdjustsLetterSpacingToFitWidth:YES];
    [_detailLabel setBaselineAdjustment:UIBaselineAdjustmentAlignBaselines];
    [_detailLabel setMinimumScaleFactor:0.3];
    [self addSubview:_detailLabel];
    
    _btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_btn setFrame:self.bounds];
    [_btn setBackgroundColor:color(clearColor)];
    [self insertSubview:_btn aboveSubview:_detailLabel];
}

- (void)setHighlighteds:(BOOL)highLighted
{
    [_leftImageView setHighlighted:highLighted];
    _select = highLighted;
}

- (void)setTag:(NSInteger)tag
{
    [super setTag:tag];
    [_btn setTag:tag];
}

- (void)addTarget:(id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents
{
    [_btn addTarget:target action:action forControlEvents:controlEvents];
}

- (void)removeTarger:(id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents
{
    [_btn removeTarget:target action:action forControlEvents:controlEvents];
}

@end


@interface CustomProgressView ()

@property (strong, nonatomic) UIView                    *contentView;
@property (strong, nonatomic) UIProgressView            *progressView;
@property (strong, nonatomic) UIImageView               *thumbImageView;

@property (assign, nonatomic) CGPoint                   currentPoint;

@property (assign, nonatomic) NSInteger                 numOfItems;
@property (strong, nonatomic) NSMutableArray            *titleArray;

@end

@implementation CustomProgressView

- (id)initWithItems:(NSArray*)items
{
    if (self = [super init]) {
        _numOfItems = [items count];
        _titleArray = [NSMutableArray array];
        [self setFrame:CGRectMake(0, 0, 200, 60)];
        [self setBackgroundColor:color(clearColor)];
        
        if ([[items lastObject] isKindOfClass:[NSString class]]) {
            [self setSubviewWithTitles:items];
        }else if ([[items lastObject] isKindOfClass:[UIImage class]]){
            [self setSubviewWithImages:items];
        }
    }
    return self;
}

- (void)progressViewResetLocation
{
    CGFloat miniProgress = 1.0;
    for (int i = 0; i<_numOfItems; i++) {
        CGFloat floatI = (CGFloat)i/(CGFloat)_numOfItems;
        CGFloat valueI = floatI - _progressView.progress;valueI = valueI < 0?-valueI:valueI;
        CGFloat valueM = miniProgress - _progressView.progress;valueM = valueM < 0?-valueM:valueM;
        miniProgress = valueI < valueM ?floatI:miniProgress;
    }
    
    
    [self setProgress:miniProgress animated:YES];
}

- (void)thumbImagePan:(UIPanGestureRecognizer*)panGesture
{
    if (panGesture.state == UIGestureRecognizerStateEnded) {
        [self progressViewResetLocation];
    }else{
        CGPoint translation = [panGesture translationInView:self.contentView];
        CGPoint movePoint   = CGPointMake(panGesture.view.center.x + translation.x, panGesture.view.center.y);
        if (movePoint.x < _progressView.frame.origin.x) {
            movePoint.x = _progressView.frame.origin.x;
        }else if (movePoint.x > (self.contentView.frame.size.width - _progressView.frame.origin.x)){
            movePoint.x = (self.contentView.frame.size.width - _progressView.frame.origin.x);
        }
        [panGesture setTranslation:CGPointZero inView:self.contentView];
        
        [self setProgress:((movePoint.x - _progressView.frame.origin.x)/self.progressView.frame.size.width)];
    }
}

- (void)setSubviewWithTitles:(NSArray*)items
{
    _progressView = [[UIProgressView alloc]initWithFrame:CGRectMake(15, 0, self.frame.size.width - 30, 10)];
    [_progressView setCenter:CGPointMake(self.frame.size.width/2, self.frame.size.height/2)];
    [_progressView setProgressViewStyle:UIProgressViewStyleBar];
    [self addSubview:_progressView];
    
    for (int i = 0;i<[items count];i++) {
        NSString *title = [items objectAtIndex:i];
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(_progressView.frame.origin.x +  _progressView.frame.size.width * i/[items count], 30 + 5, _progressView.frame.size.width/[items count], 25)];
        [label setFont:[UIFont systemFontOfSize:12]];
        [label setAutoSize:YES];
        [label setText:title];
        [label setTag:(301 + i)];
        [_titleArray addObject:label];
        [self addSubview:label];
    }
    
    if (!_contentView) {
        _contentView = [[UIView alloc]initWithFrame:self.bounds];
        [_contentView setBackgroundColor:color(clearColor)];
        [self addSubview:_contentView];
    }
    
    _thumbImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 25, 30)];
    [_thumbImageView.layer setAnchorPoint:CGPointMake(0.5, 1.0)];
    [_thumbImageView setCenter:CGPointMake(_progressView.frame.origin.x, self.center.y)];
    [_thumbImageView setBackgroundColor:color(clearColor)];
    [_thumbImageView setUserInteractionEnabled:YES];
    [self.contentView addSubview:_thumbImageView];
    
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(thumbImagePan:)];
    [panGesture setDelegate:self];
    [self.thumbImageView addGestureRecognizer:panGesture];
}

- (void)setSubviewWithImages:(NSArray*)items
{
    if (!_contentView) {
        _contentView = [[UIView alloc]initWithFrame:self.frame];
        [_contentView setBackgroundColor:color(clearColor)];
        [self addSubview:_contentView];
    }
}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    if (_contentView) {
        [_contentView setScaleX:frame.size.width/self.frame.size.width scaleY:frame.size.height/self.frame.size.height];
    }
}

- (void)setProgress:(float)progress
{
    [self setProgress:progress animated:NO];
}

- (void)setProgress:(float)progress animated:(BOOL)animated
{
    NSInteger index = (int)(progress * _numOfItems) + 300;
    for (UILabel *label in _titleArray) {
        if (label.tag == index) {
            [label setTextColor:color(colorWithRed:255.0/255.0 green:160.0/255.0 blue:30.0/255.0 alpha:1)];
        }else{
            [label setTextColor:color(blackColor)];
        }
    }
    if (animated) {
        CGFloat progressDiff = progress - _progressView.progress;
        CGFloat endTime = (_progressView.frame.size.width * (progressDiff > 0?progressDiff:-progressDiff))/CustomProgressAnimationRate;
        
        [UIView beginAnimations:@"moveProgress" context:nil];
        [UIView setAnimationDuration:endTime];
        [UIView setAnimationCurve:UIViewAnimationCurveLinear];
        [_thumbImageView setCenter:CGPointMake((self.progressView.frame.size.width * progress) + _progressView.frame.origin.x, _thumbImageView.center.y)];
        [UIView commitAnimations];
    }else{
        [_thumbImageView setCenter:CGPointMake((self.progressView.frame.size.width * progress) + _progressView.frame.origin.x, _thumbImageView.center.y)];
    }
    
    [_progressView setProgress:progress animated:animated];
    [UserDefaults shareUserDefault].searchRadiu = progress;
}

- (void)setProgressImage:(UIImage *)progressImage
{
    [_progressView setProgressImage:progressImage];
}

- (void)setTrackImage:(UIImage *)trackImage
{
    [_progressView setTrackImage:trackImage];
}

- (UIImage *)progressImage
{
    return _progressView.progressImage;
}

- (UIImage *)trackImage
{
    return _progressView.trackImage;
}

- (void)setThumbImage:(UIImage *)thumbImage
{
    [_thumbImageView setImage:thumbImage];
}

- (UIImage *)thumbImage
{
    return _thumbImageView.image;
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesEnded:touches withEvent:event];
    NSLog(@"touch end");
}

- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
    [super motionEnded:motion withEvent:event];
    NSLog(@"motion end");
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    NSLog(@"touch began");
}
- (void)motionBegan:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
    NSLog(@"motion began");
    [super motionBegan:motion withEvent:event];
}

@end




