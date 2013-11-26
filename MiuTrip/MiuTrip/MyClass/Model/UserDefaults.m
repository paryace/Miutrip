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

static UserDefaults *shareUserDefault;

@implementation UserDefaults

@synthesize userName;
@synthesize passWord;
@synthesize userId;
@synthesize cookie;
@synthesize realName;
@synthesize mobile;
@synthesize email;
@synthesize sex;
@synthesize getUserInfo;

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
    [self setUserId:nil];
    [self setPassWord:nil];
    [self setUserName:nil];
    [self setCookie:nil];
    [self setRealName:nil];
    [self setMobile:nil];
    [self setEmail:nil];
    [self setSex:nil];
    [self setGetUserInfo:NO];
    
    [self setAuthTkn:nil];
}

- (void)setReserveObject:(NSInteger)_reserveObject
{
    if (reserveObject != _reserveObject) {
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
    if (tripGoal != _tripGoal) {
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
    if (startCity != _startCity) {
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
    if (goalCity != _goalCity) {
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
    if (priceRange != _priceRange) {
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
    if (postType != _postType) {
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
    if (postAddress != _postAddress) {
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
    if (launchPage != _launchPage) {
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
    if (allowShake != _allowShake) {
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
    if (searchRadiu != _searchRadiu) {
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
    if (authTkn != _authTkn) {
        [[NSUserDefaults standardUserDefaults] setObject:_authTkn forKey:@"authTkn"];
        authTkn = _authTkn;
    }
}

- (NSString *)authTkn
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"authTkn"];
}

@end









