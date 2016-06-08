//
//  XZXDBHelper.m
//  IT Push
//
//  Created by xuzx on 16/4/13.
//  Copyright © 2016年 xuzx. All rights reserved.
//

#import "XZXDBHelper.h"
#import "XZXMainModel.h"
#define databasePath ([[[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject] stringByAppendingPathComponent:DBNAME] UTF8String])

@implementation XZXDBHelper

//创建并返回一个数据库
+ (sqlite3 *)createDatabasePath{
    
//    XZXLog(@"%s", databasePath);
    
    if(sqlite3_open(databasePath, &dataBase) != SQLITE_OK){
//        XZXLog(@"%zd", sqlite3_open(databasePath, &dataBase));
        sqlite3_close(dataBase);
        
    }
    [XZXDBHelper execSql:[NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS ARTICLEINFO(ID INTEGER PRIMARY KEY AUTOINCREMENT, %@ TEXT, %@ TEXT, %@ TEXT, %@ TEXT)", DATE, ARTICLENAME, ICONURL, ARTICLEURL] withSqlite3:dataBase];
    return dataBase;
}

+ (BOOL)openDB:(sqlite3 *)db{
    if(sqlite3_open(databasePath, &db) == SQLITE_OK){
        return YES;
    }else{
    
        sqlite3_close(db);
        return NO;
    }
}

//查询数据库中是否存在某一模型的方法
+ (BOOL)ifExistModel:(XZXMainModel *)model withDB:(sqlite3 *)db{
        const char *sql = [[NSString stringWithFormat:@"SELECT articleImageURL FROM ARTICLEINFO WHERE articleImageURL = '%@'", model.articleImageURL] UTF8String];
        
        sqlite3_stmt *stmt = NULL;
        
        int result = sqlite3_prepare_v2(db, sql, -1, &stmt, NULL);
        
        int step = sqlite3_step(stmt);
        if((result == SQLITE_OK) && (step == SQLITE_ROW)){
            return YES;
            
        }
    
    return NO;
}

//执行插入模型的语句
+ (void)insertValueWithModel:(XZXMainModel *)model withDB:(sqlite3 *)db{
    const char *sql = [[NSString stringWithFormat:@"SELECT articleImageURL FROM ARTICLEINFO WHERE articleImageURL = '%@'", model.articleImageURL] UTF8String];
    
    sqlite3_stmt *stmt = NULL;
    
    int result = sqlite3_prepare_v2(db, sql, -1, &stmt, NULL);
    
    int step = sqlite3_step(stmt);
    
    if((result == SQLITE_OK) && (step != SQLITE_ROW)){
        
        [XZXDBHelper execSql:[NSString stringWithFormat:@"INSERT INTO ARTICLEINFO (%@, %@, %@, %@) VALUES('%@', '%@', '%@', '%@');", DATE, ARTICLENAME, ICONURL, ARTICLEURL, model.date, model.articleName, model.articleImageURL, model.articleURL] withSqlite3:db];
    }
    
}


+ (void)deleteValue:(XZXMainModel *)model withDB:(sqlite3 *)db{
        NSString *sql = [NSString stringWithFormat:@"DELETE FROM ARTICLEINFO WHERE articleImageURL = '%@'", model.articleImageURL];
        [XZXDBHelper execSql:sql withSqlite3:db];
}

//执行查询数据库的语句
+ (NSMutableArray *)selectValue:(sqlite3 *)db withPage:(NSInteger)page{
    NSMutableArray *array = [NSMutableArray array];
        const char *sql = [[NSString stringWithFormat:@"SELECT date, articleName, articleImageURL, articleURL FROM ARTICLEINFO LIMIT %zd, %zd;", page * likeCountPerPage, likeCountPerPage] UTF8String];
        
        sqlite3_stmt *stmt = NULL;
        if (sqlite3_prepare_v2(db, sql, -1, &stmt, NULL) == SQLITE_OK) {
            while (sqlite3_step(stmt) == SQLITE_ROW) {
                XZXMainModel *model = [[XZXMainModel alloc] init];
                NSString *date = [NSString stringWithCString:sqlite3_column_text(stmt, 0) encoding:NSUTF8StringEncoding];
                NSString *articleName = [NSString stringWithCString:sqlite3_column_text(stmt, 1) encoding:NSUTF8StringEncoding];
                NSString *articleImageURL = [NSString stringWithCString:sqlite3_column_text(stmt, 2) encoding:NSUTF8StringEncoding];
                NSString *articleURL = [NSString stringWithCString:sqlite3_column_text(stmt, 3) encoding:NSUTF8StringEncoding];
                model.date = ([date isEqualToString:@"(null)"])?@"":date;
                model.articleName = ([articleName isEqualToString:@"(null)"])?@"":articleName;
                model.articleImageURL = ([articleImageURL isEqualToString:@"(null)"])?@"":articleImageURL;
                model.articleURL = ([articleURL isEqualToString:@"(null)"])?@"":articleURL;
                [array addObject:model];
            }
        }
    
    return array;
}

+ (void)execSql:(NSString *)sql withSqlite3:(sqlite3 *)db{
    char *error;
    if(sqlite3_exec(db, [sql UTF8String], NULL, NULL, &error) != SQLITE_OK){
        sqlite3_close(db);
//        XZXLog(@"%s", error);
//        XZXLog(@"%zd", sqlite3_exec(db, [sql UTF8String], NULL, NULL, &error));
//        XZXLog(@"数据库加载错误!")
    }
}

@end
