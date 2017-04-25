#import "OSUtil.h"
#import "common.h"


NSString* osVersionString(){
	return [[NSProcessInfo processInfo] operatingSystemVersionString];
}

static int _osVersionValue = -1; 
int osVersion(){
	if(_osVersionValue < 0){
		// We assume the strings is as:
		// Version 1.x.x (Build XXXX)
		NSString* s = osVersionString();
		if([s hasPrefix:@"Version "]){
			if([s length] >= 13 ){
				char buf[] = {0x0,0x0};
				buf[0] = [s characterAtIndex:8];
				int i1 = atoi(buf);
				buf[0] = [s characterAtIndex:10];
				int i2 = atoi(buf);
				buf[0] = [s characterAtIndex:12];
				int i3 = atoi(buf);
				_osVersionValue = i1 * 100 + i2 * 10 + i3;
				//NSLog(@"OS Version is %d",_osVersionValue);
				return _osVersionValue;
			}
		}
		_osVersionValue = 0;
	}
	return _osVersionValue;
}