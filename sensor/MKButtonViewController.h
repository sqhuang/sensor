//
//  MKButtonViewController.h
//  vccaviator
//
//  Created by qiu on 04/07/2017.
//  Copyright © 2017 qiu. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MKButtonViewController;
@protocol MKButtonViewControllerDelegate <NSObject>

- (void)focusMapBtnActionInMKButtonVC:(MKButtonViewController *)MKBtnVC;
- (void)configBtnActionInMKButtonVC:(MKButtonViewController *)MKBtnVC;
- (void)generateBtnActionInMKButtonVC:(MKButtonViewController *)MKBtnVC;
- (void)saveToFileBtnActionInMKButtonVC:(MKButtonViewController *)MKBtnVC;
- (void)loadFromFileBtnActionInMKButtonVC:(MKButtonViewController *)MKBtnVC;
- (void)loadPathBtnActionInMKButtonVC:(MKButtonViewController *)MKBtnVC;
- (void)startBtnActionInMKButtonVC:(MKButtonViewController *)MKBtnVC;
- (void)stopBtnActionInMKButtonVC:(MKButtonViewController *)MKBtnVC;

@end

@interface MKButtonViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIButton *focusMapBtn;
@property (weak, nonatomic) IBOutlet UIButton *configBtn;
@property (weak, nonatomic) IBOutlet UIButton *generateBtn;
@property (weak, nonatomic) IBOutlet UIButton *saveToFileBtn;
@property (weak, nonatomic) IBOutlet UIButton *loadFromFileBtn;
@property (weak, nonatomic) IBOutlet UIButton *loadPathBtn;
@property (weak, nonatomic) IBOutlet UIButton *startBtn;
@property (weak, nonatomic) IBOutlet UIButton *stopBtn;

@property (weak, nonatomic) id <MKButtonViewControllerDelegate> delegate;
- (IBAction)focusMapBtnAction:(id)sender;
- (IBAction)backBtnAction:(id)sender;
- (IBAction)configBtnAction:(id)sender;
- (IBAction)generateBtnAction:(id)sender;
- (IBAction)saveToFileBtnAction:(id)sender;
- (IBAction)loadFromFileBtnAction:(id)sender;
- (IBAction)loadPathBtnAction:(id)sender;
- (IBAction)startBtnAction:(id)sender;
- (IBAction)stopBtnAction:(id)sender;
@end
