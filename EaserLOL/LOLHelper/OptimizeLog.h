//
//  OptimizeLog.h
//  LOLHelper
//
//  Created by Easer Liu on 5/29/17.
//  Copyright © 2017 Liu Easer. All rights reserved.
//

#ifndef OptimizeLog_h
#define OptimizeLog_h


#define NSLog(format, ...) do {                                             \
fprintf(stderr, "<%s : %d> %s\n",                                           \
[[[NSString stringWithUTF8String:__FILE__] lastPathComponent] UTF8String],  \
__LINE__, __func__);                                                        \
(NSLog)((format), ##__VA_ARGS__);                                           \
fprintf(stderr, "-------\n");                                               \
} while (0)

//#define NSLog(format, ...) /**/

@interface OptimizeLog: NSObject

@end

#endif /* OptimizeLog_h */
