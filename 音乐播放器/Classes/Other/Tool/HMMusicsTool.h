//
//  HMMusicsTool.h
//  03-黑马音乐
//
//  Created by apple on 14/11/7.
//  Copyright (c) 2014年 heima. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HMMusicsTool : NSObject
// 获取所有音乐
+ (NSArray *)musics;

// 设置当前正在播放的音乐
+ (void)setPlayingMusic:(id)music;

// 返回当前正在播放的音乐
+ (id)returnPlayingMusic;

// 获取下一首
+ (id)nextMusic;

// 获取上一首
+ (id)previouesMusic;

@end
