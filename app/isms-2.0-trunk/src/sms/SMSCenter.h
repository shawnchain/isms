#ifndef SMSCENTER_H_
#define SMSCENTER_H_

#import <Foundation/Foundation.h>
#import "Prefix.h"

@class SMSSendStatusCallback;

//#define MESSAGE_SENT_NOTIFICATION @"MESSAGE_SENT_NOTIFICATION"
//#define SMS_STATUS_NOTIFICATION @"SMS_STATUS_NOTIFICATION"
//#define SMS_SEND_FINISHED_NOTIFICATION @"SMS_SEND_FINISHED_NOTIFICATION"
//#define STATUS_SEND_START @"SEND_START"
//#define STATUS_SEND_SUCCESS @"SEND_SUCCESS"
//#define STATUS_SEND_FAILED @"SEND_FAILED"
//#define STATUS_SEND_FINISHED @"SEND_FINISHED"
typedef enum _task_state{
	READY = 0,
	SEND_STARTED = 1,
	SEND_SUCCESS = 2,
	SEND_ERROR = 3,
	SEND_FINISHED = 4,
	SEND_ABORTED = 5
} TaskState;

@interface SMSSendTask : NSObject
{
	NSString		*text;
	NSArray			*recipients;
	NSMutableArray	*numbers;

	NSMutableDictionary	*messages;
	int currentRecipientIndex; // Message <1>---<1> Recipient
	SMSSendStatusCallback	*statusCallback;
}
-(id)initWithMessage:(NSString*)aText recipients:(NSArray*)rcpts statusCallback:(SMSSendStatusCallback*)cb;
-(id)currentRecipient;
-(int)recipientCount;
-(id)recipientAtIndex:(int)index;
-(id)nextRecipient;
-(struct __CTSMSMessage*)messageForRecipient:(id)rcpt;
-(struct __CTSMSMessage*)currentMessage;
-(struct __CTSMSMessage*)nextMessage;

-(NSArray*)sentRecipients;
-(NSArray*)unsentRecipients;

-(NSString*)text;
-(SMSSendStatusCallback*)statusCallback;

@end

@interface SMSCenter : NSObject
{
	SMSSendTask	*currentTask;
}

+(SMSCenter*)getInstance;

-(BOOL)setSendTask:(NSString*)text to:(NSArray*)recipients statusCallback:(SMSSendStatusCallback*)cb;
-(BOOL)send;
-(BOOL)send:(NSString*)text to:(NSArray*)recipients statusCallback:(SMSSendStatusCallback*)cb;
-(BOOL)sendNext;
-(BOOL)sendNextWithDelay:(NSTimeInterval)delay;
-(BOOL)retry;
-(BOOL)abort;
-(BOOL)abortSendTask;
-(BOOL)finishSendTask;

-(SMSSendTask*)currentTask;
-(BOOL)_sendMessageInBackground:(struct __CTSMSMessage*) message;

-(void)_willSend:(id)data;
-(void)_sendSuccess:(id)data;
-(void)_sendError:(id)data;
-(void)_taskFinished:(id)data;
@end
#endif /*SMSCENTER_H_*/
