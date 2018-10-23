//
//  SandboxViewController.m
//  sensor
//
//  Created by qiu on 2018/10/23.
//  Copyright © 2018 qiu. All rights reserved.
//

#import "SandboxViewController.h"

@interface SandboxViewController ()

@end

@implementation SandboxViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


- (IBAction)doneBtnAction:(id)sender{
    NSLog(@"done action");
    if ([_delegate respondsToSelector:@selector(doneBtnActionInSandboxViewController:)]) {
        [_delegate doneBtnActionInSandboxViewController:self];
    }
}
@end
