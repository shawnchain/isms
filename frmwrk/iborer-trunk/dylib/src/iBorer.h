//==============================================================================
//	Created on 2008-4-20
//==============================================================================
//	$Id: iBorer.h 240 2008-06-30 15:41:57Z shawn $
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

#import <Foundation/NSObject.h>
#import <CoreFoundation/CFMessagePort.h>

@class IBPluginManager;
@interface iBorer : NSObject{
	CFMessagePortRef messagePort;
	IBPluginManager	*pluginManager;
}
+(id)sharedInstance;

-(IBPluginManager*)pluginManager;

-(void)_initializeMessagePort;
-(void)_initializePlugins;
-(BOOL)_handleMessage:(NSString*)msg;
@end