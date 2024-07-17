//
//  HMMusicList.m
//  音乐播放器
//
//  Created by limingming on 2024/6/4.
//  Copyright © 2024 jinheng. All rights reserved.
//

#import "HMMusicList.h"
#import "Header.h"
#import "HMManagerMusic.h"

@interface HMMusicList ()
@property (nonatomic, strong) NSFileManager *filemanager;
@end

static HMMusicList *_instance;

@implementation HMMusicList

+ (instancetype)getInstance;
{
    if (!_instance) {
        _instance = [[self alloc] init];
    }
    return _instance;
}


- (instancetype)init
{
    self = [super init];
    if (self) {
        self.filemanager = [NSFileManager defaultManager];
//        [self updateMusicList];
    }
    return self;
}


- (void)updateMusicList:(NSString *)group
{
    if ([group isEqualToString:@"全部"]) {
        group = @"";
    }
    NSString *musicDir = LOCAL_MUSIC_DIR;
    BOOL isDir;
    
    [self.filemanager fileExistsAtPath:musicDir isDirectory:&isDir];
    if (!isDir) {
        [self.filemanager createDirectoryAtPath:musicDir withIntermediateDirectories:YES attributes:nil error:nil];
    }

    NSArray *files = [self.filemanager contentsOfDirectoryAtPath:musicDir error:nil];
    
    if (!self.musics) {
        self.musics = [NSMutableArray array];
    }
    NSDictionary *dic = [[HMManagerMusic getinstange] getLocalDic];
    NSArray *keys = dic.allKeys;
    for (NSString *fileStr in files) {
        NSLog(@"file: %@", fileStr);
        if ([fileStr hasSuffix:@"mp3"]) {
            HMWangyiMusicModel *model;
            if ([keys containsObject:fileStr]) {
                NSDictionary *tmpDic = dic[fileStr];
                model = [[HMWangyiMusicModel alloc] initWithDic:tmpDic];
            }else {
                model = [[HMWangyiMusicModel alloc] init];
            }
            
            
            BOOL isNew = YES;
            for (HMWangyiMusicModel *savedModel in self.musics) {
                if ([savedModel.fileName isEqualToString:fileStr]) {
                    isNew = NO;
                    break;
                }
            }
            if (!isNew) {
                continue;
            }
            model.fileName = fileStr;
            
            if (!model.isvalid) {
                continue;
            }
            if (![model.groups containsString:group] && group.length > 0) {
                continue;
            }
            if (self.musics.count == 0) {
                [self.musics addObject:model];
                continue;
            }
            
            for (int i = 0; i < self.musics.count; i++) {
                HMWangyiMusicModel *tmpModel = self.musics[i];
                NSData *jsonData = [NSJSONSerialization dataWithJSONObject:tmpModel.toDic options:NSJSONWritingPrettyPrinted error:nil];
                NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
                NSLog(@"JSON 字符串: %@", jsonString);
//                NSLog(@"%@", tmpModel.groups);
                
            // todo: 根据喜好顺序或倒序
                if (tmpModel.ts > model.ts) {
                    [self.musics insertObject:model atIndex:i];
                    break;
                }
                if (i == self.musics.count - 1) {
                    [self.musics addObject:model];
                    break;
                }
            }
            
            
        }
    }
//    self.musics = musics;
//    self.lists = lists;
}





@end
