//
//  TestViewController.h
//  MiuTrip
//
//  Created by MB Pro on 2/20/14.
//  Copyright (c) 2014 michael. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UPPayPluginDelegate.h"
#import "UPPayPlugin.h"

@interface TestViewController : UIViewController<UPPayPluginDelegate>{
    UIAlertView* mAlert;
    NSMutableData* mData;
}

- (void)showAlertWait;
- (void)showAlertMessage:(NSString*)msg;
- (void)hideAlert;

- (NSString*)currentUID;

@end
