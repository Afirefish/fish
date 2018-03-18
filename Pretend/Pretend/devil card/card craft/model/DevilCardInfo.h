//
//  DevilCardInfo.h
//  Pretend
//
//  Created by 戴曦嘉 on 2017/10/26.
//  Copyright © 2017年 戴曦嘉. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DevilCardInfo : NSObject//取消普通战斗机制，卡牌对战机制依靠卡牌的特殊效果来消减对方或者对方卡牌的lp，每损失一张卡牌，持有者的lp降低。
@property (assign,nonatomic) NSUInteger *cardSequence;//卡牌序号
@property (strong,nonatomic) NSString *cardName;//卡牌名字
@property (assign,nonatomic) NSUInteger *cardType;//卡牌类型
@property (assign,nonatomic) NSUInteger *cardLP;//卡牌的生命值
@property (strong,nonatomic) NSString *cardFunction;//卡牌的功能
@property (strong,nonatomic) UIImage *cardImage;//卡牌的图片
@property (assign,nonatomic) BOOL isDeprecated;//是否已经废弃

@end
