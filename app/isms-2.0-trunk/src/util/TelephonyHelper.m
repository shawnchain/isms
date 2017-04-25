//==============================================================================
//	Created on 2008-1-18
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
#import "TelephonyHelper.h"
#import "ObjectContainer.h"
#import "Message.h"
#import "Log.h"
#import "Util.h"
#import <dlfcn.h>
#import "SQLiteDB.h"
/***************************************************************
 * Class Comments
 * 
 * @Author Shawn
 ***************************************************************/

void _fnSMSReceivedCallback (
   CFNotificationCenterRef center,
   void *observer,
   CFStringRef name,
   const void *object,
   CFDictionaryRef userInfo
){
	DBG(@"!!! Received new message - observer: %@, name: %@, object: %@, userInfo: %@",observer, name, object,userInfo);
	
	// Post MESSAGE_RECEIVED_NOTIFICATION to our observers
	NSNumber *type = [NSNumber numberWithInt:MESSAGE_RECEIVED];
	//TODO append the userInfo into _userInfo ??
	NSDictionary *_userInfo = [NSDictionary dictionaryWithObjectsAndKeys:
			type,@"type",
			nil];
	DBG(@"Map to the MESSAGE_CHANGE_NOTIFICATION and notify our own observers");
	[[NSNotificationCenter defaultCenter] 
	  postNotificationName:MESSAGE_CHANGE_NOTIFICATION 
	  object:(id)observer
	  userInfo:_userInfo];
}


/***************************************************************
 * Customized sqlite method to check message flags
 * To be compatible with 1.1.3
 * @Author Shawn
 ***************************************************************/
static void sqlite3_fn_is_message_read(sqlite3_context *context, int argc, sqlite3_value **argv){
	if(argc != 1){
		char errMsg[] = "incorrect call, read(flags) only accepts 1 parameter";
		sqlite3_result_error(context,errMsg,-1);
		return;
	}
	int valueType = sqlite3_value_type(argv[0]);
	if(valueType != SQLITE_INTEGER){
		//Always return YES if type is incorrect
		sqlite3_result_int(context,0);
		return;
	}
	int flags = sqlite3_value_int(argv[0]);
	int result = 1;
	
	// First check whether is an incoming message
	if((flags & 1 ) == 0){
	  if((flags & 2) == 2){
	        result = 1;
	  }else{
	        result = 0;
	  }
	}else{
	  // Others are all consider read
	  result = 1;
	}
	/*
	if((flags << 0x1E) > 0 ){
		if((flags << 0x1F) > 0){
			if((flags << 0x15) > 0){
				result = 0;
			}
		}
	}*/
	DBG(@"sqlite3_fn_is_message_read -> read(%d) = %d",flags,result);
	sqlite3_result_int(context,result);
}

/***************************************************************
 * Normalize the phone numbers
 * 
 * @Author Shawn
 ***************************************************************/
NSString* normalizePhoneNumber(NSString* inNumber){
	NSMutableString* outNumber = [[NSMutableString alloc]init];
	for(int i = 0;i<[inNumber length];i++){
		unichar aChar = [inNumber characterAtIndex:i];
		if(aChar >= '0' && aChar <= '9'){
			[outNumber appendFormat:@"%c",aChar];	
		}
	}
	return [outNumber autorelease];
}

NSArray* normalizeAndSplitPhoneNumberEveryFourDigits(NSString* number){
	NSString* formalizedNumber = normalizePhoneNumber(number);
	DBG(@"Formalized number %@",formalizedNumber);
	
	int len = [formalizedNumber length];
	if(len > 7){
		formalizedNumber = [formalizedNumber substringFromIndex:(len - 7)];
		len = 7;
	}
		
	NSString *part1,*part2;
	if(len > 4){
		part1 = [formalizedNumber substringToIndex:(len - 4)];
		part2 = [formalizedNumber substringFromIndex:(len -4)];
	}else{
		part1 = formalizedNumber;
		part2 = @"";
	}
			
	return [NSArray arrayWithObjects:part1,part2,nil]; 
	
//	// Match the last 8 digital number of the phone
//	NSString *spacedNumber;
//	int len = [number length];
//	if(len > 8){
//		// We only need the last 8 number
//		number = [number substringFromIndex:(len - 8)];
//	}
//	
//	NSString *part1,*part2;
//	if(len > 4){
//		part1 = [number substringToIndex:4];
//		part2 = [number substringFromIndex:4];
//	}else{
//		part1 = number;
//		part2 = @"";
//	}
//	
//	return [NSArray arrayWithObjects:part1,part2,nil]; 
}

// 1234 ==> 12 34 (2)
// 12345 ==> 1 23 45 (1,3)
// 123456 ==> 12 34 56 (2,4)
// 1234567 ==> 1 23 45 67 (1,3,5)
NSString* convertToFranceStyleNumber(NSString* aNumber){
	NSMutableString *franceNumber = [[NSMutableString alloc]init];
	int len = [aNumber length];
	BOOL isOdd = ((len % 2)!= 0);
	for(int i = 0;i<len;i++){
		unichar aChar = [aNumber characterAtIndex:i];
		if(isOdd){
			if(i % 2 != 0){
				[franceNumber appendFormat:@" %c",aChar];
			}else{
				[franceNumber appendFormat:@"%c",aChar];
			}
		}else{
			if(i > 0 && i % 2 == 0){
				[franceNumber appendFormat:@" %c",aChar];
			}else{
				[franceNumber appendFormat:@"%c",aChar];
			}
		}
	}
	return [franceNumber autorelease];
}

static void sqlite3_fn_normalize_phone_number(sqlite3_context *context, int argc, sqlite3_value **argv) {
	//assert( argc==1 );
	//int maxResultDigits = 7;

	int valueType = sqlite3_value_type(argv[0]);
	if(valueType == SQLITE_NULL /*|| valueType == SQLITE_DATE*/) {
		sqlite3_result_null(context);
		return;
	} else if(valueType != SQLITE_TEXT) {
		//TODO support integer ??
		fprintf(stderr, "Unsupported value type %d",valueType);
		sqlite3_result_null(context);
		return;
	}
	const unsigned char* inValue = NULL;
	inValue = sqlite3_value_text(argv[0]);
	int len = strlen((char*)inValue);
	char *buf = malloc(sizeof(char) * (len + 1));
	if (buf == NULL) {
		fprintf(stderr,"malloc error in formalizePhoneNumber, buf\n");
		sqlite3_result_null(context);
		return;
	}
	memset(buf, 0, len + 1);

	// Convert
	//char* p = buf;
	int newLen = 0;
	for (int i=0; i<len; i++) {
		if ((inValue[i]>='0') && (inValue[i]<='9')) {
			//*p++=inValue[i];
			buf[newLen] = inValue[i];
			newLen++;
		}
	}
	if(newLen == 0) {
		sqlite3_result_null(context);
		return;
	}

#ifdef DEBUG
	// Get the last $maxResultDigits
	DBG(@"%s -> %s",inValue,buf);
#endif
	//sqlite3_result_text(context,buf,strlen(buf) + 1,free);
	sqlite3_result_text(context,buf,newLen + 1,free);
}


/***************************************************************
 * Class Comments
 * 
 * @Author Shawn
 ***************************************************************/
@implementation TelephonyHelper : NSObject

+(void)initialize{
	static BOOL initialized = NO;
	if (!initialized) {
		[[ObjectContainer sharedInstance] registerObject:self forKey:self isSingleton:YES];
		initialized = YES;
	}
}

+(id)sharedInstance{
	return [[ObjectContainer sharedInstance] objectForKey:self];
}

-(void)dealloc{
	if(ctLibHandler){
		dlclose(ctLibHandler);
		ctLibHandler = nil;
	}
	[super dealloc];
}

-(void)registerSMSReceivedNotification{
	void* center =  CTTelephonyCenterGetDefault();
	CTTelephonyCenterAddObserver(center, self, _fnSMSReceivedCallback,kCTSMSMessageReceivedNotification,NULL,4);
	//CTTelephonyCenterAddObserver(center, self, MyCallBack2,kCTSMSMessageReplaceReceivedNotification,NULL,4);
	DBG(@"Observer for SMSReceivedNotification registered.");
}

-(void)unregisterSMSReceivedNotification{
	void* center =  CTTelephonyCenterGetDefault();
	CTTelephonyCenterRemoveObserver(center, self, kCTSMSMessageReceivedNotification,NULL);
	DBG(@"Observer for SMSReceivedNotification removed.");
}

-(void*)ctLibHandler{
	if(ctLibHandler){
		return ctLibHandler;
	}
	ctLibHandler = dlopen(CORE_TELEPHONY_FRAMEWORK,RTLD_NOLOAD);
	if(ctLibHandler != nil){
		return ctLibHandler;
	}else{
		// Must be something wrong !
		LOG(@"ERROR - CoreTelephony Framework is not loaded, error is: %s",dlerror());
		// Let's doom!
		return nil;
	}
}

//TODO we could reuse the sqlite db connection in CPRecordStore()
-(void)registerSQLiteFunctions:(SQLiteDB*) db{
	int ret = sqlite3_create_function([db conn], "normalize_phone_number", 1, SQLITE_UTF8, NULL, &sqlite3_fn_normalize_phone_number, NULL, NULL);
	if(ret == SQLITE_OK){
		DBG(@"Customized sqlite3 function normalize_phone_number() registered ok");	
	}else{
		const char* errMsg = sqlite3_errmsg([db conn]);
		LOG(@"Error registering Customized sqlite3 function normalize_phone_number(), error code %d, error message %s",ret,errMsg);
	}

	if(osVersion() < 113){
		// Nothing to do for firmware version lower than 1.1.3
		return;
	}

	// The read() func is mapped to method messageIsRead exported in CoreTelephony
	static void (*fnMessageIsRead)(sqlite3_context *context, int argc, sqlite3_value **argv) = nil;
	if(fnMessageIsRead == nil){
		fnMessageIsRead = dlsym([self ctLibHandler],"messageIsRead");
	}
	if(fnMessageIsRead == nil){
		LOG(@"ERROR - Could not find symbol \"messageIsRead\", error is %s",dlerror());
		LOG(@"Will use my own message_is_read function");
		fnMessageIsRead = sqlite3_fn_is_message_read;
	}
	 
	if(fnMessageIsRead){
		ret = sqlite3_create_function([db conn], "read", 1, SQLITE_UTF8, NULL, fnMessageIsRead, NULL, NULL);
		if(ret == SQLITE_OK){
			DBG(@"Customized sqlite3 function read() registered ok");	
		}else{
			const char* errMsg = sqlite3_errmsg([db conn]);
			LOG(@"Error registering Customized sqlite3 function read(), error code %d, error message %s",ret,errMsg);
		}
	}
}

// Create CTSMSMessage object, compatible with all iPhone firmware versions
-(CTSMSMessageRef) createCTSMSMessage:(NSString*) text currentNumber:(NSString*)currentNumber numbers:(NSArray*)numbers{
	// For older versions, no message group
	if(osVersion() < 113){
		DBG(@"iPhone version is older than 1.1.3, using old API");
		return CTSMSMessageCreate(0,currentNumber,text);
	}else{
		DBG(@"iPhone version is %d, using new API that with messageGroup support",osVersion());
	}
	
	// For 1.1.3 and higher, need the message group
	int gid = -1;
	
	//First we'll look up existing message group for current phone number
	// if not found, then create a new one with all phone numbers
	static int (*fn_CTSMSMessageStoreGroupIDForPerson)(CFStringRef) = nil;
	if(fn_CTSMSMessageStoreGroupIDForPerson == nil){
		fn_CTSMSMessageStoreGroupIDForPerson = dlsym([self ctLibHandler],"_CTSMSMessageStoreGroupIDForPerson");
	}
	if(fn_CTSMSMessageStoreGroupIDForPerson){
		gid = fn_CTSMSMessageStoreGroupIDForPerson((CFStringRef)currentNumber);
		DBG(@"Found message group id=%d for number %@",gid,currentNumber);
	}else{
		LOG(@"ERROR - Could not find symbol \"_CTSMSMessageStoreGroupIDForPerson\", error is %s",dlerror());
		// bail out 
		return nil;
	}
	
	if(gid == -1){
		// Create a new message group
		static int (*fnCTSMSMessageCreateGroupWithMembers)(CFArrayRef) = nil;
		if(fnCTSMSMessageCreateGroupWithMembers == nil){
			fnCTSMSMessageCreateGroupWithMembers = dlsym([self ctLibHandler],"CTSMSMessageCreateGroupWithMembers");
		}
		if(fnCTSMSMessageCreateGroupWithMembers){
			gid = fnCTSMSMessageCreateGroupWithMembers((CFArrayRef)numbers);
			DBG(@"Message group id=%d for numbers %@ is created successfully",gid,numbers);
		}else{
			LOG(@"ERROR - Could not find symbol \"CTSMSMessageCreateGroupWithMembers\", error is %s",dlerror());
			// bail out 
			return nil;
		}
	}
	
	if(gid == -1){
		LOG(@"ERROR - Could not retrieve or create MessageGroup");
		return nil;
	}
	
	// Create the message
	//FIXME What is apple's ass ?
	int ass = 0;
	
	static struct __CTSMSMessage* (*fnCTSMSMessageCreateWithGroupAndAssociation) (
					void* unknow,
					NSString* number,
					void* text,
					int gid,
					int ass
				) = nil;
	if(fnCTSMSMessageCreateWithGroupAndAssociation == nil){
		fnCTSMSMessageCreateWithGroupAndAssociation = dlsym([self ctLibHandler],"CTSMSMessageCreateWithGroupAndAssociation");
	}
	if(fnCTSMSMessageCreateWithGroupAndAssociation){
		return fnCTSMSMessageCreateWithGroupAndAssociation(0,currentNumber,text,gid,ass);
	}else{
		LOG(@"ERROR - Could not find symbol \"CTSMSMessageCreateWithGroupAndAssociation\", error is %s",dlerror());
	}
	return nil;
}

@end

////=====================================================
//// iPhone 1.1.3 need ass
////=====================================================
//typedef struct __CTSMSMessage* (*fnCTSMSMessageCreateWithGroupAndAssociation) (
//	void* unknow,
//	NSString* number,
//	void* text,
//	int gid,
//	int ass
//);
//
////void* _load_113_ct_message_create_with_gid_and_ass(){
////	return 0;
////}
//
//CTSMSMessageRef CreateCTSMSMessage(NSString* number, NSString* text, int gid, int ass){
//	// Detect the firmware version and delegate to the correct CoreTelephony APIs
//	BOOL is113 = (osVersion() >= 113);
//	if(is113){
//		fnCTSMSMessageCreateWithGroupAndAssociation fn = dlsym(RTLD_NEXT,"CTSMSMessageCreateWithGroupAndAssociation");
//		return fn(0,number,text,gid,ass);
//	}else{
//		return CTSMSMessageCreate(0,number,text);
//	}
//}