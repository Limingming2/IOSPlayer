//
//  HMGroupManagerScene.m
//  音乐播放器
//
//  Created by limingming on 2024/6/14.
//  Copyright © 2024 jinheng. All rights reserved.
//

#import "HMGroupManagerScene.h"
#import "HMGroupDetailScene.h"

@interface HMGroupManagerScene ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, weak) IBOutlet UITableView *tableview;
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, weak) IBOutlet UITextField *groupTF;
@property (nonatomic, strong) NSString *path;
@property (nonatomic, strong) NSString *selectedGroupName;
@end

@implementation HMGroupManagerScene

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    NSFileManager *manager = [NSFileManager defaultManager];
    
    if (![manager fileExistsAtPath:self.path]) {
        [manager createFileAtPath:self.path contents:nil attributes:nil];
        [@[] writeToFile:self.path atomically:YES];
    }
    
    self.dataSource = [NSMutableArray arrayWithContentsOfFile:self.path];
    if (!self.dataSource) {
        self.dataSource = [NSMutableArray array];
    }
    
    [self.tableview reloadData];
    
}

- (NSString *)path
{
    if (!_path) {
        _path = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject] stringByAppendingPathComponent:@"group.plist"];
    }
    return _path;
}


- (IBAction)addGroup:(id)sender
{
    if (self.groupTF.text.length == 0) {
        return;
    }
    
    for (NSString *groupName in self.dataSource) {
        if ([groupName isEqualToString:self.groupTF.text]) {
            return;
        }
    }
    [self.dataSource addObject:self.groupTF.text];
    [self updateDatasource];
}

- (void)updateDatasource
{
    [self.dataSource writeToFile:self.path atomically:YES];
    [self.tableview reloadData];
}

#pragma mark - UITableViewDelegate, UITableViewDataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"groupmanagercell" forIndexPath:indexPath];
    cell.textLabel.text = self.dataSource[indexPath.row];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.dataSource count];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    self.selectedGroupName = self.dataSource[indexPath.row];
    // 去选择对应的歌曲
    [self performSegueWithIdentifier:@"groupmanager2groupdetails" sender:self];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self.dataSource removeObjectAtIndex:indexPath.row];
        // 删除表格视图中的行
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        [self updateDatasource];
    }
}




#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.destinationViewController isKindOfClass:[HMGroupDetailScene class]]) {
        HMGroupDetailScene *scene = segue.destinationViewController;
        scene.groupName = self.selectedGroupName;
    }
    
}


@end
