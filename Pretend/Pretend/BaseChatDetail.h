//
//  BaseChatDetail.h
//  Pretend
//
//  Created by 戴曦嘉 on 2017/9/29.
//  Copyright © 2017年 戴曦嘉. All rights reserved.
//

//聊天的具体内容控制基类
#import <UIKit/UIKit.h>

@class BaseChatTableView,ChatRoomMgr,BaseChoiceCollectionView;

@interface BaseChatDetail : UIViewController<UITableViewDelegate,UITableViewDataSource,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property (strong,nonatomic) BaseChatTableView *chatContent;//聊天的具体内容
@property (assign,nonatomic) NSInteger nodeNumber;//当前聊天所具有的节点数
@property (assign,nonatomic) BOOL isDevil;//当前节点是否是devil
@property (strong,nonatomic) NSString *playerChoice;//玩家的选择
@property (strong,nonatomic) NSArray *playerMessages;//玩家的回复数据包
@property (strong,nonatomic) NSArray *devilMessages;//devil的回复数据包
@property (strong,nonatomic) ChatRoomMgr *chatRoomMgr;
@property (strong,nonatomic) UILabel *coverLabel;//覆盖的label
@property (strong,nonatomic) BaseChoiceCollectionView *choicesCollectionView;//玩家选项集合
@property (strong,nonatomic) UICollectionViewFlowLayout *layout;//流布局
@property (assign,nonatomic) NSInteger choiceCount;//玩家选项数量
@property (strong,nonatomic) NSArray *choiceArr;//玩家所有选择的数组
@property (strong,nonatomic) NSDictionary *choiceDic;//玩家所有选择数组中的元素
@property (strong,nonatomic) NSString *choiceContent;//玩家选择字典中具体的信息字符串
@property (assign,nonatomic) NSUInteger finished;//100代表结束
@property (assign,nonatomic) NSUInteger choiceIndex;//玩家选择的回复的索引
@property (assign,nonatomic) NSUInteger previousStep;//上一步
@property (strong,nonatomic) NSArray *devilArr;//santa的回复的数组
@property (strong,nonatomic) NSDictionary *devilDic;//santa回复的字典
@property (strong,nonatomic) NSString *devilRespondContent;//santa的回复的信息字符串
@property (strong,nonatomic) NSMutableArray *allCellHeight;//保存聊天记录的所有视图的高度

- (void)setSubViews;//设置子视图
- (void)sendMessage;//玩家做出选择的消息
- (void)devilRespond;//devil的回复
- (void)jsonData:(NSString *)devil;//json解析
@end
