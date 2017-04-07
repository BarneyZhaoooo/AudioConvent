//
//  main.m
//  AudioConvent
//
//  Created by DuJin on 2017/4/6.
//  Copyright © 2017年 Du Jin. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "AppDelegate.h"

int main(int argc, const char * argv[]) {
    @autoreleasepool{
        AppDelegate *appDelegate = [[AppDelegate alloc] init];
        __weak typeof(AppDelegate *)weakDelegate = appDelegate;
        [NSApplication sharedApplication].delegate = weakDelegate;
        [NSApp setActivationPolicy:NSApplicationActivationPolicyRegular];
        [NSApp activateIgnoringOtherApps:YES];
        [NSApp run];
    }
    return 0;
}
