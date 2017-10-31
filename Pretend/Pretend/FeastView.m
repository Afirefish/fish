//
//  FeastView.m
//  Pretend
//
//  Created by 戴曦嘉 on 2017/10/31.
//  Copyright © 2017年 戴曦嘉. All rights reserved.
//

#import "FeastView.h"
#import "UIImage+Rotate.h"

@implementation FeastView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        UIImage *feastImage = [UIImage imageNamed:@"feast.png"];
        //旋转图片,创建了一个类别
        UIImage* image = [feastImage rotate:UIImageOrientationLeft];
        self.image = image;
    }
    return self;
}


@end
