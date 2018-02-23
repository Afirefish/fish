//
//  PRBGMPlayer.m
//  Pretend
//
//  Created by daixijia on 2018/2/8.
//  Copyright © 2018年 戴曦嘉. All rights reserved.
//

#import "PRBGMPlayer.h"

@interface PRBGMPlayer ()

@property (nonatomic, strong) NSURL *BGMURL;
@property (nonatomic, strong) AVAudioPlayer *player;

@end

@implementation PRBGMPlayer

static PRBGMPlayer *myPlayer = nil;
static dispatch_once_t onceToken;

+ (instancetype)defaultPlayer {
    dispatch_once(&onceToken, ^{
        myPlayer = [[PRBGMPlayer alloc] init];
    });
    return myPlayer;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        [self setupPlayer];
    }
    return self;
}

- (void)setupPlayer {
    NSError *error = nil;
    self.BGMURL = [[NSBundle mainBundle] URLForResource:@"bgm" withExtension:@"mp3"];
    self.player = [[AVAudioPlayer alloc] initWithContentsOfURL:self.BGMURL fileTypeHint:AVFileTypeMPEGLayer3 error:&error];
    if (error) {
        NSLog(@"error %@ occur when load bgm!",error.description);
        return;
    }
    self.player.numberOfLoops = -1;
    [self.player prepareToPlay];
    [self addNotify];
}

- (void)play {
    if (!self.player.isPlaying) {
        [self.player play];
    }
}

- (void)pause {
    if (self.player.isPlaying) {
        [self.player pause];
    }
}

- (void)playWithFileURL:(NSURL *)url {
    [self removeNotify];
    NSError *error = nil;
    [self.player stop];
    self.player = nil;
    self.BGMURL = url;
    self.player = [[AVAudioPlayer alloc] initWithContentsOfURL:self.BGMURL fileTypeHint:AVFileTypeMPEGLayer3 error:&error];
    if (error) {
        NSLog(@"error %@ occur when load bgm!",error.description);
        return;
    }
    [self.player prepareToPlay];
    [self addNotify];
    [self.player play];
}

- (void)dealWithInterrupt:(NSNotification *)notification {
    NSDictionary *info = notification.userInfo;
    AVAudioSessionInterruptionType type = [info[AVAudioSessionInterruptionTypeKey] integerValue];
    if (type == AVAudioSessionInterruptionTypeBegan) {
        [self pause];
    }
    if (type == AVAudioSessionInterruptionTypeEnded) {
        [self play];
    }
}

- (void)destroy {
    [self removeNotify];
    [self.player stop];
    self.player = nil;
    onceToken = 0;
    myPlayer = nil;
}

- (void)addNotify {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dealWithInterrupt:) name:AVAudioSessionInterruptionNotification object:[AVAudioSession sharedInstance]];
}

- (void)removeNotify {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:AVAudioSessionInterruptionNotification object:[AVAudioSession sharedInstance]];
}

@end
