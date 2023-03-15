//
//  ReactiveWhiteBoard.h
//  ReactiveDataBoard
//
//  Created by lizitao on 2019/9/27.
//

#import <Foundation/Foundation.h>
#import <ReactiveObjC/ReactiveObjC.h>

#define   RACWB                     [ReactiveWhiteBoard whiteBoard]
#define   RACWBObserver(key)        [[ReactiveWhiteBoard whiteBoard] addObserver:self forKey:key]
#define   RACWBRemoveObserver(key)  [[ReactiveWhiteBoard whiteBoard] removeObserver:self forKey:key]

@interface ReactiveWhiteBoard : NSObject

+ (nonnull instancetype)whiteBoard;
/**
*  Data update
*
*  @param value Update the value. It is allowed to be nil. If it is nil, the original value will be removed; It is recommended to use the macro to claim the key value string
*  @param key   nil is not allowed
*/
- (void)setValue:(id _Nullable )value forKey:(NSString *_Nullable)key;
/**
*  Get specific values synchronously.
*
*  @param key, It is recommended to use the keypath macro to claim the key value string.
*
*  @return value
*/
- (id _Nullable )valueForKey:(NSString *_Nonnull)key;

/**
*  Subscribe to the change notification of the specified key and support the initial value acquisition.
*
*  @param key nil is not allowed, It is recommended to use the keypath macro to claim the key value string.
*
*  @return signal
*/
- (RACSignal *_Nullable)addObserver:(id _Nullable )obj forKey:(NSString *_Nullable)key;
/**
*  Suspend signal transmission.
*
*  @param key, It is recommended to use the keypath macro to claim the key value string.
*
*/
- (void)pauseSignalForKey:(NSString *_Nullable)key;
/**
*  Restart transmission of signal.
*
*  @param key, It is recommended to use the keypath macro to claim the key value string.
*
*/
- (void)restartSignalForKey:(NSString *_Nonnull)key;

/**
*  Delete the key value listening under the specified obj and release the memory (required, choose one from three).
*
*  @param key, It is recommended to use the keypath macro to claim the key value string.
*
*/
- (void)removeObserver:(id _Nullable )obj forKey:(NSString *_Nonnull)key;
/**
*  Delete all listeners under the specified obj and free memory (required, choose one from three).
*
*/
- (void)removeAllObjObservers:(id _Nullable )obj;
/**
*  Delete all listeners under the specified Key value and free memory (required, choose one from three).
*
*/
- (void)removeAllKeyObservers:(NSString *_Nullable)key;

@end
