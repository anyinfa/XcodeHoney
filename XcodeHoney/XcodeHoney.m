//
//  XcodeHoney.m
//  XcodeHoney
//
//  Created by Nobita on 14-6-10.
//    Copyright (c) 2014年 Nobita. All rights reserved.
//

#import "XcodeHoney.h"
#import "NBKeyCode.h"
#import "NBTextViewOperation.h"
#import "NSTextView+NBExtension.h"

static XcodeHoney *sharedPlugin;

@interface XcodeHoney()
@property (nonatomic, strong) NSBundle *bundle;
@property (nonatomic, strong) NSEvent *keyboardEvent;
@property (nonatomic, strong) NSTextView *textView;

@end

@implementation XcodeHoney

+ (void)pluginDidLoad:(NSBundle *)plugin
{
    static dispatch_once_t onceToken;
    NSString *currentApplicationName = [[NSBundle mainBundle] infoDictionary][@"CFBundleName"];
    if ([currentApplicationName isEqual:@"Xcode"]) {
        dispatch_once(&onceToken, ^{
            sharedPlugin = [[self alloc] initWithBundle:plugin];
        });
    }
}

- (id)initWithBundle:(NSBundle *)plugin
{
    if (self = [super init])
    {
        self.bundle = plugin;
        [self initialize];
    }
    
    return self;
}

#pragma mark

- (void)initialize
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleNSApplicationDidFinishLaunchingNotification:)
                                                 name:NSApplicationDidFinishLaunchingNotification
                                               object:nil];
}

- (void)handleNSApplicationDidFinishLaunchingNotification:(NSNotification *)notification
{
    self.keyboardEvent = [NSEvent addLocalMonitorForEventsMatchingMask:NSKeyDownMask handler:^NSEvent *(NSEvent *event) {
        if (([event modifierFlags] & NSCommandKeyMask) &&
            [[event.window firstResponder] isKindOfClass:NSClassFromString(@"DVTSourceTextView")]) {
            BOOL done = YES;
            self.textView = (NSTextView *)[event.window firstResponder];
            
            switch ([event keyCode]) {
                case kVK_Return:
                    [self handleCommand_Return:event];
                    break;
                case kVK_Semicolon:
                    [self handleCommand_Semicolon:event];
                    break;
                case kVK_Minus:
                    [self handleSingle_Asterisk_Comment:event];
                    break;
                case kVK_Equals:
                    [self handleDouble_Asterisk_Comment:event];
                    break;
                case kVK_SingleQuote:
                    [self handleCopyThenPasteLine:event];
                    break;
                default:
                    done = NO;
                    break;
            }
            
            return done ? nil : event;
        }
        
        return event;
    }];
}

#pragma mark

- (void)handleCommand_Return:(NSEvent *)event
{
    [self.textView addOperation:Operation(NBOperationNewline)];
}

- (void)handleCommand_Semicolon:(NSEvent *)event
{
    [self.textView addOperations:@[Operation(NBOperationLineEnd),
                                   OperationText(@";"),
                                   Operation(NBOperationEnter)]];
}

- (void)handleSingle_Asterisk_Comment:(NSEvent *)event
{
    [self.textView addOperation:Operation(NBOperationSingleAsteriskComment)];
}

- (void)handleDouble_Asterisk_Comment:(NSEvent *)event
{
    [self.textView addOperation:Operation(NBOperationDoubleAsteriskComment)];
}

- (void)handleCopyThenPasteLine:(NSEvent *)event
{
    [self.textView addOperation:Operation(NBOperationCopyThenPasteLine)];
}

#pragma mark

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:NSApplicationDidFinishLaunchingNotification
                                                  object:nil];
}

@end
