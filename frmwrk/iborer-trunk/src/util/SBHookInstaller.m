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
#import "SBHookInstaller.h"
#import "../common/common.h"

#ifdef DEBUG_HOOK_INSTALL
#define SPRINGBOARD_CONFIG_FILE @"/tmp/com.apple.SpringBoard.plist"
#else
#define SPRINGBOARD_CONFIG_FILE @"/System/Library/LaunchDaemons/com.apple.SpringBoard.plist"
#endif

#define IBORER_DYLIB_PATH @"/Library/Frameworks/iBorer.framework/iBorer.dylib"

#define EnvironmentVariables @"EnvironmentVariables"
#define DYLD_INSERT_LIBRARIES @"DYLD_INSERT_LIBRARIES"

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

@implementation SBHookInstaller

+(BOOL)install:(NSString*)libPath flag:(BOOL)install {
	BOOL result = YES;
	NSMutableDictionary *sbConfigData = [[NSMutableDictionary alloc]initWithContentsOfFile:SPRINGBOARD_CONFIG_FILE];
	if(sbConfigData == nil){
		ERROR(@"Load %@ failed!",SPRINGBOARD_CONFIG_FILE);
		return NO;
	}
	NSMutableDictionary *mutableEnvVars = [[NSMutableDictionary alloc] init];
	NSDictionary *envVars = [sbConfigData objectForKey:EnvironmentVariables];
	if(envVars){
		[mutableEnvVars addEntriesFromDictionary:envVars];
	}else{
		INFO(@"No EnvironmentVariables found in Springboard configuration!");
		if(!install){
			// Just bail out
			INFO(@"Nothing to uninstall");
			goto __exit__;
		}
	}
	
	NSString* libStr = [mutableEnvVars objectForKey:DYLD_INSERT_LIBRARIES];
	INFO(@"DYLD_INSERT_LIBRARIES: %@",libStr);
	NSMutableArray* libs = [[NSMutableArray alloc]init];
	if(libStr){
		[libs addObjectsFromArray:[libStr componentsSeparatedByString:@":"]];
	}
	
	BOOL changed = NO;
	if(install){
		if(_addLib(libPath,libs)){
			LOG(@"Added new hook dylib path: %@",libPath);
			changed = YES;
		}
	}else{
		if(_removeLib(libPath,libs)){
			LOG(@"Removed hook dylib path: %@",libPath);
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

+(BOOL)isInstalled:(NSString*)libPath{
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
					if([s isEqualToString:libPath]){
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

int SBHookInstaller_check_install_arg(int argc,char** argv){
	// Check install flag
	int install = 0;
	const char* clibPath;
	if(argc == 3){
		if(strcmp(argv[1],"-install") == 0){
			install = 1;
			clibPath = argv[2];
		}else if(strcmp(argv[1],"-uninstall") == 0){
			install = 2;
			clibPath = argv[2];
		}
	}
	if(install > 0){
		NSAutoreleasePool* pool = [[NSAutoreleasePool alloc] init];
		NSString *libPath = [NSString stringWithUTF8String:clibPath];
		BOOL installSuccess = [SBHookInstaller install:libPath flag:(install == 1)];
    	LOG(@"Hook %@ %@ - %@!",libPath, (install == 1)?@"install":@"uninstall",installSuccess?@"finished":@"failed");		
		[pool release];
	}
	
	return install;
}

#ifdef STANDALONE
int main(int argc, char** argv){
	if(argc == 2 && (strcmp(argv[1],"--version") == 0 || strcmp(argv[1],"-v") == 0 )){
		printf("SpringBoard Hook Installation Util v0.1 by Shawn.Chain@gmail.com\n");
	}else{
		int ret = SBHookInstaller_check_install_arg(argc,argv);
		if(ret == 0){
			printf("Usage: SBHookInstaller -install|-uninstall /usr/lib/xxx.dylib\n");
		}
	}
	return 0;
}
#endif