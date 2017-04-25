//
//  HTMLHandler.m
//  MobileChat
//
//  Created by Shaun Harrison on 2/25/08.
//  Copyright 2008 twenty08. All rights reserved.
//

#import "Prefix.h"
#import "HTMLHandler.h"
#import "NSString-Plus.h"

#import "PCRE/AGRegex.h"

@implementation HTMLHandler

+ (NSString*) stripHTML: (NSString*) string {
	return [HTMLHandler stripHTML:string keepLinks:NO];
}

+ (NSString*) stripHTML: (NSString*) string keepLinks: (BOOL) links {
    AGRegex* regex = [[AGRegex alloc] initWithPattern:@"(<br>|<br />)" options:AGRegexCaseInsensitive]; 
    NSString* result = [regex replaceWithString:@"\n" inString:string]; 
	[regex release];
    
	regex = [[AGRegex alloc] initWithPattern:@"<(.|\n)+?>" options:AGRegexCaseInsensitive]; 
    result = [regex replaceWithString:@"" inString:result]; 
	[regex release];
	
	return result;
}

+ (NSString*) nl2br: (NSString*) string {
    AGRegex* regex = [[AGRegex alloc] initWithPattern:@"(\n|\r)" options:AGRegexCaseInsensitive]; 
    NSString* result = [regex replaceWithString:@"<br />" inString:string]; 
	[regex release];
	
	return result;
}

@end
