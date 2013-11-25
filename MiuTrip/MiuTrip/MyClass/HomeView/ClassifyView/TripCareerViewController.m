//
//  TripCareerViewController.m
//  MiuTrip
//
//  Created by SuperAdmin on 13-11-20.
//  Copyright (c) 2013年 michael. All rights reserved.
//

#import "TripCareerViewController.h"

@interface TripCareerViewController ()

@end

@implementation TripCareerViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)init
{
    if (self = [super init]) {
        [self.contentView setHidden:NO];
        [self setSubviewFrame];
    }
    return self;
}

#pragma mark - view init
- (void)setSubviewFrame
{
    [self setBackGroundImage:imageNameAndType(@"home_bg", nil)];
    [self setTitle:@"商旅生涯"];
    [self setTopBarBackGroundImage:imageNameAndType(@"topbar", nil)];
    
    UIButton *returnBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [returnBtn setBackgroundColor:color(clearColor)];
    [returnBtn setImage:imageNameAndType(@"return", nil) forState:UIControlStateNormal];
    [returnBtn setFrame:CGRectMake(0, 0, self.topBar.frame.size.height, self.topBar.frame.size.height)];
    [self setReturnButton:returnBtn];
    [self.view addSubview:returnBtn];
}

- (void)setSubjoinViewFrame
{
    UIImageView *itemBg = [[UIImageView alloc]initWithFrame:CGRectMake(5, 10 + controlYLength(self.topBar), self.contentView.frame.size.width - 10, 0)];
    [itemBg setBackgroundColor:color(clearColor)];
    UIImage *itemImage = imageNameAndType(@"t_item_bg", nil);
    [itemBg setImage:[itemImage stretchableImageWithLeftCapWidth:itemImage.size.width/2 topCapHeight:itemImage.size.height/2]];
    [self.contentView addSubview:itemBg];
    
    TripCareerItem *airLevelItem = [[TripCareerItem alloc]initWithFrame:CGRectMake(10, 10, itemBg.frame.size.width - 20, 0)];
    [airLevelItem setTitleImage:imageNameAndType(@"t_career_ariLevel", nil)];
    [airLevelItem setTitle:imageNameAndType(@"sub_arilevel", nil)];
    [airLevelItem.leftImageView setScaleX:0.85 scaleY:0.85];
    NSString *airText = [NSString stringWithFormat:@"您一年半内飞行了%d公里,搭乘%d次飞机;\n轻松击败的商务人士,超级百分之%d飞人名副其实!",45002,14,93];
    [airLevelItem setContentText:airText];
    [itemBg addSubview:airLevelItem];
    
    [itemBg addSubview:[self createLineWithFrame:CGRectMake(airLevelItem.frame.origin.x, controlYLength(airLevelItem) + 5, airLevelItem.frame.size.width, 1.5)]];
    
    TripCareerItem *arrivedItem = [[TripCareerItem alloc]initWithFrame:CGRectMake(airLevelItem.frame.origin.x, controlYLength(airLevelItem) + 10, airLevelItem.frame.size.width, 0)];
    [arrivedItem setTitleImage:imageNameAndType(@"t_career_arrived", nil)];
    [arrivedItem setTitle:imageNameAndType(@"sub_arrived", nil)];
    [arrivedItem.leftImageView setScaleX:0.85 scaleY:0.85];
    NSString *arrivedText = [NSString stringWithFormat:@"您一年班内去过%d个省份,%d个城市;\n其中%@去过%d次,是您商务出行高发地哦!",5,8,@"郑州",4];
    [arrivedItem setContentText:arrivedText];
    [itemBg addSubview:arrivedItem];
    
    [itemBg addSubview:[self createLineWithFrame:CGRectMake(airLevelItem.frame.origin.x, controlYLength(arrivedItem) + 5, airLevelItem.frame.size.width, 1.5)]];
    
    TripCareerItem *checkedInItem = [[TripCareerItem alloc]initWithFrame:CGRectMake(airLevelItem.frame.origin.x, controlYLength(arrivedItem) + 10, airLevelItem.frame.size.width, 0)];
    [checkedInItem setTitleImage:imageNameAndType(@"t_career_checkedIn", nil)];
    [checkedInItem setTitle:imageNameAndType(@"sub_checkedIn", nil)];
    [checkedInItem.leftImageView setScaleX:0.85 scaleY:0.85];
    NSString *checkedInText = [NSString stringWithFormat:@"您一年班内住过%d家酒店;\n其中北京%@住过%d次共%d晚,情有独钟!",6,@"万豪酒店",5,10];
    [checkedInItem setContentText:checkedInText];
    [itemBg addSubview:checkedInItem];
    
    [itemBg addSubview:[self createLineWithFrame:CGRectMake(airLevelItem.frame.origin.x, controlYLength(checkedInItem) + 5, airLevelItem.frame.size.width, 1.5)]];
    
    TripCareerItem *paidItem = [[TripCareerItem alloc]initWithFrame:CGRectMake(airLevelItem.frame.origin.x, controlYLength(checkedInItem) + 10, airLevelItem.frame.size.width, 0)];
    [paidItem setTitleImage:imageNameAndType(@"t_career_paied", nil)];
    [paidItem setTitle:imageNameAndType(@"sub_paied", nil)];
    [paidItem.leftImageView setScaleX:0.85 scaleY:0.85];
    NSString *paidText = [NSString stringWithFormat:@"您一年班内:\n机票支出%d元,平均%d/张,%@居多;\n酒店支出%d元,平均%d元/间夜,%d星级为主;",25000,670,@"经济舱",13000,400,4];
    [paidItem setContentText:paidText];
    [itemBg addSubview:paidItem];
    
    [itemBg addSubview:[self createLineWithFrame:CGRectMake(airLevelItem.frame.origin.x, controlYLength(paidItem) + 5, airLevelItem.frame.size.width, 1.5)]];
    
    TripCareerItem *tripEvaluateItem = [[TripCareerItem alloc]initWithFrame:CGRectMake(airLevelItem.frame.origin.x, controlYLength(paidItem) + 10, airLevelItem.frame.size.width, 0)];
    [tripEvaluateItem setTitleImage:imageNameAndType(@"t_career_tripevaluate", nil)];
    [tripEvaluateItem setTitle:imageNameAndType(@"sub_tripevaluate", nil)];
    [tripEvaluateItem.leftImageView setScaleX:0.85 scaleY:0.85];
    NSString *tripEvaluateText = [NSString stringWithFormat:@"您一年班内:\n机票预订完全合规,好同志!\n酒店预订有4次RC,小心老板有意见哦!"];
    [tripEvaluateItem setContentText:tripEvaluateText];
    [itemBg addSubview:tripEvaluateItem];
    
    [itemBg setFrame:CGRectMake(itemBg.frame.origin.x, itemBg.frame.origin.y, itemBg.frame.size.width, controlYLength(tripEvaluateItem) + 10)];
    [self.contentView resetContentSize];
}

- (UIImageView *)createLineWithFrame:(CGRect)rect
{
    UIImageView *line = [[UIImageView alloc]initWithFrame:rect];
    [line setBackgroundColor:color(clearColor)];
    [line setImage:imageNameAndType(@"t_line", nil)];
    return line;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

@interface TripCareerItem ()

@end

@implementation TripCareerItem

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, 40)]) {
        [self setSubviewFrame];
    }
    return self;
}

- (void)setSubviewFrame
{
    _leftImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 40, 40)];
    [_leftImageView setBackgroundColor:color(clearColor)];
    [self addSubview:_leftImageView];
    
    _titleAsLabel = [[UILabel alloc]initWithFrame:CGRectMake(controlXLength(_leftImageView), _leftImageView.frame.origin.y, self.frame.size.width - controlXLength(_leftImageView), _leftImageView.frame.size.height)];
    [_titleAsLabel setBackgroundColor:color(clearColor)];
    [_titleAsLabel setAutoSize:YES];
    [_titleAsLabel setHidden:YES];
    [_titleAsLabel setFont:[UIFont systemFontOfSize:13]];
    [self addSubview:_titleAsLabel];
    
    _titleAsImage = [[UIImageView alloc] initWithFrame:CGRectMake(_titleAsLabel.frame.origin.x, _titleAsLabel.frame.origin.y, 75, _titleAsLabel.frame.size.height)];
    [_titleAsImage setBackgroundColor:color(clearColor)];
    [_titleAsImage setHidden:YES];
    [_titleAsImage setContentMode:UIViewContentModeScaleAspectFit];
    [self addSubview:_titleAsImage];
    
    _contentLabel = [[UILabel alloc]initWithFrame:CGRectMake(_leftImageView.frame.origin.x, controlYLength(_leftImageView), self.frame.size.width, 0 )];
    [_contentLabel setBackgroundColor:color(clearColor)];
    [_contentLabel setFont:[UIFont systemFontOfSize:13]];
    [_contentLabel setAutoBreakLine:YES];
    [self addSubview:_contentLabel];
}

- (void)setTitleImage:(UIImage*)image
{
    [_leftImageView setImage:image];
}

- (void)setTitle:(NSObject*)title
{
    if ([title isKindOfClass:[NSString class]]) {
        NSString *string = (NSString*)title;
        [_titleAsLabel setText:string];
        [_titleAsImage setHidden:YES];
        [_titleAsLabel setHidden:NO];
    }else if ([title isKindOfClass:[UIImage class]]){
        UIImage *image = (UIImage*)title;
        [_titleAsImage setImage:image];
        [_titleAsImage setHidden:NO];
        [_titleAsLabel setHidden:YES];
    }
}

- (void)setContentText:(NSString*)text
{
    CGFloat height = [Utils heightForWidth:_contentLabel.frame.size.width text:text font:_contentLabel.font];
    [_contentLabel setFrame:CGRectMake(_contentLabel.frame.origin.x, _contentLabel.frame.origin.y, _contentLabel.frame.size.width, height)];
    [_contentLabel setText:text];
    [self setFrame:CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, 40 + height)];
}

@end













