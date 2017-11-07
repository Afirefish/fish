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
@property (strong,nonatomic) NSString *filePath;

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

- (BOOL)isFileFirstCreated {//设定好文件的存储位置，判断是否创建了文件
    NSString *docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    self.filePath = [docPath stringByAppendingPathComponent:@"chatRoom.txt"];
    NSLog(@"main file path %@",self.filePath);
    NSFileManager *fileMgr = [NSFileManager defaultManager];
    if (![fileMgr fileExistsAtPath:self.filePath]) {
        [fileMgr createFileAtPath:self.filePath contents:nil attributes:nil];
        return YES;
    } else {
        return NO;
    }
}

- (void)loadFromFile {//读取文件中信息
    if ([self isFileFirstCreated]) {
        self.chatFinished = NO;
    } else {
        NSDictionary *dic = [NSDictionary dictionaryWithContentsOfFile:self.filePath];
        NSLog(@"what this %@",dic);
        if (dic == nil) {
            self.chatFinished = NO;
            NSLog(@"there?");
            return;
        }
        NSLog(@"here?");
        NSString *finish = [dic objectForKey:@"finish"];
        if ([finish isEqualToString:@"YES"]) {
            self.chatFinished = YES;
        } else {
            self.chatFinished = NO;
        }
        self.cards = [dic objectForKey:@"cards"];
    }
}

- (void)writeToFile {//存入文件
    if ([self isFileFirstCreated]) {
        NSLog(@"main file create");
    }
    [self.santa saveToFile];
    [self.pufu saveToFile];
    [self.chizi saveToFile];
    [self.tiza saveToFile];
    NSString *finish = self.chatFinished?@"YES":@"NO";
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:finish,@"finish",self.cards,@"cards",nil];
    NSLog(@"save main dic %@",dic);
    [dic writeToFile:self.filePath atomically:YES];
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


- (void)reSet {//重置游戏
    [self.santa resetSanta];
    [self.pufu resetPufu];
    [self.chizi resetChizi];
    [self.tiza resetTiza];
    NSString *start = @"NO";
    self.cards = nil;
    self.chatFinished = NO;
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:start,@"finish",self.cards,@"cards",nil];
    NSLog(@"reset game %@",dic);
    [dic writeToFile:self.filePath atomically:YES];
}
@end
