//
//  Devil.h
//  Pretend
//
//  Created by 戴曦嘉 on 2017/10/26.
//  Copyright © 2017年 戴曦嘉. All rights reserved.
//

#import "Crafter.h"

@interface Devil : Crafter
@property (assign,nonatomic) NSUInteger devilID;//恶魔的标号
@property (strong,nonatomic) NSMutableSet *cards;//恶魔的卡牌，会随战况改变
@property (strong,nonatomic) UIImage *appearance;//恶魔的样子
@property (assign,nonatomic) NSUInteger mode;//恶魔的难度模式

@end
