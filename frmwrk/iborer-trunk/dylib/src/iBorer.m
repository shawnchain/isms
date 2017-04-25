//==============================================================================
//	Created on 2008-4-20
//==============================================================================
//	$Id$
//==============================================================================
//	Copyright (C) <2008>  Shawn Qian(shawn.chain@gmail.com)
//
//	This file is part of iBorer.
//
//  iBorer is free software: you can redistribute it and/or modify
//  it under the terms of the GNU General Public License as published by
//  the Free Software Foundation, either version 3 of the License, or
//  (at your option) any later version.
//
//  iBorer is distributed in the hope that it will be useful,
//  but WITHOUT ANY WARRANTY; without even the implied warranty of
//  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//  GNU General Public License for more details.
//
//  You should have received a copy of the GNU General Public License
//  along with iBorer.  If not, see <http://www.gnu.org/licenses/>.
//==============================================================================

#import "iBorer.h"
#import "IBPluginManager.h"
#import "common/common.h"
#import <UIKit/UIApplication.h>

#define IBORER_MESSAGE_PORT @"IBORER_MESSAGE_PORT"
#define IBORER_MESSAGE @"IBORER_MESSAGE"
#define SPRINGBOARD_ID @"com.apple.springboard"
#define PLUGIN_PATH @"/Library/Frameworks/iBorer.framework/plug-ins"

static iBorer	*iborerInstance = nil;

@implementation iBorer

CFDataRef _machMessageCallBack (
   CFMessagePortRef local,
   SInt32 msgid,
   CFDataRef data,
   void *info
){
	if(data){
		NSString* msg = [[NSString alloc] initWithData:(NSData*)data encoding:NSUTF8StringEncoding];
		DBG(@"Received Mach message from %@, msgid is %@, data is %@(%@), info is %@",local,msgid,msg,data,info);
		
		if(info){
			[(iBorer*)info _handleMessage:msg];
		}
		[msg release];
	}
	
	// We response nothing to client
	return nil;
}

-(BOOL)_handleMessage:(NSString*)msg{
	if(msg == nil){
		return NO;
	}
	msg = [msg stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
	// First tokenize message by " "
	NSArray *tokens = [msg componentsSeparatedByString:@" "];
	NSString *action = [tokens objectAtIndex:0];
	action = [action lowercaseString];
	if([action isEqualToString:@"reload"]){
		//TODO reload plugins
		INFO(@"TODO - Reload all plugins");
	}else if([action isEqualToString:@"restart"]){
		//restart host application
#ifdef __BUILD_FOR_2_0__
	        [[UIApplication sharedApplication] terminate];
#else
		[UIApp terminate];
#endif

	}else if([action isEqualToString:@"reboot"]){
		//TODO reboot phone
		INFO(@"TODO - Reboot phone");
	}else if([action isEqualToString:@"start_all_plugins"]){
		//Stop all plugins
		[pluginManager startAllPlugins];
	}else if([action isEqualToString:@"stop_all_plugins"]){
		//Stop all plugins
		[pluginManager stopAllPlugins];
	}else if([action isEqualToString:@"reload_all_plugins"]){
		//reload all plugins first
		[pluginManager reloadAllPlugins];
	}else if([action isEqualToString:@"unload_all_plugins"]){
		//reload all plugins first
		[pluginManager unloadAllPlugins];
	}else if([action isEqualToString:@"stop_plugin"]){
		if([tokens count] ==2){
			NSString *pid = [tokens objectAtIndex:1];
			[pluginManager stopPluginById:pid];
		}
	}else if([action isEqualToString:@"start_plugin"]){
		if([tokens count] ==2){
			NSString *pid = [tokens objectAtIndex:1];
			[pluginManager startPluginById:pid];
		}
	}else if([action isEqualToString:@"reload_plugin"]){
		if([tokens count] ==2){
			NSString *pid = [tokens objectAtIndex:1];
			[pluginManager reloadPluginById:pid];
		}
	}else{
		//TODO Notify plugins with this message
		ERROR(@"command: \"%@\" is not recognized!",msg);
	}
	return NO;
}

-(BOOL)_createMachMessagePort{
	if(messagePort){
		WARN(@"Message port is not nil ?");
		return NO;
	}
	CFMessagePortContext context = { 0 };
	context.info = self; // We need this in the callback method
	Boolean shouldFreeInfo;
	
	/*CFMessagePortRef port*/
	messagePort = CFMessagePortCreateLocal(
				kCFAllocatorDefault,
				(CFStringRef)IBORER_MESSAGE_PORT,
				_machMessageCallBack,
				&context,
				&shouldFreeInfo
				);
	if(messagePort == nil){
		WARN(@"Message port %@ already exists!",IBORER_MESSAGE_PORT);
		return NO;
	}else{
		INFO(@"Message port %@ created",IBORER_MESSAGE_PORT);
	}
	CFRunLoopSourceRef rls = CFMessagePortCreateRunLoopSource(
				kCFAllocatorDefault,
				messagePort,
				0
				);
	CFRunLoopAddSource(CFRunLoopGetCurrent(), rls, kCFRunLoopDefaultMode);
	CFRelease(rls);
	return YES;
}

-(void)_releaseMachMessagePort{
	if(messagePort){
		CFMessagePortInvalidate(messagePort);
		CFRunLoopSourceRef rls = CFMessagePortCreateRunLoopSource(
						kCFAllocatorDefault,
						messagePort,
						0
						);
		CFRunLoopRemoveSource(CFRunLoopGetCurrent(),rls,kCFRunLoopDefaultMode);
		CFRelease(rls);
		CFRelease(messagePort);
		messagePort = nil;
	}
}

-(BOOL)_sendMachMessage:(NSString*) msg{
	BOOL success = NO;
	// Connect to the remove port and send message to it
	CFMessagePortRef remotePort = CFMessagePortCreateRemote(kCFAllocatorDefault,(CFStringRef)IBORER_MESSAGE_PORT);
	if(remotePort){
		CFDataRef data = (CFDataRef)[msg dataUsingEncoding:NSUTF8StringEncoding];
		SInt32 ret = CFMessagePortSendRequest(
				remotePort,
				0,
				data,
				0,
				0,
				NULL, /*one-way message, no response is expected*/
				nil
		);
		if(ret != kCFMessagePortSuccess){
			ERROR(@"Could not send message to remote port %@, error code is %d",IBORER_MESSAGE_PORT,ret);
		}else{
			success = YES;
		}
		CFRelease(remotePort);
	}else{
		ERROR(@"Could not create remote port %@",IBORER_MESSAGE_PORT);
	}
	return success;
}

-(void)_initializeMessagePort{
	if(![self _createMachMessagePort]){
		ERROR(@"Could not create message port! iBorer framework may not work properly!");
	}
}

-(void)_initializePlugins{
	@synchronized(self){
		if(pluginManager){
			RELEASE(pluginManager);
		}
		//TODO try/cache here ?
		pluginManager = [[IBPluginManager alloc]initWithPluginPath:PLUGIN_PATH];
	}
}

-(BOOL)_isInterestedApplication:(NSString *)bundleId{
	return [bundleId isEqualToString:SPRINGBOARD_ID];
}

-(id)init{
	[super init];
	// Initialize if interested
	NSString *bundleId = [[NSBundle mainBundle] bundleIdentifier];
	DBG(@"iBorer - bundle id: %@",bundleId);
	if([self _isInterestedApplication:bundleId]){
		//Bingo! we'll bore into the springboard
		INFO(@"Boring into Springboard...");
		
		[self _initializeMessagePort];
		[self _initializePlugins];
	}else{
		// Currently do nothing on other applications
#ifdef DEBUG
		NSString *msg = [NSString stringWithFormat:@"Hello from %@",bundleId];
		[self _sendMachMessage:msg];
		DBG(@"iBorer - Skipping %@",bundleId);
#endif
	}
	
	return self;
}

-(void)dealloc{
	[self _releaseMachMessagePort];
	RELEASE(pluginManager);
	[super dealloc];
}

-(IBPluginManager*)pluginManager{
	return pluginManager;
}

+(id)sharedInstance{
	return iborerInstance;
}
@end

__attribute__((constructor)) void _onLoad(){
	DBG(@"iBorer loading");
	NSAutoreleasePool* pool = [[NSAutoreleasePool alloc] init];
	
	iborerInstance = [[iBorer alloc] init];

	[pool release];
}

__attribute__((destructor)) void _onUnLoad(){
	DBG(@"iBorer unloading");
	if(iborerInstance){
		[iborerInstance release];
		iborerInstance = nil;
	}
}

