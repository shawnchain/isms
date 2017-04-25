//
//  NSString-Plus.h
//  QuickShareIt
//
//  Created by Shaun Harrison on 6/16/07.
//  Copyright 2007 twenty08. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Plus)

- (void) display;
- (NSString*) searchReplace: (NSString*) search: (NSString*) replace;
- (NSString*) search: (NSString*) search replace: (NSString*) replace;
- (BOOL) doesContain: (NSString*) needle;
- (NSArray*) explode: (NSString*) separator;
- (NSString*) replaceWithString: (NSString*) str withPattern: (NSString*) pattern;
- (BOOL) doesMatchPattern: (NSString*) pattern;

@end

@interface NSArray (Plus)

- (NSString*) implode: (NSString*) glue;

@end
