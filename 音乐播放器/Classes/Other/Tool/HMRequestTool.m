//
//  HMDownloadTool.m
//  音乐播放器
//
//  Created by limingming on 2024/6/3.
//  Copyright © 2024 jinheng. All rights reserved.
//

#import "HMRequestTool.h"

@implementation HMRequestTool

+ (void)getData:(NSString *)urlStr callback:(RequestCallback)callback
{
    
    dispatch_queue_t globalQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(globalQueue, ^{
        NSURL *url = [NSURL URLWithString:urlStr];
        NSURLSession *session = [NSURLSession sharedSession];
        NSURLSessionDataTask *dataTask = [session dataTaskWithURL:url
                                                completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (error) {
                    NSLog(@"Error: %@", error.localizedDescription);
                    callback(NO, nil);
                    return;
                }
                callback(YES, data);
            });
            

        }];
        
        [dataTask resume];
    });
   
}

+ (void)postFormData:(NSString *)urlStr params:(NSDictionary *)dic callback:(RequestJsonCallback)callback
{
    NSDictionary *headers = @{@"Content-Type":@"application/json"};
    [self postFormData:urlStr params:dic headers:headers callback:callback];
}


+ (void)postFormData:(NSString *)urlStr params:(NSDictionary *)dic headers:(NSDictionary *)headers callback:(RequestJsonCallback)callback
{
    dispatch_queue_t globalQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(globalQueue, ^{
        NSURL *url = [NSURL URLWithString:urlStr];
        NSURLSession *session = [NSURLSession sharedSession];
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
        request.HTTPMethod = @"POST";
        NSError *requestError;
//        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:0 error:&requestError];

        NSString *boundary = @"----BoundaryString"; // 通常是一个随机字符串
        NSMutableString *body = [NSMutableString string];

        for (NSString *key in dic.allKeys) {
            [body appendFormat:@"%@\r\n", boundary];
//            [body appendString:@"--\(boundary)\r\n"];
            [body appendFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n", key];
            [body appendFormat:@"%@\r\n", dic[key]];
        }
        
        

        // 结束边界
        [body appendString:[NSString stringWithFormat:@"--%@--\r\n", boundary]];

        // 将字符串转换为NSData
        NSData *bodyData = [body dataUsingEncoding:NSUTF8StringEncoding];
        
        
        
        
        if (!bodyData) {
            NSLog(@"Error: %@", requestError);
        } else {
            // 6. 设置HTTP请求的body
            request.HTTPBody = bodyData;
        }
        
        if (headers) {
            
            for (NSString *key in headers.allKeys) {
                [request setValue:headers[key] forHTTPHeaderField:key];
            }
            
            [request setValue:@(bodyData.length).stringValue forHTTPHeaderField:@"Content-Length"];
            [request setValue:@"multipart/form-data; boundary=--BoundaryString" forHTTPHeaderField:@"Content-Type"];
            
        }
        
        NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            
            if (error) {
                NSLog(@"Error: %@", error.localizedDescription);
                dispatch_async(dispatch_get_main_queue(), ^{
                    callback(NO, nil);
                });
                
                return;
            }
            NSError *dataError;
            NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:0 error:&dataError];
            dispatch_async(dispatch_get_main_queue(), ^{
                if (dataError) {
                    callback(NO, nil);
                }else {
                    callback(YES, json);
                }
            });
            
            
        }];
        
        
        
        [dataTask resume];
    });
}




@end
