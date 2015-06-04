//
//  AppDelegate.m
//  miband-unlocker
//
//  Created by liangwei on 15/5/29.
//  Copyright (c) 2015年 pangliang. All rights reserved.
//

#import "AppDelegate.h"
#import "MainPopoverViewController.h"
#import "BlutoothIO.h"

@interface AppDelegate()
@property (strong, nonatomic) NSStatusItem *statusItem;
@property (strong, nonatomic) NSPopover* popover;
@property (strong, nonatomic) MainPopoverViewController* mainView;
@end

@implementation AppDelegate
@synthesize statusItem;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    [self initStatusItem];
    
    [BlutoothIO getInstance];
}

- (void)initStatusItem{
    self.statusItem = [[NSStatusBar systemStatusBar] statusItemWithLength:NSVariableStatusItemLength];
    self.statusItem.image = [NSImage imageNamed:@"Chain_links_24.png"];
    self.statusItem.alternateImage = [NSImage imageNamed:@"Chain_links_24.png"];
    [statusItem setTitle:@"TEST"];
    [statusItem setHighlightMode:YES];
    [self.statusItem setAction:@selector(statusItemClicked:)];
    
    self.mainView = [[MainPopoverViewController alloc] init];
    _popover = [[NSPopover alloc] init];
    _popover.contentViewController = self.mainView;
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



