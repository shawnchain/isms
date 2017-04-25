//
//  NSString-Plus.m
//  QuickShareIt
//
//  Created by Shaun Harrison on 6/16/07.
//  Copyright 2007 twenty08. All rights reserved.
//

#import "Prefix.h"
#import "NSString-Plus.h"
#import "PCRE/AGRegex.h"

@implementation NSString (Plus)

- (void) display {
	NSLog(self);
}

- (NSString*) searchReplace: (NSString*) search: (NSString*) replace {
	return [self search: search replace: replace];
}

- (NSString*) search: (NSString*) search replace: (NSString*) replace {
	NSMutableString* string = [NSMutableString stringWithString:self];
	NSRange range;
	
	if (!replace || !search ) {
		return self;
	}
	
	range = [string rangeOfString:search];
	while (range.length) {
		[string replaceCharactersInRange:range withString:replace];
		range.location = range.location + 1;
		range.length = [string length] - range.location;
		range = [string rangeOfString:search options:0 range:range];
	}
	
	return string;			
}

- (BOOL) doesContain: (NSString*) needle {
	return !([[self lowercaseString] rangeOfString:[needle lowercaseString]].location == NSNotFound);
}


- (NSArray*) explode: (NSString*) separator {
	return [self componentsSeparatedByString:separator];
}

- (NSString*) replaceWithString: (NSString*) str withPattern: (NSString*) pattern {
    AGRegex* regex = [[AGRegex alloc] initWithPattern:pattern options:AGRegexCaseInsensitive]; 
	return [regex replaceWithString:str inString:self]; 
}

- (BOOL) doesMatchPattern: (NSString*) pattern {
    AGRegex* regex = [[AGRegex alloc] initWithPattern:pattern options:AGRegexCaseInsensitive]; 
	if([regex findInString:self]) {
		[regex release];
		return YES;
	} else {
		[regex release];
		return NO;
	}
}

@end

@implementation NSArray (Plus)
- (NSString*) implode: (NSString*) glue {
	return [self componentsJoinedByString:glue];
}
@end
