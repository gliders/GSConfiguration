//
//  GSConfigurationLogging.h
//  GSConfiguration
//
//  Created by Ryan Brignoni on 2/17/15.
//  Copyright (c) 2015 Ryan Brignoni. All rights reserved.
//

#if GS_CONFIG_LOGGING_ENABLED

    #define DLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
    #define GSLogDebug(fmt, ...) DLog(fmt, ##__VA_ARGS__)
    #define GSLogInfo(fmt, ...)  DLog(fmt, ##__VA_ARGS__)
    #define GSLogWarn(fmt, ...)  DLog(fmt, ##__VA_ARGS__)
    #define GSLogError(fmt, ...) DLog(fmt, ##__VA_ARGS__)

#else

    #define GSLogDebug(fmt, ...) do{}while(0)
    #define GSLogInfo(fmt, ...)  do{}while(0)
    #define GSLogWarn(fmt, ...)  do{}while(0)
    #define GSLogError(fmt, ...) do{}while(0)

#endif