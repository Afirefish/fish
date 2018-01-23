//
//  BaseChatDetail.h
//  Pretend
//
//  Created by 戴曦嘉 on 2017/9/29.
//  Copyright © 2017年 戴曦嘉. All rights reserved.
//

//聊天的具体内容控制基类
#import <UIKit/UIKit.h>
#import "BaseChatModel.h"
#import "BaseChatTableViewCell.h"
#import "BaseChoiceCollectionViewCell.h"
#import "UIColor+PRCustomColor.h"

@class ChatRoomMgr;

NS_ASSUME_NONNULL_BEGIN

@interface BaseChatDetail : UIViewController<UITableViewDelegate,UITableViewDataSource,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

/*
 *view部分
 */
@property (strong, nonatomic) UITableView *chatContentTableView;//聊天的具体内容
@property (strong, nonatomic, nullable) UIImageView *tableBackgroundView;//聊天的背景
@property (strong, nonatomic) UICollectionView *choicesCollectionView;//玩家选项集合
@property (strong, nonatomic, nullable) UIImageView *collectionBackgroudView;//玩家选项的背景视图
@property (strong, nonatomic) UICollectionViewFlowLayout *layout;//流布局
@property (strong, nonatomic) UILabel *coverLabel;//覆盖的label

/*
 *data部分
 */
@property (assign, nonatomic) BOOL isDevil;//当前节点是否是devil
@property (assign, nonatomic) NSUInteger finished;//100代表结束
@property (assign, nonatomic) NSUInteger previousStep;//上一步
@property (strong, nonatomic) NSArray *playerMessages;//玩家的回复数据包
@property (strong, nonatomic) NSArray *devilMessages;//devil的回复数据包
@property (strong, nonatomic) ChatRoomMgr *chatRoomMgr;

@property (nonatomic, assign) BOOL isChoice;// 当前是否是对话文本
@property (nonatomic, strong) NSArray *plainMsgs;// 普通文本
@property (nonatomic, strong) NSString *plainMsg; //  普通文本的消息
@property (nonatomic, assign) NSInteger nextStep; // 下一步

@property (assign, nonatomic) NSInteger choiceCount;//玩家选项数量
@property (assign, nonatomic) NSUInteger choiceIndex;//玩家选择的回复的索引
@property (strong, nonatomic) NSArray *choiceArr;//玩家所有选择的数组
@property (strong, nonatomic) NSDictionary *choiceDic;//玩家所有选择数组中的元素
@property (strong, nonatomic) NSString *playerChoice;//玩家的选择

@property (strong, nonatomic) NSArray *devilArr;//santa的回复的数组
@property (strong, nonatomic) NSDictionary *devilDic;//santa回复的字典
@property (strong, nonatomic) NSString *devilRespondContent;//santa的回复的信息字符串

// 缓存数据，解决复用问题
@property (strong, nonatomic) NSMutableArray *allCellHeight;//保存聊天记录的所有视图的高度
@property (strong, nonatomic) NSMutableArray<BaseChatModel *> *chatMessageList;

- (void)setupSubviews;//设置子视图
- (void)setupContentViews;//设置内容视图
- (void)setupBackgroundImage;//设置背景图片
- (void)setupCoverLabel;//设置选项的mask视图

- (void)sendMessage;//玩家做出选择的消息
- (void)devilRespond;//devil的回复

- (void)reset;//重置
@end

NS_ASSUME_NONNULL_END
