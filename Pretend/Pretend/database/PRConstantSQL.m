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

NSString * const queryPlotsSQL = @"SELECT * FROM PLOTS ORDER BY ID;";

NSString * const deletePlotsSQL =  @"DELETE FROM PLOTS WHERE ID = ?;";


NSString * const createCardsSQL = @"CREATE TABLE IF NOT EXISTS CARDS "
                                    "(SEQUENCE INTEGER PRIMARY KEY, NAME TEXT, TYPE INTEGER, LP INTEGER, ATTACK INTEGER, FUNCTION TEXT DEFAULT '', IMAGE TEXT, AVAILABLE INTEGER DEFAULT 1, DEPRECATED INTEGER DEFAULT 0);";

NSString * const updateCardsSQL = @"INSERT OR REPLACE INTO CARDS (SEQUENCE,NAME,TYPE,LP,ATTACK,FUNCTION,IMAGE,AVAILABLE,DEPRECATED) "
                                    "VALUES (?,?,?,?,?,?,?,?,?);";

NSString * const updateCardAvailable = @"UPDATE CARDS SET AVAILABLE = ? WHERE SEQUENCE = ?;";

NSString * const queryCardsSQL = @"SELECT * FROM CARDS WHERE SEQUENCE = ?;";

NSString * const deleteCardsSQL = @"DELETE FROM CARDS WHERE SEQUENCE = ?;";

NSString * const updateSeqSQL = @"UPDATE SQLITE_SEQUENCE SET SEQ = ? WHERE NAME = ?;";

