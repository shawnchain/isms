//==============================================================================
//	Created on 2008-3-6
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

#import <Foundation/Foundation.h>
#import "Prefix.h"
#import "DBAdapter.h"
#import "SQLiteDB.h"
#import "Log.h"
#import "TelephonyHelper.h"

/***************************************************************
 * The DBAdapter implementation
 * 
 * @Author Shawn
 ***************************************************************/
#define CURRENT_DB_SCHEMA_VERSION 102

@implementation DBAdapter: ObjectAdapter
-(id)initWithClass:(Class)clazz mainDB:(NSString*)aFile attachedDBs:(NSDictionary*) dbs isSingleton:(BOOL)flag{
	[super initWithClass:clazz isSingleton:flag];
	mainDB = [aFile retain];
	attachedDBs = [dbs retain];
	return self;
}

-(void)dealloc{
	RELEASE(mainDB);
	RELEASE(attachedDBs);
	[super dealloc];
}

-(void) _checkVersion:(SQLiteDB*) db{
	const char* v = sqlite3_libversion();
	int n = sqlite3_libversion_number();
	LOG(@"SQLite version %s,%d",v,n);
}


-(void) _createFunction:(SQLiteDB*) db{
	[[TelephonyHelper sharedInstance]registerSQLiteFunctions:db];
}

static int CHECK_DRAFT_MESSAGE_OK = 1;
#define SQL_CREATE_DRAFT_MESSAGE @"CREATE TABLE draft_message (\"ROWID\" INTEGER PRIMARY KEY AUTOINCREMENT, address TEXT, date INTEGER, text TEXT, flags INTEGER, \"replace\" INTEGER, svc_center TEXT);"
#define SQL_INSERT_FIRST_DRAFT @"INSERT INTO draft_message (ROWID) values (365000)"
#define SQL_DELETE_FIRST_DRAFT @"DELETE FROM draft_message WHERE ROWID=365000"

static int CHECK_ARCHIVED_MESSAGE_OK = 1 << 1;
#define SQL_CREATE_ARCHIVED_MESSAGE @"CREATE TABLE archived_message (\"ROWID\" INTEGER PRIMARY KEY, address TEXT, date INTEGER, text TEXT, flags INTEGER, \"replace\" INTEGER, svc_center TEXT);"

static int CHECK_MESSAGE_CONTACT_JOINT_OK = 1 << 2;
#define SQL_CREATE_MESSAGE_CONTACT_JOINT @"CREATE TABLE message_contact (contact_id INTEGER, msg_id INTEGER);"
//#define SQL_CREATE_MESSAGE_CONTACT_JOINT_INDEX1 @"CREATE UNIQUE INDEX IF NOT EXISTS idx_message_contact ON message_contact(contact_id,msg_id);";
//#define SQL_CREATE_MESSAGE_CONTACT_JOINT_INDEX2 @"CREATE UNIQUE INDEX IF NOT EXISTS idx_message_contact_cid ON message_contact(contact_id);";
//#define SQL_CREATE_MESSAGE_CONTACT_JOINT_INDEX3 @"CREATE UNIQUE INDEX IF NOT EXISTS idx_message_contact_mid ON message_contact(msg_id);";

static int CHECK_ALL_MESSAGE_VIEW_OK = 1 << 3;
//#define SQL_CHECK_ALL_MESSAGE_VIEW @"SELECT count(*) as recordCount FROM sqlite_master WHERE TYPE='view' AND name='all_message';"
#define SQL_CREATE_ALL_MESSAGE_VIEW @"CREATE VIEW all_message AS SELECT ROWID,address,date,text,flags,replace,svc_center FROM message UNION SELECT ROWID,address,date,text,flags,replace,svc_center FROM draft_message UNION SELECT ROWID,address,date,text,flags,replace,svc_center FROM archived_message;"

//-(int) DBSchemaVersion:(SQLiteDB*) db{
//	NSDictionary *aRow = [db queryOneRow:SQL_SELECT_VERSION];
//	NSString *version = [aRow objectForKey:@"version"];
//	DBG(@"DB Schema Version is %@",version);
//	if(version) {
//		return [version intValue];
//	}
//	return 0;
//}
//
//-(void)setDBSchemaVersion:(int)version db:(SQLiteDB*) db{
//	// Create table if not found
//	if(![db hasTable:@"isms_schema_version"]){
//		DBG(@"Creating table ISMS_SCHEMA_VERSION");
//		[db execute:SQL_CREATE_VERSION];
//	}
//	[db execute:SQL_DELETE_VERSION];
//	
//	NSString *updateSQL = [NSString stringWithFormat:SQL_INSERT_VERSION,version];
//	[db execute:updateSQL];
//}

-(BOOL) _upgradeDB:(SQLiteDB*) db result:(int*)outerResult{
	
	BOOL success = YES;
	int res = 0;
	
	[db execute:@"BEGIN;"];
	//1. Create TABLE DRAFT_MESSAGE if not found
	if([db hasTable:@"draft_message"]){
//		LOG(@"Found Table [draft_message], will be dropped");
//		[db dropTable:@"draft_message"];
	}else{
		res = [db execute:SQL_CREATE_DRAFT_MESSAGE];
		if(res != 0 && outerResult != NULL){
			(*outerResult) |= CHECK_DRAFT_MESSAGE_OK;
			LOG(@"ERROR - Failed to create table [draft_message], sql result %d",res);
			success = NO;
		}else{
			LOG(@"Table [draft_message] created successfully");
			[db execute:SQL_INSERT_FIRST_DRAFT];
			[db execute:SQL_DELETE_FIRST_DRAFT];
		}		
	}
	
	// 2. Create TABLE ARCHIVED_MESSAGE if not found
	if([db hasTable:@"archived_message"]){
//		LOG(@"Found Table [archived_message], will be dropped");
//		[db dropTable:@"archived_message"];
	}else{
		res = [db execute:SQL_CREATE_ARCHIVED_MESSAGE];
		if(res != 0 && outerResult != NULL){
			(*outerResult) |= CHECK_ARCHIVED_MESSAGE_OK;
			LOG(@"ERROR - Failed to create table [ARCHIVED_MESSAGE], sql result %d",res);
			success = NO;
		}else{
			LOG(@"Table [ARCHIVED_MESSAGE] created");
		}
	}
	
	// 3. Create TABLE MESSAGE_CONTACT_JOINT if not found
	if([db hasTable:@"message_contact"]){
//		LOG(@"Found Table [message_contact], will be dropped");
//		[db dropTable:@"message_contact"];
	}else{
		res = [db execute:SQL_CREATE_MESSAGE_CONTACT_JOINT];
		if(res != 0 && outerResult != NULL){
			(*outerResult) |= CHECK_MESSAGE_CONTACT_JOINT_OK;
			LOG(@"ERROR - Failed to create table [message_contact], sql result %d",res);
			success = NO;
		}else{
			LOG(@"Table [message_contact] created");
		}		
	}

	// 4. Re-Create VIEW ALL_MESSAGE
	if([db hasObject:@"all_message" type:@"view"]){
		LOG(@"Found old View [all_message], will be dropped");
		[db execute:@"DROP VIEW all_message"];
	}

	res = [db execute:SQL_CREATE_ALL_MESSAGE_VIEW];
	if(res != 0 && outerResult != NULL){
		(*outerResult) |= CHECK_ALL_MESSAGE_VIEW_OK;
		LOG(@"ERROR - Failed to create view [ALL_MESSAGE_VIEW], sql result %d",res);
		success = NO;
	}else{
		LOG(@"View [ALL_MESSAGE_VIEW] created");
	}

	if(success){
		// Update the table version and commit
		[db setSchemaVersion:CURRENT_DB_SCHEMA_VERSION];
		[db execute:@"COMMIT;"];
		LOG(@"DB Schema upgraded to %d successfully!",[db schemaVersion]);
	}else{
		//rollback;
		[db execute:@"ROLLBACK;"];
		LOG(@"ERROR - Update DB Schema failed, please check log for more details");
	}
	return success;
}

-(id)newInstance{
	DBG(@"Creating new instance for %@",objectClass);
	id _db = [[objectClass alloc]initWithPath:mainDB];
	
	// Check the sqlite version
	[self _checkVersion:_db];	
	// Setup customized functions
	[self _createFunction:_db];
	
	// Attach databases
	if(_db && attachedDBs){
		NSEnumerator *enumerator = [attachedDBs keyEnumerator];
		id key;
		while ((key = [enumerator nextObject])) {
		    /* code that uses the returned key */
			NSString* value = [attachedDBs objectForKey:key];
			if([_db attachDatabase:value forName:(NSString*)key]){
				LOG(@"Attached to database (%@) as name (%@)",value,key);
			}else{
				LOG(@"ERROR - Attach to database %@ failed, please check db log for more error info.",value);
			}
		}
	}
	
	// Check whether the db is ready
	int result = 0;
	LOG(@"Checking database schema");
	int _currentVersion = [_db schemaVersion];
	if( _currentVersion < CURRENT_DB_SCHEMA_VERSION){
		// Need to upgrade db schema
		if(![self _upgradeDB:_db result:&result]){
			// db error, need to check the result
			LOG(@"ERROR - db upgrade failed, result %d",result);
			[_db _setDBIsOK:NO];
		}
	}else{
		[_db _setDBIsOK:YES];
		LOG(@"Database schema %d is OK!",_currentVersion);
	}
	
	// Checking the auto-archive-trigger and disable it if we're in 1.1.3+
	if(osVersion() >= 113){
		LOG(@"You're using 1.1.3 or higher version, checking auto-archive trigger and will disable it if found...");
		[_db enableAutoArchive:NO];
	}
	
	// Check whether the databases exists
	return _db;
}

@end
