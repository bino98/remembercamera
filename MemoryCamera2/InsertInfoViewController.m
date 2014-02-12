//
//  InsertInfoViewController.m
//  MemoryCamera2
//
//  Created by Takafumi Yamamoto on 2013/11/12.
//  Copyright (c) 2013年 Takafumi Yamamoto. All rights reserved.
//

#import "InsertInfoViewController.h"

@interface InsertInfoViewController ()

@end

@implementation InsertInfoViewController

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
    _imageView.image = _tookPic;
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)backButtonAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)categoryButtonAction:(id)sender {
    
    
    if ([sender tag] == 0) {
        // heart
        _heartButton.selected = (_heartButton.selected == YES)?NO:YES;
    } else if ([sender tag] == 1) {
        // object
        _objectButton.selected = (_objectButton.selected == YES)?NO:YES;
    } else if ([sender tag] == 2) {
        // culture
        _cultureButton.selected = (_cultureButton.selected == YES)?NO:YES;
    }
}

- (IBAction)nextButtonAction:(id)sender {
    //表示メッセージを空けたAlertを作成
    _commentAlert = [[UIAlertView alloc] initWithTitle:@"Your inspiration"
                                               message:@"Please comment for this picture."
                                              delegate:self
                                     cancelButtonTitle:@"Cancel"
                                     otherButtonTitles:@"OK", nil];
    
    [_commentAlert setAlertViewStyle:UIAlertViewStylePlainTextInput];
    [_commentAlert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    //OKボタンの処理（Cancelボタンの処理は標準でAlertを終了する処理が設定されている）
    if (_commentAlert == alertView) {
        if (buttonIndex == 1) {
            
            int tookPicWidth = self.imageView.image.size.width;
            int tookPicHeight = self.imageView.image.size.height;
            
            CGSize newSize = CGSizeMake(tookPicWidth, tookPicHeight + 400);
            UIGraphicsBeginImageContextWithOptions(newSize, NO, 1.0);
            [self.imageView.image drawInRect:CGRectMake(0, 200, tookPicWidth, tookPicHeight)];
            
            NSString *text = [[alertView textFieldAtIndex:0] text];
            CGRect rect = CGRectMake(100, tookPicHeight + 260, 200, 200);
            UIFont *font = [UIFont boldSystemFontOfSize:42];
            [text drawInRect:CGRectIntegral(rect) withFont:font];
            
            NSString *imageFileName = (_heartButton.selected == YES)?@"Huart_s.png":@"Huart.png";
            UIImage *categoryImage = [UIImage imageNamed:imageFileName];
            [categoryImage drawInRect:CGRectMake(300, 45, 150, 140)];
            
            imageFileName = (_objectButton.selected == YES)?@"Object_s.png":@"Object.png";
            categoryImage = [UIImage imageNamed:imageFileName];
            [categoryImage drawInRect:CGRectMake(470, 45, 150, 140)];
            
            imageFileName = (_cultureButton.selected == YES)?@"Culture_s.png":@"Culture.png";
            categoryImage = [UIImage imageNamed:imageFileName];
            [categoryImage drawInRect:CGRectMake(640, 45, 150, 140)];
            
            UIImage *willSaveImage = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();

            //カメラロールに画像を保存
            UIImageWriteToSavedPhotosAlbum(willSaveImage, self, @selector(didFinishSavingImage:didFinishSavingWithError:contextInfo:), nil);
        }
    }
    
}

//画像保存完了後。非同期で呼ばれる
- (void) didFinishSavingImage:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    
    //画像保存完了したよ、とアラートを出す
    //    _savedAlert = [[UIAlertView alloc] initWithTitle:nil
    //                                             message:@"Photo Saved."
    //                                            delegate:self
    //                                   cancelButtonTitle:@"OK"
    //                                   otherButtonTitles:nil];
    //    [_savedAlert show];
    
    [self.navigationController popToRootViewControllerAnimated:YES];
    
}

@end
