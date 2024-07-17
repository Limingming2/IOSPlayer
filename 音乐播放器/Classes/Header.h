//
//  Header.h
//  音乐播放器
//
//  Created by limingming on 2024/6/4.
//  Copyright © 2024 jinheng. All rights reserved.
//

#ifndef Header_h
#define Header_h

#define LOCAL_MUSIC_DIR [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject] stringByAppendingPathComponent:@"music"]
#define LOCAL_MUSIC_FILE(FILE_NAME) [LOCAL_MUSIC_DIR stringByAppendingFormat:@"/%@",FILE_NAME]

#define LOCAL_IMAGE_DIR [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject] stringByAppendingPathComponent:@"pic"]




#endif /* Header_h */
