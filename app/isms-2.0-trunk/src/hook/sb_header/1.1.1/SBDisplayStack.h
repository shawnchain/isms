/*
 *     Generated by class-dump 3.1.2.
 *
 *     class-dump is Copyright (C) 1997-1998, 2000-2001, 2004-2007 by Steve Nygard.
 */

#import "NSObject.h"

@class NSMutableArray;

@interface SBDisplayStack : NSObject
{
    NSMutableArray *_displayStack;	// 4 = 0x4
    void *_pushCallback;	// 8 = 0x8
    void *_popCallback;	// 12 = 0xc
}

- (void)_setDisplayStack:(id)fp8;	// IMP=0x0003ad70
- (id)copyWithZone:(struct _NSZone *)fp8;	// IMP=0x0003adb8
- (void)dealloc;	// IMP=0x0003ae40
- (id)description;	// IMP=0x0003b208
- (id)displays;	// IMP=0x0003b0a0
- (void)flushWithoutCallbackSparingDisplay:(id)fp8;	// IMP=0x0003af60
- (id)init;	// IMP=0x0003ad00
- (BOOL)isEmpty;	// IMP=0x0003aeb0
- (id)pop;	// IMP=0x0003af1c
- (id)popDisplay:(id)fp8;	// IMP=0x0003b038
- (void)pushDisplay:(id)fp8;	// IMP=0x0003aed8
- (void)setPopCallBack:(void *)fp8;	// IMP=0x0003aea8
- (void)setPushCallBack:(void *)fp8;	// IMP=0x0003aea0
- (id)topAlert;	// IMP=0x0003b168
- (id)topApplication;	// IMP=0x0003b0c8
- (id)topDisplay;	// IMP=0x0003b0a8

@end

