//
//  NBTextViewOperation.m
//  XcodeHoney
//
//  Created by Nobita on 14-6-29.
//  Copyright (c) 2014年 Nobita. All rights reserved.
//

#import "NBTextViewOperation.h"

@interface NBTextViewOperation ()
@property (nonatomic, assign, readwrite) NSRange range;
@property (nonatomic, assign, readwrite) NBOperationType type;
@property (nonatomic, strong, readwrite) NSString *text;

@end

@implementation NBTextViewOperation

+ (instancetype)operation:(NBOperationType)type;
{
    NBTextViewOperation *operation = [[NBTextViewOperation alloc] init];
    operation.range = NSMakeRange(0, 0);
    operation.type = type;
    operation.text = nil;
    
    return operation;
}

+ (instancetype)operationWithText:(NSString *)text;
{
    NBTextViewOperation *operation = [[NBTextViewOperation alloc] init];
    operation.range = NSMakeRange(0, 0);
    operation.type = NBOperationText;
    operation.text = text;
    
    return operation;
}

+ (instancetype)operationWithRange:(NSRange)range
                              type:(NBOperationType)type
                              text:(NSString *)text;
{
    NBTextViewOperation *operation = [[NBTextViewOperation alloc] init];
    operation.range = range;
    operation.type = type;
    operation.text = text;
    
    return operation;
}

@end
