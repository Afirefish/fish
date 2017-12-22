//
//  DevilRoomMgr.m
//  Pretend
//
//  Created by 戴曦嘉 on 2017/10/31.
//  Copyright © 2017年 戴曦嘉. All rights reserved.
//

#import "DevilRoomMgr.h"

@interface DevilRoomMgr()
@property (assign,nonatomic) NSUInteger considerStep;
@property (strong,nonatomic) NSDictionary *considerDic;
@property (strong,nonatomic) NSString *considerMsg;
@end

@implementation DevilRoomMgr

+ (instancetype)defaultMgr {
    static DevilRoomMgr *defaultDevilRoom = nil;
    if (defaultDevilRoom == nil) {
        defaultDevilRoom = [[DevilRoomMgr alloc] initWithFile];
        defaultDevilRoom.roomFinish = NO;
        defaultDevilRoom.betary = NO;
        defaultDevilRoom.sincere = NO;
    }
    return defaultDevilRoom;
}

- (instancetype)initWithFile {
    if (self = [super init]) {
        [self loadFromFile];
    }
    return self;
}

- (void)loadFromFile {//读取文件中信息
    NSString *considerPath = [[NSBundle mainBundle] pathForResource:@"consider" ofType:@"json"];
    NSData *considerData = [NSData dataWithContentsOfFile:considerPath];
    NSError *error1 = nil;
    self.considerArr = [NSJSONSerialization JSONObjectWithData:considerData options:kNilOptions error:&error1];
}

- (NSString *)considerMessage:(NSUInteger)index {//考虑的内容的json解析
    for (NSUInteger i = 0; i < [self.considerArr count]; i ++) {
        self.considerDic = self.considerArr[i];
        self.considerStep = [[self.considerDic objectForKey:@"step"] unsignedIntegerValue];
        if (self.considerStep == index + 1) {
            self.considerMsg = [self.considerDic objectForKey:@"message"];
            break;
        }
    }
    return self.considerMsg;
}

@end
