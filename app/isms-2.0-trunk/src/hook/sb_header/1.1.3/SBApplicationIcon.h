/*
 *     Generated by class-dump 3.1.2.
 *
 *     class-dump is Copyright (C) 1997-1998, 2000-2001, 2004-2007 by Steve Nygard.
 */

#import "SBIcon.h"

@class SBApplication;

@interface SBApplicationIcon : SBIcon
{
    SBApplication *_app;	// 108 = 0x6c
}

- (id)_automationID;	// IMP=0x0001067c
- (id)application;	// IMP=0x00010514
- (void)dealloc;	// IMP=0x000104d0
- (id)displayIdentifier;	// IMP=0x0001063c
- (id)displayName;	// IMP=0x0001061c
- (id)icon;	// IMP=0x0001051c
- (id)initWithApplication:(id)fp8;	// IMP=0x000104b0
- (void)launch;	// IMP=0x000106e0
- (BOOL)launchEnabled;	// IMP=0x000106bc
- (BOOL)shouldListInCapabilities;	// IMP=0x0001050c
- (id)tags;	// IMP=0x0001065c

@end

