//
//  NSWindow+DragAndDrop.m
//  MIU
//
//  Created by ovcharuk on 12/7/16.
//  Copyright © 2016 NIX. All rights reserved.
//

#import "MIUWindow.h"

@interface MIUWindow ()<NSDraggingDestination>

@end

@implementation MIUWindow

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    [self registerForDraggedTypes:@[NSFilenamesPboardType]];
}

- (NSDragOperation)draggingEntered:(id<NSDraggingInfo>)sender
{
    return NSDragOperationLink;
}

- (BOOL)performDragOperation:(id<NSDraggingInfo>)sender
{
    NSPasteboard *pboard;
    NSDragOperation sourceDragMask;
    
    sourceDragMask = [sender draggingSourceOperationMask];
    pboard = [sender draggingPasteboard];
    
    if ([[pboard types] containsObject:NSFilenamesPboardType])
    {
        NSArray *files = [pboard propertyListForType:NSFilenamesPboardType];
        
        if (sourceDragMask & NSDragOperationLink)
        {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"DidClickAddNewProject" object:self userInfo:@{@"files" : files}];
        }
    }
    
    return YES;
}

@end
