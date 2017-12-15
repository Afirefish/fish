//
//  ChatRoomCell.h
//  Pretend
//
//  Created by daixijia on 2017/12/13.
//  Copyright © 2017年 戴曦嘉. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ChatRoomCell : UITableViewCell
@property (nonatomic, strong) UIImageView *backgroundImageView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *sign;
@property (nonatomic, strong) UIImageView *headImageView;
@property (nonatomic, strong) UILabel *messageLabel;

@end

NS_ASSUME_NONNULL_END
