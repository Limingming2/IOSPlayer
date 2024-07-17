//
//  HMWangyiMusicCell.m
//  音乐播放器
//
//  Created by limingming on 2024/6/5.
//  Copyright © 2024 jinheng. All rights reserved.
//

#import "HMWangyiMusicCell.h"
#import "UIImageView+XM.h"
#import "HMManagerMusic.h"
#import "HMRequestTool.h"

@interface HMWangyiMusicCell ()
@property (nonatomic, weak) IBOutlet UILabel *nameLabel;
@property (nonatomic, weak) IBOutlet UIImageView *picImgView;
@property (nonatomic, weak) IBOutlet UIButton *tryButton;
@property (nonatomic, weak) IBOutlet UIButton *cacheButton;
@property (nonatomic, weak) IBOutlet UILabel *authorLabel;
@property (nonatomic, strong) HMWangyiMusicModel *info;
@end

@implementation HMWangyiMusicCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    
}

- (void)loadInfo:(HMWangyiMusicModel *)model
{
    self.info = model;
    self.nameLabel.text = model.title;
    [self.picImgView imageWithUrl:model.pic];
    NSString *cacheTitle = model.isCached == 0 ? @"下载" : (model.isCached  == 1 ? @"下载中" : @"已下载");
    [self.cacheButton setEnabled:model.isCached == 0];
    [self.cacheButton setTitle:cacheTitle forState:UIControlStateNormal];
    self.authorLabel.text = model.author;
}

- (IBAction)tryMusicClick:(id)sender
{
    
}

- (IBAction)cacheClick:(id)sender
{
    self.info.isCached = 1;
    [self loadInfo:self.info];
    
    self.info.groups = [HMManagerMusic getinstange].selectedGroup;
    [HMRequestTool getData:self.info.url callback:^(BOOL result, NSData *data) {
        if (result) {
            [[HMManagerMusic getinstange] saveWangyiMusic:self.info data:data];
            self.info.isCached = 2;
            [self loadInfo:self.info];
        }
    }];
    
}


@end
