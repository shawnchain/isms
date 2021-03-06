/*
 *     Generated by class-dump 3.1.2.
 *
 *     class-dump is Copyright (C) 1997-1998, 2000-2001, 2004-2007 by Steve Nygard.
 */

#import "NSObject.h"

@class NSDictionary, NSMutableDictionary;

@interface SBAccessoryController : NSObject
{
    NSDictionary *_lingoToApplicationMap;	// 4 = 0x4
    NSMutableDictionary *_availableAccessories;	// 8 = 0x8
}

+ (id)sharedAccessoryController;	// IMP=0x000345d4
- (void)_disableAccessoryIfNeeded:(id)fp8 forLingo:(int)fp12;	// IMP=0x000348c8
- (void)_enableAccessoryIfNeeded:(id)fp8 forLingo:(int)fp12;	// IMP=0x000347a0
- (void)accessoryAvailabilityChanged:(int)fp8 availability:(int)fp12;	// IMP=0x00034998
- (void)dealloc;	// IMP=0x000346a4
- (id)init;	// IMP=0x00034624
- (void)reloadLingoToApplicationMap;	// IMP=0x00034708

@end

