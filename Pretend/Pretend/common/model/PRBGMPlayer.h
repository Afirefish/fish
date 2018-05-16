//
//  PRBGMPlayer.h
//  Pretend
//
//  Created by daixijia on 2018/2/8.
//  Copyright © 2018年 戴曦嘉. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

@interface PRBGMPlayer : NSObject

// 单例模式创建音乐播放器
+ (instancetype)defaultPlayer;
// 播放
- (void)play;
// 暂停
- (void)pause;
// 播放指定的URL
- (void)playWithFileURL:(NSURL *)url;
// 播放器销毁
- (void)destroy;

@end
