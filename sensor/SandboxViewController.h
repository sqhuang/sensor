//
//  SandboxViewController.h
//  sensor
//
//  Created by qiu on 2018/10/23.
//  Copyright © 2018 qiu. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class SandboxViewController;

@protocol SandboxViewControllerDelegate <NSObject>

- (void)doneBtnActionInSandboxViewController:(SandboxViewController *)sbConfigVC;


@end

@interface SandboxViewController : UIViewController

@property (weak, nonatomic) id <SandboxViewControllerDelegate>delegate;

- (IBAction)doneBtnAction:(id)sender;

@end

NS_ASSUME_NONNULL_END
