/*
 *     Generated by class-dump 3.1.2.
 *
 *     class-dump is Copyright (C) 1997-1998, 2000-2001, 2004-2007 by Steve Nygard.
 */

#import "SBSlidingAlertDisplay.h"

@class NSArray, UITable;

@interface SBSIMToolkitListDisplay : SBSlidingAlertDisplay
{
    UITable *_table;	// 72 = 0x48
    NSArray *_items;	// 76 = 0x4c
}

+ (id)createTopBarForInstance:(id)fp8;	// IMP=0x000502b0
- (void)_selectListItem:(unsigned long)fp8;	// IMP=0x0004f4d0
- (id)_simToolkitListItems;	// IMP=0x0004f418
- (void)alertDisplayWillBecomeVisible;	// IMP=0x0004f8c4
- (void)dealloc;	// IMP=0x0004f3b8
- (id)initWithFrame:(struct CGRect)fp8;	// IMP=0x0004f57c
- (void)navigationBar:(id)fp8 buttonClicked:(int)fp12;	// IMP=0x0004fa7c
- (int)numberOfRowsInTable:(id)fp8;	// IMP=0x0004fb00
- (void)setMiddleContentAlpha:(float)fp8;	// IMP=0x0004f868
- (BOOL)showsDesktopImage;	// IMP=0x0004f860
- (id)table:(id)fp8 cellForRow:(int)fp12 column:(id)fp16;	// IMP=0x0004fb2c
- (void)tableSelectionDidChange:(id)fp8;	// IMP=0x0004fd34

@end

