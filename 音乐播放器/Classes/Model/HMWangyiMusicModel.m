//
//  HMWangyiMusicModel.m
//  音乐播放器
//
//  Created by limingming on 2024/6/5.
//  Copyright © 2024 jinheng. All rights reserved.
//

#import "HMWangyiMusicModel.h"
#import <AVFoundation/AVFoundation.h>
#import "Header.h"

@interface HMWangyiMusicModel ()
@property (nonatomic, strong) NSDictionary *dic;
@end

@implementation HMWangyiMusicModel

- (instancetype)initWithDic:(NSDictionary *)dic
{
    self = [super init];
    if (self) {
        self.dic = dic;
        [self dealDic];
    }
    return self;
}

- (void)dealDic
{
    if (!self.dic) {
        NSLog(@"dic 为空");
        return;
    }
    self.author = [self getValueForKey:@"author"];
    self.lrc = [self getValueForKey:@"lrc"];
    self.pic = [self getValueForKey:@"pic"];
    self.title = [self getValueForKey:@"title"];
    self.url = [self getValueForKey:@"url"];
    self.songid = [self getValueForKey:@"songid"];
    self.groups = [self getValueForKey:@"groups"];
    self.isvalid = self.url.length > 0;
    
    
    
}

- (NSString *)getValueForKey:(NSString *)key
{
    if ([self.dic.allKeys containsObject:key]) {
        return self.dic[key];
    }else {
        return @"";
    }
}

- (NSDictionary *)toDic
{
    NSMutableDictionary *dic = [self.dic mutableCopy];
    if (self.groups && [self.groups isEqualToString:@"全部"]) {
        dic[@"groups"] = [NSString stringWithFormat:@",%@,", self.groups];
    }
    
    

    
    return dic;
}

- (void)setFileName:(NSString *)fileName
{
    _fileName = fileName;
    
    self.ts = [fileName componentsSeparatedByString:@"-"][0].doubleValue;
    
    NSURL *url = [NSURL fileURLWithPath:LOCAL_MUSIC_FILE(_fileName)];
    
    
    // 创建播放器(一个AVAudioPlayer只能播放一个URL)
    AVAudioPlayer *player = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
    self.isvalid = player != nil;
    
    
    
}




@end
