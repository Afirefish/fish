//
//  ChatRoomCell.m
//  Pretend
//
//  Created by daixijia on 2017/12/13.
//  Copyright © 2017年 戴曦嘉. All rights reserved.
//

#import "ChatRoomCell.h"
#import "UIColor+PRCustomColor.h"
#import <Masonry.h>

NS_ASSUME_NONNULL_BEGIN

@implementation ChatRoomCell

- (void)setFrame:(CGRect)frame {
    CGFloat gap = 10;
    //frame.origin.x = 10;//这里间距为10，可以根据自己的情况调整
    //frame.size.width -= 2 * frame.origin.x;
    frame.size.height -= 2 * gap;
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = 8.0;
    [super setFrame:frame];
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(nullable NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupView];
    }
    return self;
}

- (void)setupView {
    self.backgroundColor = [UIColor warmShellColor];
    // 设置头像
    self.headImageView = ({
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.clipsToBounds = YES;
        imageView.layer.cornerRadius = 8.0;
        imageView;
    });
    [self.contentView addSubview:self.headImageView];
    [self.headImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(self.contentView).offset(5.0);
        make.bottom.equalTo(self.contentView).offset(-5.0);
        make.width.equalTo(self.headImageView.mas_height);
    }];
    // 设置背景视图
    self.backgroundImageView = ({
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.clipsToBounds = YES;
        imageView.layer.cornerRadius = 8.0;
        imageView;
    });
    [self.contentView addSubview:self.backgroundImageView];
    [self.contentView sendSubviewToBack:self.backgroundImageView];
    [self.backgroundImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.headImageView.mas_right).offset(5.0);
        make.top.right.bottom.equalTo(self.contentView);
    }];
    
    // 设置名字
    self.nameLabel = ({
        UILabel *label = [[UILabel alloc] init];
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = [UIColor whiteColor];
        label.font = [UIFont systemFontOfSize:24];
        label;
    });
    [self.contentView addSubview:self.nameLabel];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.headImageView.mas_top);
        make.left.equalTo(self.headImageView.mas_right).offset(15.0);
        make.height.equalTo(@30.0);
        make.width.equalTo(@60.0);
    }];
    // 设置当前剧情进度信息
    self.messageLabel = ({
        UILabel *label = [[UILabel alloc] init];
        label.textAlignment = NSTextAlignmentLeft;
        label.textColor = [UIColor whiteColor];
        label.font = [UIFont systemFontOfSize:12];
        label;
    });
    [self.contentView addSubview:self.messageLabel];
    [self.messageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.right.equalTo(self.contentView).offset(-15.0);
        make.top.equalTo(self.contentView.mas_centerY);
        make.left.equalTo(self.nameLabel);
    }];
    // 设置当前剧情是否是当前cell
    self.sign = ({
        UILabel *label = [[UILabel alloc] init];
        label.text = @"🐟";
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = [UIColor greenColor];
        label.font = [UIFont systemFontOfSize:12];
        label.hidden = YES;
        label;
    });
    [self.contentView addSubview:self.sign];
    [self.sign mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView).offset(-15.0);
        make.top.equalTo(self.contentView).offset(15.0);
        make.height.width.equalTo(@20.0);
    }];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

NS_ASSUME_NONNULL_END
