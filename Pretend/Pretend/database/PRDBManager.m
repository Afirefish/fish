//
//  PRDBManager.m
//  Pretend
//
//  Created by daixijia on 2018/6/14.
//  Copyright © 2018年 戴曦嘉. All rights reserved.
//

#import "PRDBManager.h"

NS_ASSUME_NONNULL_BEGIN

@implementation PRDBManager

- (void)testDB {
//    self.databasePath = self.plotDBPath;
//    [self createDB:createPlotsSQL];
//    [self savePlotDB:updatePlotsSQL withContent:@"第一句剧情"];
//    [self loadPlotDB:queryPlotsSQL];
//    [self deleteDB:deletePlotsSQL table:@"PLOTS" from:0 toID:self.maxRow clearSeq:YES];
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

- (BOOL)savePlotDB:(NSString *)update withContent:(NSString *)content {
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

- (BOOL)saveCardDB:(NSString *)update sequence:(int)sequence name:(NSString *)name type:(int)type lifePoint:(int)LP attack:(int)attack function:(NSString *)function image:(NSString *)image available:(int)available deprecated:(int)deprecated {
    sqlite3 *database;
    if (sqlite3_open([[self databasePath] UTF8String], &database) != SQLITE_OK) {
        sqlite3_close(database);
        NSAssert(0, @"Failed to open database");
    }
    
    char *errorMsg = NULL;
    sqlite3_stmt *stmt;
    if (sqlite3_prepare_v2(database, [update UTF8String], -1, &stmt, nil) == SQLITE_OK) {
        sqlite3_bind_int(stmt, 1, sequence);
        sqlite3_bind_text(stmt, 2, [name UTF8String], -1, NULL);
        sqlite3_bind_int(stmt, 3, type);
        sqlite3_bind_int(stmt, 4, LP);
        sqlite3_bind_int(stmt, 5, attack);
        sqlite3_bind_text(stmt, 6, [function UTF8String], -1, NULL);
        sqlite3_bind_text(stmt, 7, [image UTF8String], -1, NULL);
        sqlite3_bind_int(stmt, 8, available);
        sqlite3_bind_int(stmt, 9, deprecated);
    }
    if (sqlite3_step(stmt) != SQLITE_DONE) {
        NSAssert(0, @"Error updating table: %s", errorMsg);
    }
    sqlite3_finalize(stmt);
    sqlite3_close(database);
    return YES;
}

- (DevilCardInfo *)updateCardDB:(NSString *)update sequence:(int)sequence available:(int)available {
    sqlite3 *database;
    if (sqlite3_open([[self databasePath] UTF8String], &database) != SQLITE_OK) {
        sqlite3_close(database);
        NSAssert(0, @"Failed to open database");
    }
    
    sqlite3_stmt *statement;
    DevilCardInfo *card = [[DevilCardInfo alloc] init];
    if (sqlite3_prepare_v2(database, [update UTF8String], -1, &statement, nil) == SQLITE_OK) {
        sqlite3_bind_int(statement, 1, available);
        sqlite3_bind_int(statement, 2, sequence);
        if (sqlite3_step(statement) == SQLITE_DONE) {
            card.cardSequence = (NSUInteger)sqlite3_column_int(statement, 0);
            char *name = (char *)sqlite3_column_text(statement, 1);
            if (name) {
                card.cardName = [NSString stringWithUTF8String:name];
            }
            card.cardType = (NSUInteger)sqlite3_column_int(statement, 2);
            card.cardLP = (NSUInteger)sqlite3_column_int(statement, 3);
            card.cardAttack = (NSUInteger)sqlite3_column_int(statement, 4);
            char *function = (char *)sqlite3_column_text(statement, 5);
            if (function) {
                card.cardFunction = [NSString stringWithUTF8String:function];
            }
            char *image = (char *)sqlite3_column_text(statement, 6);
            if (image) {
                card.cardImage = [NSString stringWithUTF8String:image];
            }
            card.isAvailable = sqlite3_column_int(statement, 7) == 1?YES:NO;
            
            card.isDeprecated = sqlite3_column_int(statement, 8) == 1?YES:NO;
        }
        sqlite3_finalize(statement);
    }
    sqlite3_close(database);
    return card;
}



- (BOOL)loadPlotDB:(NSString *)query {
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

- (DevilCardInfo *)loadCardInfo:(NSString *)query sequence:(int)sequence {
    sqlite3 *database;
    if (sqlite3_open([[self databasePath] UTF8String], &database) != SQLITE_OK) {
        sqlite3_close(database);
        NSAssert(0, @"Failed to open database");
    }
    
    sqlite3_stmt *statement;
    DevilCardInfo *card = [[DevilCardInfo alloc] init];
    if (sqlite3_prepare_v2(database, [query UTF8String], -1, &statement, nil) == SQLITE_OK) {
        sqlite3_bind_int(statement, 1, sequence);
        if (sqlite3_step(statement) == SQLITE_ROW) {
            card.cardSequence = (NSUInteger)sqlite3_column_int(statement, 0);
            char *name = (char *)sqlite3_column_text(statement, 1);
            if (name) {
                card.cardName = [NSString stringWithUTF8String:name];
            }
            card.cardType = (NSUInteger)sqlite3_column_int(statement, 2);
            card.cardLP = (NSUInteger)sqlite3_column_int(statement, 3);
            card.cardAttack = (NSUInteger)sqlite3_column_int(statement, 4);
            char *function = (char *)sqlite3_column_text(statement, 5);
            if (function) {
                card.cardFunction = [NSString stringWithUTF8String:function];
            }
            char *image = (char *)sqlite3_column_text(statement, 6);
            if (image) {
                card.cardImage = [NSString stringWithUTF8String:image];
            }
            card.isAvailable = sqlite3_column_int(statement, 7) == 1?YES:NO;
     
            card.isDeprecated = sqlite3_column_int(statement, 8) == 1?YES:NO;
        }
        sqlite3_finalize(statement);
    }
    sqlite3_close(database);
    return card;
}

- (BOOL)deleteDB:(NSString *)deleteSql table:(NSString *)table from:(int)fromRowID toID:(int)toRowID clearSeq:(BOOL)clear {
    sqlite3 *database;
    if (sqlite3_open([[self databasePath] UTF8String], &database) != SQLITE_OK) {
        sqlite3_close(database);
        NSAssert(0, @"Failed to open database");
    }
    
    char *errorMsg = NULL;
    sqlite3_stmt *statement;
    for (int i = fromRowID; i <= toRowID; i++) {
        if (sqlite3_prepare_v2(database, [deleteSql UTF8String], -1, &statement, nil) == SQLITE_OK) {
            sqlite3_bind_int(statement, 1, i);
            if (sqlite3_step(statement) != SQLITE_DONE) {
                NSAssert(0, @"Error delete table: %s", errorMsg);
            }
        }
        sqlite3_finalize(statement);
    }
    if (clear) {
        NSString *clearSeq = @"UPDATE SQLITE_SEQUENCE SET SEQ = ? WHERE NAME = ?";
        if (sqlite3_prepare_v2(database, [clearSeq UTF8String], -1, &statement, nil) == SQLITE_OK) {
            sqlite3_bind_int(statement, 1, fromRowID - 1);
            sqlite3_bind_text(statement, 2, [table UTF8String], -1, NULL);
        }
        if (sqlite3_step(statement) != SQLITE_DONE) {
            NSAssert(0, @"Error delete table: %s", errorMsg);
        }
        sqlite3_finalize(statement);
    }
    sqlite3_close(database);
    return YES;
}

- (NSString *)plotDBPath {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    return [documentsDirectory stringByAppendingPathComponent:@"plots.sqlite"];
}

- (NSString *)cardDBPath {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    return [documentsDirectory stringByAppendingPathComponent:@"cards.sqlite"];
}

- (NSString *)databasePath {
    if (!_databasePath.length) {
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        return [documentsDirectory stringByAppendingPathComponent:@"plots.sqlite"];
    }
    return _databasePath;
}

@end

NS_ASSUME_NONNULL_END
