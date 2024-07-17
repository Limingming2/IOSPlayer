//
//  HMWangyiMusicCell.h
//  音乐播放器
//
//  Created by limingming on 2024/6/5.
//  Copyright © 2024 jinheng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HMWangyiMusicModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface HMWangyiMusicCell : UITableViewCell
- (void)loadInfo:(HMWangyiMusicModel *)model;
@end

NS_ASSUME_NONNULL_END
