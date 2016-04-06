//
//  DFNetworking.h
//  NetWork
//
//  Created by qqqq on 15/12/15.
//  Copyright © 2015年 董永飞. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DFNetworking : NSObject
+ (instancetype)defaultManager;
/**
 *  GET请求
 *
 *  @param UrlStr       网址字符串
 *  @param parameterDic 参数字典
 *  @param succeedBlock 完成调用的block 参数是请求后的数据
 *  @param failBlock    失败调用的block 参数是错误详情
 */
- (void)getDataWithUrlStr:(NSString *)UrlStr parameter:(NSDictionary *)parameterDic Succeed:(void(^)(id responseObject))succeedBlock Faile:(void(^)(NSError *error))failBlock;
/**
 *  POST请求
 *
 *  @param UrlStr       网址字符串
 *  @param parameterDic 参数字典
 *  @param succeedBlock 完成调用的block 参数是请求后的数据
 *  @param failBlock    失败调用的block 参数是错误详情
 */
- (void)postDataWithUrlStr:(NSString *)UrlStr parameter:(NSDictionary *)parameterDic Succeed:(void(^)(id responseObject))succeedBlock Faile:(void(^)(NSError *error))failBlock;
/**
 *  不支持断点续传
 *
 *  @param UrlStr       下载的网址字符串
 *  @param parameterDic 参数字典
 *  @param succeedBlock 下载完成调用的block
 *  @param failBlock    失败调用的block
 */
- (void)downloadDataWithUrlStr:(NSString *)UrlStr parameter:(NSDictionary *)parameterDic Succeed:(void(^)())succeedBlock Faile:(void(^)(NSError *error))failBlock;
/**
 *  支持断点续传
 *
 *  @param UrlStr       下载的网址字符串
 *  @param parameterDic 参数字典
 */
- (void)downloadDataWithUrlStr:(NSString *)UrlStr parameter:(NSDictionary *)parameterDic;
/**
 *  继续下载,使用断点续传的下载方法可用
 */
- (void)resume;
/**
 *  暂停下载任务,使用断点续传的下载方法可用
 */
- (void)pause;
@end
