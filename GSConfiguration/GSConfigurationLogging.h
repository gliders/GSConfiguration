//
//  GSConfigurationLogging.h
//  GSConfiguration
//
//  Created by Ryan Brignoni on 2/17/15.
//  Copyright (c) 2015 Ryan Brignoni. All rights reserved.
//

#if !defined(GS_CONFIG_LOGGING_ENABLED) && __has_include("CocoaLumberjack.h")
    #define GS_CONFIG_LOGGING_ENABLED 1
#endif

#if GS_CONFIG_LOGGING_ENABLED

    #if __has_include("CocoaLumberjack.h")
        #import <CocoaLumberjack/CocoaLumberjack.h>
        #define GSLogDebug(fmt, ...) DDLogDebug(fmt, ##__VA_ARGS__)
        #define GSLogInfo(fmt, ...)  DDLogInfo(fmt, ##__VA_ARGS__)
        #define GSLogWarn(fmt, ...)  DDLogWarn(fmt, ##__VA_ARGS__)
        #define GSLogError(fmt, ...) DDLogError(fmt, ##__VA_ARGS__)
    #else
        #define DLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
        #define GSLogDebug(fmt, ...) DLog(fmt, ##__VA_ARGS__)
        #define GSLogInfo(fmt, ...)  DLog(fmt, ##__VA_ARGS__)
        #define GSLogWarn(fmt, ...)  DLog(fmt, ##__VA_ARGS__)
        #define GSLogError(fmt, ...) DLog(fmt, ##__VA_ARGS__)
    #endif

#else

    #define GSLogDebug(fmt, ...) do{}while(0)
    #define GSLogInfo(fmt, ...)  do{}while(0)
    #define GSLogWarn(fmt, ...)  do{}while(0)
    #define GSLogError(fmt, ...) do{}while(0)

#endif