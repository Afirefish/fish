//
//  PufuChoice.m
//  Pretend
//
//  Created by 戴曦嘉 on 2017/10/10.
//  Copyright © 2017年 戴曦嘉. All rights reserved.
//

#import "PufuChoice.h"

@implementation PufuChoice

//初始化玩家的选择的cell
- (instancetype) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier message:(NSString *)message {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.textLabel.text = message;
        self.textLabel.numberOfLines = 0;
        self.textLabel.lineBreakMode = NSLineBreakByWordWrapping;
    }
    return self;
}

@end
