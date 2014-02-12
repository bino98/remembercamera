//
//  MenuViewController.m
//  MemoryCamera2
//
//  Created by Takafumi Yamamoto on 2013/11/12.
//  Copyright (c) 2013年 Takafumi Yamamoto. All rights reserved.
//

#import "MenuViewController.h"

@interface MenuViewController ()

@end

@implementation MenuViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)cameraButtonAction:(id)sender {
    CameraViewController *cameraViewController = [[CameraViewController alloc] init];
    [self.navigationController pushViewController:cameraViewController animated:YES];
}

- (IBAction)viewSavedPictureButtonAction:(id)sender {
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary] == YES) {
        imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        imagePickerController.delegate = self;
        imagePickerController.allowsEditing = NO;
        [self presentViewController:imagePickerController animated:YES completion:nil];
    } 
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [self dismissViewControllerAnimated:YES completion:nil];
    InsertInfoViewController *insertInfoViewController = [[InsertInfoViewController alloc] init];
//    insertInfoViewController.tookPic = [self resizeTookImage:[info objectForKey:UIImagePickerControllerOriginalImage]];
    insertInfoViewController.tookPic = [info objectForKey:UIImagePickerControllerOriginalImage];
    [self.navigationController pushViewController:insertInfoViewController animated:YES];
}

- (UIImage *)resizeTookImage:(UIImage *)beforeImage{
    UIImage *afterImage;
    CGRect rect = CGRectMake(0, 60, beforeImage.size.width, beforeImage.size.height - 340);  // 切り取る場所とサイズを指定
    
    CGImageRef srcImageRef = [beforeImage CGImage];
    CGImageRef trimmedImageRef = CGImageCreateWithImageInRect(srcImageRef, rect);
    afterImage = [UIImage imageWithCGImage:trimmedImageRef];
    
    return afterImage;
}

@end
