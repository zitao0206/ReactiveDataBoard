//
//  ReactiveBlackBoard.h
//  ReactiveDataBoard
//
//  Created by lizitao on 2019/9/27.
//

#import <Foundation/Foundation.h>
#import <ReactiveObjC/ReactiveObjC.h>

@interface ReactiveBlackBoard : NSObject
/**
 *  Subscribe to the change notification of the specified key and support the initial value acquisition.
 *
 *  @param key, nil value is not allowed. It is recommended to use the keypath macro to claim the key value string.
 *
 *  @return signal
 */
- (nonnull RACSignal *)signalForKey:(nonnull NSString *)key;
/**
 *  Data update
 *
 *  @param value, Update the value. It is allowed to be blank. If it is blank, the original value will be removed; It is recommended to use the keypath macro to claim the key value string.
 *  @param key, nil value is not allowed.
 */
- (void)setValue:(nullable id)value forKey:(nonnull NSString *)key;
/**
 *  Get specific values synchronously.
 *
 *  @param key, It is recommended to use the keypath macro to claim the key value string.
 *
 *  @return value
 */
- (nullable id)valueForKey:(nonnull NSString *)key;
/**
 *  Suspend signal transmission.
 *
 *  @param key, It is recommended to use the keypath macro to claim the key value string.
 *
 */
- (void)pauseSignalForKey:(nonnull NSString *)key;
/**
 *  Restart transmission of signal.
 *
 *  @param key, It is recommended to use the keypath macro to claim the key value string.
 *
 */
- (void)restartSignalForKey:(nonnull NSString *)key;
/**
 *  Delete the specified key and value to free memory.
 *
 *  @param key, It is recommended to use the keypath macro to claim the key value string.
 *
 */
- (void)removeValueForKey:(nonnull NSString *)key;

@end
