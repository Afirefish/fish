//
//  PRConstantSQL.m
//  Pretend
//
//  Created by daixijia on 2018/6/14.
//  Copyright © 2018年 戴曦嘉. All rights reserved.
//

#import "PRConstantSQL.h"

NSString * const createPlotsSQL = @"CREATE TABLE IF NOT EXISTS PLOTS "
                                    "(ID INTEGER PRIMARY KEY AUTOINCREMENT, CONTENT TEXT);";

NSString * const updatePlotsSQL = @"INSERT OR REPLACE INTO PLOTS (CONTENT) "
                                    "VALUES (?);";

NSString * const queryPlotsSQL = @"SELECT * FROM PLOTS ORDER BY ID";

NSString * const deletePlotsSQL =  @"DELETE FROM PLOTS WHERE ID = ?";

NSString * const updateSeqSQL = @"UPDATE SQLITE_SEQUENCE SET SEQ = ? WHERE NAME = ?";

