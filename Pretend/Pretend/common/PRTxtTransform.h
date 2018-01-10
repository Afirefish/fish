//
//  PRTxtTransform.h
//  Pretend
//
//  Created by daixijia on 2018/1/9.
//  Copyright © 2018年 戴曦嘉. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PRTxtTransform : NSObject
@property (nonatomic, assign) NSInteger tapCount;
@property (nonatomic, assign) BOOL isChoice;
@property (nonatomic, assign) BOOL isDevil;
@property (nonatomic, assign) NSInteger nextStep;

@property (nonatomic, strong) NSString *plainFile;
@property (nonatomic, strong) NSString *devilFile;
@property (nonatomic, strong) NSString *playerFile;

@property (nonatomic, strong) NSString *plainFileDirectory;
@property (nonatomic, strong) NSString *devilFileDirectory;
@property (nonatomic, strong) NSString *playerFileDirectory;

@property (nonatomic, strong) NSString *test;

- (void)transTXTToJson;

@end
