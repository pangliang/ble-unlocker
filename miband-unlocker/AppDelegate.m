//
//  AppDelegate.m
//  miband-unlocker
//
//  Created by liangwei on 15/5/29.
//  Copyright (c) 2015年 pangliang. All rights reserved.
//

#import "AppDelegate.h"
#import "BlutoothIO.h"


@interface AppDelegate()
@property (atomic,strong) BlutoothIO* io;
@property (strong, nonatomic) NSStatusItem *statusItem;
@property (assign, nonatomic) BOOL darkModeOn;
@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    self.io = [[BlutoothIO alloc] init];
    
    [self initStatusItem];
}

- (void)initStatusItem{
    self.statusItem = [[NSStatusBar systemStatusBar] statusItemWithLength:NSVariableStatusItemLength];
    self.statusItem.image = [NSImage imageNamed:@"Chain_links_24.png"];
    
    NSMenu *menu = [[NSMenu alloc] init];
    [menu addItemWithTitle:@"Open Feedbin" action:@selector(openFeedbin:) keyEquivalent:@""];
    [menu addItemWithTitle:@"Refresh" action:@selector(getUnreadEntries:) keyEquivalent:@""];
    
    [menu addItem:[NSMenuItem separatorItem]];
    [menu addItemWithTitle:@"Quit" action:@selector(terminate:) keyEquivalent:@""];
    _statusItem.menu = menu;
}

- (void)itemClicked:(id)sender {
    NSAlert * alert = [NSAlert alertWithMessageText:@"Bat signal acknowledged" defaultButton:@"Alright!" alternateButton:nil otherButton:nil informativeTextWithFormat:@"NSStatusItem was clicked"];
    [alert runModal];
}

- (void)applicationWillTerminate:(NSNotification *)aNotification {
    
}


@end



