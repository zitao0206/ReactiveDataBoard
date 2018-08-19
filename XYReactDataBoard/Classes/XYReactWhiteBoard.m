//
//  XYReactWhiteBoard.m
//  XYReactDataBoard
//
//  Created by lizitao on 2018/1/10.
//

#import "XYReactWhiteBoard.h"
#import "XYReactDataBoardSubject.h"

@interface XYReactWhiteBoard ()
@property (nonatomic, strong) NSMutableDictionary *subjects;
@property (nonatomic, strong) NSMutableDictionary *values;
@end

@implementation XYReactWhiteBoard

static XYReactWhiteBoard *whiteBoard;
static dispatch_once_t onceToken;

+ (instancetype)shareBoard
{
    return [[self alloc] init];
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone
{
    dispatch_once(&onceToken, ^{
        whiteBoard = [super allocWithZone:zone];
    });
    return whiteBoard;
}

- (instancetype)copyWithZone:(NSZone *)zone
{
    return whiteBoard;
}

- (instancetype)mutableCopyWithZone:(NSZone *)zone
{
    return whiteBoard;
}

- (void)setValue:(id)value forKey:(NSString *)key
{
    if (key.length <= 0) return;
    if (value) {
        @synchronized (self) {
            [self.values setObject:value forKey:key];
        }
    } else {
        @synchronized (self) {
            [self.values removeObjectForKey:key];
        }
    }
    [[self subjectForKey:key] sendNext:value];
}

- (id)valueForKey:(NSString *)key
{
    return [self.values objectForKey:key];
}

- (RACSignal *)signalForKey:(NSString *)key
{
    if (key.length <= 0) return [RACSignal empty];
    RACSubject *subject = [self subjectForKey:key];
    if (subject == nil) {
        subject = [RACSubject subject];
        @synchronized (self) {
            [self.subjects setObject:subject forKey:key];
            [self.rac_deallocDisposable addDisposable:[RACDisposable disposableWithBlock:^{
                [subject sendCompleted];
            }]];
        }
    }
    return subject;
}

- (nonnull RACSignal *)singleSignalForKey:(nonnull NSString *)key
{
    if (key.length <= 0) return [RACSignal empty];
    RACSubject *subject = [self subjectForKey:key];
    if (subject == nil || ![subject isKindOfClass:[XYReactDataBoardSubject class]]) {
        subject = [XYReactDataBoardSubject subject];
        @synchronized (self) {
            [self.subjects setObject:subject forKey:key];
            [self.rac_deallocDisposable addDisposable:[RACDisposable disposableWithBlock:^{
                [subject sendCompleted];
            }]];
        }
    }
    return subject;
}

- (RACSubject *)subjectForKey:(NSString *)key
{
    return [self.subjects objectForKey:key];
}

#pragma mark - accessor

- (NSMutableDictionary *)subjects
{
    if (nil == _subjects) {
        _subjects = [NSMutableDictionary dictionary];
    }
    return _subjects;
}

- (NSMutableDictionary *)values
{
    if (nil == _values) {
        _values = [NSMutableDictionary dictionary];
    }
    return _values;
}

#pragma mark - remove and destroy

- (void)removeValueForKey:(nonnull NSString *)key
{
    if (key.length <= 0) return;
    @synchronized (self) {
        [self.subjects removeObjectForKey:key];
        [self.values removeObjectForKey:key];
    }
}

- (void)destroysShareBoard
{
    whiteBoard = nil;
    onceToken = 0;
}

@end
