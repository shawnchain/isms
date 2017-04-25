//==============================================================================
//	Created on 2007-12-12
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
#import <UIKit/UIKit.h>

#import "iSMSApp.h"
#import "Log.h"
#import "hook/HookInstaller.h"
#import "container/ObjectContainer.h"
#include "Util.h"

#ifdef __BUILD_FOR_2_0__
#define ISMS_VERSION @"2.0"
#endif

int main(int argc, char **argv)
{
	int ret = 0;
	
	// Check install flag
	int install = 0;
	if(argc == 2){
		if(strcmp(argv[1],"-install") == 0){
			install = 1;
		}else if(strcmp(argv[1],"-uninstall") == 0){
			install = 2;
		}
	}
	
    const char* sig="Present by ShawnQ(shawn.chain@gmail.com)";
    NSAutoreleasePool* pool = [[NSAutoreleasePool alloc] init];
    [[Logger alloc] init];
    [ObjectContainer initialize];
    if(install > 0){
    	BOOL installSuccess = [HookInstaller install:(install == 1)];
    	LOG(@"iSMS Hook %@ - %@!",(install == 1)?@"install":@"uninstall",installSuccess?@"finished":@"failed");
    }else{
    	//NSString* osn = [[NSProcessInfo processInfo] operatingSystemVersionString];
        LOG(@"iSMS %s starting up - iPhone %@/%d",ISMS_VERSION,osVersionString(),osVersion());

#ifdef __BUILD_FOR_2_0__
        ret = UIApplicationMain(argc, argv, @"iSMSApp", @"iSMSApp");
#else
        ret = UIApplicationMain(argc, argv, [iSMSApp class]);
#endif

        LOG(@"application exit");
    }
    // Release the object container
    [ObjectContainer release];
    [Logger release];
    [pool release];
    return ret;
}
