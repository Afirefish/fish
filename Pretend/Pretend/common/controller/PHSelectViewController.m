//
//  PHSelectViewController.m
//  Pretend
//
//  Created by daixijia on 2018/2/1.
//  Copyright © 2018年 戴曦嘉. All rights reserved.
//

#import "PHSelectViewController.h"
#import <Photos/Photos.h>

@interface PHSelectViewController ()<UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (nonatomic,strong) NSString *filePath;
@property (nonatomic,strong) UIButton *addPicBtn;
@property (nonatomic,strong) UIImagePickerController *pickVC;

@end

@implementation PHSelectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.addPicBtn = [[UIButton alloc] initWithFrame:CGRectMake(150, 240, 60, 60)];
    [self.addPicBtn setTitle:@"addPic" forState:UIControlStateNormal];
    [self.addPicBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.addPicBtn addTarget:self action:@selector(uploadPic) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.addPicBtn];
}

- (void)uploadPic {
    //创建UIImagePickerController
    self.pickVC = [[UIImagePickerController alloc] init];
    //设置图片源类型
    self.pickVC.sourceType = UIImagePickerControllerSourceTypePhotoLibrary; //取出所有图片资源的相簿
    //设置代理
    self.pickVC.delegate = self;
    [self presentViewController:self.pickVC animated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController*)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    NSString *type = [info objectForKey:UIImagePickerControllerMediaType];
    if ([type isEqualToString:@"public.image"]) {
        if (@available(iOS 11.0, *)) {
            PHAsset *asset = [info objectForKey:UIImagePickerControllerPHAsset];
            // 判断是否是heif或者heic格式
            __block BOOL isHEIF = NO;
            NSArray *resourceList = [PHAssetResource assetResourcesForAsset:asset];
            [resourceList enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                PHAssetResource *resource = obj;
                NSString *UTI = resource.uniformTypeIdentifier;
                if ([UTI isEqualToString:@"public.heif"] || [UTI isEqualToString:@"public.heic"]) {
                    isHEIF = YES;
                    *stop = YES;
                }
            }];
            
            // 转换图片格式
            [[PHImageManager defaultManager] requestImageDataForAsset:asset options:nil resultHandler:^(NSData * _Nullable imageData, NSString * _Nullable dataUTI, UIImageOrientation orientation, NSDictionary * _Nullable info) {
                if (isHEIF) {
                    CIImage *ciImage = [CIImage imageWithData:imageData];
                    CIContext *context = [CIContext context];
                    NSData *jpgData = [context JPEGRepresentationOfImage:ciImage colorSpace:ciImage.colorSpace options:@{}];
                    //图片保存的路径
                    NSString * DocumentsPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
                    NSFileManager *fileManager = [NSFileManager defaultManager];
                    [fileManager createDirectoryAtPath:DocumentsPath withIntermediateDirectories:YES attributes:nil error:nil];
                    [fileManager createFileAtPath:[DocumentsPath stringByAppendingString:@"/2.jpg"] contents:jpgData attributes:nil];
                    NSString *filePath = [[NSString alloc]initWithFormat:@"%@%@",DocumentsPath,  @"/2.jpg"];
                    NSLog(@"图片的完整路径是：%@", filePath);
                }
            }];
        }
    }
//    NSData *data = UIImagePNGRepresentation(image);;
    [self.pickVC dismissViewControllerAnimated:YES completion:nil];
}

@end
