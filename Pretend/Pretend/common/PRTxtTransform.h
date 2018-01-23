//
//  PRTxtTransform.h
//  Pretend
//
//  Created by daixijia on 2018/1/9.
//  Copyright © 2018年 戴曦嘉. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PRTxtTransform : NSObject

/**
 首先规定特殊格式
 所有的特殊格式请作为单独的一行存在
 除了要标注特殊格式之外，小说文本可以比较随意，英文中文符号皆可,但不要有特殊格式（即使特殊格式穿插在文本里面也能正确解读）
 
 【1】故事开始格式：
 ALL START
 
 【2】故事结束格式:
 ALL END
 
 【3】章节开始格式（暂时不支持一个章节嵌套别的章节）：
(章节名／人物名) Chapter Begin
 例如：Santa Chapter Begin
 
 【4】章节结束格式：
 (章节名／人物名) Chapter End
 
 【5】分支开始格式（暂时不支持一个分支中嵌套分支）:
 (分支名) Branch Begin
 例如：First Branch Begin
 
 【6】具体分支，暂时只允许最多四个分支：
 例如：
 First Fork
 Second Fork
 Third Fork
 Fourth Fork
 
 【7】分支结束格式:
 (分支名) Branch End
 
 **/


/*
 *转换小说成为以句号，问号，感叹号，省略号为间隔，一句一句的文本
 */
- (void)transNovelToMyTxt;


/*
 *转换一句一句的文本成为plist文本
 */
- (void)transTXTToPlist;

@end

