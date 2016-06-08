//
//  XZXDBHelper.h
//  IT Push
//
//  Created by xuzx on 16/4/13.
//  Copyright © 2016年 xuzx. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>

#define DBNAME @"ArticleInfo.sqlite"
#define DATE @"date"
#define ARTICLENAME @"articleName"
#define ICONURL @"articleImageURL"
#define ARTICLEURL @"articleURL"
@class XZXMainModel;

static sqlite3 *dataBase;
@interface XZXDBHelper : NSObject

+ (sqlite3 *)createDatabasePath;

+ (void)deleteValue:(XZXMainModel *)model withDB:(sqlite3 *)db;

+ (void)insertValueWithModel:(XZXMainModel *)model withDB:(sqlite3 *)db;

+ (NSMutableArray *)selectValue:(sqlite3 *)db withPage:(NSInteger)page;

+ (BOOL)ifExistModel:(XZXMainModel *)model withDB:(sqlite3 *)db;

@end
