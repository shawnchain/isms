#ifndef IBPLUGIN_H_
#define IBPLUGIN_H_

@class NSDictionary;

@protocol IBPluginLifeCycle
-(void)start:(NSDictionary*)param;
-(void)stop:(NSDictionary*)param;
@end
#endif /*IBPLUGIN_H_*/
