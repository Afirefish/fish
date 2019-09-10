//
//  PRQRCodeScannerViewController.m
//  Pretend
//
//  Created by xijia dai on 2019/4/23.
//  Copyright © 2019 戴曦嘉. All rights reserved.
//

#import "PRQRCodeScannerViewController.h"
#import <SafariServices/SafariServices.h>
#import <CoreImage/CoreImage.h>

@interface PRQRCodeScannerViewController () <AVCaptureMetadataOutputObjectsDelegate>

@property (nonatomic) AVCaptureDevice *device;
@property (nonatomic) AVCaptureDeviceInput *input;
@property (nonatomic) AVCaptureMetadataOutput *output;
@property (nonatomic) AVCaptureSession *session;
@property (nonatomic) AVCaptureVideoPreviewLayer *preview;

@end

@implementation PRQRCodeScannerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self generateQRCode];
    
}

- (void)scan {
    NSError *error;
    self.device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    self.input = [AVCaptureDeviceInput deviceInputWithDevice:self.device error:&error];
    if (error) {
        NSLog(@"input error ouccer %@", error);
    }
    
    self.output = [AVCaptureMetadataOutput new];
    [self.output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    self.output.rectOfInterest = [self scanRectOfInterest];
    
    self.session = [AVCaptureSession new];
    [self.session setSessionPreset:[UIScreen mainScreen].bounds.size.height < 500 ? AVCaptureSessionPreset640x480:AVCaptureSessionPreset1920x1080];
    if ([self.session canAddInput:self.input]) {
        [self.session addInput:self.input];
    }
    if ([self.session canAddOutput:self.output]) {
        [self.session addOutput:self.output];
        self.output.metadataObjectTypes = @[AVMetadataObjectTypeQRCode];
    }
    
    self.preview = [AVCaptureVideoPreviewLayer layerWithSession:self.session];
    self.preview.videoGravity = AVLayerVideoGravityResizeAspectFill;
    self.preview.frame = [UIScreen mainScreen].bounds;
    [self startScan];
}

- (CGRect)scanRectOfInterest {
    CGSize scanSize = CGSizeMake([UIScreen mainScreen].bounds.size.height * 3/4, [UIScreen mainScreen].bounds.size.width * 3/4);
    CGRect scanRect = CGRectMake(([UIScreen mainScreen].bounds.size.width - scanSize.width)/2, ([UIScreen mainScreen].bounds.size.height - scanSize.height)/2, scanSize.width, scanSize.height);
    scanRect = CGRectMake(scanRect.origin.y/[UIScreen mainScreen].bounds.size.height, scanRect.origin.x/[UIScreen mainScreen].bounds.size.width, scanRect.size.height/[UIScreen mainScreen].bounds.size.height,scanRect.size.width/[UIScreen mainScreen].bounds.size.width);
    return scanRect;
}

- (void)startScan {
    [self.view.layer insertSublayer:self.preview atIndex:0];
    [self.session startRunning];
}

- (void)captureOutput:(AVCaptureOutput *)output didOutputMetadataObjects:(NSArray<__kindof AVMetadataObject *> *)metadataObjects fromConnection:(AVCaptureConnection *)connection {
    if (metadataObjects.count <= 0) {
        return;
    }
    [self.session stopRunning];
    NSString *result = [metadataObjects.firstObject stringValue];
    NSLog(@"result %@", result);
    NSURL *url = [NSURL URLWithString:result];
    if (url) {
        SFSafariViewController *safari = [[SFSafariViewController alloc] initWithURL:url];
        [self presentViewController:safari animated:YES completion:nil];
    }
}

- (void)scanImage:(UIImage *)image {
    if (!image) {
        return;
    }
    CIContext *context = [CIContext contextWithOptions:nil];
    CIDetector *detector = [CIDetector detectorOfType:CIDetectorTypeQRCode context:context options:@{CIDetectorAccuracy:CIDetectorAccuracyHigh}];
    CIImage *ciimage = [CIImage imageWithCGImage:image.CGImage];
    NSArray *features = [detector featuresInImage:ciimage];
    if (features.count) {
        return;
    }
    CIQRCodeFeature *feature = features.firstObject;
    NSLog(@"feature result %@", feature.messageString);
}

- (void)generateQRCode {
    CIFilter *filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    [filter setDefaults];
    NSString *value = @"monster will end, but you will continue";
    NSData *data = [value dataUsingEncoding:NSUTF8StringEncoding];
    [filter setValue:data forKey:@"inputMessage"];
    
    CIImage *outputImage = filter.outputImage;
    CGFloat scale = CGRectGetWidth([UIScreen mainScreen].bounds) / CGRectGetWidth(outputImage.extent);
    CGAffineTransform transform = CGAffineTransformMakeScale(scale, scale);
    CIImage *transformImage = [outputImage imageByApplyingTransform:transform];
    
    CIContext *context = [CIContext contextWithOptions:nil];
    CGImageRef imageRef = [context createCGImage:transformImage fromRect:transformImage.extent];
    UIImage *qrcodeImage = [UIImage imageWithCGImage:imageRef];
    
    UIImageView *imageView = [UIImageView new];
    [self.view addSubview:imageView];
    imageView.frame = CGRectMake(20, 50, 280, 280);
    imageView.image = qrcodeImage;
}

@end
