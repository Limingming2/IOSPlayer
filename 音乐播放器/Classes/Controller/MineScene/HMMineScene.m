//
//  HMMineScene.m
//  音乐播放器
//
//  Created by limingming on 2024/6/14.
//  Copyright © 2024 jinheng. All rights reserved.
//

#import "HMMineScene.h"

@interface HMMineScene ()

@end

@implementation HMMineScene

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (IBAction)clickGroupBtn:(id)sender
{
    [self performSegueWithIdentifier:@"main2group" sender:self];
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
