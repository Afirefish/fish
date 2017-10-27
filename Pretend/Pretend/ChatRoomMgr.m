//
//  ChatRoomMgr.m
//  Pretend
//
//  Created by 戴曦嘉 on 2017/10/26.
//  Copyright © 2017年 戴曦嘉. All rights reserved.
//

#import "ChatRoomMgr.h"
#import "SantaMgr.h"
#import "PufuMgr.h"
#import "TizaMgr.h"
#import "ChiziMgr.h"

@interface ChatRoomMgr ()
@property (strong,nonatomic) SantaMgr *santa;
@property (strong,nonatomic) PufuMgr *pufu;
@property (strong,nonatomic) ChiziMgr *chizi;
@property (strong,nonatomic) TizaMgr *tiza;

@end

@implementation ChatRoomMgr//读取文件中存储的数据,控制器从这个类中获得数据,主要控制所有卡牌数据，json解析，第一个游戏是否结束


+ (instancetype)defaultMgr {
    static ChatRoomMgr *defaultChatRoom = nil;
    if (defaultChatRoom == nil) {
        defaultChatRoom = [[ChatRoomMgr alloc] initWithFile];
    }
    return defaultChatRoom;
}

- (instancetype)initWithFile {
    if (self = [super init]) {
        [self loadFromFile];
        self.santa = [SantaMgr defaultMgr];
        self.pufu = [PufuMgr defaultMgr];
        self.chizi = [ChiziMgr defaultMgr];
        self.tiza = [TizaMgr defaultMgr];
    }
    return self;
}

- (void)loadFromFile {
    
}

- (void)writeToFile {
    
}


- (void)messageJson:(NSString *)devil {//解析每个恶魔和玩家的json文件
    NSString *player = [NSString stringWithFormat:@"playerTo%@",devil];
    //玩家的选择的json解析
    NSString *playerJson = [[NSBundle mainBundle] pathForResource:player ofType:@"json"];
    NSData *playerData = [NSData dataWithContentsOfFile:playerJson];
    NSError *error1 = nil;
    NSDictionary *playerMessagesDic = [NSJSONSerialization JSONObjectWithData:playerData options:kNilOptions error:&error1];
    self.playerMessages = [playerMessagesDic objectForKey:@"content"];
    //santa的对话的json解析
    NSString *devilJson = [[NSBundle mainBundle] pathForResource:devil ofType:@"json"];
    NSData *devilData = [NSData dataWithContentsOfFile:devilJson];
    NSError *error2 = nil;
    NSDictionary *devilDic = [NSJSONSerialization JSONObjectWithData:devilData options:kNilOptions error:&error2];
    self.devilMessages = [devilDic objectForKey:@"content"];
}

- (BOOL)checkComplete {//检查游戏是否通关
    if (self.santa.santaFinished == 100 && self.pufu.pufuFinished == 100 && self.chizi.chiziFinished == 100 && self.tiza.tizaFinished == 100) {
        return YES;
    } else {
        return NO;
    }
}


- (void)chatComplete{//第一个游戏通关
    self.chatFinished = YES;
    [self saveAllCards];
}

- (void)saveAllCards {//保存所有卡牌信息
    [self.cards unionSet:self.santa.cards];
    [self.cards unionSet:self.pufu.cards];
    [self.cards unionSet:self.chizi.cards];
    [self.cards unionSet:self.tiza.cards];
    NSLog(@"now the cards set %@",self.cards);
    [self writeToFile];
}
@end
