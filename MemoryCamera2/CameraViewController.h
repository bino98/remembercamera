//
//  CameraViewController.h
//  MemoryCamera2
//
//  Created by Takafumi Yamamoto on 2013/11/12.
//  Copyright (c) 2013年 Takafumi Yamamoto. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "InsertInfoViewController.h"
#import <AudioToolbox/AudioToolbox.h>

@interface CameraViewController : UIViewController <AVCaptureVideoDataOutputSampleBufferDelegate>

@property (nonatomic, strong) AVCaptureSession *session;
@property (nonatomic, strong) AVCaptureDevice *device;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

- (IBAction)takePickButtonAction:(id)sender;
- (IBAction)backButtonAction:(id)sender;

@end
