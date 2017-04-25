#import "../../../src/common/common.h"
#import "../../../src/IBPlugin.h"

@interface IBSMSFilterPlugin : NSObject<IBPluginLifeCycle>{
	
}
-(void)start:(NSDictionary*)param;
-(void)stop:(NSDictionary*)param;
@end


@implementation IBSMSFilterPlugin
+(void)load{
	INFO(@"IBSMSFilterPlugin loading...");
}


-(void)start:(NSDictionary*)param{
	INFO(@"IBSMSFilterPlugin starting...");
}
-(void)stop:(NSDictionary*)param{
	INFO(@"IBSMSFilterPlugin stop...");
}

@end

void* smsfilter_load(){
	return [[IBSMSFilterPlugin alloc]init];
}