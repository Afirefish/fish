//
//  BaseMgr.m
//  Pretend
//
//  Created by daixijia on 2017/12/13.
//  Copyright © 2017年 戴曦嘉. All rights reserved.
//

#import "BaseMgr.h"

@interface BaseMgr ()
@property (strong, nonatomic) NSString *filePath;

@end

@implementation BaseMgr

- (instancetype)init {
    if (self = [super init]) {
        self.isDevil = NO;
        self.choiceCount = 1;
        self.allCellHeight = [[NSMutableArray alloc] init];
        self.chatMessageList = [[NSMutableArray alloc] init];
        [self loadChatMessage];
        [self loadFromFile];
    }
    return self;
}

// 新的加载
- (void)loadChatMessage {
    self.isChoice = NO;
    self.nextStep = 1;
}

#pragma mark - data control

// 加载新的json数据
- (ChatStatus)loadNewMessage {
    // 获得当前真正的子类
    NSString *className = NSStringFromClass([self class]);
    NSString *devil = [className substringToIndex:className.length - 3];
    // 对于普通文本来说，只需要继续下一句话就好
    if (!self.isChoice) {
        // 解析普通文本
        if (self.finished <= [ChatRoomMgr defaultMgr].plainMessages.count) {
            NSDictionary *dic = [[ChatRoomMgr defaultMgr].plainMessages objectAtIndex:self.finished - 1];
            NSString *message = [dic objectForKey:@"message"];
            NSUInteger index = [[dic objectForKey:@"index"] unsignedIntegerValue];
            if (index == self.finished) {
                self.plainMsg = [NSString stringWithFormat:@"%@",message];
            }
            self.previousStep = self.finished;
            self.finished ++;
        }
        if ([self.plainMsg isEqualToString:@"ALL START"]) {
            return ChatBegin;
        }
        if ([self.plainMsg isEqualToString:@"ALL END"]) {
            [[ChatRoomMgr defaultMgr] chatComplete];
            return ChatComplete;
        }
        // 章节开始,只有这个时候才记录剧情的进度,其他AI从这里读取数据来查看是不是自己的剧情
        if ([self.plainMsg containsString:@"Chapter Begin"]) {
            NSArray *array = [self.plainMsg componentsSeparatedByString:@" "]; //文本生成的数组
            NSString *showTime = array.firstObject;
            if ([showTime isEqualToString:@"Santa"]) {
                [ChatRoomMgr defaultMgr].showTime = SantaShowTime;
            }
            else if ([showTime isEqualToString:@"Pufu"]) {
                [ChatRoomMgr defaultMgr].showTime = PufuShowTime;
            }
            else if ([showTime isEqualToString:@"Tiza"]) {
                [ChatRoomMgr defaultMgr].showTime = TizaShowTime;
            }
            else if ([showTime isEqualToString:@"Chizi"]) {
                [ChatRoomMgr defaultMgr].showTime = ChiziShowTime;
            }
            else {
                NSLog(@"错误的章节");
            }
            self.finished --;
            [[ChatRoomMgr defaultMgr] updateStep:self.finished];
            NSLog(@"现在是 %@的剧情",showTime);
            if (![showTime isEqualToString:devil]) {
                return OtherChapterBegin;
            }
            else {
                return ChapterBegin;
            }
        }
        // 章节结束
        if ([self.plainMsg containsString:@"Chapter End"]) {
            NSArray *array = [self.plainMsg componentsSeparatedByString:@" "]; //文本生成的数组
            NSString *showTime = array.firstObject;
            NSLog(@"现在 %@剧情结束了",showTime);
            return ChapterComplete;
        }
        // 如果文本是开始选择的消息的话，刷新玩家选项
        if ([self.plainMsg containsString:@"Branch Begin"]) {
            self.isChoice = YES;
            // 判断第几个分支
            NSArray *array = [self.plainMsg componentsSeparatedByString:@" "]; //文本生成的数组
            NSString *branchCount = array.firstObject;
            [[ChatRoomMgr defaultMgr] loadChatFile:branchCount withDevil:devil];
            self.playerMessages = [ChatRoomMgr defaultMgr].playerMessages;
            self.devilMessages = [ChatRoomMgr defaultMgr].devilMessages;
            // 获取玩家选项数量
            if (self.nextStep <= self.playerMessages.count) {
                NSDictionary *dic = [self.playerMessages objectAtIndex:self.nextStep - 1];
                NSNumber *step = [dic objectForKey:@"step"];
                NSUInteger myStep = [step integerValue];
                if (myStep == self.nextStep) {
                    self.choiceArr = [dic objectForKey:@"choice"];
                    self.choiceCount = self.choiceArr.count;
                }
            }
            return BranchBegin;
        }
        // 如果不是开始选择的情况，直接发送这个消息就好,添加普通文本到聊天记录里
        else {
            return PlainChat;
        }
    }
    // 对于对话文本来说，在玩家选择某一句话之后，对方会有相应的回复，添加玩家选择到聊天记录里
    else {
        self.isDevil = NO;
        return PlayerTime;
    }
}

//恶魔的回复,仅在对话的时候使用
- (void)devilRespond {
    self.isDevil = YES;
    // 获取恶魔的回复，添加恶魔的回复到聊天记录里
    if (self.nextStep <= self.devilMessages.count) {
        NSDictionary *dic = [self.devilMessages objectAtIndex:self.nextStep - 1];
        NSNumber *step = [dic objectForKey:@"step"];
        NSUInteger mystep = [step integerValue];
        if (mystep == self.nextStep) {
            self.devilArr = [dic objectForKey:@"choice"];
            self.devilDic = [self.devilArr objectAtIndex:self.choiceIndex];
            self.devilRespondContent = [self.devilDic objectForKey:@"message"];
        }
        self.nextStep ++;
    }
}

// 恶魔回复刷新完table之后，读取下一个选项的情况
- (ChatStatus)loadNextChoice {
    // 如果选项分支结束了，进入普通文本模式
    if (self.nextStep > self.devilMessages.count) {
        self.isChoice = NO;
        self.nextStep = 1;
        return BranchComplete;
    }
    // 如果有后续，获取下一步的选项
    else {
        NSDictionary *dic = [self.playerMessages objectAtIndex:self.nextStep - 1];
        NSNumber *step = [dic objectForKey:@"step"];
        NSUInteger myStep = [step integerValue];
        if (myStep == self.nextStep) {
            self.choiceArr = [dic objectForKey:@"choice"];
            self.choiceCount = self.choiceArr.count;
        }
        return PlayerTime;
    }
}

#pragma mark - progress control

//设定好文件的存储位置，判断是否创建了文件
- (BOOL)isFileFirstCreated {
    NSString *docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    self.filePath = [docPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.txt",NSStringFromClass([self class])]];
    //NSLog(@"file path %@",self.filePath);
    NSFileManager *fileMgr = [NSFileManager defaultManager];
    if (![fileMgr fileExistsAtPath:self.filePath]) {
        [fileMgr createFileAtPath:self.filePath contents:nil attributes:nil];
        return YES;
    } else {
        return NO;
    }
}

//读取文件
- (void)loadFromFile {
    if ([self isFileFirstCreated]) {
        self.previousStep = 1;
        self.finished = 1;
    }
    else {
        NSDictionary *dic = [NSDictionary dictionaryWithContentsOfFile:self.filePath];
        if (dic == nil) {
            self.previousStep = 1;
            self.finished = 1;
            return;
        }
        NSNumber *previousStep = [dic objectForKey:@"previousStep"];
        NSNumber *finished = [dic objectForKey:@"finished"];
        self.previousStep = [previousStep unsignedIntegerValue];
        self.finished = [finished unsignedIntegerValue];
        self.finishText = [dic objectForKey:@"finishText"];
        self.cards = [dic objectForKey:@"cards"];
    }
}

//存入文件,在退出游戏的时候再调用，这样感觉能不太影响游戏性能
- (void)saveToFile {
    if ([self isFileFirstCreated]) {
        NSLog(@"create file");
    }
    if (self.isChoice) {
        self.previousStep --;
        self.finished --;
    }
    NSNumber *previousStep = [NSNumber numberWithUnsignedInteger:self.previousStep];
    NSNumber *finished = [NSNumber numberWithUnsignedInteger:self.finished];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:
                         previousStep,@"previousStep",
                         finished,@"finished",
                         self.finishText,@"finishText",
                         self.cards,@"cards",
                         nil];
    //NSLog(@"santa dic is %@",dic);
    [dic writeToFile:self.filePath atomically:YES];
}

//重置
- (void)reset {
    if ([self isFileFirstCreated]) {
        NSLog(@"create file");
    }
    self.previousStep = 1;
    self.finished = 1;
    NSNumber *previousStep = [NSNumber numberWithUnsignedInteger:self.previousStep];
    NSNumber *finished = [NSNumber numberWithUnsignedInteger:self.finished];
    self.cards = nil;
    self.finishText = nil;
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:
                         previousStep,@"previousStep",
                         finished,@"finished",
                         self.finishText,@"finishText",
                         self.cards,@"cards",
                         nil];
    [dic writeToFile:self.filePath atomically:YES];
}

//保存获得的卡牌信息
- (void)saveCardInfo:(NSNumber *)card {
    [self.cards addObject:card];
}

@end
