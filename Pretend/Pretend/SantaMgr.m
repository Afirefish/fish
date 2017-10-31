//
//  SantaMgr.m
//  Pretend
//
//  Created by 戴曦嘉 on 2017/10/26.
//  Copyright © 2017年 戴曦嘉. All rights reserved.
//

#import "SantaMgr.h"

@interface SantaMgr()
@property (strong,nonatomic) NSString *filePath;

@end

@implementation SantaMgr//读取每个恶魔的卡牌数据，和每个恶魔的剧情进行状态

+ (instancetype)defaultMgr {
    static SantaMgr *defaultDevilMgr = nil;
    if (defaultDevilMgr == nil) {
        defaultDevilMgr = [[SantaMgr alloc] initWithFile];
    }
    return defaultDevilMgr;
}

- (instancetype)initWithFile {
    if (self = [super init]) {
        [self loadFromFile];
    }
    return self;
}

- (BOOL)isFileFirstCreated {//设定好文件的存储位置，判断是否创建了文件
    NSString *docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    self.filePath = [docPath stringByAppendingPathComponent:@"santa.txt"];
    NSLog(@"file path %@",self.filePath);
    NSFileManager *fileMgr = [NSFileManager defaultManager];
    if (![fileMgr fileExistsAtPath:self.filePath]) {
        [fileMgr createFileAtPath:self.filePath contents:nil attributes:nil];
        return YES;
    } else {
        return NO;
    }
}

- (void)loadFromFile {//读取文件
    if ([self isFileFirstCreated]) {
        self.previousStep = 1;
        self.santaFinished = 1;
    } else {
        NSDictionary *dic = [NSDictionary dictionaryWithContentsOfFile:self.filePath];
        if (dic == nil) {
            self.previousStep = 1;
            self.santaFinished = 1;
            return;
        }
        NSLog(@"santa load dic is %@",dic);
        NSNumber *previousStep = [dic objectForKey:@"previousStep"];
        NSNumber *finished = [dic objectForKey:@"finished"];
        self.previousStep = [previousStep unsignedIntegerValue];
        self.santaFinished = [finished unsignedIntegerValue];
        self.cards = [dic objectForKey:@"cards"];
    }
}

- (void)saveToFile {//存入文件,在退出游戏的时候再调用，这样感觉能不太影响游戏性能
    if ([self isFileFirstCreated]) {
        NSLog(@"create file");
    }
    NSNumber *previousStep = [NSNumber numberWithUnsignedInteger:self.previousStep];
    NSNumber *finished = [NSNumber numberWithUnsignedInteger:self.santaFinished];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:previousStep,@"previousStep",finished,@"finished",self.cards,@"cards", nil];
    NSLog(@"santa dic is %@",dic);
    [dic writeToFile:self.filePath atomically:YES];
}

- (void)resetSanta {//重置santa
    if ([self isFileFirstCreated]) {
        NSLog(@"create file");
    }
    self.previousStep = 1;
    self.santaFinished = 1;
    NSNumber *previousStep = [NSNumber numberWithUnsignedInteger:self.previousStep];
    NSNumber *finished = [NSNumber numberWithUnsignedInteger:self.santaFinished];
    self.cards = nil;
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:previousStep,@"previousStep",finished,@"finished",self.cards,@"cards", nil];
    [dic writeToFile:self.filePath atomically:YES];
}

- (void)saveStep:(NSUInteger)step {//保存当前进度
    self.santaFinished = step;
    //NSLog(@"save");
}

- (void)saveCardInfo:(NSNumber *)card {//保存获得的卡牌信息
    [self.cards addObject:card];
}

- (void)savePreviousStep:(NSUInteger)step {//保存上一步的剧情,这里将会用于重新进入游戏的加载
    self.previousStep = step;
    //NSLog(@"save2");
}

@end
