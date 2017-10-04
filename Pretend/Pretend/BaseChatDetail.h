//
//  BaseChatDetail.h
//  Pretend
//
//  Created by 戴曦嘉 on 2017/9/29.
//  Copyright © 2017年 戴曦嘉. All rights reserved.
//

//聊天的具体内容控制基类
#import <UIKit/UIKit.h>

@class DevilChatContent,ChooseRespondToDevil;

@interface BaseChatDetail : UIViewController

@property (strong,nonatomic) DevilChatContent *chatContent;//聊天的具体内容
@property (strong,nonatomic) ChooseRespondToDevil *chooseContent;//选择回复的bar
@property (assign,nonatomic) NSInteger nodeNumber;//当前聊天所具有的节点数
@property (strong,nonatomic) UIButton *chooseRespond;//bar的响应按钮
@property (strong,nonatomic) DevilChatContent *choices;//选项的具体内容
@property (assign,nonatomic) BOOL isDevil;//当前节点是否是恶魔
@property (assign,nonatomic) CGFloat cellHeight;//当前聊天的高度
@property (assign,nonatomic) CGFloat offSetHeight;//内容偏移的高度
+ (instancetype)chatDetail;
- (void)setRespondBar;
- (void)recoverRespondBar;
- (void)showChoices;
- (void)removeChoicesView;
- (void)sendMessage;
- (void)devilRespond;

@end
