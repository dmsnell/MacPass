//
//  MPContextMenuHelper.m
//  MacPass
//
//  Created by Michael Starke on 09.06.13.
//  Copyright (c) 2013 HicknHack Software GmbH. All rights reserved.
//

#import "MPContextMenuHelper.h"
#import "MPActionHelper.h"

#import "MPFlagsHelper.h"

static void MPContextmenuHelperBeginSection(NSMutableArray *items) {
  if([items count] > 0) {
    [items addObject:[NSMenuItem separatorItem]];
  }
}

@implementation MPContextMenuHelper

+ (NSArray *)contextMenuItemsWithItems:(MPContextMenuItemsFlags)flags {
  
  BOOL const insertCreate = MPTestFlagInOptions(MPContextMenuCreate, flags);
  BOOL const insertDelete = MPTestFlagInOptions(MPContextMenuDelete, flags);
  BOOL const insertCopy = MPTestFlagInOptions(MPContextMenuCopy, flags);
  BOOL const insertTrash = MPTestFlagInOptions(MPContextMenuTrash, flags);
  BOOL const insertClone = MPTestFlagInOptions(MPContextMenuClone, flags);
  
  NSMutableArray *items = [NSMutableArray arrayWithCapacity:10];
  if(insertCreate) {
    
    NSMenuItem *newGroup = [[NSMenuItem alloc] initWithTitle:NSLocalizedString(@"ADD_GROUP", @"")
                                                      action:[MPActionHelper actionOfType:MPActionAddGroup]
                                               keyEquivalent:@"G"];
    NSMenuItem *newEntry = [[NSMenuItem alloc] initWithTitle:NSLocalizedString(@"ADD_ENTRY", @"")
                                                      action:[MPActionHelper actionOfType:MPActionAddEntry]
                                               keyEquivalent:@"E"];
    
    [items addObjectsFromArray:@[ newGroup, newEntry ]];
  }
  if(insertClone) {
    MPContextmenuHelperBeginSection(items);
    NSMenuItem *cloneEntry = [[NSMenuItem alloc] initWithTitle:NSLocalizedString(@"CLONE_ENTRY", @"")
                                                      action:[MPActionHelper actionOfType:MPActionCloneEntry]
                                               keyEquivalent:@"D"];
    NSMenuItem *cloneEntyWithOptions = [[NSMenuItem alloc] initWithTitle:NSLocalizedString(@"CLONE_ENTRY_WITH_OPTIONS", @"")
                                                      action:[MPActionHelper actionOfType:MPActionCloneEntryWithOptions]
                                               keyEquivalent:@""];
    
    [items addObjectsFromArray:@[ cloneEntry, cloneEntyWithOptions ]];
  
  }
  if(insertDelete || insertTrash) {
    MPContextmenuHelperBeginSection(items);
    if(insertDelete) {
      NSMenuItem *delete = [[NSMenuItem alloc] initWithTitle:NSLocalizedString(@"DELETE", @"")
                                                      action:[MPActionHelper actionOfType:MPActionDelete]
                                               keyEquivalent:@""];
      [items addObject:delete];
      
    }
    if(insertTrash) {
      NSMenuItem *emptyTrash = [[NSMenuItem alloc] initWithTitle:NSLocalizedString(@"EMPTY_TRASH", @"")
                                                          action:[MPActionHelper actionOfType:MPActionEmptyTrash]
                                                   keyEquivalent:@""];
      [emptyTrash setKeyEquivalentModifierMask:(NSShiftKeyMask | NSCommandKeyMask)];
      unichar backSpace = NSBackspaceCharacter;
      [emptyTrash setKeyEquivalent:[NSString stringWithCharacters:&backSpace length:1]];
      [items addObject:emptyTrash];
      
    }
  }
  if(insertCopy) {
    MPContextmenuHelperBeginSection(items);
    NSMenuItem *copyUsername = [[NSMenuItem alloc] initWithTitle:NSLocalizedString(@"COPY_USERNAME", @"")
                                                          action:[MPActionHelper actionOfType:MPActionCopyUsername]
                                                   keyEquivalent:@"C"];
    NSMenuItem *copyPassword = [[NSMenuItem alloc] initWithTitle:NSLocalizedString(@"COPY_PASSWORD", @"")
                                                          action:[MPActionHelper actionOfType:MPActionCopyPassword]
                                                   keyEquivalent:@"c"];
    [copyPassword setKeyEquivalentModifierMask:[copyPassword keyEquivalentModifierMask] | NSAlternateKeyMask];
    NSMenu *urlMenu = [[NSMenu alloc] init];
    NSMenuItem *urlItem = [[NSMenuItem alloc] initWithTitle:NSLocalizedString(@"URL", @"")
                                                     action:0
                                              keyEquivalent:@""];
    [urlItem setSubmenu:urlMenu];
    
    NSMenuItem *copyURL = [[NSMenuItem alloc] initWithTitle:NSLocalizedString(@"COPY_URL", @"")
                                                     action:[MPActionHelper actionOfType:MPActionCopyURL]
                                              keyEquivalent:@"u"];
    NSMenuItem *openURL = [[NSMenuItem alloc] initWithTitle:NSLocalizedString(@"OPEN_URL", @"")
                                                     action:[MPActionHelper actionOfType:MPActionOpenURL]
                                              keyEquivalent:@"U"];
    [urlMenu addItem:copyURL];
    [urlMenu addItem:openURL];
    
    [items addObjectsFromArray:@[ copyUsername, copyPassword, urlItem]];
  }
  
  return items;
}

@end
