//
//  ReactiveWhiteBoard.h
//  ReactiveDataBoard
//
//  Created by lizitao on 2018/1/19.
//

#import <Foundation/Foundation.h>
#import <ReactiveObjC/ReactiveObjC.h>

#define   RACWB                     [ReactiveWhiteBoard whiteBoard]
#define   RACWBObserver(key)        [[ReactiveWhiteBoard whiteBoard] addObserver:self forKey:key]
#define   RACWBRemoveObserver(key)  [[ReactiveWhiteBoard whiteBoard] removeObserver:self forKey:key]

@interface ReactiveWhiteBoard : NSObject
+ (nonnull instancetype)whiteBoard;
/**
*  数据更新
*
*  @param value 更新值，允许为空，为空则移除原值；建议使用宏声称键值字符串
*  @param key   不允许为空
*/
- (void)setValue:(id _Nullable )value forKey:(NSString *_Nullable)key;
/**
*  同步获取特定值；
*
*  @param key 建议使用宏声称键值字符串
*
*  @return value
*/
- (id _Nullable )valueForKey:(NSString *_Nonnull)key;

/**
*  订阅制定key的变化通知，支持初始值获取；
*
*  @param key 不允许空值， 建议使用宏声称键值字符串
*
*  @return signal
*/
- (RACSignal *_Nullable)addObserver:(id _Nullable )obj forKey:(NSString *_Nullable)key;
/**
*  暂停信号的传递；
*
*  @param key 建议使用宏声称键值字符串
*
*/
- (void)pauseSignalForKey:(NSString *_Nullable)key;
/**
*  重启信号的传递；
*
*  @param key 建议使用宏声称键值字符串
*
*/
- (void)restartSignalForKey:(NSString *_Nonnull)key;

/**
*  删除指定obj下的Key值监听，释放内存（必须，三选一）
*
*  @param key 建议使用宏声称键值字符串
*
*/
- (void)removeObserver:(id _Nullable )obj forKey:(NSString *_Nonnull)key;
/**
*  删除指定obj下的所有的监听，释放内存（必须，三选一）
*
*/
- (void)removeAllObjObservers:(id _Nullable )obj;
/**
*  删除指定Key值下的所有的监听，释放内存（必须，三选一）
*
*/
- (void)removeAllKeyObservers:(NSString *_Nullable)key;

@end
