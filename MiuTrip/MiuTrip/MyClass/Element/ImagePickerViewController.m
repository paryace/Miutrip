//
//  ImagePickerViewController.m
//  QChat
//
//  Created by Jack Wang on 8/9/13.
//  Copyright (c) 2013 Omniquest. All rights reserved.
//

#import "ImagePickerViewController.h"

@implementation ImagePickerViewController

@synthesize delegate;
@synthesize allowsEditing;

- (id)init
{
    if (self = [super init]) 
    {
        [self setSubviewFrame];
        allowsEditing = NO;
    }
    return self;
}

- (void)setSubviewFrame
{
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    [imageView setBackgroundColor:color(blackColor)];
    [imageView setAlpha:0.7];
    [self.view addSubview:imageView];

    
    UIView *subView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 200, 85)];
    [subView setBackgroundColor:color(whiteColor)];
    [subView setCenter:self.view.center];
    [self.view addSubview:subView];
    
    UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [closeBtn setBackgroundColor:color(clearColor)];
    [closeBtn setFrame:CGRectMake(controlXLength(subView), subView.frame.origin.y - 30, 20, 20)];
    [closeBtn setImage:imageNameAndType(@"close-icon", nil) forState:UIControlStateNormal];
    [closeBtn addTarget:self action:@selector(closeBtnTapped:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:closeBtn];
    
    UIButton *photoButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [photoButton setFrame:CGRectMake(10, 10, (subView.frame.size.width - 30)/2, subView.frame.size.height - 20 - 25)];
    [photoButton setImage:imageNameAndType(@"photo-icon", nil) forState:UIControlStateNormal];
    [photoButton setBackgroundColor:color(clearColor)];
    [photoButton addTarget:self action:@selector(photosBtnTapped:) forControlEvents:UIControlEventTouchUpInside];
    [subView addSubview:photoButton];
    
    UILabel *photoLabel = [[UILabel alloc]initWithFrame:CGRectMake(photoButton.frame.origin.x, controlYLength(photoButton), photoButton.frame.size.width, 25)];
    [photoLabel setBackgroundColor:color(clearColor)];
    [photoLabel setFont:[UIFont fontWithName:@"Helvetica" size:17]];
    [photoLabel setTextColor:color(lightGrayColor)];
    [photoLabel setTextAlignment:NSTextAlignmentCenter];
    [photoLabel setText:@"photo"];
    [subView addSubview:photoLabel];
    
    UIButton *cameraButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [cameraButton setFrame:CGRectMake(controlXLength(photoButton) + 10, 10, photoButton.frame.size.width, photoButton.frame.size.height)];
    [cameraButton setImage:imageNameAndType(@"camera-icon", nil) forState:UIControlStateNormal];
    [cameraButton setBackgroundColor:color(clearColor)];
    [cameraButton addTarget:self action:@selector(cameraBtnTapped:) forControlEvents:UIControlEventTouchUpInside];
    [subView addSubview:cameraButton];
    
    UILabel *cameraLabel = [[UILabel alloc]initWithFrame:CGRectMake(cameraButton.frame.origin.x, photoLabel.frame.origin.y, photoLabel.frame.size.width, photoLabel.frame.size.height)];
    [cameraLabel setBackgroundColor:color(clearColor)];
    [cameraLabel setFont:[UIFont fontWithName:@"Helvetica" size:17]];
    [cameraLabel setTextColor:color(lightGrayColor)];
    [cameraLabel setTextAlignment:NSTextAlignmentCenter];
    [cameraLabel setText:@"photo"];
    [subView addSubview:cameraLabel];
    
    UIImageView *line = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 1, subView.frame.size.height - 20)];
    [line setCenter:subView.center];
    [subView addSubview:line];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor clearColor];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (IBAction)photosBtnTapped:(id)sender {
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.allowsEditing = YES;
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [self presentViewController:picker animated:YES completion:nil];
    }
}

- (IBAction)cameraBtnTapped:(id)sender {
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.allowsEditing = YES;
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        [self presentViewController:picker animated:YES completion:nil];
    }
}

- (IBAction)closeBtnTapped:(id)sender {
    [delegate didCancel];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesEnded:touches withEvent:event];
    [self.delegate didCancel];
}

#pragma mark -- UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo
{
    [self dismissViewControllerAnimated:YES completion:^(void){
        [delegate didFinishPickImage:image];
    }];
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:^(void){
        [delegate didCancel];
    }];
}

@end
