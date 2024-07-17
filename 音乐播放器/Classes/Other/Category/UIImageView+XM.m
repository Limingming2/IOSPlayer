//
//  UIImageView+XM.m
//  音乐播放器
//
//  Created by limingming on 2024/6/6.
//  Copyright © 2024 jinheng. All rights reserved.
//

#import "UIImageView+XM.h"
#import "HMRequestTool.h"
#import "Header.h"


@implementation UIImageView (XM)

- (void)imageWithUrl:(NSString *)url
{
    NSFileManager *filemanager = [NSFileManager defaultManager];
    NSString *dir = LOCAL_IMAGE_DIR;
    BOOL isDir;
    [filemanager fileExistsAtPath:dir isDirectory:&isDir];
    if (!isDir) {
        [filemanager createDirectoryAtPath:dir withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    NSString *file = [dir stringByAppendingPathComponent:url];
    if ([filemanager fileExistsAtPath:file]) {
        self.image = [UIImage imageWithContentsOfFile:file];
        return;
    }
    
    [HMRequestTool getData:url callback:^(BOOL result, NSData *imgData) {
        if (result) {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                [filemanager createDirectoryAtPath:[file stringByDeletingLastPathComponent] withIntermediateDirectories:YES attributes:nil error:nil];
                BOOL saveResult = [imgData writeToFile:file atomically:YES];
                if (saveResult) {
                    NSLog(@"保存图片成功");
                }
            });
            
            
            self.image = [UIImage imageWithData:imgData];
        }
    }];
}

@end
