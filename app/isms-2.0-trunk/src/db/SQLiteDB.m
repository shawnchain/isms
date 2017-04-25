//==============================================================================
//	Created on 2007-11-18
//==============================================================================
//	$Id: template.txt 11 2007-11-18 05:35:36Z shawn $
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
//  along with Foobar.  If not, see <http://www.gnu.org/licenses/>.
//==============================================================================

/***************************************************************
 * DB Class that load/persistent entity from/to sqlite db 
 * Based on the original SQLiteDB class by Feng Huajun
 * 
 * //FIXME Split into 2 class, a generic SQLiteDB class and a specific iSMSDB class
 * @Author Shawn
 * 
 ***************************************************************/
#import "SQLiteDB.h"
#import <stdlib.h>
#include <string.h>
#import "DBAdapter.h"
#import "ObjectContainer.h"
#import "Log.h"
#import <Foundation/Foundation.h>
#import "Util.h"


#ifdef TEST_SMS_DB
	#define SMS_DB @"/Applications/iSMS.app/sms.db"
	#define SMS_DB_113 @"/Applications/iSMS.app/sms.db"	
#else
	#define SMS_DB @"/var/mobile/Library/SMS/sms.db"
	#define SMS_DB_113 @"/var/mobile/Library/SMS/sms.db"	
#endif

#define CONTACT_DB @"/var/mobile/Library/AddressBook/AddressBook.sqlitedb"
#define CONTACT_DB_113 @"/var/mobile/Library/AddressBook/AddressBook.sqlitedb"
#define ISMS_DB @"/var/mobile/Library/SMS/isms.db"

/***************************************************************
 * SQLiteDB Class Implementation
 * 
 * @Author Shawn
 ***************************************************************/
@implementation SQLiteDB

+(void)initialize{
	static BOOL initialized = NO;
	if (!initialized) {
		LOG(@"Initializing %@",self);
		NSString* smsDB = (osVersion() < 113)?SMS_DB:SMS_DB_113;
		NSString* contactDB = (osVersion() < 113)?CONTACT_DB:CONTACT_DB_113;
		// By default we'll attach the contact & our iSMS db together
		NSDictionary *attachedDBs = [NSDictionary dictionaryWithObjectsAndKeys:
			contactDB,@"contact",
//			ISMS_DB,@"isms",
					nil];
		DBAdapter *dba = [[DBAdapter alloc]initWithClass:self mainDB:smsDB attachedDBs:attachedDBs isSingleton:YES];
		[[ObjectContainer sharedInstance] registerObjectAdapter:dba forKey:self];
		[dba release];
		initialized = YES;
	}
}


+(id)sharedInstance{
	return [[ObjectContainer sharedInstance] objectForKey:self];
}

-(SQLiteDB *) initWithPath: (NSString*)path {
	self = [super init];
	if (self != nil) {
		int err = sqlite3_open([path fileSystemRepresentation], &conn);
		if (err) {
			LOG(@"can not open database:%@",path);
			return nil;
		}else{
			LOG(@"database %@ opened",path);
		}
	}
	return self;
}

//-(SQLiteDB*) initWithDB:(sqlite3*)adb {
//	self = [super init];
//	if(self) {
//		db = adb;
//	} else {
//		db = NULL;
//	}
//	return self;
//}

//==========================================
// Generic operations
//==========================================

// Execute the sql query and return NSArray contains all records(NSDictionary)
-(NSArray*) query: (NSString *)sql {
	@synchronized(self) {
		DBG(@"Query - [%@]",sql);

		char* errMsg;
		char **result;
		int nrow,ncol;
		int err = sqlite3_get_table(conn,[sql UTF8String],&result,&nrow,&ncol,&errMsg);
		if( err != SQLITE_OK ) {
			LOG(@"query sql error[%s], SQL[%@]",errMsg, sql);
			return [NSArray array];
		}
		DBG(@"query sql no error, %d records returned",nrow);
		NSMutableArray* rows = [[NSMutableArray alloc] initWithCapacity:nrow];
		[rows autorelease];

		if(nrow != 0) {

			NSMutableArray* colNames = [[NSMutableArray alloc] initWithCapacity: ncol];

			int idx = 0;
			int i,j;

			// Get all column names
			for(i = 0; i < ncol; i++) {
				NSString* s = [[NSString alloc] initWithUTF8String:result[i]];
				[colNames addObject:s];
				[s release];
			}

			// Get all records data
			for(i = 0; i < nrow; i++ ) {
				NSMutableDictionary* cols = [[NSMutableDictionary alloc] initWithCapacity: ncol];
				for(j=0;j<ncol;j++) {
					idx = (i+1)*ncol + j;
					//LOG("s=%s\n",result[idx]);
					if(result[idx]) {
						NSString* s = [[NSString alloc] initWithUTF8String:result[idx]];
						[cols setObject:s forKey:[colNames objectAtIndex:j]];
						[s release];
					} else {
						[cols setObject:@"" forKey:[colNames objectAtIndex:j]];
					}
				}
				[rows addObject:cols];
				[cols release];
			}
			[colNames release];
		}

		sqlite3_free_table(result);
		return rows;
	}
	return nil;
}

// Get the last generated ROWID
-(int)getGeneratedSequenceForTable:(NSString*)tableName {
	
	const char* errMsg;
	int rowid = -1;
	NSString *sql = [NSString stringWithFormat:@"SELECT seq FROM sqlite_sequence WHERE name='%@'",tableName];

	DBG(@"Execute - %@",sql);
	
	const char* sqlUTF8 = [sql UTF8String];
	//SELECT seq FROM sqlite_sequence WHERE name='tableName'
	sqlite3_stmt* stmt = NULL;
	int ret = sqlite3_prepare(conn,sqlUTF8,-1,&stmt,NULL);
	if(SQLITE_OK != ret) {
		goto __error__;
	}
	ret = sqlite3_step(stmt);
	if(ret == SQLITE_ROW) {
		//We got the data!
		rowid = sqlite3_column_int(stmt,0);
		goto __clean_up__;
	} else if(ret == SQLITE_ERROR) {
		// something wrong
		goto __error__;
	} else {
		// No data without error ?
		LOG(@"sqlite3_step returns nothing, the result code is %d",ret);
	}

	//__success__:
	//commit and return the value;
	goto __clean_up__;

	__error__:
	errMsg = sqlite3_errmsg(conn);
	LOG(@"Error executing sql:%@, error is %d/%s",sql,ret,errMsg);

	__clean_up__:
	if(stmt) {
		sqlite3_finalize(stmt);
	}
	//get the error message and return -1;
	return rowid;
}

//NSArray* _readOneRow(char** result,int ncol,int rowNumber){
//	NSArray* aRow = [[NSArray alloc] initWithCapacity:ncol];
//	for(int i = 0; i < ncol; i++) {
//		int idx = (rowNumber + 1) * ncol + i;
//		//printf("s=%s\n",result[idx]);
//		if(result[idx]) {
//			//TODO support different type
//			NSString* s = [[NSString alloc] initWithUTF8String:result[idx]];
//			[aRow addObject:s];
//			[s release];
//		} else {
//			[aRow addObject:@""];
//		}
//	}
//	return aRow;
//}

-(NSDictionary*) queryOneRow: (NSString *)sql {
	@synchronized(self) {
		DBG(@"Query: %@",sql);

		//NSLog(@"query: %@",sql);
		char* errMsg;
		char **result;
		int nrow,ncol;
		int err = sqlite3_get_table(conn,[sql UTF8String],&result,&nrow,&ncol,&errMsg);
		if( err != SQLITE_OK ) {
			LOG(@"queryOneRow - query sql error! sql:%@ message:%s", sql, errMsg);
			return [NSDictionary dictionary];
		}
		DBG(@"%d records returned",nrow);
		NSMutableDictionary* aRow = nil;
		if(nrow != 0) {
			NSMutableArray* colNames = [[NSMutableArray alloc] initWithCapacity: ncol];

			int idx = 0;
			int i,j;

			// Get all column names
			for(i = 0; i < ncol; i++) {
				NSString* s = [[NSString alloc] initWithUTF8String:result[i]];
				[colNames addObject:s];
				[s release];
			}

			// Get all records data
			aRow = [[NSMutableDictionary alloc] initWithCapacity: ncol];
			for(j=0;j<ncol;j++) {
				idx = ncol + j;
				if(result[idx]) {
					NSString* s = [[NSString alloc] initWithUTF8String:result[idx]];
					[aRow setObject:s forKey:[colNames objectAtIndex:j]];
					[s release];
				} else {
					[aRow setObject:@"" forKey:[colNames objectAtIndex:j]];
				}
			}
			[colNames release];
		} else {
			aRow = [[NSMutableDictionary alloc] init];
		}

		sqlite3_free_table(result);
		return [aRow autorelease];	
	}
	return nil;
}

//FIXME directly access the first column instead of by column name
-(int)count:(NSString*) sql {
	NSDictionary *aRow = [self queryOneRow:sql];
	NSString *count = [aRow objectForKey:@"recordCount"];
	if(count) {
		return [count intValue];
	}
	return 0;
}

-(int)execute: (NSString *)sql
{
	@synchronized(self) {
		DBG(@"Execute - %@",sql);
		char* errMsg;
		int err = sqlite3_exec(conn,[sql UTF8String], NULL, 0, &errMsg);
		if(err!=SQLITE_OK) {
			LOG(@"excute sql error! sql:%@ message:%s", sql, errMsg);
			//TODO throw exception ?
			return err;
		}
	}
	return 0;
}

-(BOOL)dropTable:(NSString*) tableName{
	NSString* sql = [NSString stringWithFormat:@"DROP TABLE %@",tableName];
	return 0 == [self execute:sql];
}

-(BOOL)hasObject:(NSString*) name type:(NSString*)type{
	NSString* sql = [NSString stringWithFormat:@"SELECT count(*) as recordCount FROM sqlite_master WHERE TYPE='%@' AND name='%@'",type,name];
	return [self count:sql] > 0;
}

-(BOOL)hasTable:(NSString*) tableName{
	return [self hasObject:tableName type:@"table"];
}

-(BOOL)attachDatabase:(NSString*)dbFile forName:(NSString*)name{
	return 0 == [self execute:[NSString stringWithFormat:@"ATTACH '%@' AS %@",dbFile,name]];
}

-(BOOL)detachDatabase:(NSString*)name{
	return 0 == [self execute:[NSString stringWithFormat:@"DETACH %@",name]];
}

//==== Mapping methods ====
-(id)initObject:(id) object withData:(NSDictionary*) data withMapping:(SEL) mappingMethod {
	return [object performSelector:mappingMethod withObject:data];
}

// Load records and map recoard data into the object
-(BOOL)internalLoadObject:(id) object withSQL:(NSString*) sql withMapping:(SEL)mappingMethod {
	NSArray *dbres=[self query:sql];
	if(dbres && [dbres count]> 0) {
		// Got records, but we only interest the first one!
		if([dbres count]> 1) {
			LOG(@"More than 1 records returned, will pick up the first record");
		}
		NSEnumerator* e = [dbres objectEnumerator];
		NSDictionary* row = [e nextObject];
		//return [object performSelector:mappingMethod withObject:row];
		return [self initObject:object withData:row withMapping:mappingMethod] != nil;
	}
	return NO;
}

// [db load:[MyObj class] withSQL:@"select foo fom x,y,z" mappedBy:mappingMethod]
-(id) load:(Class) objectClass withSQL:(NSString*) sql withMapping:(SEL) mappingMethod {
	id o = [objectClass alloc];
	if([self internalLoadObject:o withSQL:sql withMapping:mappingMethod]) {
		//NOTE We'll use autorelease. Caller should never care about the lifecycle of loaded entity.
		return [o autorelease];
	} else {
		[o release];
		return nil;
	}
}

// [db load:[MyObj class] withSQL:@"select foo fom x,y,z"]
-(id) load:(Class) objectClass withSQL:(NSString*) sql {
	if(![objectClass conformsToProtocol:@protocol(Entity)]) {
		LOG(@"WARN - Class %@ does not conform to protocol Entity, load aborted!",[NSStringFromClass(objectClass) UTF8String]);
		return nil;
	}
	// locate the mapping method declared in Entity protocol
	SEL mappingMethod = @selector(initWithRowData:);
	//ASSERT(mappingMethod != nil);
	return [self load:objectClass withSQL:sql withMapping:mappingMethod];
}

-(NSArray*) list:(Class) objectClass withSQL:(NSString*) sql withMapping:(SEL) mappingMethod {
	NSArray *dbres=[self query:sql];
	NSEnumerator* e = [dbres objectEnumerator];
	NSDictionary* row;
	NSMutableArray* res = [NSMutableArray array];
	while((row = [e nextObject])) {
		id o = [objectClass alloc];
		if(o != nil && [self initObject:o withData:row withMapping:mappingMethod]) {
			[res addObject:o];
			[o release];
		}
	}
	return res;
}

-(NSArray*) list:(Class) objectClass withSQL:(NSString*) sql {
	if(![objectClass conformsToProtocol:@protocol(Entity)]) {
		LOG(@"WARN - Class %@ does not conform to protocol Entity, load aborted!",[NSStringFromClass(objectClass) UTF8String]);
		return nil;
	}
	SEL mappingMethod = @selector(initWithRowData:);
	return [self list:objectClass withSQL:sql withMapping:mappingMethod];
}

- (void) dealloc {
	sqlite3_close(conn);
	[super dealloc];
}

-(sqlite3*) conn {
	return conn;
}

-(BOOL)DBIsOK{
	return DBIsOK;
}
-(void)_setDBIsOK:(BOOL)value{
	DBIsOK = value;
}


#define SQL_CREATE_VERSION @"CREATE TABLE isms_schema_version (version INTEGER);"
#define SQL_SELECT_VERSION @"SELECT version FROM isms_schema_version LIMIT 1;"
//#define SQL_UPDATE_VERSION @"UPDATE isms_schema_version SET version=%d;"
#define SQL_INSERT_VERSION @"INSERT INTO isms_schema_version (version) values (%d)"
#define SQL_DELETE_VERSION @"DELETE FROM isms_schema_version"

-(int) schemaVersion{
	NSDictionary *aRow = [self queryOneRow:SQL_SELECT_VERSION];
	NSString *version = [aRow objectForKey:@"version"];
	DBG(@"DB Schema Version is %@",version);
	if(version) {
		return [version intValue];
	}
	return 0;
}

-(void)setSchemaVersion:(int)version{
	// Create table if not found
	if(![self hasTable:@"isms_schema_version"]){
		DBG(@"Creating table ISMS_SCHEMA_VERSION");
		[self execute:SQL_CREATE_VERSION];
	}
	[self execute:SQL_DELETE_VERSION];
	
	NSString *updateSQL = [NSString stringWithFormat:SQL_INSERT_VERSION,version];
	[self execute:updateSQL];
}

//#define SQL_CHECK_ARCHIVE_TRIGGER @"SELECT count(*) as recordCount FROM sqlite_master WHERE TYPE='trigger' AND name='trigger_auto_archive_message';"
// The trigger will remove the oldest messages into the ARCHIVED_MESSAGE table
#define SQL_CREATE_ARCHIVE_TRIGGER @"CREATE TRIGGER trigger_auto_archive_message " \
"AFTER INSERT " \
"ON message " \
"WHEN (SELECT COUNT(*) FROM message)>500 " \
"BEGIN " \
"  INSERT INTO archived_message SELECT * FROM message LIMIT 1; " \
"  DELETE FROM message WHERE message.ROWID IN (SELECT archived_message.ROWID FROM archived_message); " \
"END;"
#define SQL_DROP_ARCHIVE_TRIGGER @"DROP TRIGGER trigger_auto_archive_message"

-(BOOL)autoArchiveEnabled{
//	int count = [[self getDB] count:SQL_CHECK_ARCHIVE_TRIGGER];
//	LOG(@"Trigger [trigger_auto_archive_message] %@ found",(count == 0?@"NOT":@""));
//	return (count == 1);
	return [self hasObject:@"trigger_auto_archive_message" type:@"trigger"];
}

-(BOOL)enableAutoArchive:(BOOL)enable{
	if(enable && osVersion() >= 113){
		LOG(@"Detected FW version >= 1.1.3, auto archive is not supported");
		// Not need this trigger anymore on 1.1.3+ fw 
		return NO;
	}
	
	// 4. TRIGGER ARCHIVE_MESSAGE
	int res = 0;
	BOOL result = YES;
	BOOL triggerExists = [self autoArchiveEnabled];
	
	if(triggerExists && enable){
		LOG(@"ARCHIVE_MESSAGE Trigger already exists, create aborted");
		return YES;
	}
	
	if(!triggerExists && !enable){
		LOG(@"ARCHIVE_MESSAGE Trigger does not exsits, drop aborted");
		return YES;
	}
	
	if(enable){
		res = [self execute:SQL_CREATE_ARCHIVE_TRIGGER];
		if(res != 0){
			LOG(@"ERROR - Failed to create trigger [ARCHIVE_TRIGGER], sql result %d",res);
			result = NO;
		}else{
			LOG(@"Trigger [ARCHIVE_MESSAGE] created");
		}
	}else{
		res = [self execute:SQL_DROP_ARCHIVE_TRIGGER];
		if(res != 0){
			LOG(@"ERROR - Failed to create trigger [ARCHIVE_MESSAGE], sql result %d",res);
			result = NO;
		}else{
			LOG(@"Trigger [ARCHIVE_MESSAGE] dropped");
		}
	}
	return result;
}
@end

/*
//==============================
// Test codes

//static void test(){
//	SQLiteDB* db = [[SQLiteDB alloc] initWithPath:@"/var/root/Library/SMS/sms.db"];
//	//sqlite3_create_function([db conn], "formalizePhoneNumber", 1, SQLITE_UTF8, NULL, &formalizePhoneNumberFunc, NULL, NULL);
//	
//	
//	//sqlite3* dbHandler = [adb conn];
//	const char* db2 = [@"/var/root/Library/AddressBook/AddressBook.sqlitedb" fileSystemRepresentation];
//	[db execute:[NSString stringWithFormat:@"ATTACH \"%s\" AS ab",db2]];
//	
//	//NSString* sql = @"SELECT ROWID,address, formalizePhoneNumber(address) as phone FROM message join limit 5";
//
//	NSString* sql = @"SELECT a.ROWID as ROWID, "\
//			" a.text as BODY "
//			//"FROM message AS a JOIN ab.ABMultiValue AS b ON (formalizePhoneNumber(a.address) = formalizePhoneNumber(b.value) ) JOIN ab.ABPerson AS c ON (b.record_id = c.ROWID) limit 5";
//			"FROM message AS a , ab.ABMultiValue AS b, ab.ABPerson AS c "\
//			"WHERE ((formalizePhoneNumber(a.address) = formalizePhoneNumber(b.value)) "\
//			"AND (b.record_id = c.ROWID)  "\
//			"AND (c.First LIKE '%%shawn%%' OR c.Last LIKE '%%shawn%%' or a.text LIKE '%%shawn%%') "\ 
//			") ORDER BY a.date DESC limit 5";
//
//	time_t start = time(NULL);
//	NSString* sql = @"SELECT a.ROWID as ROWID, "\
//			" a.text as BODY "\
//			" FROM message AS a JOIN ab.ABMultiValue AS b ON (formalizePhoneNumber(a.address) = formalizePhoneNumber(b.value) ) JOIN ab.ABPerson AS c ON (b.record_id = c.ROWID) "\
//			" WHERE (c.First LIKE '%%shawn%%' OR c.Last LIKE '%%shawn%%' or a.text LIKE '%%shawn%%') "\
//			" ORDER BY a.date DESC limit 5";
//	NSArray* result = [db query:sql];
//	time_t stop = time(NULL);
//
//	LOG(@"Search elapsed %e ms",stop - start);
//	
//	NSEnumerator* e = [result objectEnumerator];
//	NSDictionary* row = nil;
//	while(row = [e nextObject]){
//		LOG(@"ROWID: %@",[row objectForKey:@"ROWID"]);
////		LOG(@"First, Last: %@,%@",[row objectForKey:@"first"],[row objectForKey:@"last"]);
////		LOG(@"Raw Number: %@",[row objectForKey:@"address"]);
////		LOG(@"Formatted Number: %@",[row objectForKey:@"phone"]);
//		LOG(@"Text: %@",[row objectForKey:@"BODY"]);
//	}
//	
//	stop = time(NULL);
//
//	LOG(@"Total elapsed %e ms",stop - start);
//	
//	[db execute:@"detach ab"];
//	[db release];
//}
//
//int main(int argc, char **argv)
//{
//    NSAutoreleasePool* pool = [[NSAutoreleasePool alloc] init];
//    [[Logger alloc] init];
//    LOG(@"test case start up");
//    // Code here
//    test();
//    
//    [Logger release];
//    [pool release];
//	
//	return 0;
//}

*/
