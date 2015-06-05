//
//  AppDelegate.m
//  miband-unlocker
//
//  Created by liangwei on 15/5/29.
//  Copyright (c) 2015年 pangliang. All rights reserved.
//

#import "AppDelegate.h"
#import "MainPopoverViewController.h"
#import "BLEDeviceManager.h"

@interface AppDelegate()
@property (strong, nonatomic) NSStatusItem *statusItem;
@property (strong, nonatomic) NSPopover* popover;
@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    [self initStatusItem];
    
    [BLEDeviceManager getInstance];
    
}

- (void)initStatusItem{
    self.statusItem = [[NSStatusBar systemStatusBar] statusItemWithLength:NSVariableStatusItemLength];
    self.statusItem.image = [NSImage imageNamed:@"Chain_links_24.png"];
    self.statusItem.alternateImage = [NSImage imageNamed:@"Chain_links_24.png"];
    [self.statusItem setHighlightMode:YES];
    [self.statusItem setAction:@selector(statusItemClicked:)];
    
    _popover = [[NSPopover alloc] init];
    _popover.contentViewController = [[MainPopoverViewController alloc] init];
}

- (void)statusItemClicked:(id)sender {
    if([_popover isShown]){
        [_popover close];
    }else{
        [_popover showRelativeToRect:[sender bounds] ofView:sender preferredEdge:NSMaxYEdge];
    }
    
}

- (void)applicationWillTerminate:(NSNotification *)aNotification {
    
}


@end



