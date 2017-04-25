//==============================================================================
//	Created on 2008-4-10
//==============================================================================
//	$Id$
//==============================================================================
//	Copyright (C) <2008>  Shawn Qian(shawn.chain@gmail.com)
//
//	This file is part of iSMS-1.0-trunk.
//
//  iSMS-1.0-trunk is free software: you can redistribute it and/or modify
//  it under the terms of the GNU General Public License as published by
//  the Free Software Foundation, either version 3 of the License, or
//  (at your option) any later version.
//
//  iSMS-1.0-trunk is distributed in the hope that it will be useful,
//  but WITHOUT ANY WARRANTY; without even the implied warranty of
//  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//  GNU General Public License for more details.
//
//  You should have received a copy of the GNU General Public License
//  along with iSMS-1.0-trunk.  If not, see <http://www.gnu.org/licenses/>.
//==============================================================================
#import "SMSCenter.h"

#import "Prefix.h"
//#include "encode.h"
//#include "device.h"
#import "ObjectContainer.h"
#import <MessageUI/SMSComposeRecipient.h>
#import "TelephonyHelper.h"

#import "SMSSendStatusCallback.h"
#import "Message.h"
#import "Log.h"

id _buildStatusData(id rcpt,CTSMSMessageRef msg,NSString* statusText){
	NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
	if(rcpt){
		[dict setObject:rcpt forKey:@"recipient"];
	}
	if(msg){
		[dict setObject:(id)msg forKey:@"message"];
		[dict setObject:[NSNumber numberWithInt:_CTSMSMessageGetRecordIdentifier(msg)] forKey:@"messageId"];
	}
	if(statusText){
		[dict setObject:statusText forKey:@"statusText"];
	}
	return [dict autorelease];
}

void _logAndNotifyError(SMSCenter* controller, id rcpt,CTSMSMessageRef msg,NSString* errorMessage){
	//NSString *e = @"Incorrect message flag, it should be unsent and outgoing message!";
	LOG(@"ERROR - %@",errorMessage);
	[controller _sendError:_buildStatusData(rcpt,msg,errorMessage)];
}

// Will be always on the main thread ?
void _fnSMSSendStatusCallBack (
   CFNotificationCenterRef center,
   void *observer,
   CFStringRef name,
   const void *object,
   CFDictionaryRef userInfo)
{
	SMSCenter		*smsCenter = (SMSCenter*)observer;
	CTSMSMessageRef _sms = (CTSMSMessageRef)object; 
	
	DBG(@">>> Message send status callback: %@,%@,%@",name,object,userInfo);
	SMSComposeRecipient	*_rcpt = [[smsCenter currentTask]currentRecipient];
	if(kCTSMSMessageSendErrorNotificiation == (NSString*)name){
		LOG(@"Message send error! message: %@, recipient: %@,%@",object, [_rcpt displayString],[_rcpt uncommentedAddress]);
		//Notify out and stop processing
		[smsCenter _sendError:_buildStatusData(nil,_sms,nil)];
	}else if(kCTSMSMessageSentNotification == (NSString*)name){
		//SUCCESS!
		LOG(@"Message is sent! message: %@, recipient: %@,%@",object, [_rcpt displayString],[_rcpt uncommentedAddress]);
		// Notify and go on next
		[smsCenter _sendSuccess:nil];
		
		// send next on after 1s delay
		[smsCenter sendNextWithDelay:(NSTimeInterval)0.5];
	}
}

/***************************************************************
 * SMSSendTask Comments
 * 
 * @Author Shawn
 ***************************************************************/
@implementation SMSSendTask : NSObject

-(id)initWithMessage:(NSString*)aText recipients:(NSArray*)rcpts statusCallback:(SMSSendStatusCallback*)cb{
	[super init];
	text = [aText retain];
	// Array of SMSComposeRecipient
	recipients = [[NSArray alloc]initWithArray:rcpts];
	// Array of phone numbers
	numbers = [[NSMutableArray alloc]initWithCapacity:[recipients count]];
	for(int i = 0;i < [recipients count];i++){
		[numbers addObject:[[recipients objectAtIndex:i] uncommentedAddress]];
	}
	
	// setup the number array
	statusCallback = [cb retain];
	
	messages = [[NSMutableDictionary alloc]init];// Message <1>---<1> Recipient
	currentRecipientIndex = 0; 
	return self;
}

-(void)dealloc{
	RELEASE(text);
	RELEASE(recipients);
	RELEASE(numbers);
	RELEASE(statusCallback);
	
	RELEASE(messages);
	[super dealloc];
}

// As we're iterating the recipient from index 0, so we can create the message
// in each iteration.
-(struct __CTSMSMessage*)currentMessage{
	// We assume that messages has the same size as recipients.
	id _rcpt = [self currentRecipient];
	if(_rcpt == nil){
		return nil;
	}
	struct __CTSMSMessage* _msg = (struct __CTSMSMessage*)[messages objectForKey:_rcpt];//[messages objectAtIndex:currentRecipientIndex];
	if(_msg == nil){
		// Create a new one
		LOG(@"Create new message object for recipient %@",[_rcpt displayString]);
		_msg = [[TelephonyHelper sharedInstance] createCTSMSMessage:text currentNumber:[numbers objectAtIndex:currentRecipientIndex] numbers:numbers];
		if(_msg){
			[messages setObject:(id)_msg forKey:_rcpt];
			// Added to dict, can release it here to decrease the ref count
			CFRelease(_msg);
		}else{
			LOG(@"ERROR - Could not create CTSMSMessage, check logs for more details!");
		}
	}
	
	return _msg;
}

-(struct __CTSMSMessage*)nextMessage{
	return [self messageForRecipient:[self nextRecipient]];
}

-(struct __CTSMSMessage*)messageForRecipient:(id)rcpt{
	if(rcpt){
		return (struct __CTSMSMessage*)[messages objectForKey:rcpt];	
	}else{
		return nil;
	}
}

-(id)currentRecipient{
	return [recipients objectAtIndex:currentRecipientIndex];
}

-(int)recipientCount{
	return [recipients count];
}

-(id)recipientAtIndex:(int)index{
	return [recipients objectAtIndex:index];
}

-(id)nextRecipient{
	if(currentRecipientIndex == [recipients count] -1){
		LOG(@"No more next recipient, currentRecipientIndex=%d, recipients count=",currentRecipientIndex,[recipients count]);
		return nil;
	}
	return [recipients objectAtIndex:++currentRecipientIndex];
}

-(SMSSendStatusCallback*)statusCallback{
	return statusCallback;
}

//0 ~ currentRecipientIndex are sent recipients
-(NSArray*)sentRecipients{
	NSMutableArray *result = [[NSMutableArray alloc] init];
	for(int i = 0;i < currentRecipientIndex;i++){
		[result addObject:[recipients objectAtIndex:i]];
	}
	id _rcpt = [self currentRecipient];
	if(CTSMSMessageHasBeenSent([self messageForRecipient:_rcpt])){
		[result addObject:_rcpt];
	}
	return [result autorelease];
}

//TODO currentRecipientIndex ~ [recipients count] are sent recipients
-(NSArray*)unsentRecipients{
	NSMutableArray *result = [[NSMutableArray alloc] init];
	id _rcpt = [self currentRecipient];
	if(!CTSMSMessageHasBeenSent([self messageForRecipient:_rcpt])){
		[result addObject:_rcpt];
	}
	for(int i = currentRecipientIndex + 1;i< [recipients count];i++){
		[result addObject:[recipients objectAtIndex:i]];
	}
	return [result autorelease];
}

-(NSString*)text{
	return text;
}

//-(BOOL) isEqual:(id)another{
//	return NO;
//};
@end

/***************************************************************
 * SMSCenter Class
 * 
 * @Author Shawn
 ***************************************************************/
@implementation SMSCenter
+(void)initialize{
	static BOOL initialized = NO;
	if (!initialized) {
		[[ObjectContainer sharedInstance] registerObject:self forKey:self isSingleton:YES];
		initialized = YES;
	}
}

+(SMSCenter*)getInstance{	
	return [[ObjectContainer sharedInstance] objectForKey:self];
}

-(id)init{
	[super init];
	LOG(@"SMSCenter Initializing");
	void* center =  CTTelephonyCenterGetDefault();
	CTTelephonyCenterAddObserver(center, self, _fnSMSSendStatusCallBack,kCTSMSMessageSentNotification,NULL,4);
	CTTelephonyCenterAddObserver(center, self, _fnSMSSendStatusCallBack,kCTSMSMessageSendErrorNotificiation,NULL,4);
	DBG(@"Observer for SMS send notification registered");
	return self;
}

-(void)dealloc{
	void* center =  CTTelephonyCenterGetDefault();
	CTTelephonyCenterRemoveObserver(center, self, kCTSMSMessageSentNotification,NULL);
	CTTelephonyCenterRemoveObserver(center, self, kCTSMSMessageSendErrorNotificiation,NULL);
	DBG(@"Observer for SMS send notification removed");
	
	RELEASE(currentTask);
	[super dealloc];
}

// setSendTask is not really the send task but just prepare some data and ready to go
-(BOOL)setSendTask:(NSString*)text to:(NSArray*)rcpts statusCallback:(SMSSendStatusCallback*)cb{
	if(text == nil || rcpts == nil){
		LOG(@"ERROR - message text and recipients is null!");
		return NO;
	}
	
	if(currentTask){
		LOG(@"ERROR - Current task is not completed!");
		return NO;
	}
	// Create the task
	currentTask = [[SMSSendTask alloc] initWithMessage:text recipients:rcpts statusCallback:cb];
	return YES;
}

-(BOOL)send{
	if(currentTask == nil){
		LOG(@"ERROR - currentTask is null, nothing to send!");
		return NO;
	}
	// Start from the first recipient
	SMSComposeRecipient* _rcpt = [currentTask currentRecipient];
	DBG(@">>> Sending current recipient %@",_rcpt);
	[self _willSend:_buildStatusData(_rcpt,nil,nil)];
	
	CTSMSMessageRef _msg = [currentTask currentMessage];
	
	if(_msg){
		return [self _sendMessageInBackground:_msg];	
	}else{
		LOG(@"ERROR - current message is nil, send aborted");
		return NO;
	}
	//[NSThread detachNewThreadSelector:@selector(_threadEntry:) toTarget:self withObject:(id)_msg];
	//return NO;
}

-(BOOL)send:(NSString*)text to:(NSArray*)rcpts statusCallback:(SMSSendStatusCallback*)cb{
	if([self setSendTask:text to:rcpts statusCallback:cb]){
		return [self send];
	}
	return NO;
}

-(BOOL)sendNextWithDelay:(NSTimeInterval)delay{
	[self performSelector:@selector(sendNext) withObject:nil afterDelay:delay];
	return YES;
}

-(BOOL)sendNext{
	DBG(@">>> sendNext called");
	if(currentTask == nil){
		LOG(@"ERROR - currentTask is nil, nothing to send!");
		//FIXME notify the status callback with error message!
		return NO;
	}
	// Process next recipient
	// Start from the first recipient
	SMSComposeRecipient* _rcpt = [currentTask nextRecipient];
	if(_rcpt == nil){
		// We're done! finish the task
		return [self finishSendTask];
	}else{
		DBG(@">>> Current recipient is %@",[_rcpt displayString]);
	}
	
	CTSMSMessageRef _msg = [currentTask currentMessage];
	if(_msg){
		[self _willSend:_buildStatusData(_rcpt,_msg,nil)];
		//[NSThread detachNewThreadSelector:@selector(_threadEntry:) toTarget:self withObject:(id)_msg];
		return [self _sendMessageInBackground:_msg];
	}else{
		LOG(@"ERROR - current message is nil, sendNext aborted");
		return NO;
	}
}

-(BOOL)retry{
	if(currentTask == nil){
		LOG(@"ERROR - currentTask is nil, nothing to retry!");
		//FIXME notify the status callback with error message!
		return NO;
	}
	
	// Retry current recipient
	SMSComposeRecipient* _rcpt = [currentTask currentRecipient];
	[self _willSend:_buildStatusData(_rcpt,nil,nil)];
	
	CTSMSMessageRef _msg = [currentTask currentMessage];
	
	return [self _sendMessageInBackground:_msg];
}

-(BOOL)abort{
	if(currentTask == nil){
		LOG(@"ERROR - currentTask is nil, nothing to abort!");
		return NO;
	}
	
	// Add current recipient to unsent list
	SMSComposeRecipient *_rcpt = [currentTask currentRecipient];
	LOG(@"Message send to %@ aborted.",_rcpt);
	
	// Save a new message in the draft folder
	//Message* newMsg = [[Message alloc] init];
	Message *newMsg = [Message newDraftMessage];
	[newMsg setPhoneNumber:[_rcpt uncommentedAddress]];
	[newMsg setBody:[currentTask text]];
	//[newMsg setType:DRAFT_MESSAGE];
	[newMsg save];
	[newMsg release];
	
	// Delete the failure one
	CTSMSMessageDelete([currentTask currentMessage]);
	
	// send next after 1s delay
	[self sendNextWithDelay:(NSTimeInterval)0.5];
	return YES;
}

-(BOOL)abortSendTask{
	if(currentTask == nil){
		LOG(@"ERROR - currentTask is nil, nothing to abort!");
		return NO;
	}
	// Abort current task

	// Add current recipient to unsent list
	SMSComposeRecipient *_rcpt = [currentTask currentRecipient];
	// FIXME duplicated code!
	// Save a new message in the draft folder
	//Message* newMsg = [[Message alloc] init];
	Message *newMsg = [Message newDraftMessage];
	[newMsg setPhoneNumber:[_rcpt uncommentedAddress]];
	[newMsg setBody:[currentTask text]];
	//[newMsg setType:DRAFT_MESSAGE];
	[newMsg save];
	[newMsg release];
	
	LOG(@"Message send to %@ aborted.",_rcpt);
	
	// Delete the failure one
	CTSMSMessageDelete([currentTask currentMessage]);
	
	[self finishSendTask];
	return YES;
}

-(BOOL)finishSendTask{
	if(currentTask == nil){
		LOG(@"ERROR - currentTask is nil, nothing to finish!");
		return NO;
	}
	
	NSArray* unsent = [currentTask unsentRecipients];
	LOG(@"Send task finished, unsent recipients: %@",unsent);
	NSMutableDictionary *data = [[NSMutableDictionary alloc] init];
	[data setObject:unsent forKey:@"unsent"];
	[self _taskFinished:data];
	[data release];

	[currentTask release];
	currentTask = nil;
	return YES;
}

-(BOOL)_sendMessageInBackground:(struct __CTSMSMessage*) message {
	// Message should be: outgoing|unsent or sent failure
	if(message == nil){
		LOG(@"Message object is nil!");
		return NO;
	}
	if(!CTSMSMessageIsOutgoing(message) || CTSMSMessageHasBeenSent(message)){
		// Incorrect message type!`
		NSString *e = @"Incorrect message flag, it should be unsent and outgoing message!";
		_logAndNotifyError(self,[currentTask currentRecipient],message,e);
		return NO;
	}
	[NSThread detachNewThreadSelector:@selector(_threadEntry:) toTarget:self withObject:(id)message];
	return YES;
}

- (void) _threadEntry:(id) arg {
	NSAutoreleasePool* p = [[NSAutoreleasePool alloc] init];
	
	DBG(@"SMS send thread started");
	CTSMSMessageRef _sms = (CTSMSMessageRef)arg;
	
	if(_sms){
		DBG(@"Message 0x%x/%@ is created",_sms,_sms);
#ifdef MOCK_SEND
		NSTimeInterval itv = 3;
		[NSThread sleepForTimeInterval:itv];
		// Mark message as sent and notify
	#ifdef DMOCK_SEND_FAILURE
			// MOCK FAILURE
			[self performSelectorOnMainThread:@selector(_sendError:) withObject:_buildStatusData([currentTask currentRecipient],_sms,nil) waitUntilDone:NO];		
	#else
			// MOCK SUCCESS
			CTSMSMessageMarkAsSent(_sms,YES);
			[self performSelectorOnMainThread:@selector(_sendSuccess:) withObject:_buildStatusData([currentTask currentRecipient],_sms,nil) waitUntilDone:NO];
			itv = 0.5;
			[NSThread sleepForTimeInterval:itv];
			[self performSelectorOnMainThread:@selector(sendNext) withObject:nil waitUntilDone:NO];
			//[self performSelector:@selector(sendNext) withObject:nil afterDelay:delay];		
	#endif
#else
		int ioval[2];
		//memset(result,0x00, sizeof(ioval));
		ioval[0] = 0;
		ioval[1] = 0;
		
		void* unknowPtr = CTSMSMessageSend(ioval,_sms);
		DBG(@"CTMessageSend return : 0x%x",unknowPtr);
		DBG(@"Result : 0x%x/0x%x",ioval[0],ioval[1]);
//		NSTimeInterval itv = 1;
//		[NSThread sleepForTimeInterval:itv];
		//FIXME mach port io error ?
		BOOL success = (ioval[1] == 0);
		if(!success){
			NSString* _e = @"Could not send SMS message, mac port IO error ?";
			NSString* _number = (NSString*)CTSMSMessageCopyAddress(_sms);
			LOG(@"ERROR - sending message to %@ number %@ ",_e,_number);
			[_number release];
			//[self _sendError:_buildStatusData(nil,_sms,_e)];
			[self performSelectorOnMainThread:@selector(_sendError:) withObject:_buildStatusData(nil,_sms,nil) waitUntilDone:NO];
		}
#endif
	}else{
		NSString* _e = @"ERROR - Message is null, send aborted";
		LOG(_e);
		//[self _sendError:_buildStatusData(nil,nil,_e)];
		[self performSelectorOnMainThread:@selector(_sendError:) withObject:_buildStatusData(nil,nil,_e) waitUntilDone:NO];
	}
	DBG(@"SMS send thread exitted");
	//CFRelease(_sms);
	[p release];
}

//-(BOOL)_sendMessageViaCoreTelephonyAPI:(NSString*) msg to:(NSString*)receiver{
//	int result[2];
//	//memset(result,0x00, sizeof(ioval));
//	result[0] = 0;
//	result[1] = 0;
//	
//	BOOL success = NO;
//	CTSMSMessageRef _sms = CTSMSMessageCreate(0,receiver,msg);
//	if(_sms){
//		DBG(@"Message 0x%x/%@ is created",_sms,_sms);
//		void* unknowPtr = CTSMSMessageSend(result,_sms);
//		DBG(@"CTMessageSend return : 0x%x",unknowPtr);
//		DBG(@"Result : 0x%x/0x%x",result[0],result[1]);
//		NSTimeInterval itv = 2;
//		[NSThread sleepForTimeInterval:itv];
//		success = (result[1] == 0);
//	}else{
//		LOG(@"ERROR - Error creating Message object. Receiver %@",receiver);
//	}
//	CFRelease(_sms);
//	return success;
//}
//
//-(BOOL)_sendMessageViaTTY:(NSString*) msg to:(NSString*)receiver{
//	const char* cReceiver;
//	const char* cMsg;
//	if(receiver == nil || [receiver length] == 0){
//		return NO;
//	}
//	if(msg == nil || [msg length] == 0){
//		return NO;
//	}
//	// Get the c-style string
//	cReceiver = [receiver cStringUsingEncoding:NSASCIIStringEncoding];
//	//cMsg = [msg cStringUsingEncoding:NSASCIIStringEncoding];
//	cMsg = [msg UTF8String];
//	char code[4]; //FIXME remove me
//	LOG(@"Calling sendmessage() %@",@"");
//	return sendmessage(cReceiver,cMsg,code,NULL) == 0;
//	//LOG(@"SMSCenter - _sendMessageViaTTY() success!");
//}

// Currently will always peform the callback methods on main thread
-(void)_willSend:(id)data{
	[[currentTask statusCallback] performSelectorOnMainThread:@selector(willSend:) withObject:data waitUntilDone:NO];	
	//[[currentTask statusCallback] willSend:data];
}

-(void)_sendSuccess:(id)data{
	[[currentTask statusCallback] performSelectorOnMainThread:@selector(sendSuccess:) withObject:data waitUntilDone:NO];
	//[[currentTask statusCallback] sendSuccess:data];
}

-(void)_sendError:(id)data{
	[[currentTask statusCallback] performSelectorOnMainThread:@selector(sendError:) withObject:data waitUntilDone:NO];
	//[[currentTask statusCallback] sendError:data];
}
-(void)_taskFinished:(id)data{
	[[currentTask statusCallback] performSelectorOnMainThread:@selector(taskFinished:) withObject:data waitUntilDone:NO];
}

-(SMSSendTask*)currentTask{
	return currentTask;
}
@end