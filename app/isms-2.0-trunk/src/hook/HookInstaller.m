//==============================================================================
//	Created on 2008-1-13
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
#import "HookInstaller.h"
#import "Log.h"
#import <Foundation/Foundation.h>

#ifdef DEBUG_HOOK_INSTALL
#define SPRINGBOARD_CONFIG_FILE @"/Applications/iSMS.app/com.apple.SpringBoard.plist"
#else
#define SPRINGBOARD_CONFIG_FILE @"/System/Library/LaunchDaemons/com.apple.SpringBoard.plist"
#endif

#define OLD_ISMS_HOOK_DYLIB_PATH @"/Applications/iSMS.app/iSMSHook.dylib"
#define ISMS_HOOK_DYLIB_PATH_TEMPLATE @"/Applications/iSMS.app/iSMSHook%d.dylib"

#define EnvironmentVariables @"EnvironmentVariables"
#define DYLD_INSERT_LIBRARIES @"DYLD_INSERT_LIBRARIES"

int osVersion();

BOOL _addLib(NSString* libPath, NSMutableArray* libs){
	// First check whether lib exists
	for(int i = 0;i < [libs count];i++){
		NSString *aLibEntry = [libs objectAtIndex:i];
		if([aLibEntry isEqualToString:libPath]){
			// Already exists, so bail out
			return NO;
		}
	}
	[libs addObject:libPath];
	return YES;
}

BOOL _removeLib(NSString* libPath, NSMutableArray* libs){
	for(int i = 0;i < [libs count];i++){
		NSString *aLibEntry = [libs objectAtIndex:i];
		if([aLibEntry isEqualToString:libPath]){
			// found lib, remove it and exit
			[libs removeObjectAtIndex:i];
			return YES;
		}
	}
	return NO;
}

@implementation HookInstaller

+(BOOL)install:(BOOL)install{
	NSString *ismsHookPath = [NSString stringWithFormat:ISMS_HOOK_DYLIB_PATH_TEMPLATE,osVersion()];
	
	BOOL result = YES;
	NSMutableDictionary *sbConfigData = [[NSMutableDictionary alloc]initWithContentsOfFile:SPRINGBOARD_CONFIG_FILE];
	if(sbConfigData == nil){
		LOG(@"ERROR - Load %@ failed!",SPRINGBOARD_CONFIG_FILE);
		return NO;
	}
	NSMutableDictionary *mutableEnvVars = [[NSMutableDictionary alloc] init];
	NSDictionary *envVars = [sbConfigData objectForKey:EnvironmentVariables];
	if(envVars){
		[mutableEnvVars addEntriesFromDictionary:envVars];
	}else{
		LOG(@"No EnvironmentVariables found in Springboard configuration!");
		if(!install){
			// Just bail out
			LOG(@"Nothing to uninstall");
			goto __exit__;
		}
	}
	
	NSString* libStr = [mutableEnvVars objectForKey:DYLD_INSERT_LIBRARIES];
	LOG(@"DYLD_INSERT_LIBRARIES: %@",libStr);
	NSMutableArray* libs = [[NSMutableArray alloc]init];
	if(libStr){
		[libs addObjectsFromArray:[libStr componentsSeparatedByString:@":"]];
	}
	
	BOOL changed = NO;
	if(install){
		if(_removeLib(OLD_ISMS_HOOK_DYLIB_PATH,libs)){
			LOG(@"Removed old iSMS hook lib path: %@",OLD_ISMS_HOOK_DYLIB_PATH);
			changed = YES;
		}
		if(_addLib(ismsHookPath,libs)){
			LOG(@"Added new iSMS hook lib path: %@",ismsHookPath);
			changed = YES;
		}
	}else{
		if(_removeLib(OLD_ISMS_HOOK_DYLIB_PATH,libs)){
			LOG(@"Removed old iSMS hook lib path: %@",OLD_ISMS_HOOK_DYLIB_PATH);
			changed = YES;
		}
		if(_removeLib(ismsHookPath,libs)){
			LOG(@"Removed iSMS hook lib path: %@",ismsHookPath);
			changed = YES;
		}
	}
	
	if(changed){
		NSString *newLibStr = [libs componentsJoinedByString:@":"];
		LOG(@"Saving new DYLD_INSERT_LIBRARIES: %@",newLibStr);
		[mutableEnvVars setObject:newLibStr forKey:DYLD_INSERT_LIBRARIES];
		[sbConfigData setObject:mutableEnvVars forKey:EnvironmentVariables];
		result = [sbConfigData writeToFile:SPRINGBOARD_CONFIG_FILE atomically:YES];
	}else{
		LOG(@"Springboard configuration file not changed");
	}
	
__exit__:
	// Release memory
	[mutableEnvVars release];
	[sbConfigData release];
	return result;
}

+(BOOL)isInstalled{
	NSString *ismsHookPath = [NSString stringWithFormat:ISMS_HOOK_DYLIB_PATH_TEMPLATE,osVersion()];
	BOOL result = NO;
	NSMutableDictionary *sbConfigData = [[NSMutableDictionary alloc]initWithContentsOfFile:SPRINGBOARD_CONFIG_FILE];
	if(sbConfigData != nil){
		NSDictionary *envVars = [sbConfigData objectForKey:EnvironmentVariables];
		if(envVars){
			NSString *libs = [envVars objectForKey:DYLD_INSERT_LIBRARIES];
			if(libs){
				NSArray *libComponents = [libs componentsSeparatedByString:@":"];
				for(int i = 0;i<[libComponents count];i++){
					NSString* s = [libComponents objectAtIndex:i];
					if([s isEqualToString:ismsHookPath]){
						result = YES;
						break;
					}
				}
			}
		}
	}
	[sbConfigData release];
	return result;
}
@end