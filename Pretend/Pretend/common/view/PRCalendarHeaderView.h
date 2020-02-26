//
//  PRCalendarHeaderView.h
//  Pretend
//
//  Created by xijia dai on 2019/12/10.
//  Copyright © 2019 戴曦嘉. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface PRCalendarHeaderView : UIView

- (instancetype)initWithItems:(NSArray *)items;

- (void)setTitle:(NSString *)title forSegmentAtIndex:(NSArray<NSNumber *> *)index;

- (void)setTitleColor:(UIColor *)color forSegmentAtIndex:(NSArray<NSNumber *> *)index;

@end

NS_ASSUME_NONNULL_END
