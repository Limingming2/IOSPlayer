//
//  HMDownloadTool.h
//  音乐播放器
//
//  Created by limingming on 2024/6/3.
//  Copyright © 2024 jinheng. All rights reserved.
//

#import <Foundation/Foundation.h>



typedef void(^RequestCallback)(BOOL, NSData *);
typedef void(^RequestJsonCallback)(BOOL, NSDictionary *);

@interface HMRequestTool : NSObject
+ (void)getData:(NSString *)urlStr callback:(RequestCallback)callback;
+ (void)postFormData:(NSString *)urlStr params:(NSDictionary *)dic callback:(RequestJsonCallback)callback;
+ (void)postFormData:(NSString *)urlStr params:(NSDictionary *)dic headers:(NSDictionary *)headers callback:(RequestJsonCallback)callback;
@end


