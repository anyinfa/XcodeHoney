//
//  NBTextViewOperation.h
//  XcodeHoney
//
//  Created by Nobita on 14-6-29.
//  Copyright (c) 2014年 Nobita. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, NBOperationType)
{
    NBOperationText,
    NBOperationEnter,
    NBOperationBackspace,
    NBOperationTab,
    NBOperationNewline,
    NBOperationPlaceholder,
    NBOperationSingleAsteriskComment,
    NBOperationDoubleAsteriskComment,
    NBOperationLineEnd,
    NBOperationSelectLine,
    NBOperationCopyThenPasteLine
};

#define Operation(type) [NBTextViewOperation operation:type]
#define OperationText(text) [NBTextViewOperation operationWithText:text]

@interface NBTextViewOperation : NSObject
@property (nonatomic, assign, readonly) NSRange range;
@property (nonatomic, assign, readonly) NBOperationType type;
@property (nonatomic, strong, readonly) NSString *text;

+ (instancetype)operation:(NBOperationType)type;
+ (instancetype)operationWithText:(NSString *)text;
+ (instancetype)operationWithRange:(NSRange)range
                              type:(NBOperationType)type
                              text:(NSString *)text;

@end
