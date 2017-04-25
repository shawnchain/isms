//
//  HTMLHandler.h
//  MobileChat
//
//  Created by Shaun Harrison on 2/25/08.
//  Copyright 2008 twenty08. All rights reserved.
//

#import <Foundation/NSObject.h>

@interface HTMLHandler : NSObject {

}

+ (NSString*) stripHTML: (NSString*) string;
+ (NSString*) stripHTML: (NSString*) string keepLinks: (BOOL) links;
+ (NSString*) nl2br: (NSString*) string;

@end
