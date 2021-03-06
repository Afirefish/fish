//
//  DevilCardInfo.h
//  Pretend
//
//  Created by 戴曦嘉 on 2017/10/26.
//  Copyright © 2017年 戴曦嘉. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, CardType) {
    RoleCard = 0,
    SustainedCard = 1,
    InstantCard = 2,
};

@interface DevilCardInfo : NSObject//卡牌对战机制依靠卡牌的特殊效果来消减对方或者对方卡牌的lp。
@property (assign,nonatomic) NSUInteger cardSequence;//卡牌序号
@property (strong,nonatomic) NSString *cardName;//卡牌名字
@property (assign,nonatomic) CardType cardType;//卡牌类型
@property (assign,nonatomic) NSUInteger cardLP;//卡牌的生命值
@property (assign,nonatomic) NSUInteger cardAttack;//攻击力
@property (strong,nonatomic) NSString *cardFunction;//卡牌的功能
@property (strong,nonatomic) NSString *cardImage;//卡牌的图片
@property (assign,nonatomic) BOOL isAvailable;//卡牌是否可用
@property (assign,nonatomic) BOOL isDeprecated;//是否已经废弃

// 根据卡牌序号初始化卡牌对象
- (instancetype)initWithCardSequence:(NSUInteger)cardSequence;

@end
