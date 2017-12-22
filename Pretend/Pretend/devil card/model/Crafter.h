//
//  Crafter.h
//  Pretend
//
//  Created by 戴曦嘉 on 2017/10/26.
//  Copyright © 2017年 戴曦嘉. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Crafter : NSObject
@property (assign,nonatomic) NSUInteger lifePoint;//对战者的生命值
@property (assign,nonatomic) BOOL isDefeated;//是否已经被击败
@property (strong,nonatomic) NSString *name;//对战者的名字
@property (strong,nonatomic) NSString *crafterInfo;//对战者的描述

@end
