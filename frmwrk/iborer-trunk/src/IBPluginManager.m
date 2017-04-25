#import "IBPlugin.h"
#import "IBPluginManager.h"
#import "common/common.h"
#import "common/OSUtil.h"


@interface IBPluginModel : NSObject{
	NSString	*pluginId;
	NSString	*path;
	CFBundleRef	bundle;
	id			instance;
	BOOL		started;
}
-(BOOL)load;
-(BOOL)unload;
-(BOOL)start:(NSDictionary*)param;
-(BOOL)stop:(NSDictionary*)param;
-(BOOL)isLoaded;
-(BOOL)isStarted;

-(NSString*)pluginId;
-(NSString*)path;
-(CFBundleRef)bundle;
-(id)instance;

@end
@implementation IBPluginModel
-(id)initWithPath:(NSString*)aPath{
	[super init];
	RETAIN(path,aPath);
	return self;
}

-(BOOL)load{
	INFO(@"Trying to load plugin at %@",path);
	CFURLRef url = CFURLCreateFromFileSystemRepresentation(kCFAllocatorDefault,(const UInt8 *)[path UTF8String],(CFIndex)[path length],YES);
	CFBundleRef aBundle = CFBundleCreate(kCFAllocatorDefault,url);//[NSBundle bundleWithPath:path];
	if(aBundle) {
		CFStringRef anId = CFBundleGetIdentifier(aBundle);//[aBundle bundleIdentifier];
		if(anId){
			INFO(@"Bundle %@ found",anId);
		}else{
			ERROR(@"Bundle loaded but no identification found, abort loading!");
			goto _error_exit_;
		}

		//Check the OS version requirement
		CFDictionaryRef info = CFBundleGetInfoDictionary(aBundle);
		CFStringRef requiredOSVersion = CFDictionaryGetValue(info,CFSTR("RequiredOSVersion"));

		if(requiredOSVersion){
			INFO(@"Plugin requires OS version: %@",requiredOSVersion);
			int currentOsVersionNumber = osVersion();
			int requiredOSVersionNumber = [(NSString*)requiredOSVersion intValue];
			if(currentOsVersionNumber < requiredOSVersionNumber){
				ERROR(@"Plugin %@ needs os version %d, but current OS version is %d, load aborted!",anId, requiredOSVersionNumber,currentOsVersionNumber);
				goto _error_exit_;
			}
		}else{
			
		}
		
		// Get the loader function name from plist first, if not found, using the $(PLUGIN_NAME)_load() convention
		NSString *loadFunctionName = (NSString*)CFDictionaryGetValue(info,CFSTR("LoadFunction"));
		if(loadFunctionName == nil){
			loadFunctionName = [NSString stringWithFormat:@"%@_load",[(NSString*)anId pathExtension]];
		}
		// Trying to locate the initialize method instead from info plist
		void* (*fnLoad)(void) = CFBundleGetFunctionPointerForName(aBundle,(CFStringRef)loadFunctionName/*CFSTR("test_bundle_load")*/);
		if(fnLoad == nil){
			//TODO try to use NSBundle to locate the principal class
			ERROR(@"Could not locate the load function %@ in plugin %@!",loadFunctionName,anId);
			goto _error_exit_;
		}
		id anInstance = fnLoad();
		if(anInstance){
			INFO(@"Plugin %@(%@) initialized",anId,anInstance);
			// Initialize successfully, retain info and report success
			bundle = aBundle;
			RELEASE(pluginId);
			pluginId = [[NSString alloc]initWithFormat:@"%@",anId];
			RETAIN(instance,anInstance);
			[anInstance release];
			INFO(@"Plug-in %@ now loaded",pluginId);
			return YES;
		}else{
			ERROR(@"Could not initializing plugin %@",anId);
			goto _error_exit_;
		}
		/*
		INFO(@"Trying to load  principal class...");
		Class pluginClass = [aBundle principalClass];
		if (pluginClass)
		{
			INFO(@"Principal class %@ loaded!",pluginClass);

			@try{
				id anInstance = [[pluginClass alloc]init];
				if(anInstance){
					INFO(@"Plugin %@(%@) initialized",anId,anInstance);
					// Initialize successfully, retain info and report success
					RETAIN(bundle,aBundle);
					RETAIN(pluginId,anId);
					RETAIN(instance,anInstance);
					[anInstance release];
					INFO(@"Plug-in %@ now loaded",pluginId);
					return YES;
				}
			}@catch(NSException	*exception){
				ERROR(@"Got exception %@ while initializing plugin %@(%@)",exception,pluginClass,anId);
			}@finally{
				// Noop
			}
		}else{
			ERROR(@"Could not load plugin %@ without principal class defined!",anId);
		}
		*/
	}else {
		ERROR(@"Failed to load plugin from %@",path);
	}
_error_exit_:
	if(aBundle != nil){
		CFRelease(aBundle);
	}
	return NO;
}

-(BOOL)unload{
	if(![self isLoaded]){
		WARN(@"Plug-in is not loaded yet");
		return NO;
	}
	// Stop first if plugin is still running
	//DECIDE can we unload a started plugin ? 
	if([self isStarted]){
		[self stop:nil];
	}
	
	NSString *tmpId = [NSString stringWithFormat:@"%@",pluginId];
	@try{
		RELEASE(instance);
		RELEASE(pluginId);
		CFRelease(bundle);
		bundle = nil;
		INFO(@"Plug-in %@ now unloaded",tmpId);
	}@catch(NSException* e){
		ERROR(@"Got exception while unloading plugin %@",tmpId);
	}
	
	return YES;
}

-(BOOL)start:(NSDictionary*)param{
	//TODO The parameter is ignored currently
	if(![self isLoaded]){
		WARN(@"Plug-in is not loaded yet");
		return NO;
	}
	
	if(started){
		WARN(@"Plug-in %@ has already started",pluginId);
		return NO;
	}
	
	if([instance conformsToProtocol:@protocol(IBPluginLifeCycle)]){
		@try{
			[(id<IBPluginLifeCycle>)instance start:nil];
			started = YES;
			INFO(@"Plug-in %@ now started",pluginId);
		}@catch(NSException *e){
			ERROR(@"Got exception while startting plug-in %@, %@",pluginId,e);
		}
	}
	return YES;
}

-(BOOL)stop:(NSDictionary*)param{
	//TODO The parameter is ignored currently
	if(![self isLoaded]){
		WARN(@"Plug-in is not loaded yet");
		return NO;
	}
	
	if(!started){
		WARN(@"Plug-in %@ is not started yet",pluginId);
		return NO;
	}
	if([instance conformsToProtocol:@protocol(IBPluginLifeCycle)]){
		@try{
			[(id<IBPluginLifeCycle>)instance stop:nil];
			started = NO;
			INFO(@"Plug-in %@ now stopped",pluginId);
		}@catch(NSException *e){
			ERROR(@"Got exception while stopping plug-in %@, %@",pluginId,e);
		}
	}
	return YES;
}

-(void)dealloc{
	//DECIDE do we need stop & unload plugin when the model data is destroied ?
	// Stop & Unload bundle first
	if([self isLoaded]){
		[self unload];
	}
	RELEASE(path);
	[super dealloc];
}


-(BOOL)isLoaded{return bundle != nil && pluginId != nil && instance != nil;}
-(BOOL)isStarted{return started;}
-(NSString*)pluginId{return pluginId;}
-(NSString*)path{return path;}
-(CFBundleRef)bundle{return bundle;}
-(id)instance{return instance;}
@end

//=========================================================
// PluginManager implementation
//=========================================================
@implementation IBPluginManager

-(id)initWithPluginPath:(NSString*)aPath{
	[super init];
	pluginDict = [[NSMutableDictionary alloc]init];
	RETAIN(pluginsPath,aPath);
	[self _loadAllPlugins];
	return self;
}

-(void)_loadAllPlugins{
	//load all bundles under the plugin path
	// Make sure the plugin path is initialized correctly
	INFO(@"IBPluginManager is initializing with plugin path %@",pluginsPath);
	NSFileManager *fm = [NSFileManager defaultManager];
	// First check whether the path exists;
	NSArray	*dirContents = [fm directoryContentsAtPath:pluginsPath];
	for(int i = 0;dirContents != nil && i < [dirContents count];i++){
		NSString *fname = [dirContents objectAtIndex:i];
		DBG(@"Checking %@",fname);
		if([[fname pathExtension] isEqualToString:@"bundle"]){
			//We got it!
			NSString *pPath = [pluginsPath stringByAppendingPathComponent:fname];
			IBPluginModel	*aPluginModel = [[IBPluginModel alloc]initWithPath:pPath];
			if([aPluginModel load]){
				[aPluginModel start:nil];
				// Load and start success, and register it into the plugin dict
				[pluginDict setObject:aPluginModel forKey:[aPluginModel pluginId]];
			}
			[aPluginModel release];
			//[self _loadPluginAtPath:[aPath stringByAppendingPathComponent:fname]];
		}
	}
}

//TODO Define a convention that PluginManager will broadcast notification with Plugin's ID as the notify name
// and all plugins can register observer for that specific notification?
void _notifyPlugin(NSString* notifiyName, NSString* cmd, NSDictionary* param){
	//TODO add the sender in param ?
	[[NSNotificationCenter defaultCenter]
		  postNotificationName:notifiyName
		  object:cmd // The startup command
		  userInfo:param];  // Parameter of the command
}

-(void)dealloc{
	RELEASE(pluginsPath);
	RELEASE(pluginDict);
	[super dealloc];
}

-(id)pluginForId:(NSString*)anId{
	IBPluginModel	*pm = [pluginDict objectForKey:anId];
	return [pm instance];
}

-(void*)pluginBundleForId:(NSString*)anId{
	IBPluginModel	*pm = [pluginDict objectForKey:anId];
	return [pm bundle];
}

// Get all plugin instances, if plugin is loaded
-(NSArray*)plugins{
	NSMutableArray *result = [[NSMutableArray alloc] init];
	NSEnumerator* pEnum = [pluginDict objectEnumerator];
    id obj;
    while( (obj = [pEnum nextObject]) != nil) {
    	IBPluginModel* apm = (IBPluginModel*)obj;
    	if([apm isLoaded]){
    		[result addObject:[apm instance]];
    	}
    }
	return [result autorelease];
}

-(void)startPluginById:(NSString*)pluginId{
	IBPluginModel	*pm = [pluginDict objectForKey:pluginId];
	[pm start:nil];
}

-(void)stopPluginById:(NSString*)pluginId{
	IBPluginModel	*pm = [pluginDict objectForKey:pluginId];
	if(pm){
		[pm stop:nil];		
	}else{
		INFO(@"Plug-in %@ is not found!",pluginId);
	}
}

-(void)stopAllPlugins{
	NSEnumerator* pEnum = [pluginDict objectEnumerator];
    id apm;
    while( (apm = [pEnum nextObject]) != nil) {
    	[(IBPluginModel*)apm stop:nil];
    }
}

-(void)startAllPlugins{
	NSEnumerator* pEnum = [pluginDict objectEnumerator];
    id apm;
    while( (apm = [pEnum nextObject]) != nil) {
    	[(IBPluginModel*)apm start:nil];
    }
}

-(void)unloadAllPlugins{
//	NSEnumerator* pEnum = [pluginDict objectEnumerator];
//    id apm;
//    while( (apm = [pEnum nextObject]) != nil) {
//    	[(IBPluginModel*)apm unload];
//    }
    // !!! Remove all plugin entry out of the dict !!!
    // And the dealloc() of class IBPluginModel  should unload the plugin automatically
    [pluginDict removeAllObjects];
}

-(void)reloadAllPlugins{
	[self unloadAllPlugins];
	[self _loadAllPlugins];
}

-(void)reloadPluginById:(NSString*)anId{
	IBPluginModel	*pm = [pluginDict objectForKey:anId];
	if(nil == pm){
		INFO(@"Plug-in %@ is not found!",anId);
		return;
	}
	if([pm isLoaded]){
		[pm unload];
	}
	if([pm load]){
		[pm start:nil];
	}
}
@end
