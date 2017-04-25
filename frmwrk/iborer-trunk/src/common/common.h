#ifndef COMMON_H_
#define COMMON_H_

#import <Foundation/Foundation.h>
#import <CoreFoundation/CoreFoundation.h>

#import "Logger.h"

#define RETAIN(var,val) \
({ \
	id ___newVal = (val); \
        id ___oldVar = (var); \
			if (___oldVar != ___newVal) { \
				if (___newVal != nil) { \
					[___newVal retain]; \
				} \
				var = ___newVal; \
					if (___oldVar != nil) { \
						[___oldVar release]; \
					} \
			} \
})

#define RELEASE(var) \
({ \
	id	___oldVar = (id)(var); \
		if (___oldVar != nil) { \
			var = nil; \
                [___oldVar release]; \
		} \
})
#endif /*COMMON_H_*/
