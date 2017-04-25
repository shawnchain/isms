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

NSString* _logLevelValToStr(LogLevel level){
	switch(level){
		case 	LOG_FATAL:
			return @"FATAL";
		case 	LOG_ERROR:
			return @"ERROR";
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

#ifdef DEBUG
static LogLevel s_defaultLogLevel = LOG_DEBUG;
#else 
static LogLevel s_defaultLogLevel = LOG_INFO;
#endif

void _setDefaultLogLevel(LogLevel level){
	s_defaultLogLevel = level;
}

LogLevel _internalGetDefaultLogLevel(){
	return s_defaultLogLevel;
}

NSString* _buildLogBody(const char* file, int line, LogLevel logLevel, NSString* format, va_list args){
	//NSLog(@"Start build log body");
	static NSMutableString *buffer = nil;
	if(buffer == nil){
		buffer = [[NSMutableString alloc] initWithCapacity:1024];
	}else{
		[buffer setString:@""];		
	}
	//NSMutableString *buffer =  [[NSMutableString alloc] initWithCapacity:128];
	                                  
	NSString *body=[[NSString alloc] initWithFormat:format arguments:args];
	NSString *logLevelStr = _logLevelValToStr(logLevel);
	if(file){
		// Log the source file info if exists, "gcc -g"
		NSString *sFile = [[NSString alloc] initWithCString:file encoding:NSUTF8StringEncoding];
		//const char* utf8FileName = [[file lastPathComponent] UTF8String];
		[buffer appendFormat:@"[%@] - %@:%d - %@",logLevelStr, [sFile lastPathComponent], line,body];
		[sFile release];
	}else{
		[buffer appendFormat:@"[%@] - %@",logLevelStr,body];
	}
	//	NSLog(@"Finished build log body");
	//	NSLog(@"Buffer is 0x%x",(void*)buffer);	
	[body release];
	return buffer;
	//return [buffer autorelease];
}

void _simpleLog(const char* file, int line, LogLevel logLevel, NSString* format, ...){
//void _simpleLog(LogLevel logLevel, NSString* format, ...){
	if(logLevel < s_defaultLogLevel){
		// Don't need log
		return;
	}
	va_list ap;
	va_start(ap,format);
	NSString *logBody = _buildLogBody(file,line,logLevel, format, ap);
	va_end(ap);
	NSLog(logBody);
}

static Logger* sharedInstance = nil;
@implementation Logger

+(void)initializeWithFile:(NSString*) file{
	if(sharedInstance){
		return;
	}
	if(file == nil){
		NSString *bid = [[NSBundle mainBundle] bundleIdentifier];
		file = [NSString stringWithFormat:@"/var/logs/%@.log",bid];
	}
	sharedInstance = [[self alloc] initWithFile:file];
}

+ (id) sharedInstance{
	@synchronized(self){
		if(sharedInstance == nil){
			[self initializeWithFile:nil];
		}
	}
	return sharedInstance;
}

+(void)release{
	[sharedInstance release];
	sharedInstance = nil;
}

-(id)initWithFile:(NSString*)aFile{
	[super init];
	if(aFile){
		NSString *_fileName = [[NSString stringWithString:aFile] stringByExpandingTildeInPath];
		// logFile will be nil if file not exists or no permission
		logFile = [[NSFileHandle fileHandleForWritingAtPath:_fileName] retain];
	}
#ifdef DEBUG
	defaultLogLevel = LOG_DEBUG;
#else
	defaultLogLevel = LOG_INFO;
#endif
	return self;
}

-(void)dealloc{
	sharedInstance = nil;
	if(logFile){
		[logFile release];
		logFile = nil;
	}
	[super dealloc];
}

-(void)log:(const char*) file line:(int)line logLevel:(LogLevel) logLevel format:(NSString*)format, ...{
	if(logLevel < defaultLogLevel){
		return;
	}
	va_list ap;
	va_start(ap,format);
	NSString *logBody = _buildLogBody(file,line,logLevel, format, ap);
	va_end(ap);
	if(logFile){
		// Log to file
		NSDate *t = [NSDate date];
		[logFile truncateFileAtOffset:[logFile seekToEndOfFile]];
		[logFile writeData:[[NSString stringWithFormat: @"%@ - %@\n", t, logBody] dataUsingEncoding:NSUTF8StringEncoding]];
	}
	// Use NSLog anyway
	NSLog(logBody);
}

-(void)setDefaultLogLevel:(LogLevel)level{
	defaultLogLevel = level;
}

-(LogLevel)defaultLogLevel{
	return defaultLogLevel;
}
@end

