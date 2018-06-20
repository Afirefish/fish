//
//  BaseChatTableViewCell.m
//  Pretend
//
//  Created by 戴曦嘉 on 2017/9/29.
//  Copyright © 2017年 戴曦嘉. All rights reserved.
//

#import "BaseChatTableViewCell.h"
#import <Masonry.h>

@interface BaseChatTableViewCell ()

@end

@implementation BaseChatTableViewCell

- (void)updateWithModel:(BaseChatModel *)model {
    self.backgroundColor = [UIColor clearColor];
    self.contentView.backgroundColor = [UIColor clearColor];
    self.textLabel.numberOfLines = 0;
    self.textLabel.lineBreakMode = NSLineBreakByWordWrapping;
    self.textLabel.text = model.message;
    self.textLabel.textColor = [UIColor whiteColor];
    self.textLabel.font = [UIFont systemFontOfSize:17.0];
    
    if (model.isDevil == YES && model.isChoice == YES && model.devil) {
        self.textLabel.textAlignment = NSTextAlignmentLeft;
        // 修改头像大小固定为40*40
        self.imageView.image = [UIImage imageNamed:model.devil];
        CGSize imageSize = CGSizeMake(35, 35);
        UIGraphicsBeginImageContext(imageSize);
        CGRect imageRect = CGRectMake(0, 0, imageSize.width, imageSize.height);
        [self.imageView.image drawInRect:imageRect];
        self.imageView.image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    }
    else if (model.isDevil == NO && model.isChoice == YES) {
        self.textLabel.textAlignment = NSTextAlignmentRight;
        self.imageView.image = nil;
    }
    else {
        self.textLabel.textAlignment = NSTextAlignmentCenter;
        self.imageView.image = nil;
    }
}

@end
