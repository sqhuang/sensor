//
//  MKButtonViewController.m
//  vccaviator
//
//  Created by qiu on 04/07/2017.
//  Copyright © 2017 qiu. All rights reserved.
//

#import "MKButtonViewController.h"

@interface MKButtonViewController ()

@end

@implementation MKButtonViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Property Method
- (IBAction)focusMapBtnAction:(id)sender{
    if ([_delegate respondsToSelector:@selector(focusMapBtnActionInMKButtonVC:)]) {
        [_delegate focusMapBtnActionInMKButtonVC:self];
    }
}
- (IBAction)configBtnAction:(id)sender{
    if ([_delegate respondsToSelector:@selector(configBtnActionInMKButtonVC:)]) {
        [_delegate configBtnActionInMKButtonVC:self];
    }
}

- (IBAction)generateBtnAction:(id)sender{
    if ([_delegate respondsToSelector:@selector(generateBtnActionInMKButtonVC:)]) {
        [_delegate generateBtnActionInMKButtonVC:self];
    }
}

- (IBAction)saveToFileBtnAction:(id)sender{
    if ([_delegate respondsToSelector:@selector(saveToFileBtnActionInMKButtonVC:)]) {
        [_delegate saveToFileBtnActionInMKButtonVC:self];
    }
}

- (IBAction)loadFromFileBtnAction:(id)sender{
    if ([_delegate respondsToSelector:@selector(loadFromFileBtnAction:)]) {
        [_delegate loadFromFileBtnActionInMKButtonVC:self];
    }
}

- (IBAction)loadPathBtnAction:(id)sender{
    if ([_delegate respondsToSelector:@selector(loadPathBtnActionInMKButtonVC:)]) {
        [_delegate loadPathBtnActionInMKButtonVC:self];
    }
}

- (IBAction)startBtnAction:(id)sender{
    if ([_delegate respondsToSelector:@selector(startBtnActionInMKButtonVC:)]) {
        [_delegate startBtnActionInMKButtonVC:self];
    }
}
- (IBAction)stopBtnAction:(id)sender{
    if ([_delegate respondsToSelector:@selector(stopBtnActionInMKButtonVC:)]) {
        [_delegate stopBtnActionInMKButtonVC:self];
    }
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
