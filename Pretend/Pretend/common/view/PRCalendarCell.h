//
//  PRCalendarCell.h
//  Pretend
//
//  Created by xijia dai on 2019/12/11.
//  Copyright © 2019 戴曦嘉. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface PRCalendarCell : UICollectionViewCell

- (void)updateNumber:(NSInteger)number enable:(BOOL)enable;

@end

NS_ASSUME_NONNULL_END
