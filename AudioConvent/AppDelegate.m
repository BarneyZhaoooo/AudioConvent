//
//  AppDelegate.m
//  AudioConvent
//
//  Created by DuJin on 2017/4/6.
//  Copyright © 2017年 Du Jin. All rights reserved.
//

#import "AppDelegate.h"
#import "RootView.h"

@interface AppDelegate ()

@end



@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    NSSize screenSize = [NSScreen mainScreen].frame.size;
    
    id applicationName = [[NSProcessInfo processInfo] processName];
    self.window = [[NSWindow alloc] initWithContentRect:NSMakeRect(0.0f,
                                                                   0.0f,
                                                                   screenSize.width / 2.0f,
                                                                   screenSize.height / 2.0f)
                                              styleMask:NSWindowStyleMaskTitled | NSWindowStyleMaskClosable | NSWindowStyleMaskMiniaturizable | NSWindowStyleMaskResizable
                                                backing:NSBackingStoreBuffered
                                                  defer:NO];
    [self.window center];
    [self.window setTitle:applicationName];
    [self.window makeKeyAndOrderFront:nil];
    
    
    RootView *rootV = [[RootView alloc] initWithFrame:NSMakeRect(0.0f,
                                                                 0.0f,
                                                                 screenSize.width / 2.0f,
                                                                 screenSize.height / 2.0f)];
    [self.window.contentView addSubview:rootV];
}


- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}


@end
