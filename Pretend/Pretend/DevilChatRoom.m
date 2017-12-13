//
//  DevilChatRoom.m
//  Pretend
//
//  Created by 戴曦嘉 on 2017/9/29.
//  Copyright © 2017年 戴曦嘉. All rights reserved.
//

#import "DevilChatRoom.h"
#import "ChatRoomMgr.h"
#import "SantaMgr.h"
#import "PufuMgr.h"
#import "TizaMgr.h"
#import "ChiziMgr.h"
#import "ChatRoomCell.h"
#import "SantaChatDetail.h"
#import "PufuChatDetail.h"
#import "ChiziChatDetail.h"
#import "TizaChatDetail.h"
#import "ChatRoomCleared.h"
#import "UIColor+PRCustomColor.h"

NSString *devilMaster = @"devilMaster";

NS_ASSUME_NONNULL_BEGIN

@interface DevilChatRoom ()
@property (strong,nonatomic) NSArray *devilNames;
@property (strong,nonatomic) NSArray *devilImages;
@property (strong,nonatomic) ChatRoomMgr *chatRoomMgr;
@property (strong,nonatomic) NSIndexPath *roomIndex;

@end

@implementation DevilChatRoom

//单例
+ (instancetype)defaultChatRoom {
    static DevilChatRoom *devilChatCenter = nil;
    if (devilChatCenter == nil) {
        devilChatCenter = [[DevilChatRoom alloc] initWithFirstState];
    }
    return devilChatCenter;
}

//初始化
- (instancetype)initWithFirstState {
    if (self = [super init]) {
        self.devilNames = @[@"santa",@"pufu",@"chizi",@"tiza"];
        self.devilImages = @[[UIImage imageNamed:@"santa.png"],
                             [UIImage imageNamed:@"pufu.png"],
                             [UIImage imageNamed:@"chizi.png"],
                             [UIImage imageNamed:@"tiza.png"]];
        self.chatRoomMgr = [ChatRoomMgr defaultMgr];
    }
    return self;
}

//设置恶魔名字，图片
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Devil Chat";
    [self setupTableView];
    [self setupSaveBtn];
    [self checkFinished];
}

- (void)setupTableView {
    self.tableView.backgroundColor = [UIColor warmShellColor];
    self.tableView.layer.borderWidth = 2;
    self.tableView.layer.borderColor = [UIColor blackColor].CGColor;
    [self.tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];//设置多余cell的分割线不显示
    [self.tableView registerClass:[ChatRoomCell class] forCellReuseIdentifier:devilMaster];
}

- (void)setupSaveBtn {
    UIButton *saveBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    saveBtn.frame = CGRectMake(0, 0, 44, 44);
    [saveBtn setTitle:@"save" forState:UIControlStateNormal];
    [saveBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    saveBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [saveBtn addTarget:self action:@selector(saveToFile) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *saveItem = [[UIBarButtonItem alloc] initWithCustomView:saveBtn];
    self.navigationItem.rightBarButtonItem = saveItem;
}

- (void)saveToFile {//保存
    [self.chatRoomMgr writeToFile];
    UIAlertController *confirm = [UIAlertController alertControllerWithTitle:@"保存成功" message:nil preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:nil];
    [confirm addAction:confirmAction];
    [self presentViewController:confirm animated:YES completion:nil];
}

//检查完成状态
- (void)checkFinished {
    if ([self.chatRoomMgr checkComplete]) {
        [self complete];
    }
}

//全部完成之后的处理 ,可以用个模态框来实现跳转
- (void)complete {
    [self.chatRoomMgr chatComplete];
    ChatRoomCleared *cleared = [[ChatRoomCleared alloc] init];
    [self.navigationController pushViewController:cleared animated:YES];
    [self removeFromParentViewController];
}
#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ChatRoomCell *cell = [tableView dequeueReusableCellWithIdentifier:devilMaster forIndexPath:indexPath];
    cell.nameLabel.text = self.devilNames[indexPath.row];
    cell.messageLabel.text = @"这里要传一下进入的cell的剧情";
    cell.headImageView.image = self.devilImages[indexPath.row];
    cell.sign.hidden = NO;
    return cell;
}

#pragma mark Table view delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    self.roomIndex = indexPath;
    BaseChatDetail *chatDetail = nil;
    if (indexPath.row == 0) {
        chatDetail = [SantaChatDetail santaChatDetail];
    } else if (indexPath.row == 1) {
        chatDetail = [PufuChatDetail pufuChatDetail];
    } else if (indexPath.row == 2) {
        chatDetail = [ChiziChatDetail chiziChatDetail];
    } else {
        chatDetail = [TizaChatDetail tizaChatDetail];
    }
    [self.navigationController pushViewController:chatDetail animated:YES];
}

@end

NS_ASSUME_NONNULL_END
