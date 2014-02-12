//
//  InsertInfoViewController.h
//  MemoryCamera2
//
//  Created by Takafumi Yamamoto on 2013/11/12.
//  Copyright (c) 2013年 Takafumi Yamamoto. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InsertInfoViewController : UIViewController <UIAlertViewDelegate>

@property (nonatomic, strong) UIImage *tookPic;
@property (nonatomic, strong) UIAlertView *commentAlert;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@property (weak, nonatomic) IBOutlet UIButton *heartButton;
@property (weak, nonatomic) IBOutlet UIButton *objectButton;
@property (weak, nonatomic) IBOutlet UIButton *cultureButton;



- (IBAction)backButtonAction:(id)sender;
- (IBAction)nextButtonAction:(id)sender;
- (IBAction)categoryButtonAction:(id)sender;

@end
