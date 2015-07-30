//
//  DBManager.m
//  DBTest
//
//  Created by Ivan Gnatyuk on 14.07.14.
//  Copyright (c) 2014 dalein. All rights reserved.
//

#import "DBManager.h"
#import "FMDatabase.h"


@implementation DBManager {
    sqlite3 *myDB;
}

///*
- (NSArray *)getMorseDicts {
    
    NSArray *arrMorseDicts = @[ @{@"morseCode" : @".-", @"value" : @{@"en" : @"a", @"ru" : @"а"}},
                                @{@"morseCode" : @"-...", @"value" : @{@"en" : @"b", @"ru" : @"б"}},
                                @{@"morseCode" : @".--", @"value" : @{@"en" : @"w", @"ru" : @"в"}},
                                @{@"morseCode" : @"--.", @"value" : @{@"en" : @"g", @"ru" : @"г"}},
                                @{@"morseCode" : @"-..", @"value" : @{@"en" : @"d", @"ru" : @"д"}},
                                @{@"morseCode" : @".", @"value" : @{@"en" : @"e", @"ru" : @"е"}},
                                @{@"morseCode" : @"...-", @"value" : @{@"en" : @"v", @"ru" : @"ж"}},
                                @{@"morseCode" : @"--..", @"value" : @{@"en" : @"z", @"ru" : @"з"}},
                                @{@"morseCode" : @"..", @"value" : @{@"en" : @"i", @"ru" : @"и"}},
                                @{@"morseCode" : @".---", @"value" : @{@"en" : @"j", @"ru" : @"й"}},
                                @{@"morseCode" : @"-.-", @"value" : @{@"en" : @"k", @"ru" : @"к"}},
                                @{@"morseCode" : @".-..", @"value" : @{@"en" : @"l", @"ru" : @"л"}},
                                @{@"morseCode" : @"--", @"value" : @{@"en" : @"m", @"ru" : @"м"}},
                                @{@"morseCode" : @"-.", @"value" : @{@"en" : @"n", @"ru" : @"н"}},
                                @{@"morseCode" : @"---", @"value" : @{@"en" : @"o", @"ru" : @"о"}},
                                @{@"morseCode" : @".--.", @"value" : @{@"en" : @"p", @"ru" : @"п"}},
                                @{@"morseCode" : @".-.", @"value" : @{@"en" : @"r", @"ru" : @"р"}},
                                @{@"morseCode" : @"...", @"value" : @{@"en" : @"s", @"ru" : @"с"}},
                                @{@"morseCode" : @"-", @"value" : @{@"en" : @"t", @"ru" : @"т"}},
                                @{@"morseCode" : @"..-", @"value" : @{@"en" : @"u", @"ru" : @"у"}},
                                @{@"morseCode" : @"..-.", @"value" : @{@"en" : @"f", @"ru" : @"ф"}},
                                @{@"morseCode" : @"....", @"value" : @{@"en" : @"h", @"ru" : @"х"}},
                                @{@"morseCode" : @"-.-.", @"value" : @{@"en" : @"c", @"ru" : @"ц"}},
                                @{@"morseCode" : @"---.", @"value" : @{@"en" : @"", @"ru" : @"ч"}},
                                @{@"morseCode" : @"----", @"value" : @{@"en" : @"", @"ru" : @"ш"}},
                                @{@"morseCode" : @"--.-", @"value" : @{@"en" : @"q", @"ru" : @"щ"}},
                                @{@"morseCode" : @"-.--", @"value" : @{@"en" : @"y", @"ru" : @"ы"}},
                                @{@"morseCode" : @"-..-", @"value" : @{@"en" : @"x", @"ru" : @"ь"}},
                                @{@"morseCode" : @"..-..", @"value" : @{@"en" : @"", @"ru" : @"э"}},
                                @{@"morseCode" : @"..--", @"value" : @{@"en" : @"", @"ru" : @"ю"}},
                                @{@"morseCode" : @".-.-", @"value" : @{@"en" : @"", @"ru" : @"я"}},
                                @{@"morseCode" : @".----", @"value" : @{@"en" : @"1", @"ru" : @"1"}},
                                @{@"morseCode" : @"..----", @"value" : @{@"en" : @"2", @"ru" : @"2"}},
                                @{@"morseCode" : @"...--", @"value" : @{@"en" : @"3", @"ru" : @"3"}},
                                @{@"morseCode" : @"....-", @"value" : @{@"en" : @"4", @"ru" : @"4"}},
                                @{@"morseCode" : @".....", @"value" : @{@"en" : @"5", @"ru" : @"5"}},
                                @{@"morseCode" : @"-....", @"value" : @{@"en" : @"6", @"ru" : @"6"}},
                                @{@"morseCode" : @"--...", @"value" : @{@"en" : @"7", @"ru" : @"7"}},
                                @{@"morseCode" : @"---..", @"value" : @{@"en" : @"8", @"ru" : @"8"}},
                                @{@"morseCode" : @"----.", @"value" : @{@"en" : @"9", @"ru" : @"9"}},
                                @{@"morseCode" : @"-----", @"value" : @{@"en" : @"0", @"ru" : @"0"}},
                                @{@"morseCode" : @"......", @"value" : @{@"en" : @".", @"ru" : @"."}},
                                @{@"morseCode" : @".-.-.-", @"value" : @{@"en" : @",", @"ru" : @","}},
                                @{@"morseCode" : @"---...", @"value" : @{@"en" : @":", @"ru" : @":"}},
                                @{@"morseCode" : @"-.-.-.-", @"value" : @{@"en" : @";", @"ru" : @";"}},
                                @{@"morseCode" : @"-.--.-", @"value" : @{@"en" : @"(", @"ru" : @"("}},
                                @{@"morseCode" : @".----.", @"value" : @{@"en" : @"'", @"ru" : @"'"}},
                                @{@"morseCode" : @".-..-.", @"value" : @{@"en" : @"""", @"ru" : @""""}},
                                @{@"morseCode" : @"-....-", @"value" : @{@"en" : @"-", @"ru" : @"-"}},
                                @{@"morseCode" : @"-..-.", @"value" : @{@"en" : @"/", @"ru" : @"/"}},
                                @{@"morseCode" : @"..--..", @"value" : @{@"en" : @"?", @"ru" : @"?"}},
                                @{@"morseCode" : @"--..--", @"value" : @{@"en" : @"!", @"ru" : @"!"}},
                                @{@"morseCode" : @".--.-.", @"value" : @{@"en" : @"@", @"ru" : @"@"}},
                              ];
    return arrMorseDicts;
    
}



- (void)initMorseAlphabetTable {
    
    // Build the path to the database file
    NSString * databasePath = [[NSString alloc] initWithString: [_strDBMainPath stringByAppendingPathComponent:[NSString stringWithFormat:@"myDB.db"]]];
    
    FMDatabase *database = [FMDatabase databaseWithPath:databasePath];
    [database open];
    
    NSArray *arrMorseDicts = [self getMorseDicts];
    for (int i = 0; i <arrMorseDicts.count; i++) {
        
        NSDictionary *dicCurrMorseSymbol = arrMorseDicts[i];
        NSDictionary *dictMorseValue = dicCurrMorseSymbol[@"value"];
        BOOL b = [database executeUpdate: @"INSERT INTO MorseAlphabet (morseCode, enStr, ruStr) VALUES (?,?,?)", dicCurrMorseSymbol[@"morseCode"], dictMorseValue[@"en"], dictMorseValue[@"ru"]];
        if (b) {
            NSLog(@"Add Morse symbol OK");
        }
        else {
            NSLog(@"Add Morse symbol fail");
        }
    }
    
    [database close];

}

+ (id)initDB {
    static DBManager *mySinglton = nil;
    @synchronized(self) {
        if (mySinglton == nil)
            mySinglton = [[self alloc] init];
    }
    return mySinglton;
}

- (id)init {
    if (self = [super init]) {
        [self myInit];
    }
    return self;
}

- (void)myInit {
        
        _strDBMainPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
        
        // Build the path to the database file
        NSString * databasePath = [[NSString alloc] initWithString: [_strDBMainPath stringByAppendingPathComponent:[NSString stringWithFormat:@"myDB.db"]]];
        
        NSFileManager *filemgr = [NSFileManager defaultManager];
        
        if ([filemgr fileExistsAtPath: databasePath ] == NO)
        {
            NSLog(@"БД нет - создаем");
            
            const char *dbpath = [databasePath UTF8String];
            
            if (sqlite3_open(dbpath, &myDB) == SQLITE_OK)
            {
                char *errMsg;
                
                //Prepares a SQL statement to create the contacts table in the database.
                const char *sql_stmt3 = "CREATE TABLE IF NOT EXISTS MorseAlphabet (morseCode STRING, enStr STRING, ruStr STRING)";
                
                if (sqlite3_exec(myDB, sql_stmt3, NULL, NULL, &errMsg) != SQLITE_OK)
                {
                    NSLog(@"Failed to create myPurposeTable table");
                }
                
                sqlite3_close(myDB);
                
                //Init MorseAlphabet
                [self initMorseAlphabetTable];

            }
            else {
                NSLog(@"Failed to open/create database");
            }
            
        }
        else {
            NSLog(@"БД есть");
        }
}

- (NSDictionary *)getMorseElementWithParams:(NSDictionary *)dictParams {
    
    //key : MorseSymbol || AlphabetSymbol
    //val : .-          || a
    
    
    NSString *dbPath = [[NSString alloc] initWithString: [_strDBMainPath stringByAppendingPathComponent:[NSString stringWithFormat:@"myDB.db"]]];
    FMDatabase *database = [FMDatabase databaseWithPath:dbPath];
    [database open];
    
    NSString * sqlSelectQuery = [NSString stringWithFormat:@"SELECT * FROM MorseAlphabet WHERE %@='%@'", dictParams[@"key"], dictParams[@"val"]];
    NSLog(@"sqlSelectQuery = %@", sqlSelectQuery);
    
    NSString *strMorseCode = nil;
    NSString *strEn = nil;
    NSString *strRu = nil;
    // Query result   (MorseCode STRING, enStr STRING, ruStr STRING)
    FMResultSet *resultsWithNameLocation = [database executeQuery:sqlSelectQuery];
    while([resultsWithNameLocation next]) {
            strMorseCode = [resultsWithNameLocation stringForColumn:@"morseCode"];
            strEn = [resultsWithNameLocation stringForColumn:@"enStr"];
            strRu = [resultsWithNameLocation stringForColumn:@"ruStr"];
        
    }
    [database close];
    
    if (strMorseCode) {
        return @{@"morseCode" : strMorseCode,
                 @"enStr" : strEn,
                 @"ruStr" : strRu
                 };
    }
    else {
        return nil;
    }
   
}




@end