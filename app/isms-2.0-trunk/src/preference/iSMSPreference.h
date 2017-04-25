#ifndef ISMSPREFERENCE_H_
#define ISMSPREFERENCE_H_

//#import "Prefix.h"
#import <Foundation/Foundation.h>

#define PREF_RUN_BACKGROUND @"PREF_RUN_BACKGROUND"
#define PREF_CONFIRM_BEFORE_SEND @"PREF_CONFIRM_BEFORE_SEND"
#define PREF_DEFAULT_APP @"PREF_DEFAULT_APP"
#define PREF_HOOK_ENABLED @"PREF_HOOK_ENABLED"
#define PREF_DB_SCHEMA_VERSION @"PREF_DB_SCHEMA_VERSION"
#define PREF_APP_VERSION @"PREF_APP_VERSION"
#define PREF_LAST_CONVERSATION_PHONE_NUMBER @"PREF_LAST_CONVERSATION_PHONE_NUMBER"
#define PREF_USE_CONVERSATION_VIEW @"PREF_USE_CONVERSATION_VIEW"
#define PREF_NEW_MESSAGE_PREVIEW @"PREF_NEW_MESSAGE_PREVIEW"

#define CURRENT_APP_VERSION 100

@class NSUserDefaults;

@interface iSMSPreference : NSObject
{
	NSUserDefaults *userDefaults;
}
+(id)sharedInstance;

//-(BOOL)runBackground;
//-(void)setRunBackground:(BOOL)value;

-(BOOL)confirmBeforeSend;
-(void)setConfirmBeforeSend:(BOOL)value;

-(BOOL)defaultApp;
-(void)setDefaultApp:(BOOL)value;

-(BOOL)hookEnabled;
-(void)setHookEnabled:(BOOL)value;

-(BOOL)newMessagePreview;
-(void)setNewMessagePreview:(BOOL)value;

-(id)objectForKey:(NSString*)key;
-(void)setObject:(id)obj forKey:(NSString*)key;

-(int)osVersion;
-(NSString*)osVersionString;

-(BOOL)isHelperInstalled;

-(void)flush;

-(BOOL)isFirstTimeRun;

-(BOOL)useConversationView;
-(void)setUseConversationView:(BOOL)value;

-(NSString*)lastConversationPhoneNumber;
-(void)setLastConversationPhoneNumber:(NSString*)aNumber;

@end
#endif /*ISMSPREFERENCE_H_*/
