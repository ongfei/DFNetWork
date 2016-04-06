//
//  DFNetworking.m
//  NetWork
//
//  Created by qqqq on 15/12/15.
//  Copyright © 2015年 董永飞. All rights reserved.
//

#import "DFNetworking.h"


@interface DFNetworking ()<NSURLSessionDelegate>
@property (nonatomic, strong) NSURLSessionDownloadTask *downloadTask;
@property (nonatomic, strong) NSData *resumeData;
@end
@implementation DFNetworking

static DFNetworking *s_defaultManager = nil;
+ (instancetype)defaultManager {
    return [[self alloc] init];;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        s_defaultManager = [super allocWithZone:zone];
    });
    return s_defaultManager;
}

- (void)getDataWithUrlStr:(NSString *)UrlStr parameter:(NSDictionary *)parameterDic Succeed:(void(^)(id responseObject))succeedBlock Faile:(void(^)(NSError *error))failBlock {
    NSMutableString *url = [NSMutableString stringWithFormat:@"%@?",UrlStr];
    for (NSString *str in parameterDic.allKeys) {
        [url appendFormat:@"&%@=%@",str,parameterDic[str]];
    }
    [url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    NSLog(@"%@",url);
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
    NSURLSessionDataTask *dataTask = [[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        if (error) {
            dispatch_sync(dispatch_get_main_queue(), ^{
                failBlock(error);
            });
        }else {
            id result = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            succeedBlock(result);
            
        }
        
    }];
    [dataTask resume];
    
}
- (void)postDataWithUrlStr:(NSString *)UrlStr parameter:(NSDictionary *)parameterDic Succeed:(void(^)(id responseObject))succeedBlock Faile:(void(^)(NSError *error))failBlock {
    
    NSMutableString *url = [NSMutableString stringWithFormat:@"?"];
    for (NSString *str in parameterDic.allKeys) {
        [url appendFormat:@"&%@=%@",str,parameterDic[str]];
    }
    [url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[UrlStr stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]]];
    [request setHTTPMethod:@"Post"];
    [request setValue:@"571d43e256a3d87e7e1586f17d3e7642" forHTTPHeaderField:@"apikey"];
    
    NSData *data = [url dataUsingEncoding:NSUTF8StringEncoding];
    request.HTTPBody = data;
    
    NSURLSessionDataTask *dataTask = [[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        if (error) {
            dispatch_sync(dispatch_get_main_queue(), ^{
                failBlock(error);
            });
        }else {
            id result = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            succeedBlock(result);
            
        }
        
    }];
    [dataTask resume];
}
- (void)downloadDataWithUrlStr:(NSString *)UrlStr parameter:(NSDictionary *)parameterDic Succeed:(void(^)())succeedBlock Faile:(void(^)(NSError *error))failBlock {
    
    NSMutableString *url = [NSMutableString stringWithFormat:@"%@?",UrlStr];
    for (NSString *str in parameterDic.allKeys) {
        [url appendFormat:@"&%@=%@",str,parameterDic[str]];
    }
    [url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    
//    NSURLSessionConfiguration *sessionConfig = [NSURLSessionConfiguration defaultSessionConfiguration];
//    NSURLSession *session = [NSURLSession sessionWithConfiguration:sessionConfig delegate:self delegateQueue:nil];
    NSURLSessionDownloadTask *downloadTask = [[NSURLSession sharedSession] downloadTaskWithURL:[NSURL URLWithString:UrlStr] completionHandler:^(NSURL * _Nullable location, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error) {
            failBlock(error);
        }else {
            //下载成功回调的block
            NSLog(@"%@",location);
            succeedBlock();
        }
    }];
    [downloadTask resume];
}

// 暂停下载任务
- (void)pause
{
    // 如果下载任务不存在，直接返回
    if (self.downloadTask == nil) return;
    
    // 暂停任务(块代码中的resumeData就是当前正在下载的二进制数据)
    // 停止下载任务时，需要保存数据
    [self.downloadTask cancelByProducingResumeData:^(NSData *resumeData) {
        self.resumeData = resumeData;
        
        // 清空并且释放当前的下载任务
        self.downloadTask = nil;
    }];
}

- (void)resume
{
    // 要续传的数据是否存在？
    if (self.resumeData == nil) return;
    
    // 建立续传的下载任务
    self.downloadTask = [[NSURLSession sharedSession] downloadTaskWithResumeData:self.resumeData];
    [self.downloadTask resume];
    
    // 将此前记录的续传数据清空
    self.resumeData = nil;
}

//支持断点续传
- (void)downloadDataWithUrlStr:(NSString *)UrlStr parameter:(NSDictionary *)parameterDic {
    
    NSMutableString *url = [NSMutableString stringWithFormat:@"%@?",UrlStr];
    for (NSString *str in parameterDic.allKeys) {
        [url appendFormat:@"&%@=%@",str,parameterDic[str]];
    }
    [url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    
    NSURLSessionConfiguration *sessionConfig = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:sessionConfig delegate:self delegateQueue:[NSOperationQueue mainQueue]];
    
    self.downloadTask = [session downloadTaskWithURL:[NSURL URLWithString:url]];
    [self.downloadTask resume];
}

#pragma mark - delegate

//下载完成
- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask
didFinishDownloadingToURL:(NSURL *)location {
    NSString * documentPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).lastObject;
    
//    NSString * fileName = [NSString stringWithFormat:@"%ld", [self.baseURLString hash]];
    
//    NSString * filePath = [documentPath stringByAppendingPathComponent:fileName];
    
//    NSURL * fileURL = [NSURL fileURLWithPath:filePath];
    
//    [[NSFileManager defaultManager] moveItemAtURL:location toURL:fileURL error:nil];
    
//    if (self.completion) {
//        
//        self.completion(fileURL);
//    }

}

/**
 *                   下载多少
 * bytesWritten               : 本次下载的字节数
 * totalBytesWritten          : 已经下载的字节数
 * totalBytesExpectedToWrite  : 下载总大小
 */
- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask
      didWriteData:(int64_t)bytesWritten
 totalBytesWritten:(int64_t)totalBytesWritten
totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite {
    //获取下载的百分比
    float progress = (float)totalBytesWritten / totalBytesExpectedToWrite;
    NSLog(@"%f",progress);
//    dispatch_sync(dispatch_get_main_queue(), ^{
//       //更新UI
//    });
}

//续传
- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask
 didResumeAtOffset:(int64_t)fileOffset
expectedTotalBytes:(int64_t)expectedTotalBytes {
    
}

@end
