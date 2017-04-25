#ifndef PLUGINMANAGER_H_
#define PLUGINMANAGER_H_

#import <Foundation/NSObject.h>

@class NSMutableDictionary;
@class NSArray;
@class NSBundle;

@interface IBPluginManager : NSObject{
	NSMutableDictionary	*pluginDict;
	NSString	*pluginsPath;
}
-(id)initWithPluginPath:(NSString*)aPath;
-(id)pluginForId:(NSString*)anId;
-(void*)pluginBundleForId:(NSString*)anId;
-(NSArray*)plugins;

-(void)startPluginById:(NSString*)anId;
-(void)stopPluginById:(NSString*)anId;
//-(void)unloadPluginById:(NSString*)anId;
-(void)reloadPluginById:(NSString*)anId;

-(void)stopAllPlugins;
-(void)startAllPlugins;
-(void)unloadAllPlugins;
-(void)reloadAllPlugins;

-(void)_loadAllPlugins;
@end

//extern NSString *kIBPluginManagerNotification;
#define kIBPluginManagerNotification @"kIBPluginManagerNotification"
#define kIBPluginManagerNotification_Start @"kIBPluginManagerNotification_Start"
#define kIBPluginManagerNotification_Stop @"kIBPluginManagerNotification_Stop"

#endif /*PLUGINMANAGER_H_*/
