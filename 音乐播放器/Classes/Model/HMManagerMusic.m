//
//  HMManagerMusic.m
//  音乐播放器
//
//  Created by limingming on 2024/6/4.
//  Copyright © 2024 jinheng. All rights reserved.
//

#import "HMManagerMusic.h"
#import "Header.h"
#import "HMWangyiMusicModel.h"

static HMManagerMusic *_instance;

@interface HMManagerMusic ()
@property (nonatomic, strong) dispatch_queue_t serialQueue;
@property (nonatomic, strong) NSString *groupPath;
@end

@implementation HMManagerMusic


+ (instancetype)getinstange
{
    if (!_instance) {
        _instance = [[HMManagerMusic alloc] init];
        _instance.serialQueue = dispatch_queue_create("save-serial", DISPATCH_QUEUE_SERIAL);
    }
    return _instance;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (void)saveMusic:(NSString *)name data:(NSData *)data
{
    NSTimeInterval ts = [[NSDate date] timeIntervalSince1970];
    NSString *fileName = [NSString stringWithFormat:@"%.0f-%@.mp3", ts, name];
    NSString *dir = LOCAL_MUSIC_DIR;
    fileName = [dir stringByAppendingPathComponent:fileName];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        BOOL result = [data writeToFile:fileName atomically:YES];
        NSLog(@"写入本地：%d", result);
    });
}

- (void)saveWangyiMusic:(HMWangyiMusicModel *)model data:(NSData *)data
{
    NSTimeInterval ts = [[NSDate date] timeIntervalSince1970];
    NSString *fileName = [NSString stringWithFormat:@"%.0f-%@.mp3", ts, model.title];
    NSString *dir = LOCAL_MUSIC_DIR;
    
    BOOL isDir;
    [[NSFileManager defaultManager] fileExistsAtPath:dir isDirectory:&isDir];
    if (!isDir) {
        [[NSFileManager defaultManager] createDirectoryAtPath:dir withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    
    
    NSString *filePath = [dir stringByAppendingPathComponent:fileName];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        BOOL result = [data writeToFile:filePath atomically:YES];
        NSLog(@"写入本地：%d", result);
    });
    
    // 保存本地对应表
    [self saveMusicDetails:fileName details:model];
}

- (void)saveMusicDetails:(NSString *)localName details:(id)obj
{
    NSFileManager *manager = [NSFileManager defaultManager];
    NSString *dir = LOCAL_MUSIC_DIR;
    NSString *fileName = [dir stringByAppendingPathComponent:@"details.plist"];
    
    if (![manager fileExistsAtPath:fileName]) {
         [manager createFileAtPath:fileName contents:nil attributes:nil];
        [@{} writeToFile:fileName atomically:YES];
    }
    
    if ([obj isKindOfClass:[HMWangyiMusicModel class]]) {
        HMWangyiMusicModel *model = obj;
        
        NSDictionary *dic = [model toDic];
        dispatch_async(self.serialQueue, ^{
            NSMutableDictionary *contents = [NSMutableDictionary dictionaryWithContentsOfFile:fileName];
            contents[localName] = dic;
            [contents writeToFile:fileName atomically:YES];
        });
        
    }
}

- (NSDictionary *)getLocalDic
{
    NSString *dir = LOCAL_MUSIC_DIR;
    NSString *fileName = [dir stringByAppendingPathComponent:@"details.plist"];
    NSDictionary *dic = [NSDictionary dictionaryWithContentsOfFile:fileName];
    return dic;
    
}

- (void)update:(NSString *)key value:(NSDictionary *)value
{
    NSMutableDictionary *dic = [[self getLocalDic] mutableCopy];
    dic[key] = value;
    NSString *dir = LOCAL_MUSIC_DIR;
    NSString *fileName = [dir stringByAppendingPathComponent:@"details.plist"];
    
    dispatch_async(self.serialQueue, ^{
        [dic writeToFile:fileName atomically:YES];
    });
}

- (NSArray *)allGroups
{
    if (![[NSFileManager defaultManager] fileExistsAtPath:self.groupPath]) {
        return @[];
    }
    return [NSArray arrayWithContentsOfFile:self.groupPath];
}

- (NSString *)groupPath
{
    if (!_groupPath) {
        _groupPath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject] stringByAppendingPathComponent:@"group.plist"];
    }
    return _groupPath;
}


@end
