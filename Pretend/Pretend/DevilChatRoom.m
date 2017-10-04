//
//  DevilChatRoom.m
//  Pretend
//
//  Created by 戴曦嘉 on 2017/9/29.
//  Copyright © 2017年 戴曦嘉. All rights reserved.
//

#import "DevilChatRoom.h"
#import "BaseChatDetail.h"
#import "SantaChatDetail.h"
#import "PufuChatDetail.h"
#import "ChiziChatDetail.h"
#import "TizaChatDetail.h"

@interface DevilChatRoom ()
@property (strong,nonatomic) NSArray *devilNames;
@property (strong,nonatomic) NSArray *devilImages;
@property (assign,nonatomic) NSUInteger santaFinished;
@property (assign,nonatomic) NSUInteger pufuFinished;
@property (assign,nonatomic) NSUInteger chiziFinished;
@property (assign,nonatomic) NSUInteger tizaFinished;

@end

@implementation DevilChatRoom

//设置恶魔名字，图片
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.hidesBackButton = YES;
    self.title = @"DevilChat";
    [self checkFinished];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

//单例
+ (instancetype)devilShowUp {
    static DevilChatRoom *devilChatCenter = nil;
    if (devilChatCenter == nil) {
        devilChatCenter = [[DevilChatRoom alloc] initWithFirstState];
    }
    return devilChatCenter;
}

- (instancetype)initWithFirstState {
    if (self = [super init]) {
        self.devilNames = @[@"santa",@"pufu",@"chizi",@"tiza"];
        self.devilImages = @[[UIImage imageNamed:@"santa.png"],
                             [UIImage imageNamed:@"pufu.png"],
                             [UIImage imageNamed:@"chizi.png"],
                             [UIImage imageNamed:@"tiza.png"]];
        self.santaFinished = 0;
        self.pufuFinished = 0;
        self.chiziFinished = 0;
        self.tizaFinished = 0;
    }
    return self;
}

//检查完成状态
- (void)checkFinished {
    if (self.santaFinished == 100 && self.pufuFinished == 100 && self.chiziFinished == 100 && self.tizaFinished == 100) {
        [self complete];
    }
}

//全部完成之后的处理 ,可以用个模态框来实现跳转
- (void)complete {
    
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *devilMaster = @"devilMaster";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:devilMaster];
    if(cell == nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:devilMaster];
    }
    cell.textLabel.text = self.devilNames[indexPath.row];
    cell.imageView.image = self.devilImages[indexPath.row];
    return cell;
}

#pragma mark Table view delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return self.view.bounds.size.height/8;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        SantaChatDetail *santaChatDetail = [SantaChatDetail santaChatDetail];
        [self.navigationController pushViewController:santaChatDetail animated:YES];
    } else if (indexPath.row == 1) {
        PufuChatDetail *pufuChatDetail = [PufuChatDetail pufuChatDetail];
        [self.navigationController pushViewController:pufuChatDetail animated:YES];
    } else if (indexPath.row == 2) {
        ChiziChatDetail *chiziChatDetail = [ChiziChatDetail chiziChatDetail];
        [self.navigationController pushViewController:chiziChatDetail animated:YES];
    } else {
        TizaChatDetail *tizaChatDetail = [TizaChatDetail tizaChatDetail];
        [self.navigationController pushViewController:tizaChatDetail animated:YES];
    }
    
}

@end
