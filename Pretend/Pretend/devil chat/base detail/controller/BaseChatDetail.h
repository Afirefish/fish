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
#import "BaseMgr.h"
#import "BaseChatTableViewCell.h"
#import "BaseChoiceCollectionViewCell.h"
#import "UIColor+PRCustomColor.h"
#import "PRBGMPlayer.h"

NS_ASSUME_NONNULL_BEGIN

/*
 *基本的控制器，如果实现新的章节，建议继承这个控制器来定义
 命名方式参考目前的几个控制器的命名 章节名+ChatDetail以及章节名+Mgr
 */

@interface BaseChatDetail : UIViewController<UITableViewDelegate,UITableViewDataSource,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
/*
 *view部分
 */
@property (strong, nonatomic) UITableView *chatContentTableView;//聊天的具体内容
@property (strong, nonatomic, nullable) UIImageView *tableBackgroundView;//聊天的背景
@property (strong, nonatomic) UIView *overlayView; // 蒙版视图，用于显示文字
@property (strong, nonatomic) UICollectionView *choicesCollectionView;//玩家选项集合
@property (strong, nonatomic, nullable) UIImageView *collectionBackgroudView;//玩家选项的背景视图
@property (strong, nonatomic) UICollectionViewFlowLayout *layout;//流布局
@property (strong, nonatomic) UILabel *coverLabel;//覆盖的label

/*
 *data部分
 */
@property (strong, nonatomic) BaseMgr *chatMgr;

- (void)setupSubviews;//设置子视图
- (void)setupContentViews;//设置内容视图
- (void)setupBackgroundImage;//设置背景图片
- (void)setupCoverLabel;//设置选项的mask视图

- (void)playBGM; //播放音乐
- (void)sendMessage;//玩家做出选择的消息
- (void)devilRespond;//对方的回复

@end

NS_ASSUME_NONNULL_END
