//
//  PufuChatDetail.m
//  Pretend
//
//  Created by 戴曦嘉 on 2017/9/30.
//  Copyright © 2017年 戴曦嘉. All rights reserved.
//

#import "PufuChatDetail.h"

@interface PufuChatDetail ()
@property (readwrite,assign,nonatomic) NSUInteger pufuFinished;//100代表结束

@end

@implementation PufuChatDetail

+ (instancetype)pufuChatDetail {
    static PufuChatDetail *pufuChatDetail = nil;
    if ((pufuChatDetail = [super chatDetail]) == nil) {
        pufuChatDetail = [[PufuChatDetail alloc] init];
    }
    return pufuChatDetail;
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
- (void)setPufuFinished:(NSUInteger)pufuFinished {
    self.pufuFinished = 100;
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
