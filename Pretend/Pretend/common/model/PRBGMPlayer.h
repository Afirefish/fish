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

+ (instancetype)defaultPlayer;
- (void)play;
- (void)pause;
- (void)playWithFileURL:(NSURL *)url;
- (void)destroy;

@end
