//
//  UserDefaults.m
//  TrainTicketQuery
//
//  Created by M J on 13-9-2.
//  Copyright (c) 2013年 M J. All rights reserved.
//

#import "UserDefaults.h"
#import "Model.h"
#import "Utils.h"
#import "LoginInfoDTO.h"
#import "RequestManager.h"
//#import "Common.h"

static UserDefaults *shareUserDefault;

@implementation UserDefaults

@synthesize loginInfo;

@synthesize userName;
@synthesize passWord;
@synthesize mobile;
@synthesize email;
@synthesize sex;
@synthesize getUserInfo;

@synthesize autoLogin;

@synthesize reserveObject;
@synthesize tripGoal;
@synthesize startCity;
@synthesize goalCity;
@synthesize priceRange;
@synthesize postType;
@synthesize postAddress;
@synthesize launchPage;
@synthesize allowShake;
@synthesize searchRadiu;

@synthesize authTkn;

@synthesize allCity;

+ (UserDefaults*)shareUserDefault
{
    @synchronized(self){
        if (shareUserDefault == nil) {
            shareUserDefault = [[UserDefaults alloc]init];
        }
    }
    return shareUserDefault;
}

- (id)init
{
    self = [super init];
    if (self) {
        getUserInfo = NO;
        goalCity    = @"上海";
    }
    return self;
}

- (void)clearDefaults
{
    [self setPassWord:nil];
    [self setUserName:nil];
    [self setMobile:nil];
    [self setEmail:nil];
    [self setSex:nil];
    [self setGetUserInfo:NO];
    
    [self setAuthTkn:nil];
    [self setLoginInfo:Nil];
}

- (void)setAutoLogin:(BOOL)_autoLogin
{
    if (self.autoLogin != _autoLogin) {
        [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:_autoLogin] forKey:@"autoLogin"];
        autoLogin = _autoLogin;
    }
}

- (NSString *)getPriceRange
{
    //1:不限  2:0~150  3:151~300  4:301~450  5:451~600  6:600以上
    NSString *range = nil;
    switch (priceRange) {
        case 1:
            range = @"不限";
            break;
        case 2:
            range = @"0~150";
            break;
        case 3:
            range = @"151~300";
            break;
        case 4:
            range = @"301~450";
            break;
        case 5:
            range = @"451~600";
            break;
        case 6:
            range = @"600以上";
            break;
        default:
            range = @"不限";
            break;
    }
    return range;
}

- (NSString *)getPostType
{
    //0:不需要行程单 1:平邮 6.0元 2:快递 10.0元 3:EMS 10.0元 4:快递到付 10.0元
    NSString *getPostType = nil;
    switch (priceRange) {
        case 0:
            getPostType = @"不需要行程单";
            break;
        case 1:
            getPostType = @"平邮 6.0元";
            break;
        case 2:
            getPostType = @"快递 10.0元";
            break;
        case 3:
            getPostType = @"EMS 10.0元";
            break;
        case 4:
            getPostType = @"快递到付 10.0元";
            break;
        
        default:
            getPostType = @"不需要行程单";
            break;
    }
    return getPostType;
}

- (BOOL)autoLogin
{
    return [[[NSUserDefaults standardUserDefaults] objectForKey:@"autoLogin"] boolValue];
}

- (void)setReserveObject:(NSInteger)_reserveObject
{
    if (self.reserveObject != _reserveObject) {
        [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInteger:_reserveObject] forKey:@"reserveObject"];
        reserveObject = _reserveObject;
    }
}

- (NSInteger)reserveObject
{
    if (!reserveObject) {
        reserveObject = [[[NSUserDefaults standardUserDefaults] objectForKey:@"reserveObject"] integerValue];
    }
    return reserveObject;
}

- (void)setTripGoal:(NSInteger)_tripGoal
{
    if (self.tripGoal != _tripGoal) {
        [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInteger:_tripGoal] forKey:@"tripGoal"];
        tripGoal = _tripGoal;
    }
}

- (NSInteger)tripGoal
{
    if (!tripGoal) {
        tripGoal = [[[NSUserDefaults standardUserDefaults] objectForKey:@"tripGoal"] integerValue];
    }
    return tripGoal;
}

- (void)setStartCity:(NSString *)_startCity
{
    if (self.startCity != _startCity) {
        [[NSUserDefaults standardUserDefaults] setObject:_startCity forKey:@"startCity"];
        startCity = _startCity;
    }
}

- (NSString *)startCity
{
    if (!startCity) {
        startCity = [[NSUserDefaults standardUserDefaults] objectForKey:@"startCity"];
    }
    return startCity;
}

- (void)setGoalCity:(NSString *)_goalCity
{
    if (self.goalCity != _goalCity) {
        [[NSUserDefaults standardUserDefaults] setObject:_goalCity forKey:@"goalCity"];
        goalCity = _goalCity;
    }
}

- (NSString *)goalCity
{
    if (!goalCity) {
        goalCity = [[NSUserDefaults standardUserDefaults] objectForKey:@"goalCity"];
    }
    return goalCity;
}


- (void)setPriceRange:(NSInteger)_priceRange
{
    if (self.priceRange != _priceRange) {
        [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInteger:_priceRange] forKey:@"priceRange"];
        priceRange = _priceRange;
    }
}

- (NSInteger)priceRange
{
    if (!priceRange) {
        priceRange = [[[NSUserDefaults standardUserDefaults] objectForKey:@"priceRange"] integerValue];
    }
    return priceRange;
}

- (void)setPostType:(NSInteger)_postType
{
    if (self.postType != _postType) {
        [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInteger:_postType] forKey:@"postType"];
        postType = _postType;
    }
}

- (NSInteger)postType
{
    if (!postType) {
        postType = [[[NSUserDefaults standardUserDefaults] objectForKey:@"postType"] integerValue];
    }
    return postType;
}

- (void)setPostAddress:(NSString *)_postAddress
{
    if (self.postAddress != _postAddress) {
        [[NSUserDefaults standardUserDefaults] setObject:_postAddress forKey:@"postAddress"];
        postAddress = _postAddress;
    }
}

- (NSString *)postAddress
{
    if (!postAddress) {
        postAddress = [[NSUserDefaults standardUserDefaults] objectForKey:@"postAddress"];
    }
    return postAddress;
}

- (void)setLaunchPage:(NSInteger)_launchPage
{
    if (self.launchPage != _launchPage) {
        [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInteger:_launchPage] forKey:@"launchPage"];
        launchPage = _launchPage;
    }
}

- (NSInteger)launchPage
{
    if (!launchPage) {
        launchPage = [[[NSUserDefaults standardUserDefaults] objectForKey:@"launchPage"] integerValue];
    }
    return launchPage;
}

- (void)setAllowShake:(BOOL)_allowShake
{
    if (self.allowShake != _allowShake) {
        [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:_allowShake] forKey:@"allowShake"];
        allowShake = _allowShake;
    }
}

- (BOOL)allowShake
{
    if (!allowShake) {
        allowShake = [[[NSUserDefaults standardUserDefaults] objectForKey:@"allowShake"] boolValue];
    }
    return allowShake;
}

- (void)setSearchRadiu:(CGFloat)_searchRadiu
{
    if (self.searchRadiu != _searchRadiu) {
        [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithFloat:_searchRadiu] forKey:@"searchRadiu"];
        searchRadiu = _searchRadiu;
    }
}

- (CGFloat)searchRadiu
{
    if (!searchRadiu) {
        searchRadiu = [[[NSUserDefaults standardUserDefaults] objectForKey:@"searchRadiu"] floatValue];
    }
    return searchRadiu;
}

- (void)setAuthTkn:(NSString *)_authTkn
{
    if (self.authTkn != _authTkn) {
        [[NSUserDefaults standardUserDefaults] setObject:_authTkn forKey:@"authTkn"];
        authTkn = _authTkn;
    }
}

- (NSString *)authTkn
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"authTkn"];
}

@end









