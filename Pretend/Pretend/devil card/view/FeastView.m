//
//  FeastView.m
//  Pretend
//
//  Created by 戴曦嘉 on 2017/10/31.
//  Copyright © 2017年 戴曦嘉. All rights reserved.
//

#import "FeastView.h"
#import "UIImage+Rotate.h"
#import <Masonry.h>

@interface FeastView ()

@property (nonatomic,strong) UIImage *feastImage;

@end

@implementation FeastView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.feastImage = [UIImage imageNamed:@"feast.png"];
        //旋转图片,创建了一个类别
        //UIImage* image = [feastImage rotate:UIImageOrientationLeft];
        self.contentMode = UIViewContentModeScaleAspectFill;
        self.image = self.feastImage;
        //[self setupActions];
    }
    return self;
}

- (void)setupActions {
    //添加yuri craft
    self.yuiBtn = [UIButton buttonWithType:UIButtonTypeSystem];
//    self.yuiBtn.frame = CGRectMake(0, self.bounds.size.height * 0.85, self.bounds.size.width * 0.2, self.bounds.size.height * 0.1);
    self.yuiBtn.backgroundColor = [UIColor clearColor];
    //[yuiBtn setTitle:@"yui" forState:UIControlStateNormal];
    [self addSubview:self.yuiBtn];
    [self.yuiBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self);
        make.left.equalTo(self).offset(10.0);
        make.bottom.equalTo(self.mas_centerY);
        make.width.equalTo(@30);
    }];
    
    //添加kirito
    self.kiritoBtn = [UIButton buttonWithType:UIButtonTypeSystem];
//    self.kiritoBtn.frame = CGRectMake(self.bounds.size.width * 0.1, self.bounds.size.height * 0.7, self.bounds.size.width * 0.8, self.bounds.size.height * 0.1);
    self.kiritoBtn.backgroundColor = [UIColor clearColor];
    //[kiritoBtn setTitle:@"kirito" forState:UIControlStateNormal];
    [self addSubview:self.kiritoBtn];
    [self.kiritoBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self);
        make.right.equalTo(self.mas_centerX);
        make.width.equalTo(@40.0);
    }];
    //添加asuna
    self.asunaBtn = [UIButton buttonWithType:UIButtonTypeSystem];
//    self.asunaBtn.frame = CGRectMake(self.bounds.size.width * 0.2, self.bounds.size.height * 0.8, self.bounds.size.width * 0.7, self.bounds.size.height * 0.1);
    self.asunaBtn.backgroundColor = [UIColor clearColor];
    //[asunaBtn setTitle:@"asuna" forState:UIControlStateNormal];
    [self addSubview:self.asunaBtn];
    [self.asunaBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self);
        make.left.equalTo(self.yuiBtn.mas_right);
        make.right.equalTo(self.kiritoBtn.mas_left);
    }];

    //添加silica
    self.silicaBtn = [UIButton buttonWithType:UIButtonTypeSystem];
//    self.silicaBtn.frame = CGRectMake(self.bounds.size.width * 0.65, self.bounds.size.height * 0.45, self.bounds.size.width  * 0.25, self.bounds.size.height *0.05);
    self.silicaBtn.backgroundColor = [UIColor clearColor];
    //[silicaBtn setTitle:@"silica" forState:UIControlStateNormal];
    [self addSubview:self.silicaBtn];
    [self.silicaBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_centerY);
        make.left.equalTo(self.mas_centerX);
        make.width.equalTo(@30.0);
        make.bottom.equalTo(self);
    }];
    //添加leafa
    self.leafaBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    //    self.leafaBtn.frame = CGRectMake(self.bounds.size.width * 0.6, self.bounds.size.height * 0.38, self.bounds.size.width  * 0.3, self.bounds.size.height * 0.05);
    self.leafaBtn.backgroundColor = [UIColor clearColor];
    //[leafaBtn setTitle:@"leafa" forState:UIControlStateNormal];
    [self addSubview:self.leafaBtn];
    [self.leafaBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_centerY);
        make.left.equalTo(self.silicaBtn.mas_right);
        make.width.equalTo(@30.0);
        make.bottom.equalTo(self);
    }];
    //添加agil
    self.agilBtn = [UIButton buttonWithType:UIButtonTypeSystem];
//    self.agilBtn.frame = CGRectMake(self.bounds.size.width * 0.5, self.bounds.size.height * 0.6, self.bounds.size.width  * 0.4, self.bounds.size.height * 0.05);
    self.agilBtn.backgroundColor = [UIColor clearColor];
    //[agilBtn setTitle:@"agil" forState:UIControlStateNormal];
    [self addSubview:self.agilBtn];
    [self.agilBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.kiritoBtn.mas_right);
        make.right.equalTo(self.mas_centerX);
        make.bottom.equalTo(self);
        make.top.equalTo(self.mas_centerY);
    }];
    //添加klein
    self.kleinBtn = [UIButton buttonWithType:UIButtonTypeSystem];
//    self.kleinBtn.frame = CGRectMake(self.bounds.size.width * 0.3, self.bounds.size.height  * 0.1, self.bounds.size.width  * 0.6, self.bounds.size.height * 0.1);
    self.kleinBtn.backgroundColor = [UIColor clearColor];
    //[kleinBtn setTitle:@"klein" forState:UIControlStateNormal];
    [self addSubview:self.kleinBtn];
    [self.kleinBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(10.0);
        make.top.equalTo(self.mas_centerY);
        make.bottom.equalTo(self);
        make.width.equalTo(@40.0);
    }];
    //添加lisbeth
    self.lisbethBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    self.lisbethBtn.frame = CGRectMake(self.bounds.size.width * 0.3, self.bounds.size.height  * 0.25, self.bounds.size.width  * 0.6, self.bounds.size.height * 0.1);
    self.lisbethBtn.backgroundColor = [UIColor clearColor];
    //[lisbethBtn setTitle:@"lisbeth" forState:UIControlStateNormal];
    [self addSubview:self.lisbethBtn];
    [self.lisbethBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.leafaBtn.mas_right).offset(30.0);
        make.right.equalTo(self.kleinBtn.mas_left).offset(10.0);
        make.top.equalTo(self.mas_centerY);
        make.bottom.equalTo(self);
    }];
}



@end
