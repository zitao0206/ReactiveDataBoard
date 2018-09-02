//
//  XYReactWhiteBoard.h
//  XYReactDataBoard
//
//  Created by lizitao on 2018/1/10.
//

#import <Foundation/Foundation.h>
#import <ReactiveObjC/ReactiveObjC.h>

#define XY_KEYPATH(key) [NSString stringWithFormat:@"%@ %@",key, self]

@interface XYReactWhiteBoard : NSObject

+ (nonnull instancetype)shareBoard;
/**
 *  订阅制定key的变化通知，支持初始值获取；
 *
 *  @param key 不允许空值， 建议使用XY_KEYPATH宏声称键值字符串
 *
 *  @return signal
 */
- (nonnull RACSignal *)signalForKey:(nonnull NSString *)key;
/**
 *  订阅制定key的变化通知，支持初始值获取；
 *
 *  @param keyPath 不允许空值， 须使用XY_KEYPATH宏声称键值字符串
 *
 *  @return signal
 */
- (nonnull RACSignal *)signalForKeyPath:(nonnull NSString *)keyPath;
/**
 *  订阅制定key的变化通知，支持初始值获取，首次订阅有效，无法被覆盖；
 *
 *  @param key 不允许空值， 建议使用keypath宏声称键值字符串
 *
 *  @return signal
 */
- (nonnull RACSignal *)singleSignalForKey:(nonnull NSString *)key;
/**
 *  订阅制定key的变化通知，支持初始值获取，首次订阅有效，无法被覆盖；
 *
 *  @param keyPath 不允许空值， 须使用XY_KEYPATH宏声称键值字符串
 *
 *  @return signal
 */
- (nonnull RACSignal *)singleSignalForKeyPath:(nonnull NSString *)keyPath;
/**
 *  数据更新
 *
 *  @param value 更新值，允许为空，为空则移除原值；建议使用keypath宏声称键值字符串
 *  @param key   不允许为空
 */
- (void)setValue:(nullable id)value forKey:(nonnull NSString *)key;
/**
 *  同步获取特定值；
 *
 *  @param key 建议使用XY_KEYPATH宏声称键值字符串
 *
 *  @return value
 */
- (nullable id)valueForKey:(nonnull NSString *)key;
/**
 *  删除指定key和value；
 */
- (void)removeValueForKey:(nonnull NSString *)key;
@end
