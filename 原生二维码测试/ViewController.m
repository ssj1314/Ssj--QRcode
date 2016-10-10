//
//  ViewController.m
//  原生二维码测试
//
//  Created by ssj on 16/9/29.
//  Copyright © 2016年 jiteng. All rights reserved.
//

#import "ViewController.h"
#import "CreateBarcodeAndQrcode.h"
#import <AVFoundation/AVFoundation.h>
@interface ViewController ()<AVCaptureMetadataOutputObjectsDelegate>
@property (strong, nonatomic) IBOutlet UIView *videoPreviewLayer;
@property (strong, nonatomic) UIView *boxView;
@property (nonatomic) BOOL isReading;
@property (strong, nonatomic) CALayer *scanLayer;
@property (nonatomic, weak) AVCaptureSession *session;
@property (nonatomic, strong) AVCaptureSession *captureSession;//捕捉会话
@property (strong, nonatomic) IBOutlet UIImageView *erWEima;
@property (strong, nonatomic) IBOutlet UIImageView *Image222;
@property (strong, nonatomic) IBOutlet UITextField *INput;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
;
    
    
}
- (BOOL)startReading {
    NSError *error;
    //1.初始化捕捉设备（AVCaptureDevice），类型为AVMediaTypeVideo
    AVCaptureDevice *captureDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    //2.用captureDevice创建输入流
    AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:captureDevice error:&error];
    if (!input) {
        NSLog(@"%@", [error localizedDescription]);
        return NO;
    }
    //3.创建媒体数据输出流
    AVCaptureMetadataOutput *captureMetadataOutput = [[AVCaptureMetadataOutput alloc] init];
    //4.实例化捕捉会话
    _captureSession = [[AVCaptureSession alloc] init];
    //4.1.将输入流添加到会话
    [_captureSession addInput:input];
    //4.2.将媒体输出流添加到会话中
    [_captureSession addOutput:captureMetadataOutput];
    //5.创建串行队列，并加媒体输出流添加到队列当中
    dispatch_queue_t dispatchQueue;
    dispatchQueue = dispatch_queue_create("myQueue", NULL);
    //5.1.设置代理
    [captureMetadataOutput setMetadataObjectsDelegate:self queue:dispatchQueue];
    //5.2.设置输出媒体数据类型为QRCode
    [captureMetadataOutput setMetadataObjectTypes:[NSArray arrayWithObject:AVMetadataObjectTypeQRCode]];
    //6.实例化预览图层
    
    //10.2.扫描线
    _scanLayer = [[CALayer alloc] init];
    _scanLayer.frame = CGRectMake(0, 0, _boxView.bounds.size.width, 1);
    _scanLayer.backgroundColor = [UIColor brownColor].CGColor;
    [_boxView.layer addSublayer:_scanLayer];
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:0.2f target:self selector:@selector(moveScanLayer:) userInfo:nil repeats:YES];
    [timer fire];
    
    //10.开始扫描
    [_captureSession startRunning];
    return YES;
}
#pragma mark - AVCaptureMetadataOutputObjectsDelegate
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection
{
    //判断是否有数据
    if (metadataObjects != nil && [metadataObjects count] > 0) {
        AVMetadataMachineReadableCodeObject *metadataObj = [metadataObjects objectAtIndex:0];
        //判断回传的数据类型
//        if ([[metadataObj type] isEqualToString:AVMetadataObjectTypeQRCode]) {
//            [_lblStatus performSelectorOnMainThread:@selector(setText:) withObject:[metadataObj stringValue] waitUntilDone:NO];
//            [self performSelectorOnMainThread:@selector(stopReading) withObject:nil waitUntilDone:NO];
//            _isReading = NO;
//        }
    }
}
- (void)moveScanLayer:(NSTimer *)timer
{
    CGRect frame = _scanLayer.frame;
    if (_boxView.frame.size.height < _scanLayer.frame.origin.y) {
        frame.origin.y = 0;
        _scanLayer.frame = frame;
    }else{
        frame.origin.y += 5;
        [UIView animateWithDuration:0.1 animations:^{
            _scanLayer.frame = frame;
        }];
    }
}
- (IBAction)CreatImage:(UIButton *)sender {
    _Image222.image = [CreateBarcodeAndQrcode generateQRCode:self.INput.text size:_Image222.frame.size color:[UIColor whiteColor] backGroundColor:[UIColor blackColor]];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
