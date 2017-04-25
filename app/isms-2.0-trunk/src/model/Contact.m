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

#import "Contact.h"
#import "Log.h"
#import "SQLiteDB.h"
#import "ObjectContainer.h"
#import "TelephonyHelper.h"

static NSString* __compositeName(NSString* firstName, NSString* lastName);
extern NSString* ABCCopyLocalizedPropertyOrLabel(NSString*);

@implementation Contact

+(Contact*) loadById:(NSString*) aID{
	return nil;
}

/**
 * Load contact by number, support following number format:
 * 
 * xxxxxxx // china
 * xxx xxxx // china ?
 * xxx-xxxx // us
 * x xx xx xx // france
 */
+(Contact*) loadByNumber:(NSString*) number {
	LOG(@"Load contact by number: %@",number);
	if(number == nil || [number length] == 0) {
		return nil;
	}
	NSString *number1 = nil,*number2 = nil,*number3 = nil,*number4 = nil;
	
//	NSArray *numberParts = [number componentsSeparatedByString:@" "];
//	int parts = [numberParts count];
//	if(parts == 1){
//		numberParts = [self _splitNumberEveryFourDigits:number];
//		parts = [numberParts count];
//	}
	NSArray *numberParts = normalizeAndSplitPhoneNumberEveryFourDigits(number);
	//int parts = [numberParts count];
	NSString *part1 = [numberParts objectAtIndex:0];
	NSString *part2 = [numberParts objectAtIndex:1];
	
	INFO(@"Number part1=%@, part2=%@",part1,part2);
	
	number1 = [NSString stringWithFormat:@"%@%@",part1,part2];
	if(part2 != nil && [part2 length] > 0){
		number2 = [NSString stringWithFormat:@"%@ %@",part1,part2];
		number3 = [NSString stringWithFormat:@"%@-%@",part1,part2];
		number4 = convertToFranceStyleNumber(number1);
	}
	
	INFO(@"Number1=%@, Number2=%@, Number3=%@, Number4=%@",number1,number2,number3,number4);

	NSString* sql;
	if(number2 != nil){
		sql = [NSString stringWithFormat:@"SELECT a.ROWID, a.First, a.Last, b.value FROM ABPerson AS a LEFT JOIN ABMultiValue AS b ON a.ROWID = b.record_id WHERE b.property=3 AND b.value LIKE \'%%%@\' or b.value LIKE \'%%%@\' or b.value LIKE \'%%%@\' or b.value LIKE \'%%%@\'",number1,number2,number3,number4];
	}else{
		// No separated number, so it must be < 4, we use exact match!
		sql = [NSString stringWithFormat:@"SELECT a.ROWID, a.First, a.Last, b.value FROM ABPerson AS a LEFT JOIN ABMultiValue AS b ON a.ROWID = b.record_id WHERE b.property=3 AND b.value = \'%@\'",number1];
	}
	
	LOG(@"Formatted SQL: %s",[sql UTF8String]);
	
	//NOTE self = [Contact class]
	return [[SQLiteDB sharedInstance] load:self withSQL:sql];
}

static NSString* __getColumnText(sqlite3_stmt* stmt, int col){
	const char* text = (const char*)sqlite3_column_text(stmt,col);
	if(text){
		return [[NSString alloc] initWithCString:text encoding: NSUTF8StringEncoding];
	}
	return nil;
}

/**
 * Retuan an array contains contact's compisite name, property label & property value
 * 
 */
+(NSArray*) searchContactProperty:(PropertyType)type forName:(NSString*)name{
	NSMutableArray* result = [[NSMutableArray alloc] init];
	SQLiteDB* sqliteDB = [SQLiteDB sharedInstance];
	
	@synchronized(sqliteDB){
		sqlite3* db = [sqliteDB conn];
		// Hookup the customized functions
		NSString *sql = [NSString stringWithFormat:@"SELECT ROWID, first, last, l.value AS label, v.value AS value FROM ABPerson p JOIN ABMultiValue v ON (p.rowid = v.record_id)  JOIN ABMultivalueLabel l ON (v.label = l.rowid) WHERE property = %d AND (firstSort LIKE \'%@%%\' OR lastSort LIKE \'%@%%\')",type,name,name];
		const char* sqlUTF8 = [sql UTF8String];
		LOG(@"searchContactProperty SQL: %s",sqlUTF8);
		sqlite3_stmt* stmt = NULL;
		int ret = sqlite3_prepare(db,sqlUTF8,-1,&stmt,NULL);
		BOOL hasError = (SQLITE_OK != ret);
		if(!hasError){
	//		sqlite3_bind_int(stmt,1,type);
	//		sqlite3_bind_text(stmt,)
			while((ret = sqlite3_step(stmt)) == SQLITE_ROW){
				// Read each row
				int colCount = sqlite3_column_count(stmt);
				if(colCount == 0){
					// Oops, no column returned ??
					continue;
				}
				//			for(int i = 1;i <= colCount;i++){
				//				NSString* colName = [[NSString alloc] initWithUTF8String:sqlite3_column_name(stmt,0)];
				//				NSString* colText = [[NSString alloc] initWithUTF8String:(char*)sqlite3_column_text(stmt,0)];
				//				[aRow setObject:colText forKey:colText];
				//				LOG(@"%@ = %@",colName,colText);
				//				[colName release];
				//				[colText release];
				//			}
				NSString* _rowid = __getColumnText(stmt,0);
				NSString* _first = __getColumnText(stmt,1);//[[NSString alloc] initWithCString:(const char*)sqlite3_column_text(stmt,1) encoding: NSUTF8StringEncoding];
				NSString* _last  = __getColumnText(stmt,2);//[[NSString alloc] initWithCString:(const char*)sqlite3_column_text(stmt,2) encoding: NSUTF8StringEncoding];
				NSString* _label = __getColumnText(stmt,3);//[[NSString alloc] initWithCString:(const char*)sqlite3_column_text(stmt,3) encoding: NSUTF8StringEncoding];
				NSString* _value = __getColumnText(stmt,4);//[[NSString alloc] initWithCString:(const char*)sqlite3_column_text(stmt,4) encoding: NSUTF8StringEncoding];
				NSString* _compositeName = [__compositeName(_first,_last) retain];
				NSString* _localizedLabel = ABCCopyLocalizedPropertyOrLabel(_label);
				//LOG(@"%@ | %@ | %@",_compositeName,_localizedLabel,_value);
				// Now store in a map
				NSMutableDictionary *aRow = [[NSMutableDictionary alloc] init];
				[aRow setObject:_rowid forKey:@"ROWID"];
				[aRow setObject:_compositeName forKey:@"compositeName"];
				[aRow setObject:_localizedLabel forKey:@"label"];
				[aRow setObject:_value forKey:@"value"];
				[result addObject:aRow];
				
				[_first release];
				[_last release];
				[_label release];
				[_value release];
				[_compositeName release];
				[_localizedLabel release];
				[aRow release];
				//LOG(@"==========================");
			}
			if(ret == SQLITE_ERROR){
				hasError = YES;
			}
		}
		
		if(hasError){
			const char* errMsg = sqlite3_errmsg(db);
			LOG(@"Error executing sql:%@, error is %d/%s",sql,ret,errMsg);
		}
		
		// clean up
		if(stmt) {
			sqlite3_finalize(stmt);
			stmt = NULL;
		}
	}
	return [result autorelease];
//	return [[SQLiteDB sharedInstance] query:sql];
}

+(NSArray*) searchByPartialName:(NSString*) name {
	if(name == nil || [name length] == 0) {
		return nil;
	}

	//NSString *temp=@"%";
	//NSString *sql=[NSString stringWithFormat:@"select first, last, value from ABperson, ABMultivalue where ABPerson.rowid=ABmultivalue.record_id and (first like \'%@%@%@\' or last like   \'%@%@%@\')",temp,name,temp,temp,name,temp];
	//TODO search the index table ?
	NSString *sql = [NSString stringWithFormat:@"SELECT first, last, value FROM ABperson, ABMultivalue where ABPerson.rowid=ABmultivalue.record_id and (first LIKE \'%@%%\' OR last LIKE   \'%@%%\')",name,name];

	// This is a class method, so "self" is [Contact class]
	return [[SQLiteDB sharedInstance] list:self withSQL:sql];
}

+(NSString *)getNameByPhoneNumber:(NSString*)aNum
{
	NSString* s = [[Contact loadByNumber:aNum] compositeName];
	if(s){
		return s;
	}else{
		return aNum;
	}
}

-(id)init{
	self = [super init];
	if(nil == self){
		return nil; 
	}
	rowId = nil;
	firstName = nil;
	lastName = nil;
	phoneNumber = nil;
	return self;
}

-(id)initWithRowData:(NSDictionary*) row {
	self = [self init];
	if(self) {
		rowId = [[row objectForKey:@"ROWID"] retain];
		firstName = [[row objectForKey:@"First"] retain];
		lastName = [[row objectForKey:@"Last"] retain];
		phoneNumber = [[row objectForKey:@"value"] retain];
		LOG(@"Contact(%@ %@/%@) loaded ok",firstName,lastName, phoneNumber);
	}
	return self;
}

-(void)dealloc
{
	[rowId release];
	[firstName release];
	[lastName release];
	[phoneNumber release];
	[super dealloc];
}

-(NSString *)getId {
	return rowId;
}

-(NSString *)firstName {
	return firstName;
}

-(NSString *)lastName {
	return lastName;
}

-(NSString *)phoneNumber {
	return phoneNumber;
}

-(void)setFirstName:(NSString*)value {
	firstName=value;
}

-(void)setLast:(NSString*)value {
	lastName = value;
}
-(void)setPhoneNumber:(NSString*)value {
	phoneNumber=value;
}
-(void)setId:(NSString*)value {
	rowId=value;
}

-(NSString*)compositeName {
	return __compositeName(firstName,lastName);
}

int getPersonNameOrdering();
static NSString* __compositeName(NSString* firstName, NSString* lastName){
	if(firstName != nil && lastName != nil && [firstName length] > 0 && [lastName length] > 0){
		//Both first name/last name exsits
		if(getPersonNameOrdering() == 0){
			return [NSString stringWithFormat:@"%@ %@", firstName,lastName];	
		}else{
			return [NSString stringWithFormat:@"%@ %@", lastName,firstName];
		}
	}
	
	if(firstName != nil && [firstName length] > 0){
		return [NSString stringWithFormat:@"%@", firstName];
	}
	
	if(lastName != nil && [lastName length] > 0){
		return [NSString stringWithFormat:@"%@", lastName];
	}
	
	return @"";
}

-(NSString*)description{
	return [self compositeName];
}
@end