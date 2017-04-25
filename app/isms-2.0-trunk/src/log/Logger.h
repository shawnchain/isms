//==============================================================================
//	Created on 2007-12-12
//==============================================================================
//	$Id: Logger.h 251 2008-09-11 13:16:22Z shawn $
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
#ifndef LOGGER_H_
#define LOGGER_H_

#import <Foundation/Foundation.h>

typedef enum _LOG_LEVEL{
	LOG_DEBUG = 0,
	LOG_INFO = 1,
	LOG_WARN = 2,
	LOG_ERROR = 3,
	LOG_FATAL = 4
} LogLevel;

@class NSFileHandle;

@interface Logger : NSObject {
	NSFileHandle* logFile;
}
- (void)log: (char*)sourceFile lineNumber: (int)lineNumber logLevel:(int)logLevel format:(NSString*)format, ...;
//- (void)log: (char*)sourceFile lineNumber: (int)lineNumber format:(NSString*)format, ...;
+ (id)sharedInstance;
+ (void)release;
@end

#endif /*LOGGER_H_*/
