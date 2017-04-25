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
//
// Part of the codes is credited to Shaun Harrison/mobile chat/twenty08

#import "Logger.h"
#import <Foundation/Foundation.h>
#include <sys/time.h>

static Logger* sharedInstance = nil;
@implementation Logger
+ (id) sharedInstance{
	return sharedInstance;
}

+(void)release{
	[sharedInstance release];
	sharedInstance = nil;
}

+(void)initialize{
	if (sharedInstance == nil) {
		// Initialize the default logger
		sharedInstance = [[self alloc] init];
	}
}

-(id)initWithFileName:(NSString*)aFile{
	self = [super init];
	if(self){
		NSString *_fileName = [[NSString stringWithString:aFile] stringByExpandingTildeInPath];
		logFile = [[NSFileHandle fileHandleForWritingAtPath:_fileName] retain];
	}
	return self;
}

-(id)init{
	return [self initWithFileName:@"/Applications/iSMS2.app/isms.log"];
}

-(void)dealloc{
	sharedInstance = nil;
	if(logFile){
		[logFile release];
		logFile = nil;
	}
	[super dealloc];
}

//void _log(char* lineNumber,int lineNumber,int logLevel, NSString* format,...){
//	
//}

//- (void)log: (char*)sourceFile lineNumber: (int)lineNumber logLevel:(int)logLevel format:(NSString*)format, ...{
//	[self log:sourceFile lineNumber:lineNumber logLevel:LOG_INFO format:format ...];
//}

NSString* _logLevelValToStr(LogLevel level){
	switch(level){
		case 	LOG_FATAL:
			return @"FATAL";
		case 	LOG_ERROR:
			return @"FATAL";
		case 	LOG_WARN:
			return @"WARN";
		case 	LOG_INFO:
			return @"INFO";
		case 	LOG_DEBUG:
			return @"DEBUG";
		default:
			return @"INFO";// All unknow log levels are treated as INFO
	}
}

//- (void)log: (char*) sourceFile lineNumber: (int) lineNumber format:(NSString*)format, ...{
- (void)log: (char*)sourceFile lineNumber: (int)lineNumber logLevel:(int)logLevel format:(NSString*)format, ...{	
#ifndef DEBUG
	// Under release mode, if no log file found, just exit
	if(logFile == nil){
		return;
	}
#endif
	// Log message
	va_list ap;
	va_start(ap,format);
	NSString *file=[[NSString alloc] initWithBytes:sourceFile length:strlen(sourceFile) encoding:NSUTF8StringEncoding];
	NSString *print=[[NSString alloc] initWithFormat:format arguments:ap];
	va_end(ap);

	NSString* _sLevel = _logLevelValToStr(logLevel); 
	NSString* str = [NSString stringWithFormat:@"%@ - %s:%d %@",_sLevel,[[file lastPathComponent] UTF8String], lineNumber,print];
#ifdef DEBUG
	// Under debug mode we will always dump log messages to console
	NSLog(@"%@",str);
#endif
	if(logFile){
		// Time stamp
//		time_t tval=time(NULL);
//		struct tm *now=localtime(&tval);
//		NSString *t = [NSString stringWithFormat:@"[%d:%02d:%02d]",now->tm_hour,now->tm_min,now->tm_sec];
//		
		NSDate *t = [NSDate date];
		[logFile truncateFileAtOffset:[logFile seekToEndOfFile]];
		[logFile writeData:[[NSString stringWithFormat: @"%@ - %@\n", t, str] dataUsingEncoding:NSUTF8StringEncoding]];		
	}
	
	[print release];
	[file release];

	return;
}

//+ (void)LOG: (char*) sourceFile lineNumber: (int) lineNumber format:(NSString*)format, ...{
//	
//	if(sharedInstance){
//		return [sharedInstance log:sourceFile lineNumber:lineNumber format:format,]
//	}
//}

@end


