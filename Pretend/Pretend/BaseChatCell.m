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

//重写了初始化方法，可以根据参数来初始化devil的cell或者玩家的cell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier devil:(BOOL)isDevil message:(NSString *)message respond:(NSString *)respond{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.textLabel.numberOfLines = 0;
        self.textLabel.lineBreakMode = NSLineBreakByWordWrapping;
        if (isDevil == YES) {
            self.textLabel.text = @"Devil";
            self.imageView.image = [UIImage imageNamed:@"santa.png"];
            //修改头像大小固定为40*40
            CGSize imageSize = CGSizeMake(40, 40);
            UIGraphicsBeginImageContext(imageSize);
            CGRect imageRect = CGRectMake(0, 0, imageSize.width, imageSize.height);
            [self.imageView.image drawInRect:imageRect];
            self.imageView.image = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
        } else {
            self.textLabel.text = message;
            self.textLabel.textAlignment = NSTextAlignmentRight;
            self.contentView.backgroundColor = [UIColor clearColor];
        }
    }
    return self;
}

@end