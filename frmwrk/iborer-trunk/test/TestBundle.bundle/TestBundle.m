#import <Foundation/Foundation.h>
#import "../HelloBundle.h"
#import "../../src/IBPlugin.h"

@interface TestBundle : NSObject<HelloBundle,IBPluginLifeCycle>{
	
}
-(void)sayHello;
-(void)start:(NSDictionary*)param;
-(void)stop:(NSDictionary*)param;
@end


@implementation TestBundle
+(void)load{
	NSLog(@"TestBundle loading...");
}

-(void)sayHello{
	NSLog(@"Hello from TestBundle!");
}

-(void)start:(NSDictionary*)param{
	NSLog(@"TestBundle starting...");
}
-(void)stop:(NSDictionary*)param{
	NSLog(@"TestBundle stop...");
}
@end

static id test_bundle_instance = nil;

void* test_bundle_load(){
	NSLog(@"test_bundle_load() called");
	test_bundle_instance = [[TestBundle alloc] init];
	return test_bundle_instance;
}

void* testbundle_load(){
	NSLog(@"testbundle_load() called, but forwarding to test_bundle_load()...");
	return test_bundle_load();
}