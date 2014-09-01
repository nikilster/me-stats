//
//  MSAppDelegate.m
//  me-stats
//
//  Created by Sameer Arya on 8/31/14.
//  Copyright (c) 2014 NJS. All rights reserved.
//

#import "MSAppDelegate.h"

@implementation MSAppDelegate

- (NSFileHandle *)fileHandleForLog:(NSString *)logFilename
{
    NSString *documentsDir = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    NSString *logPath = [NSString stringWithFormat:@"%@/%@.txt", documentsDir, logFilename];
    [[NSFileManager defaultManager] createFileAtPath:logPath contents:nil attributes:nil];
    NSFileHandle *logFile = [NSFileHandle fileHandleForWritingAtPath:logPath];
    [logFile truncateFileAtOffset:0];
    return logFile;
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    [self.window orderOut:nil];
    
    NSFileHandle *keyLogFile = [self fileHandleForLog:@"ms-keystrokes"];
    
    NSCharacterSet *alphaSet = [NSCharacterSet letterCharacterSet];
    NSCharacterSet *digitSet = [NSCharacterSet decimalDigitCharacterSet];
    
    /* Record keystroke timestamps */
    [NSEvent addGlobalMonitorForEventsMatchingMask:(NSKeyDownMask) handler:^(NSEvent *event) {
        unichar key = [event.characters characterAtIndex:0];
        int charType = 0;
        if ([alphaSet characterIsMember:key])
            charType = 1;
        else if ([digitSet characterIsMember:key])
            charType = 2;
        
        NSString *dataStr = [NSString stringWithFormat:@"%d %d\n", (int)[[NSDate date] timeIntervalSince1970], charType];
        [keyLogFile writeData:[dataStr dataUsingEncoding:NSUTF8StringEncoding]];
    }];
    
    NSFileHandle *appLogFile = [self fileHandleForLog:@"ms-apps"];
    __block NSString *currentAppName = [[[NSWorkspace sharedWorkspace] frontmostApplication] localizedName];
    
    /* Record time spent by app */
    [NSEvent addGlobalMonitorForEventsMatchingMask:(0xffffffffU) handler:^(NSEvent *event) {
        NSString *foregroundAppName = [[[NSWorkspace sharedWorkspace] frontmostApplication] localizedName];
        
        if (![foregroundAppName isEqualToString:currentAppName]) {
            NSString *dataStr = [NSString stringWithFormat:@"%d %@\n", (int)[[NSDate date] timeIntervalSince1970], foregroundAppName];
            [appLogFile writeData:[dataStr dataUsingEncoding:NSUTF8StringEncoding]];
            currentAppName = foregroundAppName;
        }
    }];
}

@end