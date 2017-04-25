//==============================================================================
//	Created on 2007-11-18
//==============================================================================
//	$Id$
//==============================================================================
//	Copyright (C) <2007>  Shawn Qian(shawn.chain@gmail.com)
//
//	This file is part of iSMS.
//
//  iSMS is free software: you can redistribute it and/or modify
//  it under the terms of the GNU General Public License as published by
//  the Free Software Foundation, either version 3 of the License, or
//  (at your option) any later version.
//
//  iSMS is distributed in the hope that it will be useful,
//  but WITHOUT ANY WARRANTY; without even the implied warranty of
//  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//  GNU General Public License for more details.
//
//  You should have received a copy of the GNU General Public License
//  along with iSMS.  If not, see <http://www.gnu.org/licenses/>.
//==============================================================================
// Originally based on SQLiteDB.h by Feng Huajun
//==============================================================================

#import <Foundation/Foundation.h>
#import <sqlite3.h>
#import "Entity.h"

@interface SQLiteDB : NSObject {
	sqlite3	*conn;
	BOOL	DBIsOK;
}

+(id)sharedInstance;
-(SQLiteDB *) initWithPath: (NSString*)path;
-(NSArray*) query: (NSString *)sql;
-(NSDictionary*) queryOneRow: (NSString *)sql;

/**
 * Count record. assuming the count column is "recordCount"
 * SELECT count(*) as recordCount FROM t_foo WHERE ....
 */
-(int)count:(NSString*) sql;

-(int) execute: (NSString *)sql;

-(id) load:(Class) objectClass withSQL:(NSString*) sql;
-(id) load:(Class) objectClass withSQL:(NSString*) sql withMapping:(SEL) mappingMethod;
-(NSArray*) list:(Class) objectClass withSQL:(NSString*) sql;
-(NSArray*) list:(Class) objectClass withSQL:(NSString*) sql withMapping:(SEL) mappingMethod;
-(int)getGeneratedSequenceForTable:(NSString*)tableName;
//-(id) initObject:(id) object withData:(NSDictionary*) data withMapping:(SEL) mappingCallback;
//-(id) internalLoadObject:(id) object bySQL:(NSString*) sql mapping:(SEL)mappingCallback;

-(BOOL)hasObject:(NSString*) name type:(NSString*)type;
-(BOOL)hasTable:(NSString*) tableName;
-(BOOL)attachDatabase:(NSString*)dbFile forName:(NSString*)name;
-(BOOL)detachDatabase:(NSString*)name;
-(BOOL)dropTable:(NSString*) tableName;

-(BOOL)enableAutoArchive:(BOOL)flag;
-(BOOL)autoArchiveEnabled;

-(int) schemaVersion;
-(void)setSchemaVersion:(int)version;

-(sqlite3*) conn;
-(BOOL)DBIsOK;
-(void)_setDBIsOK:(BOOL)value;
@end
