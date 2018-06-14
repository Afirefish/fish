//
//  PRDBManager.m
//  Pretend
//
//  Created by daixijia on 2018/6/14.
//  Copyright © 2018年 戴曦嘉. All rights reserved.
//

#import "PRDBManager.h"

@implementation PRDBManager

- (void)testDB {
//    [self createDB:createPlotsSQL];
//    [self saveDB:updatePlotsSQL withContent:@"第一句剧情"];
//    [self saveDB:updatePlotsSQL withContent:@"第二句剧情"];
//    [self saveDB:updatePlotsSQL withContent:@"第三句剧情"];
//    [self saveDB:updatePlotsSQL withContent:@"第四句剧情"];
//    [self saveDB:updatePlotsSQL withContent:@"第五句剧情"];
//    [self saveDB:updatePlotsSQL withContent:@"第六句剧情"];
//    [self saveDB:updatePlotsSQL withContent:@"第七句剧情"];
//
//    [self loadDB:queryPlotsSQL];
//    NSLog(@"max row %d", self.maxRow);
//    [self deleteDB:deletePlotsSQL table:@"PLOTS" from:3 toID:self.maxRow];
//
//    [self loadDB:queryPlotsSQL];
}

- (BOOL)createDB:(NSString *)createSQL {
    sqlite3 *database;
    if (sqlite3_open([[self databasePath] UTF8String], &database) != SQLITE_OK) {
        sqlite3_close(database);
        NSAssert(0, @"Failed to open database");
    }

    char *errorMsg;
    if (sqlite3_exec (database, [createSQL UTF8String], NULL, NULL, &errorMsg) != SQLITE_OK) {
        sqlite3_close(database);
        NSAssert(0, @"Error creating table: %s", errorMsg);
    }
    sqlite3_close(database);
    return YES;
}

- (BOOL)saveDB:(NSString *)update withContent:(NSString *)content {
    sqlite3 *database;
    if (sqlite3_open([[self databasePath] UTF8String], &database) != SQLITE_OK) {
        sqlite3_close(database);
        NSAssert(0, @"Failed to open database");
    }
    
    char *errorMsg = NULL;
    sqlite3_stmt *stmt;
    if (sqlite3_prepare_v2(database, [update UTF8String], -1, &stmt, nil) == SQLITE_OK) {
        sqlite3_bind_text(stmt, 1, [content UTF8String], -1, NULL);
    }
    if (sqlite3_step(stmt) != SQLITE_DONE) {
        NSAssert(0, @"Error updating table: %s", errorMsg);
    }
    sqlite3_finalize(stmt);
    sqlite3_close(database);
    return YES;
}

- (BOOL)loadDB:(NSString *)query {
    sqlite3 *database;
    if (sqlite3_open([[self databasePath] UTF8String], &database) != SQLITE_OK) {
        sqlite3_close(database);
        NSAssert(0, @"Failed to open database");
    }
    
    sqlite3_stmt *statement;
    int ID = 0;
    if (sqlite3_prepare_v2(database, [query UTF8String], -1, &statement, nil) == SQLITE_OK) {
        while (sqlite3_step(statement) == SQLITE_ROW) {
            ID = sqlite3_column_int(statement, 0);
            char *data = (char *)sqlite3_column_text(statement, 1);
            NSString *content = [NSString stringWithUTF8String:data];
            NSLog(@"the plots ID : %d  data : %@", ID, content);
        }
        self.maxRow = ID;
        sqlite3_finalize(statement);
    }
    sqlite3_close(database);
    return YES;
}

- (BOOL)deleteDB:(NSString *)delete table:(NSString *)table from:(int)fromRowID toID:(int)toRowID {
    sqlite3 *database;
    if (sqlite3_open([[self databasePath] UTF8String], &database) != SQLITE_OK) {
        sqlite3_close(database);
        NSAssert(0, @"Failed to open database");
    }
    
    char *errorMsg = NULL;
    sqlite3_stmt *statement;
    for (int i = fromRowID; i <= toRowID; i++) {
        if (sqlite3_prepare_v2(database, [delete UTF8String], -1, &statement, nil) == SQLITE_OK) {
            sqlite3_bind_int(statement, 1, i);
            if (sqlite3_step(statement) != SQLITE_DONE) {
                NSAssert(0, @"Error delete table: %s", errorMsg);
            }
        }
        sqlite3_finalize(statement);
    }
    
    NSString *clearSeq = @"UPDATE SQLITE_SEQUENCE SET SEQ = ? WHERE NAME = ?";
    if (sqlite3_prepare_v2(database, [clearSeq UTF8String], -1, &statement, nil) == SQLITE_OK) {
        sqlite3_bind_int(statement, 1, fromRowID - 1);
        sqlite3_bind_text(statement, 2, [table UTF8String], -1, NULL);
    }
    if (sqlite3_step(statement) != SQLITE_DONE) {
        NSAssert(0, @"Error delete table: %s", errorMsg);
    }
    sqlite3_finalize(statement);
    sqlite3_close(database);
    return YES;
}

- (NSString *)databasePath {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    return [documentsDirectory stringByAppendingPathComponent:@"plots.sqlite"];
}

@end
