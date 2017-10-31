//
//  Puri.h
//  Pretend
//
//  Created by 戴曦嘉 on 2017/10/26.
//  Copyright © 2017年 戴曦嘉. All rights reserved.
//

#import "Crafter.h"

@interface Puri : Crafter//主角如果对战的中途退出，不保存当前的对战数据，再次挑战时还是和这个敌人重新战斗（这个算是提供一个刷对人卡牌的办法吧。。）
@property (assign,nonatomic) NSUInteger defeatedCrafterCount;//击破的对手数量,对手的难度根据这个来确定


@end
