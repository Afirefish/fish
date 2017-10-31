//
//  ChiziMgr.m
//  Pretend
//
//  Created by 戴曦嘉 on 2017/10/26.
//  Copyright © 2017年 戴曦嘉. All rights reserved.
//

#import "ChiziMgr.h"

@interface ChiziMgr()
@property (strong,nonatomic) NSString *filePath;

@end


@implementation ChiziMgr
+ (instancetype)defaultMgr {
    static ChiziMgr *defaultDevilMgr = nil;
    if (defaultDevilMgr == nil) {
        defaultDevilMgr = [[ChiziMgr alloc] initWithFile];
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
    self.filePath = [docPath stringByAppendingPathComponent:@"chizi.txt"];
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
        self.chiziFinished = 1;
    } else {
        NSDictionary *dic = [NSDictionary dictionaryWithContentsOfFile:self.filePath];
        if (dic == nil) {
            self.previousStep = 1;
            self.chiziFinished = 1;
            return;
        }
        NSLog(@"chizi load dic is %@",dic);
        NSNumber *previousStep = [dic objectForKey:@"previousStep"];
        NSNumber *finished = [dic objectForKey:@"finished"];
        self.previousStep = [previousStep unsignedIntegerValue];
        self.chiziFinished = [finished unsignedIntegerValue];
        self.cards = [dic objectForKey:@"cards"];
    }
}

- (void)saveToFile {//存入文件,在退出游戏的时候再调用，这样感觉能不太影响游戏性能
    if ([self isFileFirstCreated]) {
        NSLog(@"create file");
    }
    NSNumber *previousStep = [NSNumber numberWithUnsignedInteger:self.previousStep];
    NSNumber *finished = [NSNumber numberWithUnsignedInteger:self.chiziFinished];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:previousStep,@"previousStep",finished,@"finished",self.cards,@"cards", nil];
    NSLog(@"chizi dic is %@",dic);
    [dic writeToFile:self.filePath atomically:YES];
}

- (void)resetChizi {//重置chizi
    if ([self isFileFirstCreated]) {
        NSLog(@"create file");
    }
    self.previousStep = 1;
    self.chiziFinished = 1;
    NSNumber *previousStep = [NSNumber numberWithUnsignedInteger:self.previousStep];
    NSNumber *finished = [NSNumber numberWithUnsignedInteger:self.chiziFinished];
    self.cards = nil;
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:previousStep,@"previousStep",finished,@"finished",self.cards,@"cards", nil];
    [dic writeToFile:self.filePath atomically:YES];
}

- (void)saveStep:(NSUInteger)step {
    self.chiziFinished = step;
}

- (void)saveCardInfo:(NSNumber *)card {
    [self.cards addObject:card];
}

- (void)savePreviousStep:(NSUInteger)step {
    self.previousStep = step;
}
@end
