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

NS_ASSUME_NONNULL_BEGIN

@interface ChatRoomMgr ()
@property (assign, nonatomic) BOOL chatFinished;
@property (strong, nonatomic) SantaMgr *santa;
@property (strong, nonatomic) PufuMgr *pufu;
@property (strong, nonatomic) ChiziMgr *chizi;
@property (strong, nonatomic) TizaMgr *tiza;
@property (strong, nonatomic) NSString *filePath; // 剧情进度存储的文件

@property (nonatomic, strong) NSString *plainFile; // 普通文本，剧情进程的主要控制
@property (nonatomic, strong) NSString *devilFile;  // 当前对话文本
@property (nonatomic, strong) NSString *playerFile;

@property (nonatomic, strong) NSString *devilFileDirectory; // 存储恶魔对话文件的目录
@property (nonatomic, strong) NSString *playerFileDirectory; // 存储玩家对话文件的目录

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
        [self loadPlainFile];
        self.santa = [SantaMgr defaultMgr];
        self.pufu = [PufuMgr defaultMgr];
        self.chizi = [ChiziMgr defaultMgr];
        self.tiza = [TizaMgr defaultMgr];
        self.step = self.santa.finished;
    }
    return self;
}

#pragma mark - new way to load file

// 加载普通文本
- (void)loadPlainFile {
    self.plainFile = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"plain/plain.plist"]; //普通文本的目录
    NSDictionary *plainDic = [[NSDictionary alloc] initWithContentsOfFile:self.plainFile];
    self.plainMessages = [plainDic objectForKey:@"content"];
}

// 加载对话文本
- (void)loadChatFile:(NSString *)file withDevil:(NSString *)devil {
    self.devilFileDirectory = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@",devil]]; //恶魔文本的目录
    self.playerFileDirectory = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:[NSString stringWithFormat:@"PlayerTo%@",devil]]; //玩家文本的目录
    self.devilFile = [self.devilFileDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.plist",file]]; //恶魔文本的文件
    self.playerFile = [self.playerFileDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.plist",file]]; //玩家文本的文件
    NSDictionary *playerDic = [[NSDictionary alloc] initWithContentsOfFile:self.playerFile];
    self.playerMessages = [playerDic objectForKey:@"content"];
    NSDictionary *devilDic = [[NSDictionary alloc] initWithContentsOfFile:self.devilFile];
    self.devilMessages = [devilDic objectForKey:@"content"];
}

#pragma mark - step manager

// 控制全局对话的文件，设定好文件的存储位置，判断是否创建了文件
- (BOOL)isFileFirstCreated {
    NSString *docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    self.filePath = [docPath stringByAppendingPathComponent:@"ChatRoom.txt"];
    NSFileManager *fileMgr = [NSFileManager defaultManager];
    if (![fileMgr fileExistsAtPath:self.filePath]) {
        [fileMgr createFileAtPath:self.filePath contents:nil attributes:nil];
        return YES;
    }
    else {
        return NO;
    }
}

// 读取文件中信息
- (void)loadFromFile {
     // 第一次创建，初始化
    if ([self isFileFirstCreated]) {
        self.chatFinished = NO;
        self.showTime = SantaShowTime;
    }
    // 已经创建了，读取内容
    else {
        NSDictionary *dic = [NSDictionary dictionaryWithContentsOfFile:self.filePath];
        // 内容为空 初始化
        if (dic == nil) {
            self.chatFinished = NO;
            self.showTime = SantaShowTime;
            return;
        }
        // 初始化目前剧情的进展，是否完成，以及卡牌
        self.showTime = [[dic objectForKey:@"showTime"] integerValue];
        NSString *finish = [dic objectForKey:@"finish"];
        if ([finish isEqualToString:@"YES"]) {
            self.chatFinished = YES;
        }
        else {
            self.chatFinished = NO;
        }
        self.cards = [dic objectForKey:@"cards"];
    }
}

// 存入文件
- (void)writeToFile {
    // 如果没有创建
    if ([self isFileFirstCreated]) {
        NSLog(@"main file create");
    }
    // 局部的剧情写入
    [self.santa saveToFile];
    [self.pufu saveToFile];
    [self.chizi saveToFile];
    [self.tiza saveToFile];
    // 主要的剧情进度在santa处保存
    self.step = self.santa.finished;
    NSString *finish = self.chatFinished?@"YES":@"NO";
    NSNumber *currentDevil = [NSNumber numberWithInteger:self.showTime];
    // 存入当前剧情所在的位置，卡牌
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:
                         currentDevil,@"showTime",
                         finish,@"finish",
                         self.cards,@"cards",
                         nil];
    [dic writeToFile:self.filePath atomically:YES];
}

- (void)updateStep:(NSUInteger)step {
    self.step = step;
    self.santa.finished = step;
    self.pufu.finished = step;
    self.tiza.finished = step;
    self.chizi.finished = step;
    switch (self.showTime) {
        case SantaShowTime:
            self.santa.previousStep = self.santa.finished = step + 1;
            break;
            
        case PufuShowTime:
            self.pufu.previousStep = self.pufu.finished = step + 1;
            break;
            
        case TizaShowTime:
            self.tiza.previousStep = self.tiza.finished = step + 1;
            break;
            
        case ChiziShowTime:
            self.chizi.previousStep = self.chizi.finished = step + 1;
            break;
            
        default:
            break;
    }
}

// 检查游戏是否通关
- (BOOL)checkComplete {
    return self.chatFinished;
}

// 第一个游戏通关
- (void)chatComplete {
    self.chatFinished = YES;
    [self saveAllCards];
}

// 保存所有卡牌信息
- (void)saveAllCards {
    [self.cards unionSet:self.santa.cards];
    [self.cards unionSet:self.pufu.cards];
    [self.cards unionSet:self.chizi.cards];
    [self.cards unionSet:self.tiza.cards];
    [self writeToFile];
}

// 重置游戏
- (void)reSet {
    [self.santa reset];
    [self.pufu reset];
    [self.chizi reset];
    [self.tiza reset];
    self.santa = [SantaMgr defaultMgr];
    self.pufu = [PufuMgr defaultMgr];
    self.chizi = [ChiziMgr defaultMgr];
    self.tiza = [TizaMgr defaultMgr];
    self.step = self.santa.finished;
    // 当前剧情重置为1,重新写入文件
    self.step = 1;
    NSString *finish = @"NO";
    self.cards = nil;
    self.chatFinished = NO;
    self.showTime = SantaShowTime;
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:finish,@"finish",self.cards,@"cards",nil];
    [dic writeToFile:self.filePath atomically:YES];
    [self loadFromFile];
}
@end

NS_ASSUME_NONNULL_END
