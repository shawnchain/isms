//==============================================================================
//	Created on 2008-4-11
//==============================================================================
//	$Id$
//==============================================================================
//	Copyright (C) <2008>  Shawn Qian(shawn.chain@gmail.com)
//
//	This file is part of iSMS-1.0.
//
//  iSMS-1.0 is free software: you can redistribute it and/or modify
//  it under the terms of the GNU General Public License as published by
//  the Free Software Foundation, either version 3 of the License, or
//  (at your option) any later version.
//
//  iSMS-1.0 is distributed in the hope that it will be useful,
//  but WITHOUT ANY WARRANTY; without even the implied warranty of
//  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//  GNU General Public License for more details.
//
//  You should have received a copy of the GNU General Public License
//  along with iSMS-1.0.  If not, see <http://www.gnu.org/licenses/>.
//==============================================================================

#import "Prefix.h"
#import "ISMSConversationModel.h"
#import "Message.h"
#import "TelephonyHelper.h"

@implementation ISMSConversationModel : NSObject

+(id)load:(NSString*)phoneNumber{
	return [[[ISMSConversationModel alloc] initWithPhoneNumber:phoneNumber] autorelease];
}

-(id)initWithPhoneNumber:(NSString*)aNumber{
	[super init];
	// TODO customized init logic here
	RETAIN(phoneNumber,aNumber);
	messages = nil;
	//[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_messageChanged:) name:MESSAGE_CHANGE_NOTIFICATION object:nil];
	return self;
}

-(void)dealloc{
	//[[NSNotificationCenter defaultCenter] removeObserver:self name:MESSAGE_CHANGE_NOTIFICATION object:nil];
	RELEASE(messages);
	RELEASE(phoneNumber);
//	RELEASE(buddyName);
	[super dealloc];
}

-(NSString*)_getAddressMatchClause{
	NSString *number1 = nil,*number2 = nil,*number3 = nil,*number4 = nil;
	
	// Split phone numbers
	NSArray *numberParts = normalizeAndSplitPhoneNumberEveryFourDigits(phoneNumber);
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
	
	NSString* addressClause = nil;;
	if(number2 != nil){
		addressClause = [NSString stringWithFormat:@" address LIKE \'%%%@\' OR address LIKE \'%%%@\' OR address LIKE \'%%%@\' OR address LIKE \'%%%@\'",number1,number2,number3,number4];
	}else{
		// No separated number, so it must be < 4, we use exact match!
		addressClause = [NSString stringWithFormat:@" address = \'%@\'",number1];
	}
	DBG(@"Formatted addressClause: %%",addressClause);
	return addressClause;
}

-(void)_reloadMessages{
	DBG(@"Loading messages for conversation %@",phoneNumber);
	
	if(phoneNumber == nil || [phoneNumber length] == 0){
		return;
	}
	
	//FIXME - Normalize the phone number and compare the right 7 digits only!
	Criteria *c = [Criteria 
	    criteria:[NSString stringWithFormat:@"(flags=0 OR flags=1 OR flags=2 OR flags=3) AND %@",[self _getAddressMatchClause]]
		order:nil
		limit:-1
		offset:-1];
	NSArray* msgs = [Message list:c];
	LOG(@"Loaded total %d messages from conversation with %@",[msgs count],phoneNumber);
	RETAIN(messages,msgs);
	//RETAIN(messages,);
}

-(NSArray*)messages{
	if(!messages){
		[self _reloadMessages];
	}
	return messages;
}

-(int)messageCount{
	//FIXME normalize the phone number and compare the right 7 digits only!
	if(phoneNumber == nil || [phoneNumber length] == 0){
		return 0;
	}
	Criteria *c = [Criteria criteria:
		[NSString stringWithFormat:@"(flags=0 OR flags=1 OR flags=2 OR flags=3) AND %@",[self _getAddressMatchClause]]
	];
	int result = [Message count:c];
	
	// Check cached messags BTW
	if(messages && [messages count] != result){
		INFO(@"Message count from database %d does not match cached message count %d !",result,[messages count]);
		RELEASE(messages);
	}
	return result;
}

-(Message*)messageAtIndex:(int)index{
	if(!messages){
		[self _reloadMessages];
	}
	
	if(index >= [messages count] && index < [self messageCount]){
		[self _reloadMessages];
	}
	
	if(index < 0 || index >= [messages count]){
		LOG(@"Incorrect message index: %d",index);
		return nil;
	}
	return [messages objectAtIndex:index];
}

//- (void) _messageChanged:(NSNotification *) notification{
//	// First check whether the update is related to this conversation
//	DBG(@"Message changed, cleaning up message cache");
//	RELEASE(messages);
//}

-(NSString*)phoneNumber{
	return phoneNumber;
}

-(void)clear{
	DBG(@"Clear conversation %@",phoneNumber);
	
	if(phoneNumber == nil || [phoneNumber length] == 0){
		return;
	}
	
	//FIXME - Normalize the phone number and compare the right 7 digits only!
	Criteria *c = [Criteria 
	    criteria:[NSString stringWithFormat:@"(flags=0 OR flags=1 OR flags=2 OR flags=3) AND %@",[self _getAddressMatchClause]]
		order:nil
		limit:-1
		offset:-1];
	int result = [Message delete:c];
	//NSArray* msgs = [Message list:c];
	LOG(@"Deleted %d messages of conversation %@",result,phoneNumber);
	
	RELEASE(messages);
}
//-(NSString*)buddyName{
//	if(!buddyName){
//		buddyName = [[Contact getNameByPhoneNumber:phoneNumber] retain];	
//	}
//	return buddyName;
//}
@end