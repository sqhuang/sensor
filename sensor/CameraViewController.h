//
//  CameraViewController.h
//  CustomeCamera
//
//  Created by ios2chen on 2017/7/20.
//  Copyright © 2017年 ios2chen. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import <AVFoundation/AVFoundation.h>
//@protocol CameraViewControllerDelegate <NSObject>
//
//- (void)cameraViewDidChangeZoom:(CGFloat)zoom;
//
//@end


@interface CameraViewController : UIViewController

- (void)videoStart;
- (void)videoStop;

//@property (weak, nonatomic) id <CameraViewControllerDelegate>delegate;
- (void)cameraViewDidChangeZoom:(CGFloat)zoom;
- (void)cameraViewDidChangeFocus:(CGFloat)focus;
- (CGFloat) getHFOV;
- (CGFloat) getVFOV;


@end
