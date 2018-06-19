//
//  PRDBManager.h
//  Pretend
//
//  Created by daixijia on 2018/6/14.
//  Copyright © 2018年 戴曦嘉. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>
#import "PRConstantSQL.h"
#import "DevilCardInfo.h"

@interface PRDBManager : NSObject
// 数据库位置,使用前请先初始化这个
@property (nonatomic, strong) NSString *databasePath;
@property (nonatomic, strong) NSString *plotDBPath;
@property (nonatomic, strong) NSString *cardDBPath;
@property (nonatomic, assign) int maxRow;

- (void)testDB;
// 创建数据库
- (BOOL)createDB:(NSString *)createSQL;
// 保存plot
- (BOOL)savePlotDB:(NSString *)update withContent:(NSString *)content;
// 保存card
- (BOOL)saveCardDB:(NSString *)update sequence:(int)sequence name:(NSString *)name type:(int)type lifePoint:(int)LP attack:(int)attack function:(NSString *)function image:(NSString *)image available:(int)available deprecated:(int)deprecated;
// 更新card可用
- (DevilCardInfo *)updateCardDB:(NSString *)update sequence:(int)sequence available:(int)available;
// 加载plot
- (BOOL)loadPlotDB:(NSString *)query;
// 加载card
- (DevilCardInfo *)loadCardInfo:(NSString *)query sequence:(int)sequence;
// 删除
- (BOOL)deleteDB:(NSString *)deleteSql table:(NSString *)table from:(int)fromRowID toID:(int)toRowID clearSeq:(BOOL)clear;

@end
