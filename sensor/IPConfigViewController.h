//
//  IPConfigViewController.h
//  sensor
//
//  Created by qiu on 2018/10/23.
//  Copyright © 2018 qiu. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class IPConfigViewController;

@protocol IPConfigViewControllerDelegate <NSObject>

- (void)cancelBtnActionInIPConfigViewController:(IPConfigViewController *)ipConfigVC;
- (void)finishBtnActionInIPConfigViewController:(IPConfigViewController *)ipConfigVC;

@end

@interface IPConfigViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *ipTextField;
@property (weak, nonatomic) IBOutlet UITextField *portTextField;

@property (weak, nonatomic) id <IPConfigViewControllerDelegate>delegate;

- (IBAction)cancelBtnAction:(id)sender;
- (IBAction)finishBtnAction:(id)sender;

@end

NS_ASSUME_NONNULL_END
