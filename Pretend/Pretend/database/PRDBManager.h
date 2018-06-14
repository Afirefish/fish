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

@interface PRDBManager : NSObject
// 数据库位置
@property (nonatomic, strong) NSString *databasePath;
@property (nonatomic, assign) int maxRow;

- (void)testDB;
// 创建数据库
- (BOOL)createDB:(NSString *)createSQL;
// 保存
- (BOOL)saveDB:(NSString *)update withContent:(NSString *)content;
// 加载
- (BOOL)loadDB:(NSString *)query;
// 删除
- (BOOL)deleteDB:(NSString *)delete table:(NSString *)table from:(int)fromRowID toID:(int)toRowID;

@end
