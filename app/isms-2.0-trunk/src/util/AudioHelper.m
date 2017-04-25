//==============================================================================
//	Created on 2008-1-12
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
#include "AudioHelper.h"
#include "Prefix.h"

static Boolean gPlaySoundFlag = NO;

Boolean shouldPlaySounds(){
  if(gPlaySoundFlag){
    return gPlaySoundFlag;
  }

  Boolean success;
  Boolean value = CFPreferencesGetAppBooleanValue(CFSTR("sms-sound"),CFSTR("com.apple.springboard"),&success);
  if(success){
	  gPlaySoundFlag = value;
  }else{
	  gPlaySoundFlag = YES;
  }
  return gPlaySoundFlag;
}

void playMessageSentSound(){
	if(shouldPlaySounds()){
		AudioServicesPlaySystemSound(0x3EC);
	}
}

void playMessageReceivedSound2(BOOL force){
	if(!force && !shouldPlaySounds()){
		return;
	}
	AudioServicesPlaySystemSound(0x3EF);
}

void playMessageReceivedSound(){
	playMessageReceivedSound2(YES);
}

extern void * _CTServerConnectionCreate(CFAllocatorRef, int (*)(void *, CFStringRef, CFDictionaryRef, void *), int *);
extern int _CTServerConnectionSetVibratorState(int *, void *, int, float, float, float, float);
int vibratecallback(void *connection, CFStringRef string, CFDictionaryRef dictionary, void *data) {
	return 1;
}

static id sharedInstance = nil;
@implementation AudioHelper : NSObject
+(id)sharedInstance{
	if(sharedInstance == nil){
		sharedInstance = [[self alloc] init];
	}
	return sharedInstance;
}

-(id)init{
	[super init];
	isVibrating = NO;
	return self;
}

- (void) vibrate {
	if(isVibrating == NO /*&& [_app vibrationIsSet] == YES*/) {
#ifdef DEBUG		
		LOG(@"Vibrating...");
#endif		
		isVibrating = YES;
		[NSThread detachNewThreadSelector:@selector(doVibrate) toTarget:self withObject:nil];
	}
}

- (void) doVibrate {
	NSAutoreleasePool* p = [[NSAutoreleasePool alloc] init];
	int x;
	void* connection = _CTServerConnectionCreate(kCFAllocatorDefault, &vibratecallback, &x);
	_CTServerConnectionSetVibratorState(&x, connection, 3, 10.0, 10.0, 10.0, 10.0);
    time_t now = time(NULL);
    while (time(NULL) - now < 0.5) { }
	_CTServerConnectionSetVibratorState(&x, connection, 0, 10.0, 10.0, 10.0, 10.0);
	isVibrating = NO;
	[p release];
}
@end