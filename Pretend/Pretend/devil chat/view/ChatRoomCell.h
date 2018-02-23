//
//  ChatRoomCell.h
//  Pretend
//
//  Created by daixijia on 2017/12/13.
//  Copyright © 2017年 戴曦嘉. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN


/*
 *不同章节的cell，可以对应不同背景图片
 */
@interface ChatRoomCell : UITableViewCell

@property (nonatomic, strong) UIImageView *backgroundImageView; //背景图片
@property (nonatomic, strong) UILabel *nameLabel;               //章节名
@property (nonatomic, strong) UILabel *sign;                    //当前剧情在的章节位置
@property (nonatomic, strong) UIImageView *headImageView;       //章节主要人物头像
@property (nonatomic, strong) UILabel *messageLabel;            //章节主要人物名

@end

NS_ASSUME_NONNULL_END
