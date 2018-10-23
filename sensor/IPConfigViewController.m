//
//  IPConfigViewController.m
//  sensor
//
//  Created by qiu on 2018/10/23.
//  Copyright © 2018 qiu. All rights reserved.
//

#import "IPConfigViewController.h"

@interface IPConfigViewController ()

@end

@implementation IPConfigViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self initUI];
}

- (void)initUI
{
    //self.altitudeTextField.text = @"100"; //Set the altitude to 100
    self.ipTextField.text = @"192.168."; //Set the autoFlightSpeed to 8
    self.portTextField.text = @"7979"; //Set the maxFlightSpeed to 10

    
}

- (IBAction)cancelBtnAction:(id)sender {
    
    if ([_delegate respondsToSelector:@selector(cancelBtnActionInIPConfigViewController:)]) {
        [_delegate cancelBtnActionInIPConfigViewController:self];
    }
}

- (IBAction)finishBtnAction:(id)sender {
    
    if ([_delegate respondsToSelector:@selector(finishBtnActionInIPConfigViewController:)]) {
        [_delegate finishBtnActionInIPConfigViewController:self];
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
