//
//  AppDelegate.m
//  MiuTrip
//
//  Created by SuperAdmin on 11/13/13.
//  Copyright (c) 2013 michael. All rights reserved.
//

#import "AppDelegate.h"
#import "RegisterAndLogViewController.h"
#import "HomeViewController.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    NSLog(@"autoLogin = %d",[UserDefaults shareUserDefault].autoLogin);
    if ([UserDefaults shareUserDefault].autoLogin) {
        if ([UserDefaults shareUserDefault].authTkn) {
            _viewController = [[HomeViewController alloc]init];
        }else{
            _viewController = [[RegisterAndLogViewController alloc]init];
            [Model shareModel].mainView = _viewController;
        }
    }else{
        [[UserDefaults shareUserDefault] clearDefaults];
        _viewController = [[RegisterAndLogViewController alloc]init];
        [Model shareModel].mainView = _viewController;
    }

    UINavigationController *navigationController = [[UINavigationController alloc]initWithRootViewController:_viewController];
    [navigationController setNavigationBarHidden:YES];
    self.window.rootViewController = navigationController;
    //[[UIApplication sharedApplication] setStatusBarHidden:YES];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    if (deviceVersion >= 7.0) {
        UIViewController *viewController = nil;
        if (self.window.rootViewController.presentedViewController) {
            viewController = self.window.rootViewController.presentedViewController;
        }else{
            viewController = self.window.rootViewController;
        }
        CGAffineTransform currentTransform = self.window.transform;
        CGAffineTransform newTransform = CGAffineTransformScale(currentTransform, 1, (viewController.view.frame.size.height - 20)/viewController.view.frame.size.height);
        [viewController.view.layer setAnchorPoint:CGPointMake(0.5f, 1.0f)];

        [viewController.view setFrame:CGRectMake(0, 0, viewController.view.frame.size.width, viewController.view.frame.size.height)];
        [viewController.view setTransform:newTransform];
    }
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
