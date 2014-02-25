//
//  BindingAccountViewController.m
//  MiuTrip
//
//  Created by Y on 14-2-25.
//  Copyright (c) 2014年 michael. All rights reserved.
//

#import "BindingAccountViewController.h"

@interface BindingAccountViewController ()

@end

@implementation BindingAccountViewController

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

- (void)setSubviewFrame
{
    [self setBackGroundImage:imageNameAndType(@"home_bg", nil)];
    [self setTitle:@"绑定帐号"];
    [self setTopBarBackGroundImage:imageNameAndType(@"topbar", nil)];
    
    UIButton *returnBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [returnBtn setBackgroundColor:color(clearColor)];
    [returnBtn setImage:imageNameAndType(@"return", nil) forState:UIControlStateNormal];
    [returnBtn setFrame:CGRectMake(0, 0, self.topBar.frame.size.height, self.topBar.frame.size.height)];
    [self setReturnButton:returnBtn];
    [self.view addSubview:returnBtn];
    
    [self setSubjoinViewFrame];
}

-(void)setSubjoinViewFrame
{
    UIImageView *topView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_finish"]];
    [topView setFrame:CGRectMake(self.contentView.frame.size.width/15-5,self.contentView.frame.size.height/12 + 15,self.contentView.frame.size.width/10 - 5 ,self.contentView.frame.size.width/10 - 5)];
    [self.contentView addSubview:topView];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(controlXLength(topView) + 5, topView.frame.origin.y , self.view.frame.size.width/2,topView.frame.size.height)];
    [titleLabel setText:@"我想绑定已有觅优帐号"];
    [titleLabel setFont:[UIFont boldSystemFontOfSize:15]];
    [titleLabel setBackgroundColor:[UIColor clearColor]];
    [titleLabel setTextColor:[UIColor grayColor]];
    [self.contentView addSubview:titleLabel];
    
    UIImageView *bgImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"log_text_bg"]];
    [bgImageView setFrame:CGRectMake(topView.frame.origin.x - 6 , controlYLength(topView)+5, appFrame.size.width - 20, self.contentView.frame.size.height/5 - 20)];
    [self.contentView addSubview:bgImageView];
    
    UILabel *account = [[UILabel alloc] initWithFrame:CGRectMake(bgImageView.frame.origin.x + 5,bgImageView.frame.origin.y+5,bgImageView.frame.size.width/4,bgImageView.frame.size.height/2-5)];
    [account setText:@"  帐    号"];
    [account setBackgroundColor:[UIColor clearColor]];
    [account setTextColor:[UIColor grayColor]];
    [self.contentView addSubview:account];

    UITextField * accountTf = [[UITextField alloc] initWithFrame:CGRectMake(controlXLength(account)+ 10, account.frame.origin.y, bgImageView.frame.size.width - 20 - account.frame.size.width, bgImageView.frame.size.height/2)];
    [self.contentView addSubview:accountTf];
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(account.frame.origin.x, controlYLength(account), bgImageView.frame.size.width - 10, 0.5)];
    [line setBackgroundColor:[UIColor lightGrayColor]];
    [self.contentView addSubview:line];
    
    UIView *line2 = [[UIView alloc] initWithFrame:CGRectMake(controlXLength(account), account.frame.origin.y, 0.5, bgImageView.frame.size.height - 12)];
    [line2 setBackgroundColor:[UIColor lightGrayColor]];
    [self.contentView addSubview:line2];
    
    UILabel *passWord = [[UILabel alloc] initWithFrame:CGRectMake(bgImageView.frame.origin.x + 5,controlYLength(account),bgImageView.frame.size.width/4,bgImageView.frame.size.height/2-5)];
    [passWord setText:@"  密    码"];
    [passWord setBackgroundColor:[UIColor clearColor]];
    [passWord setTextColor:[UIColor grayColor]];
    [self.contentView addSubview:passWord];
    
    UITextField * psdTf = [[UITextField alloc] initWithFrame:CGRectMake(controlXLength(passWord)+10, passWord.frame.origin.y, bgImageView.frame.size.width - 20 - passWord.frame.size.width, bgImageView.frame.size.height/2)];
    [self.contentView addSubview:psdTf];
    
    UIButton *forgrtPsd = [[UIButton alloc] initWithFrame:CGRectMake(controlXLength(bgImageView) - bgImageView.frame.size.width/4-20, controlYLength(bgImageView), bgImageView.frame.size.width/3, bgImageView.frame.size.height/2)];
    [forgrtPsd setTitle:@"忘记密码" forState:UIControlStateNormal];
    [forgrtPsd setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [self.contentView addSubview:forgrtPsd];
    
    UIImageView *bgBtnView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"button_booking"] highlightedImage: [UIImage imageNamed:@"button_booking_pressed"]];
    [bgBtnView setFrame:CGRectMake(self.view.frame.size.width/4, controlYLength(forgrtPsd) + 20, self.view.frame.size.width/2, bgImageView.frame.size.height/2)];
    [self.contentView addSubview:bgBtnView];
    
    UIButton *bindingBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width/4, controlYLength(forgrtPsd) + 20, self.view.frame.size.width/2, bgImageView.frame.size.height/2)];
    [bindingBtn setTitle:@"   绑      定   " forState:UIControlStateNormal];
    [self.contentView addSubview:bindingBtn];
    
}

@end
