//
//  MenuViewController.h
//  MemoryCamera2
//
//  Created by Takafumi Yamamoto on 2013/11/12.
//  Copyright (c) 2013年 Takafumi Yamamoto. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CameraViewController.h"

@interface MenuViewController : UIViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate>

- (IBAction)cameraButtonAction:(id)sender;
- (IBAction)viewSavedPictureButtonAction:(id)sender;
@end
