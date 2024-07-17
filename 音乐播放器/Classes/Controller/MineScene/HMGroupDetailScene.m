//
//  HMGroupDetailScene.m
//  音乐播放器
//
//  Created by limingming on 2024/6/15.
//  Copyright © 2024 jinheng. All rights reserved.
//

#import "HMGroupDetailScene.h"
#import "HMManagerMusic.h"
#import "HMWangyiMusicModel.h"

@interface HMGroupDetailScene ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, weak) IBOutlet UITableView *tableview;
@property (nonatomic, strong) NSMutableDictionary *datasource;
@property (nonatomic, strong) NSArray *keys;
@end

@implementation HMGroupDetailScene

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableview.allowsMultipleSelection = YES;
    // Do any additional setup after loading the view.
    self.datasource = [[[HMManagerMusic getinstange] getLocalDic] mutableCopy];
    self.keys = [self.datasource allKeys];
}

#pragma mark - UITableViewDelegate, UITableViewDataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"groupdetailcell"];
    HMWangyiMusicModel *model = [[HMWangyiMusicModel alloc] initWithDic:self.datasource[self.keys[indexPath.row]]];
    cell.textLabel.text = model.title;
    NSString *str = [NSString stringWithFormat:@",%@,", self.groupName];
    if ([model.groups containsString:str]) {
        [tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
    }else {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
    
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.keys.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSLog(@"selected, %zd", indexPath.row);
    NSMutableDictionary *dic = [self.datasource[self.keys[indexPath.row]] mutableCopy];
    NSString *groups = dic[@"groups"] ? dic[@"groups"] : @"";
    dic[@"groups"] = [groups stringByAppendingFormat:@",%@,", self.groupName];
    self.datasource[self.keys[indexPath.row]] = dic;
    [[HMManagerMusic getinstange] update:self.keys[indexPath.row] value:dic];
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"deselected, %zd", indexPath.row);
    NSMutableDictionary *dic = [self.datasource[self.keys[indexPath.row]] mutableCopy];
    NSString *str = [NSString stringWithFormat:@",%@,", self.groupName];
    dic[@"groups"] = [dic[@"groups"] stringByReplacingOccurrencesOfString:str withString:@""];
    self.datasource[self.keys[indexPath.row]] = dic;
    [[HMManagerMusic getinstange] update:self.keys[indexPath.row] value:dic];
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
