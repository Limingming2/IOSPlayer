//
//  HMMusicList.h
//  音乐播放器
//
//  Created by limingming on 2024/6/4.
//  Copyright © 2024 jinheng. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HMMusicList : NSObject

+ (instancetype)getInstance;

@property (nonatomic, strong) NSArray *lists;
@property (nonatomic, strong) NSMutableArray *musics;

- (void)updateMusicList:(NSString *)group;
@end

NS_ASSUME_NONNULL_END
