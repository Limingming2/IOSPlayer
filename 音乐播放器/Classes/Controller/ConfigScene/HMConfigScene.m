//
//  HMConfigScene.m
//  音乐播放器
//
//  Created by limingming on 2024/6/3.
//  Copyright © 2024 jinheng. All rights reserved.
//

#import "HMConfigScene.h"
#import "HMRequestTool.h"
#import "HMWangyiScene.h"

NSString static * const kConfig2WangyiSceneKey = @"config2wangyiscene";

@interface HMConfigScene ()
@property (nonatomic, weak) IBOutlet UITextField *urlTF;
@end

@implementation HMConfigScene

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (IBAction)download:(id)sender
{    
    [self performSegueWithIdentifier:kConfig2WangyiSceneKey sender:self];
    [self.urlTF resignFirstResponder];
    
}



- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:kConfig2WangyiSceneKey]) {
        HMWangyiScene *scene = segue.destinationViewController;
        scene.musicName = self.urlTF.text;
    }
}





@end
