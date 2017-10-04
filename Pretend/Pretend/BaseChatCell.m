//
//  BaseChatCell.m
//  Pretend
//
//  Created by 戴曦嘉 on 2017/9/29.
//  Copyright © 2017年 戴曦嘉. All rights reserved.
//

#import "BaseChatCell.h"

@implementation BaseChatCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier devil:(BOOL)isDevil{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        if (isDevil == YES) {
            self.textLabel.text = @"Santa";
            self.imageView.image = [UIImage imageNamed:@"santa.png"];
        } else {
            self.textLabel.text = @"the choosed answer";
            self.contentView.backgroundColor = [UIColor clearColor];
        }
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
