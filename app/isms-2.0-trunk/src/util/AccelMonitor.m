//==============================================================================
//	Created on 2008-1-17
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
#import "AccelMonitor.h"
#import <IOKit/IOKitLib.h>
#include <CoreFoundation/CoreFoundation.h>

#if 0 // -- Disabled

typedef struct {} *IOHIDEventSystemRef;
typedef struct {} *IOHIDEventRef;
float IOHIDEventGetFloatValue(IOHIDEventRef ref, int param);
int IOHIDEventGetType(IOHIDEventRef ptr);

static int accelCount = 0;
static int lastAccelCount = 0;
static int deadCount = 0;
static NSTimer * timer = nil;

void handleHIDEvent(int a, int b, int c, IOHIDEventRef ptr) {
  int type = IOHIDEventGetType(ptr);

  if (type == 12) {
    float x,y,z;

    x = IOHIDEventGetFloatValue(ptr, 0xc0000);
    y = IOHIDEventGetFloatValue(ptr, 0xc0001);
    z = IOHIDEventGetFloatValue(ptr, 0xc0002);

    accelCount++;
    NSLog(@"x=%f,y=%f,z=%f",x,y,z);
    // update the world's accel view
    // Invoke the callback;
    //[[World singleton] updateAccelerometerInX: x Y: y Z: z];
  }
}

#define expect(x) if(!x) { printf("failed: %s\n", #x);  return; }

void initialize(int hz) {
  mach_port_t master;
  expect(0 == IOMasterPort(MACH_PORT_NULL, &master));
  int page = 0xff00, usage = 3;

  CFNumberRef nums[2];
  CFStringRef keys[2];
  keys[0] = CFStringCreateWithCString(0, "PrimaryUsagePage", 0);
  keys[1] = CFStringCreateWithCString(0, "PrimaryUsage", 0);
  nums[0] = CFNumberCreate(0, kCFNumberSInt32Type, &page);
  nums[1] = CFNumberCreate(0, kCFNumberSInt32Type, &usage);
  CFDictionaryRef dict = CFDictionaryCreate(0, (const void**)keys, (const void**)nums, 2, &kCFTypeDictionaryKeyCallBacks, &kCFTypeDictionaryValueCallBacks);
  expect(dict);

  IOHIDEventSystemRef sys = (IOHIDEventSystemRef) IOHIDEventSystemCreate(0);
  expect(sys);

  CFArrayRef srvs = (CFArrayRef)IOHIDEventSystemCopyMatchingServices(sys, dict, 0, 0, 0);
  expect(CFArrayGetCount(srvs)==1);

  io_registry_entry_t serv = (io_registry_entry_t)CFArrayGetValueAtIndex(srvs, 0);
  expect(serv);

  CFStringRef cs = CFStringCreateWithCString(0, "ReportInterval", 0);
  int rv = 1000000/hz;
  CFNumberRef cn = CFNumberCreate(0, kCFNumberSInt32Type, &rv);

  int res = IOHIDServiceSetProperty(serv, cs, cn);
  expect(res == 1);

  res = IOHIDEventSystemOpen(sys, handleHIDEvent, 0, 0);
  expect(res != 0);
}

#define timeInterval 1

@implementation AccelMonitor : NSObject

+ (void) _threadEntry:(id) arg {
	NSAutoreleasePool* p = [[NSAutoreleasePool alloc] init];
	timer = [NSTimer scheduledTimerWithTimeInterval:2.f
		           target: self
		           selector: @selector(onTimer:)
		           userInfo: nil
		           repeats: YES];
	
//	BOOL shouldKeepRunning = YES;        // global
//
//	NSRunLoop *theRL = [NSRunLoop currentRunLoop];
//
//	while (shouldKeepRunning && [theRL runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]]);
	[[NSRunLoop currentRunLoop] run];
//	while(true){
//		sleep(1);
//		[self onTimer:nil];
//	}
	[p release];
}

+(void)registerAccelListener:(SEL)listener{
	NSLog(@"Creating new thread for accel listener");
	[NSThread detachNewThreadSelector:@selector(_threadEntry:) toTarget:self withObject:nil];
}

+(void)onTimer:(NSTimer *)timer
{
	if(lastAccelCount == accelCount){
		// Dead ?
		deadCount++;
		if(deadCount == 5){
			deadCount = 0;
			lastAccelCount = 0;
			NSLog(@"Reenabling the accel monitor");
			//initialize(10);
			return;
		}
	}else{
		lastAccelCount = accelCount;
	}	
}
@end
#endif

