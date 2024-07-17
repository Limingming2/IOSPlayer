//
//  HMManagerMusic.h
//  音乐播放器
//
//  Created by limingming on 2024/6/4.
//  Copyright © 2024 jinheng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HMWangyiMusicModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface HMManagerMusic : NSObject
+ (instancetype)getinstange;
- (void)saveWangyiMusic:(HMWangyiMusicModel *)model data:(NSData *)data;
- (NSDictionary *)getLocalDic;
- (void)update:(NSString *)key value:(NSDictionary *)value;
- (NSArray *)allGroups;


@property (nonatomic, strong) NSString *selectedGroup;
@end

NS_ASSUME_NONNULL_END
