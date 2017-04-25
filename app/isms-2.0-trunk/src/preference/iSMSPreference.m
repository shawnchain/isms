//==============================================================================
//	Created on 2007-12-27
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
#import "iSMSPreference.h"
//#import "iSMSApp.h"
#import "ObjectContainer.h"
#import "Prefix.h"
#import "Util.h"
#import "hook/HookInstaller.h"

@implementation iSMSPreference

+(void)initialize {
	static BOOL initialized = NO;
	if (!initialized) {
		NSLog(@"iSMSPreference initializing...");
		[[ObjectContainer sharedInstance] registerObject:self forKey:self isSingleton:YES];
		initialized = YES;
	}
}

+(id)sharedInstance {
	return [[ObjectContainer sharedInstance] objectForKey:self];
}

-(id)init {
	self = [super init];
	if(self) {
		// Setup the factory default values
		userDefaults = [[NSUserDefaults standardUserDefaults] retain];
		[userDefaults registerDefaults:[NSDictionary dictionaryWithObjectsAndKeys:
		//			@"NO",  PREF_RUN_BACKGROUND,
		@"YES", PREF_CONFIRM_BEFORE_SEND,
		@"YES", PREF_DEFAULT_APP,
		@"NO", PREF_HOOK_ENABLED,
		@"NO", PREF_USE_CONVERSATION_VIEW,
		@"YES", PREF_NEW_MESSAGE_PREVIEW,
		nil]];
	}
	return self;
}

-(void)dealloc {
	RELEASE(userDefaults);
	[super dealloc];
}

//-(BOOL)runBackground{
//	return [userDefaults boolForKey:PREF_RUN_BACKGROUND];
//}
//
//-(void)setRunBackground:(BOOL)value{
//	[userDefaults setBool:value forKey:PREF_RUN_BACKGROUND];
//}

-(BOOL)confirmBeforeSend {
	return [userDefaults boolForKey:PREF_CONFIRM_BEFORE_SEND];
}

-(void)setConfirmBeforeSend:(BOOL)value {
	[userDefaults setBool:value forKey:PREF_CONFIRM_BEFORE_SEND];
}

-(BOOL)defaultApp {
	return [userDefaults boolForKey:PREF_DEFAULT_APP];
}

-(void)setDefaultApp:(BOOL)value {
	[userDefaults setBool:value forKey:PREF_DEFAULT_APP];
}

-(BOOL)newMessagePreview{
	return [userDefaults boolForKey:PREF_NEW_MESSAGE_PREVIEW];
}

-(void)setNewMessagePreview:(BOOL)value{
	[userDefaults setBool:value forKey:PREF_NEW_MESSAGE_PREVIEW];
}

-(BOOL)hookEnabled {
	return [userDefaults boolForKey:PREF_HOOK_ENABLED];
}

-(void)setHookEnabled:(BOOL)value {
	[userDefaults setBool:value forKey:PREF_HOOK_ENABLED];
}

-(int)DBSchemaVersion{
	return [userDefaults integerForKey:PREF_DB_SCHEMA_VERSION]; 
}

-(void)setDBSchemaVersion:(int)value{
	[userDefaults setInteger:value forKey:PREF_DB_SCHEMA_VERSION];
}

-(int)appVersion{
	return [userDefaults integerForKey:PREF_APP_VERSION]; 
}

-(void)setAppVersion:(int)value{
	[userDefaults setInteger:value forKey:PREF_APP_VERSION];
}

-(BOOL)isFirstTimeRun{
	return CURRENT_APP_VERSION != [self appVersion];
}

-(id)objectForKey:(NSString*)key {
	return [userDefaults objectForKey:key];
}

-(void)setObject:(id)obj forKey:(NSString*)key {
	[userDefaults setObject:obj forKey:key];
}

-(NSString*)lastConversationPhoneNumber{
	return [userDefaults objectForKey:PREF_LAST_CONVERSATION_PHONE_NUMBER];
}

-(void)setLastConversationPhoneNumber:(NSString*)aNumber{
	[userDefaults setObject:aNumber forKey:PREF_LAST_CONVERSATION_PHONE_NUMBER];
}
//-(NSString*)osVersion{
//	return [[NSProcessInfo processInfo] operatingSystemVersionString];
//}


-(BOOL)useConversationView{
	return [userDefaults boolForKey:PREF_USE_CONVERSATION_VIEW];
}

-(void)setUseConversationView:(BOOL)value{
	[userDefaults setBool:value forKey:PREF_USE_CONVERSATION_VIEW];
}

-(int)osVersion{
	return osVersion();
}

-(NSString*)osVersionString{
	return osVersionString();
}

-(BOOL)isHelperInstalled{
#ifdef DEBUG_HOOK
	return YES;//[HookInstaller isInstalled];
#else
	//We supports 112+ now
	return [HookInstaller isInstalled];
#endif
}

-(void)flush {
	[userDefaults synchronize];
}
@end