//
//  TizaChatDetail.m
//  Pretend
//
//  Created by 戴曦嘉 on 2017/9/30.
//  Copyright © 2017年 戴曦嘉. All rights reserved.
//

#import "TizaChatDetail.h"

@interface TizaChatDetail ()
@property (readwrite,assign,nonatomic) NSUInteger tizaFinished;//100代表结束

@end

@implementation TizaChatDetail

+ (instancetype)tizaChatDetail {
    static TizaChatDetail *tizaChatDetail = nil;
    if ((tizaChatDetail = [super chatDetail]) == nil) {
        tizaChatDetail = [[TizaChatDetail alloc] init];
    }
    return tizaChatDetail;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//tiza恶魔通过
- (void)setTizaFinished:(NSUInteger)tizaFinished {
    self.tizaFinished = 100;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
