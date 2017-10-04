//
//  ChiziChatDetail.m
//  Pretend
//
//  Created by 戴曦嘉 on 2017/9/30.
//  Copyright © 2017年 戴曦嘉. All rights reserved.
//

#import "ChiziChatDetail.h"

@interface ChiziChatDetail ()
@property (readwrite,assign,nonatomic) NSUInteger chiziFinished;//100代表结束

@end

@implementation ChiziChatDetail

+ (instancetype)chiziChatDetail {
    static ChiziChatDetail *chiziChatDetail = nil;
    if ((chiziChatDetail = [super chatDetail]) == nil) {
        chiziChatDetail = [[ChiziChatDetail alloc] init];
    }
    return chiziChatDetail;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//pufu恶魔通过
- (void)setChiziFinished:(NSUInteger)chiziFinished {
    self.chiziFinished = 100;
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
