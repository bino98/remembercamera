//
//  CameraViewController.m
//  MemoryCamera2
//
//  Created by Takafumi Yamamoto on 2013/11/12.
//  Copyright (c) 2013年 Takafumi Yamamoto. All rights reserved.
//

#import "CameraViewController.h"

@interface CameraViewController ()

@end

@implementation CameraViewController

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
    [self prepareCamera];
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

- (void)prepareCamera
{
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    //入力作成
    AVCaptureDeviceInput* deviceInput = [AVCaptureDeviceInput deviceInputWithDevice:device error:NULL];
    
    //ビデオデータ出力作成
    NSDictionary* settings = @{(id)kCVPixelBufferPixelFormatTypeKey:[NSNumber numberWithInt:kCVPixelFormatType_32BGRA]};
    AVCaptureVideoDataOutput* dataOutput = [[AVCaptureVideoDataOutput alloc] init];
    dataOutput.videoSettings = settings;
    [dataOutput setSampleBufferDelegate:self queue:dispatch_get_main_queue()];
    
    //セッション作成
    self.session = [[AVCaptureSession alloc] init];
    [self.session addInput:deviceInput];
    [self.session addOutput:dataOutput];
    self.session.sessionPreset = AVCaptureSessionPresetHigh;
    
    AVCaptureConnection *videoConnection = NULL;
    
    // カメラの向きなどを設定する
    [self.session beginConfiguration];
    
    for ( AVCaptureConnection *connection in [dataOutput connections] )
    {
        for ( AVCaptureInputPort *port in [connection inputPorts] )
        {
            if ( [[port mediaType] isEqual:AVMediaTypeVideo] )
            {
                videoConnection = connection;
                
            }
        }
    }
    if([videoConnection isVideoOrientationSupported]) // **Here it is, its always false**
    {
        [videoConnection setVideoOrientation:AVCaptureVideoOrientationPortrait];
    }
    
    [self.session commitConfiguration];
    // セッションをスタートする
    [self.session startRunning];
}

- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection *)connection
{
    // 画像の表示
    self.imageView.image = [self imageFromSampleBufferRef:sampleBuffer];
}

- (UIImage *)imageFromSampleBufferRef:(CMSampleBufferRef)sampleBuffer
{
    // イメージバッファの取得
    CVImageBufferRef    buffer;
    buffer = CMSampleBufferGetImageBuffer(sampleBuffer);
    
    // イメージバッファのロック
    CVPixelBufferLockBaseAddress(buffer, 0);
    // イメージバッファ情報の取得
    uint8_t*    base;
    size_t      width, height, bytesPerRow;
    base = CVPixelBufferGetBaseAddress(buffer);
    width = CVPixelBufferGetWidth(buffer);
    height = CVPixelBufferGetHeight(buffer);
    bytesPerRow = CVPixelBufferGetBytesPerRow(buffer);
    
    // ビットマップコンテキストの作成
    CGColorSpaceRef colorSpace;
    CGContextRef    cgContext;
    colorSpace = CGColorSpaceCreateDeviceRGB();
    cgContext = CGBitmapContextCreate(
                                      base, width, height, 8, bytesPerRow, colorSpace,
                                      kCGBitmapByteOrder32Little | kCGImageAlphaPremultipliedFirst);
    CGColorSpaceRelease(colorSpace);
    
    // 画像の作成
    CGImageRef  cgImage;
    UIImage*    image;
    cgImage = CGBitmapContextCreateImage(cgContext);
    image = [UIImage imageWithCGImage:cgImage scale:1.0f
                          orientation:UIImageOrientationUp];
    CGImageRelease(cgImage);
    CGContextRelease(cgContext);
    
    // イメージバッファのアンロック
    CVPixelBufferUnlockBaseAddress(buffer, 0);
    return image;
}

- (UIImage *)resizeTookImage:(UIImage *)beforeImage{
    UIImage *afterImage;
    CGRect rect = CGRectMake(0, 60, beforeImage.size.width, beforeImage.size.height - 340);  // 切り取る場所とサイズを指定
    
    CGImageRef srcImageRef = [beforeImage CGImage];
    CGImageRef trimmedImageRef = CGImageCreateWithImageInRect(srcImageRef, rect);
    afterImage = [UIImage imageWithCGImage:trimmedImageRef];
    
    return afterImage;
}

- (IBAction)takePickButtonAction:(id)sender {
    
    SystemSoundID mSound = 0;
    CFBundleRef mainBundle = CFBundleGetMainBundle();
    CFURLRef soundUrl = CFBundleCopyResourceURL(mainBundle, CFSTR("shutter"), CFSTR("mp3"), NULL );
    AudioServicesCreateSystemSoundID( soundUrl, &mSound );
    AudioServicesPlaySystemSound( mSound );
    
    InsertInfoViewController *insertInfoViewController = [[InsertInfoViewController alloc] init];
    insertInfoViewController.tookPic = [self resizeTookImage:self.imageView.image];
    
    [self.navigationController pushViewController:insertInfoViewController animated:YES];
}

- (IBAction)backButtonAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint touchedPoint = [touch locationInView:self.view];
    NSLog(@"x:%f y:%f", touchedPoint.x, touchedPoint.y);
    
    AVCaptureDevice* videoCaptureDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];

    CGSize viewSize = self.view.bounds.size;
    CGPoint pointOfInterest = CGPointMake(touchedPoint.y / viewSize.height,1.0 - touchedPoint.x / viewSize.width);
    if ([videoCaptureDevice isFocusPointOfInterestSupported] && [videoCaptureDevice isFocusModeSupported:AVCaptureFocusModeAutoFocus]) {
        NSError *error = nil;
        [videoCaptureDevice lockForConfiguration:&error];
        videoCaptureDevice.focusPointOfInterest = pointOfInterest;
        videoCaptureDevice.focusMode = AVCaptureFocusModeAutoFocus;
        [videoCaptureDevice unlockForConfiguration];
    }
}

@end
