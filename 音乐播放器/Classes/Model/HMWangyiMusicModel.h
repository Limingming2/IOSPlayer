//
//  HMWangyiMusicModel.h
//  音乐播放器
//
//  Created by limingming on 2024/6/5.
//  Copyright © 2024 jinheng. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HMWangyiMusicModel : NSObject

@property (nonatomic, strong) NSString *author;
@property (nonatomic, strong) NSString *lrc;
@property (nonatomic, strong) NSString *pic;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *url;
@property (nonatomic, strong) NSString *songid;
@property (nonatomic, assign) BOOL isvalid;
@property (nonatomic, strong) NSString *fileName;
@property (nonatomic, assign) NSTimeInterval ts;
@property (nonatomic, assign) int isCached; // 0: 未下载 1：下载中 2：已下载
@property (nonatomic, strong) NSString *groups;
- (instancetype)initWithDic:(NSDictionary *)dic;

- (NSDictionary *)toDic;

@end

NS_ASSUME_NONNULL_END
