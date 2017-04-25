#ifndef LOG_H_
#define LOG_H_

#import "Logger.h"

#define LOG_WITH_LEVEL(x,y,...) [[Logger sharedInstance] log:__FILE__ lineNumber:__LINE__ logLevel:x format:(y),##__VA_ARGS__]

#define LOG(x,...) LOG_WITH_LEVEL(LOG_INFO,x,##__VA_ARGS__)
#define INFO(x,...) LOG_WITH_LEVEL(LOG_INFO,x,##__VA_ARGS__)
#define WARN(x,...) LOG_WITH_LEVEL(LOG_WARN,x,##__VA_ARGS__)
#define ERROR(x,...) LOG_WITH_LEVEL(LOG_ERROR,x,##__VA_ARGS__)
#define FATAL(x,...) LOG_WITH_LEVEL(LOG_FATAL,x,##__VA_ARGS__)

#ifdef DEBUG
#define DBG(x,...) LOG_WITH_LEVEL(LOG_DEBUG,x,##__VA_ARGS__)
#else
#define DBG(x,...)
#endif

#endif /*LOG_H_*/
