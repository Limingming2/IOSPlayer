//
//  HMWangyiScene.m
//  音乐播放器
//
//  Created by limingming on 2024/6/5.
//  Copyright © 2024 jinheng. All rights reserved.
//

#import "HMWangyiScene.h"
#import "HMRequestTool.h"
#import "HMWangyiMusicModel.h"
#import "HMWangyiMusicCell.h"
#import "HMManagerMusic.h"

#define wangyi_url @"https://www.myfreemp3.com.cn/"
#define SPECIAL_GROUP_NAME @"临时决定"
#define ALL_GROUP_NAME @"全部"

@interface HMWangyiScene ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, assign) int pageIndex;
@property (nonatomic, weak) IBOutlet UITableView *tableview;
@property (nonatomic, strong) NSMutableArray *datasource;
@property (nonatomic, assign) BOOL isRequesting;
@property (nonatomic, weak) IBOutlet UIButton *groupBtn;
@property (nonatomic, strong) NSString *selectedGroup;
@end

@implementation HMWangyiScene

- (void)viewDidLoad {
    [super viewDidLoad];
    self.pageIndex = 1;
    if (!self.musicName ||self.musicName.length == 0) {
        self.musicName = @"热门推荐";
    }
    NSLog(@"music %@", self.musicName);
    self.navigationItem.title = self.musicName;
    self.datasource = [NSMutableArray array];
    [self requestData];
    self.selectedGroup = ALL_GROUP_NAME;
    
}

- (void)requestData
{
    
    if (self.isRequesting) {
        return;
    }
    NSDictionary *params = @{@"input":self.musicName,
                             @"filter":@"name",
                             @"page":@(self.pageIndex),
                             @"type":@"netease"
    };
    NSDictionary *headers = @{@"X-Requested-With":@"XMLHttpRequest",
                              @"Host":@"www.myfreemp3.com.cn"
    };
    self.isRequesting = YES;
    [HMRequestTool postFormData:wangyi_url params:params headers:headers callback:^(BOOL result, NSDictionary *dic) {

        if (!dic || ![dic.allKeys containsObject:@"code"] || [dic[@"code"] intValue] != 200 || ![dic.allKeys containsObject:@"data"]) {
            NSLog(@"获取失败");
        }else {
            NSDictionary *dataDic = dic[@"data"];
            NSArray *list = [self dicListToModelList:dataDic[@"list"]];
            [self.datasource addObjectsFromArray:list];
            [self.tableview reloadData];
            self.pageIndex++;
            
        }
        self.isRequesting = NO;
        NSLog(@"%@", dic);
    }];
}


- (NSArray *)dicListToModelList:(NSArray *)list
{
    NSMutableArray *resultArr = [NSMutableArray array];
    NSDictionary *totalDic = [[HMManagerMusic getinstange] getLocalDic];
    NSArray *names = totalDic.allKeys;
    for (NSDictionary *dic in list) {
        HMWangyiMusicModel *model = [[HMWangyiMusicModel alloc] initWithDic:dic];
        if (model.isvalid) {
            
            for (NSString *name in names) {
                if ([name containsString:model.title]) {
                    
                    HMWangyiMusicModel *tmpModel = [[HMWangyiMusicModel alloc] initWithDic:totalDic[name]];
                    if ([tmpModel.songid isEqual:model.songid]) {
                        model.isCached = 2;
                        break;
                    }
                }
            }
            
            [resultArr addObject:model];
        }
    }
    return resultArr;
    
}

- (IBAction)chooseGroup:(id)sender
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"选择分组" message:@"" preferredStyle:UIAlertControllerStyleActionSheet];
    NSMutableArray *arr = [[[HMManagerMusic getinstange] allGroups] mutableCopy];
    [arr addObject:ALL_GROUP_NAME];
    for (NSString *group in arr) {
        [alert addAction:[UIAlertAction actionWithTitle:group style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self.groupBtn setTitle:group forState:UIControlStateNormal];
            [HMManagerMusic getinstange].selectedGroup = group;
            
        }]];
    }
    [self presentViewController:alert animated:YES completion:nil];
    
}

#pragma mark - datasource


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.datasource.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HMWangyiMusicCell *cell = [self.tableview dequeueReusableCellWithIdentifier:@"wangyilistcell"];
    
    [cell loadInfo:self.datasource[indexPath.row]];
    
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.tableview deselectRowAtIndexPath:indexPath animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;;
}


- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == self.datasource.count - 2) {
        [self requestData];
    }
}


@end
