//
//  FMScanViewController.m
//  FlavaMusic
//
//  Created by R_flava_Man on 16/9/21.
//  Copyright © 2016年 R_style_Man. All rights reserved.
//

#import "FMScanViewController.h"
#import <AVFoundation/AVFoundation.h>

@interface FMScanViewController ()<AVCaptureMetadataOutputObjectsDelegate>

@property (nonatomic,strong)AVCaptureSession *session;

@end

@implementation FMScanViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    CGFloat kWidth = [UIScreen mainScreen].bounds.size.width;
    CGFloat kHeight = [UIScreen mainScreen].bounds.size.height;
    CGFloat QRcode_width = 320;
    
    NSString *mediaType =AVMediaTypeVideo;
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:mediaType];
    
    if(authStatus ==AVAuthorizationStatusRestricted ||
       authStatus == AVAuthorizationStatusDenied)
    {
        NSLog(@"相机权限受限");
        return;
    }
    else
    {
        // 获取摄像设备
        AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
        // 创建输入流
        AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:device error:nil];
        // 创建输出流
        AVCaptureMetadataOutput *outPut = [[AVCaptureMetadataOutput alloc] init];
        /**
         设置范围 ( 若不需要限制区域扫描，rectOfInterest不需要设置 ，此demo限制扫描区域宽高为150的中心区域 )
         注意：坑爹地方！！    此处坐标不是传统意义上的坐标，而为比例关系的坐标，数值在[0,1]区间
         坐标原点为右上角，x,y,width,height坐标互换，也就是说设置此处坐标时，应为( y , x , height , width)
         */
//        outPut.rectOfInterest = CGRectMake(((kHeight - QRcode_width) / 2) / kHeight,
//                                           ((kWidth - QRcode_width) / 2) / kWidth,
//                                           QRcode_width / kHeight,
//                                           QRcode_width / kWidth);
        // 设置代理 在主线程里刷新
        [outPut setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
        
        // 初始化链接对象
        self.session = [[AVCaptureSession alloc] init];
        // 质量采集率（此处设置为高质量采集率）
        [self.session setSessionPreset:AVCaptureSessionPresetHigh];
        [self.session addInput:input];
        [self.session addOutput:outPut];
        // 设置扫码支持的编码格式（设置条形码和二维码兼容）
        outPut.metadataObjectTypes = [outPut availableMetadataObjectTypes];
        
        AVCaptureVideoPreviewLayer *layer = [AVCaptureVideoPreviewLayer layerWithSession:self.session];
        layer.videoGravity =AVLayerVideoGravityResizeAspectFill;
        layer.frame = self.view.layer.bounds;
        [self.view.layer insertSublayer:layer atIndex:0];
        // 开始捕获
        [self.session startRunning];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [self.session startRunning];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [self.session stopRunning];
}

#pragma mark - AVCaptureMetadataOutputObjectsDelegate

- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection
{
    [self.session stopRunning];
    
    NSString *stringValue;
    if (metadataObjects.count >0)
    {
        AVMetadataMachineReadableCodeObject *metadataObject = [metadataObjects objectAtIndex:0];
        stringValue = metadataObject.stringValue;
        // 输出扫描字符串
        NSLog(@"metadataObject.stringValue = %@ %@",[metadataObject stringValue], metadataObject);
        
        /**
         根据 stringValue 设置你需要执行的事件
         */
        NSArray *corners = [metadataObject corners];
        NSLog(@"cor = %@", corners);
        
        CGPoint point0, point1, point2, point3;
        NSDictionary *dict0 = [corners firstObject];
        NSDictionary *dict1 = corners[1];
        NSDictionary *dict2 = corners[2];
        NSDictionary *dict3 = corners[3];
        BOOL ret = CGPointMakeWithDictionaryRepresentation((CFDictionaryRef)dict0, &point0);
        ret = CGPointMakeWithDictionaryRepresentation((CFDictionaryRef)dict1, &point1);
        ret = CGPointMakeWithDictionaryRepresentation((CFDictionaryRef)dict2, &point2);
        ret = CGPointMakeWithDictionaryRepresentation((CFDictionaryRef)dict3, &point3);
        CGFloat width = self.view.bounds.size.width;
        CGFloat height = self.view.bounds.size.height;
        CGRect frame = CGRectMake(point3.x * width, point3.y * height, (point1.x - point0.x)*width, (point0.y - point2.y) *width);
        
        UIView *colorView = [[UIView alloc] initWithFrame:CGRectMake(metadataObject.bounds.origin.x * width, metadataObject.bounds.origin.y * height, metadataObject.bounds.size.width * width, metadataObject.bounds.size.height * width)];
        colorView.backgroundColor = [[UIColor orangeColor] colorWithAlphaComponent:0.2];
        [self.view addSubview:colorView];
    }
    // 停止捕获
    
}
@end
