//
//  DBManager.h
//  DBTest
//
//  Created by Ivan Gnatyuk on 14.07.14.
//  Copyright (c) 2014 dalein. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>

@interface DBManager : NSObject

@property (nonatomic, strong) NSString *strDBMainPath;


//Инициализировать ДБ
+(instancetype)initDB;


//Получить инфу по нужному элементу
- (NSDictionary *)getMorseElementWithParams:(NSDictionary *)dictParams;



@end
