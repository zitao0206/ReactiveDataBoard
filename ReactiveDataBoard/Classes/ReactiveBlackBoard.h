//
//  ReactiveBlackBoard.h
//  ReactiveDataBoard
//
//  Created by lizitao on 2018/1/19.
//

#import <Foundation/Foundation.h>
#import <ReactiveObjC/ReactiveObjC.h>

@interface ReactiveBlackBoard : NSObject
/**
 *  订阅制定key的变化通知，支持初始值获取；
 *
 *  @param key 不允许空值， 建议使用keypath宏声称键值字符串
 *
 *  @return signal
 */
- (nonnull RACSignal *)signalForKey:(nonnull NSString *)key;
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
 *  @param key 建议使用keypath宏声称键值字符串
 *
 *  @return value
 */
- (nullable id)valueForKey:(nonnull NSString *)key;
/**
 *  暂停信号的传递；
 *
 *  @param key 建议使用keypath宏声称键值字符串
 *
 */
- (void)pauseSignalForKey:(nonnull NSString *)key;
/**
 *  重启信号的传递；
 *
 *  @param key 建议使用keypath宏声称键值字符串
 *
 */
- (void)restartSignalForKey:(nonnull NSString *)key;
/**
 *  删除指定key和value，释放内存
 *
 *  @param key 建议使用keypath宏声称键值字符串
 *
 */
- (void)removeValueForKey:(nonnull NSString *)key;

@end
