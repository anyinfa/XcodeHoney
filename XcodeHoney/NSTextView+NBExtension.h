//
//  NSTextView+NBExtension.h
//  XcodeHoney
//
//  Created by Nobita on 14-6-29.
//  Copyright (c) 2014年 Nobita. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class NBTextViewOperation;

@interface NSTextView (NBExtension)

- (void)addOperation:(NBTextViewOperation *)operation;
- (void)addOperations:(NSArray *)operations;

- (void)pressKey:(unsigned short)keyCode modifier:(NSUInteger)modifierFlags;

@end
