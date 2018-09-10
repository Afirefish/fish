//
//  PRBGMPlayer.m
//  Pretend
//
//  Created by daixijia on 2018/2/8.
//  Copyright © 2018年 戴曦嘉. All rights reserved.
//

#import "PRBGMPlayer.h"
#import <MediaPlayer/MediaPlayer.h>

NS_ASSUME_NONNULL_BEGIN

@interface PRBGMPlayer ()

@property (nonatomic, strong) NSURL *BGMURL;
@property (nonatomic, strong, nullable) AVAudioPlayer *player;

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
    [self setupAudioSession];
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

- (BOOL)isPlaying {
    return self.player.isPlaying;
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


- (void)setupAudioSession {
    //静音状态下播放
    [[AVAudioSession sharedInstance] setActive:YES error:nil];
    //处理电话打进时中断音乐播放
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(interruptionNotificationHandler:) name:AVAudioSessionInterruptionNotification object:nil];
    //后台播放
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
    
    // 在App启动后开启远程控制事件, 接收来自锁屏界面和上拉菜单的控制
    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
    // 处理远程控制事件
    [self remoteControlEventHandler];

}

//来电中断处理
- (void)interruptionNotificationHandler:(NSNotification*)notification {
    NSDictionary *interuptionDict = notification.userInfo;
    NSString *type = [NSString stringWithFormat:@"%@", [interuptionDict valueForKey:AVAudioSessionInterruptionTypeKey]];
    NSUInteger interuptionType = [type integerValue];
    
    if (interuptionType == AVAudioSessionInterruptionTypeBegan) {
        //获取中断前音乐是否在播放
        NSLog(@"AVAudioSessionInterruptionTypeBegan");
    }else if (interuptionType == AVAudioSessionInterruptionTypeEnded) {
        NSLog(@"AVAudioSessionInterruptionTypeEnded");
    }
    
    if(self.isPlaying)
    {
        //停止播放的事件
        [self play];
    }else {
        //继续播放的事件
        [self pause];
    }
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // 在App要终止前结束接收远程控制事件, 也可以在需要终止时调用该方法终止
    [application endReceivingRemoteControlEvents];
}

/**
 *  设置锁屏信息
 */
-(void)configNowPlayingInfoCenter {
    MPNowPlayingInfoCenter *playingInfoCenter = [MPNowPlayingInfoCenter defaultCenter];
    
    if (playingInfoCenter) {
        NSMutableDictionary *songInfo = [[NSMutableDictionary alloc] init];
        UIImage *image = [UIImage imageNamed:@"puri_black"];
        MPMediaItemArtwork *albumArt = [[MPMediaItemArtwork alloc] initWithBoundsSize:image.size requestHandler:^UIImage * _Nonnull(CGSize size) {
            return image;
        }];
        //歌曲名称
        [songInfo setObject:@"music" forKey:MPMediaItemPropertyTitle];
        //演唱者
        [songInfo setObject:@"daixijia" forKey:MPMediaItemPropertyArtist];
        //专辑名
        [songInfo setObject:@"album" forKey:MPMediaItemPropertyAlbumTitle];
        //专辑缩略图
        [songInfo setObject:albumArt forKey:MPMediaItemPropertyArtwork];
        //音乐当前已经播放时间
        NSInteger currentTime = self.player.currentTime;
        [songInfo setObject:[NSNumber numberWithInteger:currentTime] forKey:MPNowPlayingInfoPropertyElapsedPlaybackTime];
        //进度光标的速度 （这个随 自己的播放速率调整，我默认是原速播放）
        [songInfo setObject:[NSNumber numberWithFloat:1.0] forKey:MPNowPlayingInfoPropertyPlaybackRate];
        //歌曲总时间设置
        NSInteger duration = self.player.duration;
        [songInfo setObject:[NSNumber numberWithInteger:duration] forKey:MPMediaItemPropertyPlaybackDuration];
        //设置锁屏状态下屏幕显示音乐信息
        [[MPNowPlayingInfoCenter defaultCenter] setNowPlayingInfo:songInfo];
    }
}

// 在需要处理远程控制事件的具体控制器或其它类中实现
- (void)remoteControlEventHandler {
    // 直接使用sharedCommandCenter来获取MPRemoteCommandCenter的shared实例
    MPRemoteCommandCenter *commandCenter = [MPRemoteCommandCenter sharedCommandCenter];
    // 启用播放命令 (锁屏界面和上拉快捷功能菜单处的播放按钮触发的命令)
    commandCenter.playCommand.enabled = YES;
    // 为播放命令添加响应事件, 在点击后触发
    [commandCenter.playCommand addTargetWithHandler:^MPRemoteCommandHandlerStatus(MPRemoteCommandEvent * _Nonnull event) {
        [self play];
        [self configNowPlayingInfoCenter];
        return MPRemoteCommandHandlerStatusSuccess;
    }];
    // 播放, 暂停, 上下曲的命令默认都是启用状态, 即enabled默认为YES
    [commandCenter.pauseCommand addTargetWithHandler:^MPRemoteCommandHandlerStatus(MPRemoteCommandEvent * _Nonnull event) {
        //点击了暂停
        [self pause];
        [self configNowPlayingInfoCenter];
        return MPRemoteCommandHandlerStatusSuccess;
    }];
//    [commandCenter.previousTrackCommand addTargetWithHandler:^MPRemoteCommandHandlerStatus(MPRemoteCommandEvent * _Nonnull event) {
//        //点击了上一首
//        [[MusicPlayViewController shareMusicPlay] lastSongAction];
//        [[MusicPlayViewController shareMusicPlay] configNowPlayingInfoCenter];
//        return MPRemoteCommandHandlerStatusSuccess;
//    }];
//    [commandCenter.nextTrackCommand addTargetWithHandler:^MPRemoteCommandHandlerStatus(MPRemoteCommandEvent * _Nonnull event) {
//        //点击了下一首
//        [[MusicPlayViewController shareMusicPlay] nextSongButtonAction:nil];
//        [[MusicPlayViewController shareMusicPlay] configNowPlayingInfoCenter];
//        return MPRemoteCommandHandlerStatusSuccess;
//    }];
    // 启用耳机的播放/暂停命令 (耳机上的播放按钮触发的命令)
//    commandCenter.togglePlayPauseCommand.enabled = YES;
//    // 为耳机的按钮操作添加相关的响应事件
//    [commandCenter.togglePlayPauseCommand addTargetWithHandler:^MPRemoteCommandHandlerStatus(MPRemoteCommandEvent * _Nonnull event) {
//        // 进行播放/暂停的相关操作 (耳机的播放/暂停按钮)
//        [[MusicPlayViewController shareMusicPlay] playPauseButtonAction:nil];
//        [[MusicPlayViewController shareMusicPlay] configNowPlayingInfoCenter];
//        return MPRemoteCommandHandlerStatusSuccess;
//    }];
}

- (void)applicationWillResignActive {
    //后台播放音频设置
    AVAudioSession *session = [AVAudioSession sharedInstance];
    [session setActive:YES error:nil];
    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
    [self configNowPlayingInfoCenter];
}

- (void)addNotify {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dealWithInterrupt:) name:AVAudioSessionInterruptionNotification object:[AVAudioSession sharedInstance]];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationWillResignActive) name:UIApplicationWillResignActiveNotification object:nil];
}

- (void)removeNotify {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:AVAudioSessionInterruptionNotification object:[AVAudioSession sharedInstance]];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationWillResignActiveNotification object:[AVAudioSession sharedInstance]];
}

@end

NS_ASSUME_NONNULL_END
