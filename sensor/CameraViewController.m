//
//  CameraViewController.m
//  CustomeCamera
//
//  Created by ios2chen on 2017/7/20.
//  Copyright © 2017年 ios2chen. All rights reserved.
//

#import "CameraViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>

@interface CameraViewController ()<AVCaptureFileOutputRecordingDelegate>

/*
 *  AVCaptureSession:它从物理设备得到数据流（比如摄像头和麦克风），输出到一个或
 *  多个目的地，它可以通过
 *  会话预设值(session preset)，来控制捕捉数据的格式和质量
 */
@property (nonatomic, strong) AVCaptureSession *iSession;
//设备
@property (nonatomic, strong) AVCaptureDevice *iDevice;
 //输入
@property (nonatomic, strong) AVCaptureDeviceInput *iInput;

//视频输出
@property (nonatomic, strong) AVCaptureMovieFileOutput *iMovieOutput;
//预览层
@property (nonatomic, strong) AVCaptureVideoPreviewLayer *iPreviewLayer;


@property (nonatomic, assign) CGFloat HFOV;
@property (nonatomic, assign) CGFloat VFOV;
@property (nonatomic, assign) CGFloat cx;
@property (nonatomic, assign) CGFloat cy;
@property (nonatomic, assign) CGFloat fx;
@property (nonatomic, assign) CGFloat fy;




@end

@implementation CameraViewController



-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (self.iSession) {
        [self.iSession startRunning];
    }
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    if (self.iSession) {
        [self.iSession stopRunning];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //UI

    
    
    self.iSession = [[AVCaptureSession alloc]init];
    self.iSession.sessionPreset = AVCaptureSessionPresetHigh;
    
    NSArray *deviceArray = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    for (AVCaptureDevice *device in deviceArray) {
        if (device.position == AVCaptureDevicePositionBack) {
            self.iDevice = device;
        }
    }
    
    //添加摄像头设备
    //对设备进行设置时需上锁，设置完再打开锁
    [self.iDevice lockForConfiguration:nil];
    if ([self.iDevice isFlashModeSupported:AVCaptureFlashModeAuto]) {
        [self.iDevice setFlashMode:AVCaptureFlashModeAuto];
    }
    if ([self.iDevice isFocusModeSupported:AVCaptureFocusModeAutoFocus]) {
        [self.iDevice setFocusMode:AVCaptureFocusModeAutoFocus];
    }
    if ([self.iDevice isWhiteBalanceModeSupported:AVCaptureWhiteBalanceModeAutoWhiteBalance]) {
        [self.iDevice setWhiteBalanceMode:AVCaptureWhiteBalanceModeAutoWhiteBalance];
    }
    [self.iDevice unlockForConfiguration];
    
    //添加音频设备
    AVCaptureDevice *audioDevice = [[AVCaptureDevice devicesWithMediaType:AVMediaTypeAudio] firstObject];
    
    AVCaptureDeviceInput *audioInput = [AVCaptureDeviceInput deviceInputWithDevice:audioDevice error:nil];
    
    self.iInput = [[AVCaptureDeviceInput alloc]initWithDevice:self.iDevice error:nil];
    
    
    
    
    self.iMovieOutput = [[AVCaptureMovieFileOutput alloc]init];
    
    if ([self.iSession canAddInput:self.iInput]) {
        [self.iSession addInput:self.iInput];
    }

    if ([self.iSession canAddInput:audioInput]) {
        [self.iSession addInput:audioInput];
    }
    
    self.iPreviewLayer = [[AVCaptureVideoPreviewLayer alloc]initWithSession:self.iSession];
  [self.iPreviewLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
    //  [self.iPreviewLayer setVideoGravity:AVLayerVideoGravityResize];
    self.iPreviewLayer.frame = [UIScreen mainScreen].bounds;
    [self.view.layer insertSublayer:self.iPreviewLayer atIndex:0];
    
    //orientation
    AVCaptureConnection *previewLayerConnection=self.iPreviewLayer.connection;
    
    if ([previewLayerConnection isVideoOrientationSupported])
        [previewLayerConnection setVideoOrientation:[[UIApplication sharedApplication] statusBarOrientation]];
    
    
    [self.iSession startRunning];
    
    [self showIntrinsicMatrix];
    
}

// show intrinsic Matrix
- (void)showIntrinsicMatrix{
    AVCaptureDeviceFormat *format = self.iInput.device.activeFormat;
    CMFormatDescriptionRef fDesc = format.formatDescription;
    CGSize dim = CMVideoFormatDescriptionGetPresentationDimensions(fDesc, true, true);
    
    _cx = (float)(dim.width) / 2.0;
    _cy = (float)(dim.height) / 2.0;
    
    self.HFOV = format.videoFieldOfView;
    self.VFOV = ((self.HFOV)/_cx)*_cy;
    
    _fx = fabs((float)(dim.width) / (2 * tan(self.HFOV / 180 * (float)(M_PI) / 2)));
    _fy = fabs((float)(dim.height) / (2 * tan(self.VFOV  / 180 * (float)(M_PI) / 2)));
    
    NSLog(@"ipad mini 4 intrinsic Matrix\n");
    NSLog(@"cx:\t%f\ncy:\t%f\nfx:\t%f\nfy:\t%f\nHFOV:\t%f\nVFOV:\t%f\n", _cx,_cy,_fx,_fy,self.HFOV,self.VFOV );
}


#pragma mark - ButtonAction






    
- (void)videoStart{
    [self.iSession beginConfiguration];
        if ([self.iSession canAddOutput:self.iMovieOutput]) {
            [self.iSession addOutput:self.iMovieOutput];
        
        //设置视频防抖
        AVCaptureConnection *connection = [self.iMovieOutput connectionWithMediaType:AVMediaTypeVideo];
        if ([connection isVideoStabilizationSupported]) {
            connection.preferredVideoStabilizationMode = AVCaptureVideoStabilizationModeCinematic;
        }
        }
        [self.iSession commitConfiguration];
        NSURL *url = [NSURL fileURLWithPath:[NSTemporaryDirectory() stringByAppendingString:@"myMovie.mov"]];
        if (![self.iMovieOutput isRecording]) {
            [self.iMovieOutput startRecordingToOutputFileURL:url recordingDelegate:self];
        }
    
}
    
    
-(void)videoStop{

        if ([self.iMovieOutput isRecording]) {
            [self.iMovieOutput stopRecording];
        }
    
//        [self.iSession beginConfiguration];
//        [self.iSession commitConfiguration];
    }
    
    


-(void)captureOutput:(AVCaptureFileOutput *)captureOutput didFinishRecordingToOutputFileAtURL:(NSURL *)outputFileURL fromConnections:(NSArray *)connections error:(NSError *)error{
    
    //保存视频到相册
    ALAssetsLibrary *assetsLibrary=[[ALAssetsLibrary alloc]init];
    [assetsLibrary writeVideoAtPathToSavedPhotosAlbum:outputFileURL completionBlock:nil];
    [[CustomeAlertView shareView] showCustomeAlertViewWithMessage:@"视频保存成功"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - zoom 1 - 3
- (void)cameraViewDidChangeZoom:(CGFloat)zoom {
    AVCaptureDevice *captureDevice = [self.iInput device];
    NSError *error;
    if ([captureDevice lockForConfiguration:&error]) {
        [captureDevice rampToVideoZoomFactor:zoom withRate:50];
        [self showIntrinsicMatrix];
    }else{
        // Handle the error appropriately.
        NSLog(@"zoom error\n");
    }
}

- (CGFloat) getHFOV{
    return self.HFOV;
}

- (CGFloat) getVFOV{
    return self.VFOV;
}

@end
