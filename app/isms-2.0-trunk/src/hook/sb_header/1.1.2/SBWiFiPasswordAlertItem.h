/*
 *     Generated by class-dump 3.1.2.
 *
 *     class-dump is Copyright (C) 1997-1998, 2000-2001, 2004-2007 by Steve Nygard.
 */

#import "SBAlertItem.h"

@class NSString;

@interface SBWiFiPasswordAlertItem : SBAlertItem
{
    id _delegate;	// 12 = 0xc
    NSString *_name;	// 16 = 0x10
}

- (void)alertSheet:(id)fp8 buttonClicked:(int)fp12;	// IMP=0x00071168
- (void)configure:(BOOL)fp8 requirePasscodeForActions:(BOOL)fp12;	// IMP=0x00071278
- (void)dealloc;	// IMP=0x0007102c
- (void)dismiss;	// IMP=0x000710dc
- (id)initWithNetworkName:(id)fp8;	// IMP=0x00070fc8
- (void)returnKeyPressed:(id)fp8;	// IMP=0x00071238
- (void)setDelegate:(id)fp8;	// IMP=0x00071080

@end
