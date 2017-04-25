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
//  along with Foobar.  If not, see <http://www.gnu.org/licenses/>.
//==============================================================================
#import "Message.h"
#import "SQLiteDB.h"
#import "ObjectContainer.h"
#import "Contact.h"
#import "Log.h"
#include "stdlib.h"
#import "TelephonyHelper.h"
#include <libkern/OSAtomic.h>

//====================================================================
// Internal enum/functions for Message class
//====================================================================
enum _msg_flags
{
	FLAG_OUTGOING = 1,
	FLAG_READ = 1 << 1,
	FLAG_SENT = 1 << 1,
	FLAG_FAILED = 1 << 5,
	FLAG_PLACE_HOLDER = 1 << 7,
	FLAG_DRAFT = 1 << 14,	
	FLAG_PROTECTED = 1 << 15, // 32768
	FLAG_DELETED = 1 << 16, // 65536
};

BOOL _isOutgoing(int flags){
	return (flags & FLAG_OUTGOING) == FLAG_OUTGOING;
}

BOOL _hasBeenSent(int flags){
	//	return _isOutgoing(flags) && ((flags & FLAG_SENT) == FLAG_SENT);
	if(_isOutgoing(flags)){
		return ((flags & FLAG_SENT) == FLAG_SENT);
	}
	return YES;
}

BOOL _hasBeenRead(int flags){
	//	return (!_isOutgoing(flags)) &&  ((flags & FLAG_READ) == FLAG_READ);
	if(!_isOutgoing(flags)){
		return ((flags & FLAG_READ) == FLAG_READ);
	}
	return YES;
}

void _notifyChange(id sender, int changeType){
	//TODO add message id ?
	id _notifyType = [NSNumber numberWithInt:changeType];
	NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys:
			_notifyType,@"type",
			nil];
	[[NSNotificationCenter defaultCenter] postNotificationName:MESSAGE_CHANGE_NOTIFICATION object:sender userInfo:userInfo];
}


//====================================================================
// Tricky method to get a new message id from the message table sequence
// Available for draft/deleted/protected message
//====================================================================
int _newMessageId(){
	// TODO - implement me
	CTSMSMessageRef msg = CTSMSMessageCreate(nil,@"",@"");
	if(msg){
		int msgId = _CTSMSMessageGetRecordIdentifier(msg);
		CTSMSMessageDelete(msg);
		return msgId;
	}
	return -1;
}

/***************************************************************
 * The Message Modal Class
 * 
 * @Author Shawn
 ***************************************************************/
@implementation Message

//====================================================================
// Common query methods
//====================================================================
+(NSArray*)executeQuery:(NSString*) sql {
	return [[SQLiteDB sharedInstance] query:sql];
}
+(int)executeUpdate:(NSString*) sql {
	[[SQLiteDB sharedInstance] execute:sql];
	//FIXME should return how many rows effected
	return 0;
}

//====================================================================
// Factory methods - 
//====================================================================
+(Message*)newDraftMessage{
	Message *msg = [[Message alloc]init];
	//FIXME deprecate the DRAFT_MESSAGE type!!!
	msg->type = DRAFT_MESSAGE;
	//msg.flags |= FLAG_DRAFT;
	return msg;
}

//====================================================================
// Load methods - 
//====================================================================
+(Message*)load:(NSString*) msgId {	
	NSString* sql = [NSString stringWithFormat:@"SELECT ROWID,address,date,text,flags FROM all_message WHERE message.ROWID=%@",msgId];
	return [[SQLiteDB sharedInstance] load:self withSQL:sql];
}
+(Message*)loadById:(int) msgId {
	NSString* sql = [NSString stringWithFormat:@"SELECT ROWID,address,date,text,flags FROM all_message WHERE message.ROWID=%d",msgId];
	return [[SQLiteDB sharedInstance] load:self withSQL:sql];
}

//====================================================================
// List methods
//====================================================================
+(NSArray*)list:(NSString*) table criteria:(Criteria*) criteria{
	NSString *baseSQL = [NSString stringWithFormat:@"SELECT ROWID,address,date,text,flags FROM %@",table];
	NSString *sql;
	if(criteria){
		sql = [NSString stringWithFormat:@"%@ %@",baseSQL,[criteria sql]];	
	}else{
		sql = baseSQL;
	}
	return [[SQLiteDB sharedInstance] list:self withSQL:sql];
}

+(NSArray*)list:(Criteria*) criteria{
	return [self list:@"all_message" criteria:criteria];
	/*
	NSString *baseSQL = @"SELECT ROWID,address,date,text,flags FROM all_message";
	NSString *sql;
	if(criteria){
		sql = [NSString stringWithFormat:@"%@ %@",baseSQL,[criteria sql]];	
	}else{
		sql = baseSQL;
	}
	return [[SQLiteDB sharedInstance] list:self withSQL:sql];
	*/
}
+(NSArray*)list {
	//NOTE there're strange records with flag = 129, seems like a dummy record for the conversation
	Criteria *c = [Criteria criteria:@"flags=0 OR flags=1 OR flags=2 OR flags=3" order:@"date DESC" limit:-1 offset:-1];
	return [self list:c];
}
+(NSArray*)listByType:(MessageType)type{
	NSString *where = [NSString stringWithFormat:@"flags=%d",type];
	Criteria *c = [Criteria criteria:where order:@"date DESC"];
	return [self list:c];
}
+(NSArray*)listInbox{
	NSString* where = [NSString stringWithFormat:@"flags=%d OR flags=%d",UNREAD_MESSAGE,READ_MESSAGE];
	Criteria *c = [Criteria criteria:where order:@"date DESC"];
	return [self list:c];
}
+(NSArray*)listUnreadMessages{
	NSString *where = [NSString stringWithFormat:@"flags=%d",UNREAD_MESSAGE];
	Criteria *c = [Criteria criteria:where order:@"date ASC"];
	return [self list:c];
}

+(NSArray*)listDeletedMessages{
	//TODO implement me
	return nil;
}
+(NSArray*)listDraftMessages{
	//Criteria *c = [Criteria criteria:]
	return [self list:@"draft_message" criteria:nil];
}
+(NSArray*)listProtectedMessages{
	return nil;
}

//====================================================================
// Count methods
//====================================================================
+(int)count:(NSString*) table criteria:(Criteria*)criteria{
	NSString *baseSQL = [NSString stringWithFormat:@"SELECT count(ROWID) AS recordCount FROM %@",table];
	NSString *sql;
	if(criteria){
		sql = [NSString stringWithFormat:@"%@ %@",baseSQL,[criteria sql]];	
	}else{
		sql = baseSQL;
	}
	return [[SQLiteDB sharedInstance] count:sql];
}

+(int)count:(Criteria*)criteria{
	return [self count:@"all_message" criteria:criteria];
	/*
	NSString *baseSQL = @"SELECT count(ROWID) AS recordCount FROM all_message";
	NSString *sql;
	if(criteria){
		sql = [NSString stringWithFormat:@"%@ %@",baseSQL,[criteria sql]];	
	}else{
		sql = baseSQL;
	}
	return [[SQLiteDB sharedInstance] count:sql];
	*/
}
+(int)count{
	return [self count:nil];
}
+(int)countByType:(MessageType)type{
	NSString* where = [NSString stringWithFormat:@"flags=%d",type];
	return [self count:[Criteria criteria:where]];
}
+(int)countInbox{ 
	NSString* where = [NSString stringWithFormat:@"flags=%d OR flags=%d",UNREAD_MESSAGE,READ_MESSAGE];
	return [self count:[Criteria criteria:where]];
}

+(int)countUnreadMessages{
	return CTSMSMessageGetUnreadCount();
}

+(int)countDraftMessages{
	return [self count:@"draft_message" criteria:nil];
}
//====================================================================
// Search methods
//====================================================================
+(NSArray*)search:(NSString*)searchContent{
	NSString *sql = [NSString stringWithFormat:@"SELECT * FROM all_message WHERE text LIKE \'%%%@%%\' ORDER BY date DESC",searchContent];
	return [[SQLiteDB sharedInstance] list:self withSQL:sql];
}

//====================================================================
// Delete methods
//====================================================================

// Bulk delete, If no criteria, will delete all messages
+(int)delete:(Criteria*) criteria{
	// Transaction ?
	NSString *baseSQL = @"DELETE FROM message";
	NSString *sql;
	if(criteria){
		sql = [NSString stringWithFormat:@"%@ %@",baseSQL,[criteria sql]];	
	}else{
		sql = baseSQL;
	}
	int result = [[SQLiteDB sharedInstance] execute:sql];
	// If sender is null, means bulk deletion
	_notifyChange(nil,MESSAGE_DELETED);
	return result;
}
+(int)deleteByType:(MessageType)type{
	NSString *where = [NSString stringWithFormat:@"flags=%d",type];
	Criteria *c = [Criteria criteria:where];
	return [self delete:c];
}

-(NSString*)_getTargetTable{
	// We have 3 tables to store the message, the "message", "archived_message" & "draft_message"
	NSString *_targetTable;
	if([self isDraft]){
		_targetTable = @"draft_message";
	}else if([self isArchived]){
		_targetTable = @"archived_message";
	}else{
		_targetTable = @"message";
	}
	return _targetTable;
}

// Delete a single message according to it's flag/type
-(BOOL)delete {
	if(rowId < 0){
		// Not persistented yet, nothing to delete
		return false;
	}
	
	NSString* sql = [NSString stringWithFormat:@"DELETE FROM %@ WHERE ROWID=%d",[self _getTargetTable],rowId];
	int removed = [Message executeUpdate:sql];
	
	DBG(@"Message deleted %d",removed);
	// Notify the changes
	_notifyChange(self,MESSAGE_DELETED);
	return true;
}

//====================================================================
// Save/Update method
//====================================================================
#define SQL_INSERT_MESSAGE @"INSERT INTO %@ (\'address\',\'date\',\'text\',\'flags\') VALUES ('%@','%@','%@',%d)"

#define SQL_UPDATE_MESSAGE @"UPDATE %@ SET address=\'%@\',date=\'%@\',text=\'%@\',flags=%d WHERE ROWID=%d" 
-(BOOL)save {

	int ret = 0;
	SQLiteDB* _db = [SQLiteDB sharedInstance];
	NSString* sql = nil;
	
	//FIXME Shall we setup the timestamp here ?
	time_t _now = time(NULL);
	NSString* _sNow = [NSString stringWithFormat:@"%d",_now];

	if(phoneNumber == nil){// || ([phoneNumber length] == 0)){
		phoneNumber = @"";
	}

	//FIXME !!! BUG? - WHAT IF WE CHANGED THE MESSAGE TYPE FROM READ -> DRAFT ???
	NSString *_targetTable = [self _getTargetTable];
	if(rowId >=0 ){
		// Update the message
		LOG(@"Updating Message(%d)",rowId);
		sql = [NSString stringWithFormat:SQL_UPDATE_MESSAGE,_targetTable,phoneNumber,_sNow,body,type,rowId];
		ret = [_db execute:sql];
		if(ret != 0){
			LOG(@"ERROR - Update message failed!");
		}else{
			LOG(@"Message saved successfully!");
			// Notify the change
			_notifyChange(self,MESSAGE_UPDATED);
		}
		return ret == 0;
	}else{
		LOG(@"Saving New Message (0x%x) ==> %@",self,phoneNumber);	
	}
	
	// For new message, we need 2 steps: 1)insert, 2)get the generated rowid, 3)commit tx
	ret = [_db execute:@"BEGIN"];
	if(ret == 0){
		sql = [NSString stringWithFormat:SQL_INSERT_MESSAGE,_targetTable,phoneNumber,_sNow,body,type];
		ret = [_db execute:sql];
		if(ret == 0){
			// Get the new rowid - 
			int newoid = [_db getGeneratedSequenceForTable:_targetTable];
			if(newoid > 0){
				LOG(@"Generated ROWID is %d",newoid);
				[self setMsgId:[NSString stringWithFormat:@"%d",newoid]];	
				// what if commit failed ?
				[_db execute:@"COMMIT;"];
				LOG(@"Message saved successfully!");
				// Notify the change
				_notifyChange(self,MESSAGE_CREATED);
				return TRUE;
			}else{
				LOG(@"Invalid ROWID returned %d",newoid);
				LOG(@"Save Message aborted");
			}
			
		}
	}
	
	[_db execute:@"ROLLBACK"];
	return FALSE;
}

//====================================================================
// Flag Update method
//====================================================================
#define SQL_UPDATE_MESSAGE_FLAGS @"UPDATE message SET flags=%d WHERE ROWID=%d"
-(void)_updateFlags:(int)newFlags{
	if(type == newFlags){
		// Nothing to change
		return;
	}
	
	type = newFlags;
	if(rowId >=0){
		NSString *sql = [NSString stringWithFormat:SQL_UPDATE_MESSAGE_FLAGS,newFlags,rowId];
		[[SQLiteDB sharedInstance] execute:sql];
	}
	_notifyChange(self,MESSAGE_UPDATED);
}

-(void)markAsSent:(BOOL)sent{
	int flags = type;
	if(!_isOutgoing(flags)){
		return;
	}
	BOOL changed = NO;
	if(sent && !_hasBeenSent(flags)){
		flags |= FLAG_SENT;
		changed = YES;
	}else if(!sent && _hasBeenSent(flags)){
		flags &= ~FLAG_SENT;
		changed = YES;
	}
	if(changed){
		CTSMSMessageRef aMsg = _CTSMSMessageCreateFromRecordID(kCFAllocatorDefault,rowId);
		if(aMsg){
			//FIXME what if mark read failed ?
			CTSMSMessageMarkAsSent(aMsg,sent);
			CFRelease(aMsg);
			_notifyChange(self,MESSAGE_UPDATED);			
		}
	}
}

// Mark unread message read
-(void)markAsRead:(BOOL)read{
	int flags = type;
	
	if(_isOutgoing(flags)){
		return ;
	}
	
	BOOL changed = NO;
	if(read && !_hasBeenRead(flags)){
		// Mark as read
		DBG(@"Marking as read");
		flags |= FLAG_READ;
		changed = YES;
	}else if (!read && [self hasBeenRead]){
		// Mark as unread
		DBG(@"Marking as unread");
		flags &= ~FLAG_READ;
		changed = YES;
	}
	
	if(changed){
		CTSMSMessageRef aMsg = _CTSMSMessageCreateFromRecordID(kCFAllocatorDefault,rowId);
		if(aMsg){
			//FIXME what if mark read failed ?
			CTSMSMessageMarkAsRead(aMsg,read);
			CFRelease(aMsg);
			_notifyChange(self,MESSAGE_UPDATED);			
		}
	}else{
		DBG(@"markAsRead() not changed");
	}
}

//====================================================================
// Type change methods - Target table changed
//====================================================================
#define SQL_INSERT_DRAFT_MESSAGE @"INSERT INTO draft_message (\'address\',\'date\',\'text\',\'flags\') VALUES ('%@','%@','%@',%d)"
#define SQL_UPDATE_DRAFT_MESSAGE @"UPDATE %@ SET address=\'%@\',date=\'%@\',text=\'%@\',flags=%d WHERE ROWID=%@" 
-(void)markAsDraft {
	//TODO implement me
}

// Move to draft table
-(void)markAsProtected{
	//TODO implement me
}

// Move to deleted table
-(void)markAsDeleted{
	//TODO implement me
}

// Move to archive table
-(void)archive{
	//TODO implement me
}

//====================================================================
// Flag/Type Property Accessor
//====================================================================
-(BOOL)isArchived{
	if(rowId < 0){
		// Transient message must not be the archived message
		return NO;
	}
	// If found in message table, then it's an archived message
	NSString* sql = [NSString stringWithFormat:@"SELECT COUNT(*) as recordCount FROM archived_message WHERE ROWID=%d",rowId];
	int i = [[SQLiteDB sharedInstance] count:sql];
	return i == 1;
}

-(BOOL)isDraft{
	return type == DRAFT_MESSAGE;
}

-(BOOL)isDeleted{
	return (type & FLAG_DELETED) > 0;
}

-(BOOL)isProtected{
	return (type & FLAG_PROTECTED) > 0;
}

-(BOOL)hasBeenSent{
	return _hasBeenRead(type);
}

-(BOOL)isOutgoing{
	return _isOutgoing(type);
}

-(BOOL)hasBeenRead{
	return _hasBeenRead(type);
}

//====================================================================
// Initialize/Dealloc methods
//====================================================================
-(id)init{
	self = [super init];
	if(nil == self){
		return nil;
	}
	rowId = -1;
	phoneNumber = nil;
	body = nil;
	date = nil;
	senderName = nil;
	sender = nil;
	type = SENT_MESSAGE;
	date = nil;
	return self;
}

-(id)initWithRowData:(NSDictionary*) row{
	self = [self init];
	if(self == nil){
		return nil;
	}
	[self setMsgId:[row objectForKey:@"ROWID"] ];
	[self setPhoneNumber:[row objectForKey:@"address"] ];
	[self setBody:[row objectForKey:@"text"] ];
	
	NSString* sFlag = [row objectForKey:@"flags"];
	if(sFlag){
		type = [sFlag intValue];
	}
	
	// Handle date
	NSString* sDate = [row objectForKey:@"date"];
	if(sDate){
		NSTimeInterval iDate = atol([sDate cStringUsingEncoding:NSASCIIStringEncoding]); 
		RETAIN(date,[NSDate dateWithTimeIntervalSince1970:iDate]);
		//LOG(@">>> Message Date: %@",date);
	}
	
	return self;
}

- (void)dealloc {
	[phoneNumber release];
	[date release];
	[body release];
	[sender release];
	
	[super dealloc];
}

//Getter methods
-(NSString*)msgId {
	return [NSString stringWithFormat:@"%d",rowId];
}

-(int)rowId{
	return rowId;
}

-(NSString*)phoneNumber {
	return phoneNumber;
}

-(NSDate*)date {
	return date;
}
-(NSString*)body {
	return body;
}

-(NSString*) text{
	return body;
}

// Internal methods
-(void)setMsgId:(NSString*) value {
	rowId = [value intValue];
}

-(void)setPhoneNumber:(NSString*) value {
	RETAIN(phoneNumber,value);
}

-(void)setDate:(NSDate*) value {
	RETAIN(date,value);
}

-(void)setBody:(NSString*) value {
	RETAIN(body,value);
}

//-(void)setType:(int) value{
//	type = value;
//}

-(int)type{
	return type;
}

-(NSString*)toString {
	//return [NSString stringWithFormat:@"%d-%@-%@", msgId, [date description], body];
	return [NSString stringWithFormat:@"%d-%@-%@", rowId, date, body];
}


// Try to load contactor by number, if not found, use the number as the name
-(NSString*) getSenderName{
	//return phoneNumber;
	Contact* c = [self getSender];//[Contact loadByNumber:phoneNumber];
	if(c && [c getId]){
		return [c compositeName];
	}else{
		return phoneNumber;
	}
}

-(Contact*)getSender{
	if(sender == nil){
		if(phoneNumber != nil){
			sender = [[Contact loadByNumber:phoneNumber] retain];
		}
	}
	if(sender == nil){
		// create a mock one
		sender = [[Contact alloc] init];
	}
	return sender;
}


//+(NSArray*)FTS_search:(NSString*)searchContent{
//	// First attach to the contact database
//	const char* sms_fts = [dbFTSPath fileSystemRepresentation];
//	[[SQLiteDB sharedInstance] execute:[NSString stringWithFormat:@"ATTACH \"%s\" AS sms_fts",sms_fts]];
//
//
//	//NSString *sql = [NSString stringWithFormat:@"SELECT * FROM message WHERE text LIKE \'%%%@%%\' ORDER BY date DESC",searchContent];
////	NSString* sqlTemplate = @"SELECT a.ROWID, a.address, a.date, a.text, a.flags, a.formalizePhoneNumber(a.address) AS phone"
//		" FROM message AS a JOIN ab.ABMultiValue AS b ON (a.phone = formalizePhoneNumber(b.value) ) JOIN ab.ABPerson AS c ON (b.record_id = c.ROWID) "
//		" WHERE (c.First LIKE '%%%@%%' OR c.Last LIKE '%%%@%%' OR phone LIKE '%%%@%%' OR a.text LIKE '%%%@%%') "
//		" ORDER BY a.date DESC";
//
//	NSMutableString *sql = [[NSMutableString alloc]init];
//	[sql appendString:@"SELECT a.ROWID, a.address, a.date, a.text, a.flags "];
//	[sql appendString:@" FROM message AS a JOIN messag1 USING(rowid) "];
//	[sql appendString:@" WHERE (messag1 MATCH '"];
//	[sql appendString:searchContent];
////	[sql appendString:@"' OR b.address match '%%"];
////	[sql appendString:searchContent];
////	[sql appendString:@"%%\' OR c.First LIKE '%%"];
////	[sql appendString:searchContent];
////	[sql appendString:@"%%\' OR c.Last LIKE '%%"];
////	[sql appendString:searchContent];
//	[sql appendString:@"') "];
//	[sql appendString:@" ORDER BY a.date DESC"];
//
//
////	NSString* sql = [NSString stringWithFormat:
////		@"SELECT a.ROWID, a.address, a.date, a.text, a.flags "
//			" FROM message AS a JOIN ab.ABMultiValue AS b ON (formalizePhoneNumber(a.address) = formalizePhoneNumber(b.value) ) JOIN ab.ABPerson AS c ON (b.record_id = c.ROWID) "
//			" WHERE (c.First LIKE \'%%%@%%\' OR c.Last LIKE \'%%%@%%\' OR a.address LIKE \'%%%@%%\' OR a.text LIKE \'%%%@%%\') "
//			" ORDER BY a.date DESC"
////		,searchContent
////		,searchContent
////		,searchContent
////		,searchContent];
//
////	NSString* sql = @"SELECT DISTINCT a.ROWID, a.address, a.date, a.text, a.flags "
//		" FROM message AS a JOIN ab.ABMultiValue AS b ON (formalizePhoneNumber(a.address) = formalizePhoneNumber(b.value) ) JOIN ab.ABPerson AS c ON (b.record_id = c.ROWID) "
//		" WHERE (c.First LIKE '%%shaw%%' OR c.Last LIKE '%%shaw%%' OR a.address LIKE '%%shaw%%' OR a.text LIKE '%%shaw%%') "
//		" ORDER BY a.date DESC";
////#ifdef DEBUG
////	NSLog(sql);
////#endif
//
//	//LOG(@"SQL is %@",sql);
//	NSArray* result = nil;
//	result =  [[SQLiteDB sharedInstance] list:self withSQL:sql];
//	
//	result = [[SQLiteDB sharedInstance] query:sql];
//	NSEnumerator* e = [result objectEnumerator];
//	NSDictionary* row = nil;
//	while(row = [e nextObject]){
//		LOG(@"ROWID: %@",[row objectForKey:@"ROWID"]);
//	//		LOG(@"First, Last: %@,%@",[row objectForKey:@"first"],[row objectForKey:@"last"]);
//	//		LOG(@"Raw Number: %@",[row objectForKey:@"address"]);
//	//		LOG(@"Formatted Number: %@",[row objectForKey:@"phone"]);
//		LOG(@"Text: %@",[row objectForKey:@"text"]);
//	}
//	
//	[[SQLiteDB sharedInstance] execute:@"DETACH sms_fts"];
//	[sql release];
//	return result;
//}

//+(NSArray*)SQL_JOIN_search:(NSString*)searchContent{
//	// First attach to the contact database
//	const char* db2 = [@"/var/root/Library/AddressBook/AddressBook.sqlitedb" fileSystemRepresentation];
//	[[SQLiteDB sharedInstance] execute:[NSString stringWithFormat:@"ATTACH \"%s\" AS ab",db2]];
//
//	//NSString *sql = [NSString stringWithFormat:@"SELECT * FROM message WHERE text LIKE \'%%%@%%\' ORDER BY date DESC",searchContent];
////	NSString* sqlTemplate = @"SELECT a.ROWID, a.address, a.date, a.text, a.flags, a.formalizePhoneNumber(a.address) AS phone"
//		" FROM message AS a JOIN ab.ABMultiValue AS b ON (a.phone = formalizePhoneNumber(b.value) ) JOIN ab.ABPerson AS c ON (b.record_id = c.ROWID) "
//		" WHERE (c.First LIKE '%%%@%%' OR c.Last LIKE '%%%@%%' OR phone LIKE '%%%@%%' OR a.text LIKE '%%%@%%') "
//		" ORDER BY a.date DESC";
//
//	NSMutableString *sql = [[NSMutableString alloc]init];
//	[sql appendString:@"SELECT a.ROWID, a.address, a.date, a.text, a.flags "];
//	[sql appendString:@" FROM message AS a LEFT JOIN ab.ABMultiValue AS b ON (formalizePhoneNumber(a.address) = formalizePhoneNumber(b.value) ) LEFT JOIN ab.ABPerson AS c ON (b.record_id = c.ROWID) "];
//	[sql appendString:@" WHERE (a.text LIKE '%%"];
//	[sql appendString:searchContent];
//	[sql appendString:@"' OR a.address LIKE '%%"];
//	[sql appendString:searchContent];
//	[sql appendString:@"%%\' OR c.First LIKE '%%"];
//	[sql appendString:searchContent];
//	[sql appendString:@"%%\' OR c.Last LIKE '%%"];
//	[sql appendString:searchContent];
//	[sql appendString:@"%%') "];
//	[sql appendString:@" ORDER BY a.date DESC"];
//
//
////	NSString* sql = [NSString stringWithFormat:
////		@"SELECT a.ROWID, a.address, a.date, a.text, a.flags "
//			" FROM message AS a JOIN ab.ABMultiValue AS b ON (formalizePhoneNumber(a.address) = formalizePhoneNumber(b.value) ) JOIN ab.ABPerson AS c ON (b.record_id = c.ROWID) "
//			" WHERE (c.First LIKE \'%%%@%%\' OR c.Last LIKE \'%%%@%%\' OR a.address LIKE \'%%%@%%\' OR a.text LIKE \'%%%@%%\') "
//			" ORDER BY a.date DESC"
////		,searchContent
////		,searchContent
////		,searchContent
////		,searchContent];
//
////	NSString* sql = @"SELECT DISTINCT a.ROWID, a.address, a.date, a.text, a.flags "
//		" FROM message AS a JOIN ab.ABMultiValue AS b ON (formalizePhoneNumber(a.address) = formalizePhoneNumber(b.value) ) JOIN ab.ABPerson AS c ON (b.record_id = c.ROWID) "
//		" WHERE (c.First LIKE '%%shaw%%' OR c.Last LIKE '%%shaw%%' OR a.address LIKE '%%shaw%%' OR a.text LIKE '%%shaw%%') "
//		" ORDER BY a.date DESC";
//
//#ifdef DEBUG
//	NSLog(sql);
//#endif
//	//LOG(@"SQL is %@",sql);
//	NSArray* result = nil;
//	result =  [[SQLiteDB sharedInstance] list:self withSQL:sql];
//	
//	result = [[SQLiteDB sharedInstance] query:sql];
//	NSEnumerator* e = [result objectEnumerator];
//	NSDictionary* row = nil;
//	while(row = [e nextObject]){
//		LOG(@"ROWID: %@",[row objectForKey:@"ROWID"]);
//	//		LOG(@"First, Last: %@,%@",[row objectForKey:@"first"],[row objectForKey:@"last"]);
//	//		LOG(@"Raw Number: %@",[row objectForKey:@"address"]);
//	//		LOG(@"Formatted Number: %@",[row objectForKey:@"phone"]);
//		LOG(@"Text: %@",[row objectForKey:@"text"]);
//	}
//	
//	[[SQLiteDB sharedInstance] execute:@"DETACH ab"];
//	[sql release];
//	return result;
//}
@end
