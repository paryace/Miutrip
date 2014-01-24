//
//  InCommonNameViewController.h
//  MiuTrip
//
//  Created by GX on 13-12-23.
//  Copyright (c) 2013年 michael. All rights reserved.
//

#define     CellHeight              40.0f
#define     TripCellUnfoldHeight        260.0f
#define     ContactCellUnfoleHeight 200.0f
#import "RequestManager.h"
#import "BaseUIViewController.h"
#import "SavePassengerListRequest.h"
#import "SearchPassengersResponse.h"
#import <Foundation/Foundation.h>
#import "GetContactRequest.h"
#import "ContactController.h"
#import "TrippersonController.h"
@class tripcellview;
@class CustomBtn;









@interface InCommonNameViewController : BaseUIViewController <UIAlertViewDelegate,UIActionSheetDelegate,UITableViewDataSource,UITableViewDelegate,BusinessDelegate,ContactDelegate,TripDelegate>
@property(strong, nonatomic) UITableView *showtableView;
@property(nonatomic,assign) NSObject *mydelegate;
@property (strong, nonatomic) UIView                *viewCommonTripPerson;
@property (strong, nonatomic) UIView                *viewContact;
 @property(nonatomic,assign) NSMutableArray *currentDataSource;
@property (nonatomic,assign) NSInteger r;
@property (strong, nonatomic) NSArray       *dataSource;
@property (strong, nonatomic) NSDictionary *dic;
@property (nonatomic,strong) id<BusinessDelegate> delegate;
-(void)compileButton:(UIButton*)sender;

@end

#define KEY_REQUEST_CLASS_NAME  @"request_class_name"
#define KEY_REQUEST_CACHEABLE @"request_cacheable"
#define KEY_REQUEST_CONDITION @"request_condition"

@interface  tripcellview: UITableViewCell

@property (strong, nonatomic) CustomBtn     *deleteButton;
@property (assign, nonatomic) BOOL          rightImageHighlighted;

@property (nonatomic,strong) NSDictionary *cellparam;

-(void)setSubview;
-(void)setotherSubview;
- (void)setContentWithParams:(NSDictionary*)params;
-(void)setContentWithParamss:(NSDictionary*)paramss;
- (id)initWithotherStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;
@end

