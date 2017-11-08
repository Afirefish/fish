//
//  DevilChatRoom.m
//  Pretend
//
//  Created by 戴曦嘉 on 2017/9/29.
//  Copyright © 2017年 戴曦嘉. All rights reserved.
//

#import "DevilChatRoom.h"
#import "ChatRoomMgr.h"
#import "SantaChatDetail.h"
#import "PufuChatDetail.h"
#import "ChiziChatDetail.h"
#import "TizaChatDetail.h"
#import "ChatRoomCleared.h"

@interface DevilChatRoom ()
@property (strong,nonatomic) NSArray *devilNames;
@property (strong,nonatomic) NSArray *devilImages;
@property (strong,nonatomic) ChatRoomMgr *chatRoomMgr;

@end

@implementation DevilChatRoom

//单例
+ (instancetype)devilShowUp {
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
    //self.navigationItem.hidesBackButton = YES;
    self.navigationItem.title = @"Devil Chat";
    self.view.backgroundColor = [UIColor colorWithRed:255.0/255 green:250.0/255 blue:240.0/255 alpha:1.0];
    UIButton *saveBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    saveBtn.frame = CGRectMake(0, 0, 44, 44);
    [saveBtn setTitle:@"save" forState:UIControlStateNormal];
    [saveBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    saveBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [saveBtn addTarget:self action:@selector(saveToFile) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *saveItem = [[UIBarButtonItem alloc] initWithCustomView:saveBtn];
    self.navigationItem.rightBarButtonItem = saveItem;
    [self checkFinished];
}

- (void)saveToFile {//保存
    [self.chatRoomMgr writeToFile];
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
    cell.backgroundColor = [UIColor colorWithRed:255.0/255 green:250.0/255 blue:240.0/255 alpha:1.0];
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
