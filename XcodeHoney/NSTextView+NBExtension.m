//
//  NSTextView+NBExtension.m
//  XcodeHoney
//
//  Created by Nobita on 14-6-29.
//  Copyright (c) 2014年 Nobita. All rights reserved.
//

#import "NSTextView+NBExtension.h"
#import "NBTextViewOperation.h"
#import "NBKeyCode.h"

@implementation NSTextView (NBExtension)

- (void)addOperation:(NBTextViewOperation *)operation;
{
    switch (operation.type)
    {
        case NBOperationText:
            [self insertText:operation.text];
            break;
        case NBOperationEnter:
            [self addOperation:OperationText(@"\n")];
            break;
        case NBOperationBackspace:
            [self addOperation:OperationText(@"\b")];
            break;
        case NBOperationTab:
            [self addOperation:OperationText(@"\t")];
            break;
        case NBOperationNewline:
            [self addOperation:Operation(NBOperationLineEnd)];
            [self addOperation:OperationText(@"\n")];
            break;
        case NBOperationPlaceholder:
            [self addOperation:OperationText(@"<#placeholder#>")];
            break;
        case NBOperationSingleAsteriskComment:
            [self addOperation:OperationText(@"/** <#comments#> */")];
            [self setSelectedRange:[self rangeOfStringInCurrentLine:@"<#comments#>"]];
            break;
        case NBOperationDoubleAsteriskComment:
            [self addOperations:@[OperationText(@"/**\n"),
                                  OperationText(@"* "),
                                  OperationText(@"<#comments#>"),
                                  OperationText(@"\n*/")]];
            [self moveUp:self];
            [self setSelectedRange:[self rangeOfStringInCurrentLine:@"<#comments#>"]];
            break;
        case NBOperationLineEnd:
            [self moveToEndOfLine:nil];
            break;
        case NBOperationSelectLine:
            [self selectLine:self];
            break;
        case NBOperationCopyThenPasteLine:
            [self copyThenPasteSelectedRange];
            break;
            
        default:
            break;
    }
}

- (void)addOperations:(NSArray *)operations;
{
    for (NBTextViewOperation *operation in operations) {
        [self addOperation:operation];
    }
}

#pragma mark

- (void)copyThenPasteSelectedRange
{
    if (self.selectedRange.length > 0) {
        [self copy:self];
    } else
    {
        [self selectLine:self];
        if (self.selectedRange.length > 0) {
            [self copy:self];
        }
    }

    if (self.selectedRange.length > 0) {
        [self paste:self];
        [self paste:self];
        [self moveLeft:self];
    }
}

- (void)pressKey:(unsigned short)keyCode modifier:(NSUInteger)modifierFlags;
{
    CGEventSourceRef source = CGEventSourceCreate(kCGEventSourceStateCombinedSessionState);
    CGEventTapLocation location = kCGHIDEventTap;
    CGEventRef event = CGEventCreateKeyboardEvent(source, keyCode, true);
    if (modifierFlags != kVK_NONE) CGEventSetFlags(event, modifierFlags);
    CGEventPost(location, event);
    CFRelease(event);
    
    event = CGEventCreateKeyboardEvent(source, keyCode, false);
    if (modifierFlags != kVK_NONE) CGEventSetFlags(event, modifierFlags);
    CGEventPost(location, event);
    CFRelease(event);
    
    CFRelease(source);
}

- (NSRange)rangeOfStringInCurrentLine:(NSString *)string
{
    NSRange selectedRange = [self selectedRange];
    NSString *viewContent = [self string];
    NSRange lineRange = [viewContent lineRangeForRange:NSMakeRange(selectedRange.location, 0)];
    NSRange searchRange = [viewContent rangeOfString:string options:NSBackwardsSearch range:lineRange];
    
    return searchRange;
}

@end
