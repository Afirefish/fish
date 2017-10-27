//
//  BaseChatDetail.h
//  Pretend
//
//  Created by 戴曦嘉 on 2017/9/29.
//  Copyright © 2017年 戴曦嘉. All rights reserved.
//

//聊天的具体内容控制基类
#import <UIKit/UIKit.h>

@class DevilChatContent,ChooseRespondToDevil,ChatRoomMgr;

@interface BaseChatDetail : UIViewController

@property (strong,nonatomic) DevilChatContent *chatContent;//聊天的具体内容
@property (strong,nonatomic) ChooseRespondToDevil *chooseContent;//选择回复的bar
@property (assign,nonatomic) NSInteger nodeNumber;//当前聊天所具有的节点数
@property (strong,nonatomic) DevilChatContent *choices;//选项的具体内容
@property (assign,nonatomic) BOOL isDevil;//当前节点是否是devil
@property (assign,nonatomic) NSString *playerChoice;//玩家的选择
@property (strong,nonatomic) NSArray *playerMessages;//玩家的回复数据包
@property (strong,nonatomic) NSArray *devilMessages;//devil的回复数据包
@property (strong,nonatomic) ChatRoomMgr *chatRoomMgr;

- (void)setSubViews;//设置子视图
- (void)setRespondBar;//设置respond bar选中之后的变化
- (void)recoverRespondBar;//恢复respond bar的初始状态
- (void)showChoices;//显示玩家的选项
- (void)removeChoicesView;//隐藏玩家的选项
- (void)sendMessage;//玩家做出选择的消息
- (void)devilRespond;//devil的回复
- (void)jsonData:(NSString *)devil;//json解析
@end
