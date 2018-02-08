//
//  PRTxtTransform.m
//  Pretend
//
//  Created by daixijia on 2018/1/9.
//  Copyright © 2018年 戴曦嘉. All rights reserved.
//

#import "PRTxtTransform.h"

@interface PRTxtTransform ()

@property (nonatomic, assign) NSInteger tapCount;
@property (nonatomic, assign) BOOL isChoice;
@property (nonatomic, assign) BOOL isDevil;
@property (nonatomic, assign) NSInteger nextStep;

@property (nonatomic, strong) NSString *plainFileDirectory;
@property (nonatomic, strong) NSString *devilFileDirectory;
@property (nonatomic, strong) NSString *playerFileDirectory;

@property (nonatomic, strong) NSString *plainFile;
@property (nonatomic, strong) NSString *devilFile;
@property (nonatomic, strong) NSString *playerFile;

@property (nonatomic, strong) NSString *test;

@end

@implementation PRTxtTransform

- (instancetype)init {
    if (self = [super init]) {
        [self resetArgs];
    }
    return self;
}

- (void)resetArgs {
    self.tapCount = 1;
    self.isChoice = NO;
    self.isDevil = NO;
    self.nextStep = 1;
}

// 要求在""之后也加个句号。。禁用英文符号
- (void)transNovelToMyTxt {
    NSString *contentPath = [[NSBundle mainBundle] pathForResource:@"article" ofType:@"txt"]; // 文本存储位置
    NSString *txtContent = [NSString stringWithContentsOfFile:contentPath encoding:NSUTF8StringEncoding error:nil]; // 文本转nsstring
    // 统一修改所有英文符号变成中文
    txtContent = [txtContent stringByReplacingOccurrencesOfString:@"." withString:@"。"];//中文句号
    txtContent = [txtContent stringByReplacingOccurrencesOfString:@"?" withString:@"？"]; //中文问号
    txtContent = [txtContent stringByReplacingOccurrencesOfString:@"!" withString:@"！"];//中文感叹号
    txtContent = [txtContent stringByReplacingOccurrencesOfString:@";" withString:@"；"];//分号
    // 指定的中文符号后添加回车
    txtContent = [txtContent stringByReplacingOccurrencesOfString:@"。" withString:@".\n"];//中文句号
    txtContent = [txtContent stringByReplacingOccurrencesOfString:@"？" withString:@"?\n"]; //中文问号
    txtContent = [txtContent stringByReplacingOccurrencesOfString:@"！" withString:@"!\n"];//中文感叹号
    txtContent = [txtContent stringByReplacingOccurrencesOfString:@"。。。" withString:@"...\n"];//省略号
    txtContent = [txtContent stringByReplacingOccurrencesOfString:@"；" withString:@";\n"];//分号
    //转回中文。。
    txtContent = [txtContent stringByReplacingOccurrencesOfString:@"." withString:@"。"];//中文句号
    txtContent = [txtContent stringByReplacingOccurrencesOfString:@"?" withString:@"？"]; //中文问号
    txtContent = [txtContent stringByReplacingOccurrencesOfString:@"!" withString:@"！"];//中文感叹号
    txtContent = [txtContent stringByReplacingOccurrencesOfString:@";" withString:@"；"];//分号
    
    NSString *testFile = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"novel.txt"];
    [txtContent writeToFile:testFile atomically:YES encoding:NSUTF8StringEncoding error:nil];
}

// 转换！
- (void)transTXTToPlist {
    NSString *contentPath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"novel.txt"];
    NSString *txtContent = [NSString stringWithContentsOfFile:contentPath encoding:NSUTF8StringEncoding error:nil]; // 文本转nsstring
    NSArray *array = [txtContent componentsSeparatedByString:@"\n"]; //文本生成的数组
    
    self.plainFileDirectory = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"plain"]; //普通文本的目录

    [[NSFileManager defaultManager] createDirectoryAtPath:self.plainFileDirectory withIntermediateDirectories:YES attributes:nil error:nil];
    
    self.plainFile = [self.plainFileDirectory stringByAppendingPathComponent:@"plain.plist"]; //普通文本的文件
    
    NSMutableArray *plainArr = [[NSMutableArray alloc] init]; //存储普通文本的数组
    NSMutableArray *devilArr = [[NSMutableArray alloc] init]; //存储恶魔回复的数组
    NSMutableArray *playerArr = [[NSMutableArray alloc] init]; //存储玩家选择的数组
    
    NSMutableArray *respondArr1,*respondArr2,*respondArr3,*respondArr4; // 最多4个分支的数组
    NSMutableArray *choiceArr1,*choiceArr2,*choiceArr3,*choiceArr4;
    
    NSUInteger count = 1;// 普通文本的计数
    BOOL isPlainText = YES; // 是否是普通文本
    BOOL isDevil = NO; // 是否是恶魔的回复
    NSUInteger step = 1; // 对话文本的计数
    NSUInteger branch = 0; //对话文本的分支数
    
    // 一些开始结束的标志
    BOOL start = NO;
    BOOL end = NO;
    
    for (NSString *string in array) {
        // 去掉空白
        NSString *str = [string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        if (!str.length) {
            continue;
        }
        
        // 结束分支
        if ([str containsString:@"Branch End"]) {
            // 恶魔
            if (respondArr1) {
                NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:
                                     [NSNumber numberWithInteger:1],@"step",
                                     respondArr1,@"choice",
                                     nil];
                [devilArr addObject:dic];
            }
            if (respondArr2) {
                NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:
                                     [NSNumber numberWithInteger:2],@"step",
                                     respondArr2,@"choice",
                                     nil];
                [devilArr addObject:dic];
            }
            if (respondArr3) {
                NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:
                                     [NSNumber numberWithInteger:3],@"step",
                                     respondArr3,@"choice",
                                     nil];
                [devilArr addObject:dic];
            }
            if (respondArr4) {
                NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:
                                     [NSNumber numberWithInteger:4],@"step",
                                     respondArr4,@"choice",
                                     nil];
                [devilArr addObject:dic];
            }
            
            // 玩家
            if (choiceArr1) {
                NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:
                                     [NSNumber numberWithInteger:1],@"step",
                                     choiceArr1,@"choice",
                                     nil];
                [playerArr addObject:dic];
            }
            if (choiceArr2) {
                NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:
                                     [NSNumber numberWithInteger:2],@"step",
                                     choiceArr2,@"choice",
                                     nil];
                [playerArr addObject:dic];
            }
            if (choiceArr3) {
                NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:
                                     [NSNumber numberWithInteger:3],@"step",
                                     choiceArr3,@"choice",
                                     nil];
                [playerArr addObject:dic];
            }
            if (choiceArr4) {
                NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:
                                     [NSNumber numberWithInteger:4],@"step",
                                     choiceArr4,@"choice",
                                     nil];
                [playerArr addObject:dic];
            }
            
            // 判断第几个分支
            NSArray *array = [str componentsSeparatedByString:@" "]; //文本生成的数组
            NSString *branchCount = array.firstObject;
            self.devilFile = [self.devilFileDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.plist",branchCount]]; //恶魔文本的文件
            self.playerFile = [self.playerFileDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.plist",branchCount]]; //玩家文本的文件
            
            //写文件
            NSDictionary *playContent = [NSDictionary dictionaryWithObject:playerArr forKey:@"content"];
            [playContent writeToFile:self.playerFile atomically:YES];
            NSDictionary *devilContent = [NSDictionary dictionaryWithObject:devilArr forKey:@"content"];
            [devilContent writeToFile:self.devilFile atomically:YES];
            
            //初始化
            [devilArr removeAllObjects];
            [playerArr removeAllObjects];
            respondArr1 = nil;
            respondArr2 = nil;
            respondArr3 = nil;
            respondArr4 = nil;
            choiceArr1 = nil;
            choiceArr2 = nil;
            choiceArr3 = nil;
            choiceArr4 = nil;
            step = 1;
            branch = 0;
            isDevil = NO;
            isPlainText = YES;
            continue;
        }
        
        // 普通文本,分支开始要加入到普通文本中，解析的时候要用到，所以在这里判断
        if (isPlainText) {
            NSNumber *index = [NSNumber numberWithUnsignedInteger:count];
            count++;
            NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:
                                 index,@"index",
                                 str,@"message",
                                 nil];
            [plainArr addObject:dic];
            
            // 开始结束标记
            if ([str isEqualToString:@"ALL START"]) {
                start = YES;
                continue;
            }
            
            if ([str isEqualToString:@"ALL END"]) {
                end = YES;
                continue;
            }
            
            // 新章节开始的时候，设置是属于谁的章节,对话将存储到对应的文件中
            if ([str containsString:@"Chapter Begin"]) {
                NSArray *array = [str componentsSeparatedByString:@" "]; //文本生成的数组
                NSString *devilName = array.firstObject;
                self.devilFileDirectory = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@",devilName]]; //恶魔文本的目录
                self.playerFileDirectory = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:[NSString stringWithFormat:@"PlayerTo%@",devilName]]; //玩家文本的目录
                
                if (![[NSFileManager defaultManager] fileExistsAtPath:self.devilFileDirectory]) {
                    [[NSFileManager defaultManager] createDirectoryAtPath:self.devilFileDirectory withIntermediateDirectories:YES attributes:nil error:nil];
                }
                if (![[NSFileManager defaultManager] fileExistsAtPath:self.playerFileDirectory]) {
                    [[NSFileManager defaultManager] createDirectoryAtPath:self.playerFileDirectory withIntermediateDirectories:YES attributes:nil error:nil];
                }
                continue;
//                self.devilFile = [self.devilFileDirectory stringByAppendingPathComponent:@"devil.plist"]; //恶魔文本的文件
//                self.playerFile = [self.playerFileDirectory stringByAppendingPathComponent:@"player.plist"]; //玩家文本的文件
            }
            
            //  如果某个章节结束了，设置为nil
            if ([str containsString:@"Chapter End"]) {
                self.devilFileDirectory = nil;
                self.playerFileDirectory = nil;
                self.devilFile = nil;
                self.playerFile = nil;
                continue;
            }
            
            // 开始分支
            if ([str containsString:@"Branch Begin"]) {
                isPlainText = NO;
                continue;
            }
        }
        
        // 恶魔的回复
        else if (isDevil) {
            isDevil = NO;
            NSNumber *index = [NSNumber numberWithUnsignedInteger:branch];
            NSDictionary *respond = [NSDictionary dictionaryWithObjectsAndKeys:
                                     index,@"index",
                                     str,@"message",
                                     nil];
            // 根据不同的分支存储到不同的数组中去
            switch (step) {
                case 1:
                    if (!respondArr1) {
                        respondArr1 = [[NSMutableArray alloc] init];
                    }
                    [respondArr1 addObject:respond];
                    break;
                    
                case 2:
                    if (!respondArr2) {
                        respondArr2 = [[NSMutableArray alloc] init];
                    }
                    [respondArr2 addObject:respond];
                    break;
                    
                case 3:
                    if (!respondArr3) {
                        respondArr3 = [[NSMutableArray alloc] init];
                    }
                    [respondArr3 addObject:respond];
                    break;
                    
                case 4:
                    if (!respondArr4) {
                        respondArr4 = [[NSMutableArray alloc] init];
                    }
                    [respondArr4 addObject:respond];
                    break;
                    
                default:
                    break;
            }
            step ++;
        }
        
        // 玩家的回复
        else {
            // 判断是哪个分支
            if ([str containsString:@"Fork"]) {
                branch ++;
                step = 1;
            }
            else {
                isDevil = YES;
                NSNumber *index = [NSNumber numberWithUnsignedInteger:branch];
                NSDictionary *choice = [NSDictionary dictionaryWithObjectsAndKeys:
                                        index,@"index",
                                        str,@"message",
                                        nil];
                // 根据不同的分支存储到不同的数组中去
                switch (step) {
                    case 1:
                        if (!choiceArr1) {
                            choiceArr1 = [[NSMutableArray alloc] init];
                        }
                        [choiceArr1 addObject:choice];
                        break;
                        
                    case 2:
                        if (!choiceArr2) {
                            choiceArr2 = [[NSMutableArray alloc] init];
                        }
                        [choiceArr2 addObject:choice];
                        break;
                        
                    case 3:
                        if (!choiceArr3) {
                            choiceArr3 = [[NSMutableArray alloc] init];
                        }
                        [choiceArr3 addObject:choice];
                        break;
                        
                    case 4:
                        if (!choiceArr4) {
                            choiceArr4 = [[NSMutableArray alloc] init];
                        }
                        [choiceArr4 addObject:choice];
                        break;
                        
                    default:
                        break;
                }
            }
        }
    }
    NSDictionary *plainDic = [NSDictionary dictionaryWithObject:plainArr forKey:@"content"];
    [plainDic writeToFile:self.plainFile atomically:YES];
    
    NSLog(@"file path %@",self.plainFile);
//    self.test = @"";
//    NSString *testFile = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"mytest.txt"];
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        while (self.tapCount < count ) {
//            [self next];
//        }
//        [self.test writeToFile:testFile atomically:YES encoding:NSUTF8StringEncoding error:nil];
//    });
}

// 输出测试
- (void)next {
    
    // 解析普通文本
    NSDictionary *plainDic = [[NSDictionary alloc] initWithContentsOfFile:self.plainFile];
    NSArray *plainArr = [plainDic objectForKey:@"content"];
    if (!self.isChoice) {
        if (self.tapCount <= plainArr.count) {
            NSDictionary *dic = [plainArr objectAtIndex:self.tapCount - 1];
            NSString *message = [dic objectForKey:@"message"];
            NSUInteger index = [[dic objectForKey:@"index"] unsignedIntegerValue];
            if (index == self.tapCount) {
                if ([message containsString:@"Branch Begin"]) {
                    self.isChoice = YES;
                    
                    // 判断第几个分支
                    NSArray *array = [message componentsSeparatedByString:@" "]; //文本生成的数组
                    NSString *branchCount = array.firstObject;
                    self.devilFile = [self.devilFileDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@devil.plist",branchCount]]; //恶魔文本的文件
                    self.playerFile = [self.playerFileDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@player.plist",branchCount]]; //玩家文本的文件
                    self.test = [self.test stringByAppendingString:[NSString stringWithFormat:@"index: %ld, message: %@\n",index,message]];
                    //NSLog(@"index: %ld, message: %@",index,message);
                }
                else {
                    self.test = [self.test stringByAppendingString:[NSString stringWithFormat:@"index: %ld, message: %@\n",index,message]];
                   // NSLog(@"index: %ld, message: %@",index,message);
                }
            }
            self.tapCount ++;
        }
    }
    //解析对话文件
    else {
        //玩家的选择的json解析
        if (!self.isDevil) {
            NSDictionary *playerMessagesDic = [[NSDictionary alloc] initWithContentsOfFile:self.playerFile];
            NSArray *playerMessages = [playerMessagesDic objectForKey:@"content"];
            if (self.nextStep <= playerMessages.count) {
                NSDictionary *dic = [playerMessages objectAtIndex:self.nextStep - 1];
                NSUInteger step = [[dic objectForKey:@"step"] unsignedIntegerValue];
                NSArray *arr = [dic objectForKey:@"choice"];
                if (step == self.nextStep) {
                    self.test = [self.test stringByAppendingString:[NSString stringWithFormat:@"player step %ld\n",step]];
                    //NSLog(@"step %ld",step);
                    for (NSDictionary *dic in arr) {
                        NSString *message = [dic objectForKey:@"message"];
                        NSUInteger index = [[dic objectForKey:@"index"] unsignedIntegerValue];
                        self.test = [self.test stringByAppendingString:[NSString stringWithFormat:@"index: %ld, message: %@\n",index,message]];
                        //NSLog(@"index: %ld, message: %@",index,message);
                    }
                }
                self.isDevil = YES;
            }
        }
        //恶魔的json解析
        else {
            NSDictionary *devilDic = [[NSDictionary alloc] initWithContentsOfFile:self.devilFile];
            NSArray *devilMessages = [devilDic objectForKey:@"content"];
            if (self.nextStep <= devilMessages.count) {
                NSDictionary *dic = [devilMessages objectAtIndex:self.nextStep - 1];
                NSUInteger step = [[dic objectForKey:@"step"] unsignedIntegerValue];
                NSArray *arr = [dic objectForKey:@"choice"];
                if (step == self.nextStep) {
                    self.test = [self.test stringByAppendingString:[NSString stringWithFormat:@"devil step %ld\n",step]];
                    //NSLog(@"step %ld",step);
                    for (NSDictionary *dic in arr) {
                        NSString *message = [dic objectForKey:@"message"];
                        NSUInteger index = [[dic objectForKey:@"index"] unsignedIntegerValue];
                        self.test = [self.test stringByAppendingString:[NSString stringWithFormat:@"index: %ld, message: %@\n",index,message]];
                        //NSLog(@"index: %ld, message: %@",index,message);
                    }
                }
                self.isDevil = NO;
                if (self.nextStep == [devilMessages count]) {
                    self.test = [self.test stringByAppendingString:@"Branch End\n"];
                    self.isChoice = NO;
                    self.nextStep = 1;
                }
                else {
                    self.nextStep ++;
                }
            }
        }
    }
}


@end
