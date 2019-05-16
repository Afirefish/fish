//
//  FeatureViewController.h
//  Pretend
//
//  Created by daixijia on 2018/1/24.
//  Copyright © 2018年 戴曦嘉. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/**
 初始控制器
 */
@interface FeatureViewController : UIViewController

- (void)stopPlay:(void (^ __nullable)(void))completion;

@end

NS_ASSUME_NONNULL_END
