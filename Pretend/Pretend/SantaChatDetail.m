//
//  SantaChatDetail.m
//  Pretend
//
//  Created by 戴曦嘉 on 2017/9/29.
//  Copyright © 2017年 戴曦嘉. All rights reserved.
//

#import "SantaChatDetail.h"

@interface SantaChatDetail ()
@property (readwrite,assign,nonatomic) NSUInteger santaFinished;//100代表结束

@end

@implementation SantaChatDetail

+ (instancetype)santaChatDetail {
    static SantaChatDetail *santaChatDetail = nil;
    if ((santaChatDetail = [super chatDetail]) == nil) {
        santaChatDetail = [[SantaChatDetail alloc] init];
    }
    return santaChatDetail;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//santa恶魔通过
- (void)setSantaFinished:(NSUInteger)santaFinished {
    self.santaFinished = 100;
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
