//
//  ImagePickerViewController.h
//  QChat
//
//  Created by Jack Wang on 8/9/13.
//  Copyright (c) 2013 Omniquest. All rights reserved.
//

@protocol ImagePickerViewControllerDelegate;

@interface ImagePickerViewController : UIViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate>
{
    BOOL allowsEditing;
}

@property (nonatomic, assign) id<ImagePickerViewControllerDelegate> delegate;
@property (nonatomic) BOOL allowsEditing;

- (IBAction)photosBtnTapped:(id)sender;
- (IBAction)cameraBtnTapped:(id)sender;
- (IBAction)closeBtnTapped:(id)sender;

@end

@protocol ImagePickerViewControllerDelegate<NSObject>

- (void)didFinishPickImage:(UIImage *)image;
- (void)didCancel;

@end