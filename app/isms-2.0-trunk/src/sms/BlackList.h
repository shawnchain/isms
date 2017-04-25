#ifndef BLACKLIST_H_
#define BLACKLIST_H_

#import <Foundation/Foundation.h>
#define BLACK_LIST @"BLACK_LIST"

@class NSMutableDictionary;
@class NSArray;

@interface BlackList : NSObject
{
	//NSMutableDictionary	*blackList;
}

+(id)sharedInstance;

-(BOOL)isBlocked:(NSString*)address;
-(void)block:(NSString*)address;
-(void)unblock:(NSString*)address;

-(NSArray*)list;
-(int)count;
@end
#endif /*BLACKLIST_H_*/
