//
//  JHMusicsViewController.m
//  黑马音乐
//
//  Created by piglikeyoung on 15/5/24.
//  Copyright (c) 2015年 jinheng. All rights reserved.
//

#import "HMMusicsViewController.h"
#import "MJExtension.h"
#import "UIImage+NJ.h"
#import "Colours.h"
#import "HMPlayingViewController.h"
#import "HMMusicsTool.h"
#import "HMMusicCell.h"
#import "HMMusicList.h"
#import "HMWangyiMusicModel.h"
#import "Header.h"
#import "HMManagerMusic.h"

#import <AVFoundation/AVFoundation.h>

@interface HMMusicsViewController ()
// 播放界面
@property (nonatomic, strong) HMPlayingViewController *playingVc;
@property (nonatomic, strong) HMMusicList *musicList;
@property (nonatomic, strong) NSString *selectedGroup;
@property (nonatomic, weak) IBOutlet UIButton *groupBtn;
@end

@implementation HMMusicsViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self reloadData];
    
    
}



- (void)viewDidLoad
{
    [super viewDidLoad];
    self.selectedGroup = [[NSUserDefaults standardUserDefaults] objectForKey:@"selectedGroup"];
    if (self.selectedGroup.length > 0) {
        [self.groupBtn setTitle:self.selectedGroup forState:UIControlStateNormal];
    }else {
        self.selectedGroup = @"全部";
    }
    
}

- (void)reloadData
{
    [self.musicList updateMusicList:self.selectedGroup];
    [self.tableView reloadData];
}

- (void)setSelectedGroup:(NSString *)selectedGroup
{
    _selectedGroup = selectedGroup;
    
    
    
}

- (IBAction)chooseGroup:(id)sender
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"选择分组" message:@"" preferredStyle:UIAlertControllerStyleActionSheet];
    NSMutableArray *arr = [[[HMManagerMusic getinstange] allGroups] mutableCopy];
    [arr addObject:@"全部"];
    for (NSString *group in arr) {
        [alert addAction:[UIAlertAction actionWithTitle:group style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self.groupBtn setTitle:group forState:UIControlStateNormal];
            self.selectedGroup = group;
            [[NSUserDefaults standardUserDefaults] setObject:self.selectedGroup forKey:@"selectedGroup"];
            [self reloadData];
        }]];
    }
    [self presentViewController:alert animated:YES completion:nil];
    
}

#pragma mark - 懒加载
- (HMPlayingViewController *)playingVc
{
    if (!_playingVc) {
        self.playingVc = [[HMPlayingViewController alloc] init];
    }
    return _playingVc;
}

- (HMMusicList *)musicList
{
    if (!_musicList) {
        _musicList = [HMMusicList getInstance];
    }
    return _musicList;
}



#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.musicList.musics.count;
//    return [[HMMusicsTool musics] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    // 1.创建cell
    HMMusicCell *cell = [HMMusicCell cellWithTableView:tableView];
    cell.music = self.musicList.musics[indexPath.row];
//    cell.music = [HMMusicsTool musics][indexPath.row];
    // 2.返回cell
    return cell;
    
}
// 选中某一个行
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 1.主动取消选中
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    // 2.执行segue跳转到播放界面，使用modal的方式打开，关闭控制器会销毁，无法继续播放音乐
    //    [self performSegueWithIdentifier:@"musics2playing" sender:nil];
    
    HMWangyiMusicModel *music = self.musicList.musics[indexPath.row];
    
    
    // 3.设置当前播放的音乐
//    HMMusic *music = [HMMusicsTool musics][indexPath.row];
    [HMMusicsTool setPlayingMusic:music];
    
    // 自定义控制器，像modal的方式弹出控制器
    [self.playingVc show];
//    [self presentViewController:self.playingVc animated:YES completion:^{
//        [self.playingVc show];
//    }];
    
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        HMWangyiMusicModel *music = self.musicList.musics[indexPath.row];
        NSString *file = LOCAL_MUSIC_FILE(music.fileName);
        [[NSFileManager defaultManager] removeItemAtPath:file error:nil];
            // 删除数据源中的数据
        [self.musicList.musics removeObjectAtIndex:indexPath.row];
//            [self.data removeObjectAtIndex:indexPath.row];
            
            // 删除表格视图中的行
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        }
}

@end
