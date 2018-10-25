//
//  ViewController.m
//  sensor
//
//  Created by qiu on 2018/10/17.
//  Copyright © 2018 qiu. All rights reserved.
//

#import "ViewController.h"

#define IS_IOS8 ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8)

@interface ViewController ()<IPConfigViewControllerDelegate, SandboxViewControllerDelegate, GCDAsyncSocketDelegate>
@property (strong, nonatomic) IBOutlet UILabel *lblYaw;
@property (strong, nonatomic) IBOutlet UILabel *lblPitch;
@property (strong, nonatomic) IBOutlet UILabel *lblRoll;

@property (strong, nonatomic) IBOutlet UILabel *lblAccelerometerX;
@property (strong, nonatomic) IBOutlet UILabel *lblAccelerometerY;
@property (strong, nonatomic) IBOutlet UILabel *lblAccelerometerZ;

@property (strong, nonatomic) IBOutlet UILabel *lblGravityX;
@property (strong, nonatomic) IBOutlet UILabel *lblGravityY;
@property (strong, nonatomic) IBOutlet UILabel *lblGravityZ;

@property (strong, nonatomic) IBOutlet UILabel *lblRotationRateX;
@property (strong, nonatomic) IBOutlet UILabel *lblRotationRateY;
@property (strong, nonatomic) IBOutlet UILabel *lblRotationRateZ;

@property (strong, nonatomic) IBOutlet UILabel *lblLongti;
@property (strong, nonatomic) IBOutlet UILabel *lblLati;
@property (strong, nonatomic) IBOutlet UILabel *lblHeight;

@property (strong, nonatomic) IBOutlet UILabel *lblcurTake;
@property (strong, nonatomic) IBOutlet UILabel *lblStatus;

@property (strong, nonatomic) IBOutlet UIButton *btnSend;
@property (strong, nonatomic) IBOutlet UISlider *zoomSilder;

//video
@property (strong, nonatomic)CameraViewController *cameraVC;

//log data

@property double logLongti;
@property double logLati;
@property double logHeight;
@property double logYaw;
@property double logPitch;
@property double logRoll;

//tcp
@property (nonatomic, assign)BOOL isSending;
@property (strong, nonatomic)NSTimer *timer;
@property (strong, nonatomic)GCDAsyncSocket * clientSocket;



//
//@property enum state{initmode, recordmode, debugmode } stateFlag;
// UI on the right side

- (IBAction)startSwitchHandler:(id)sender;
- (IBAction)recordSwitchHandler:(id)sender;
- (IBAction)debugSwitchHandler:(id)sender;
- (IBAction)newTakeAction:(id)sender;
- (IBAction)IPConfigAction:(id)sender;
- (IBAction)sendAction:(id)sender;
- (IBAction)sandboxAction:(id)sender;
- (IBAction)zoomSliderChanged:(id)sender;


@property (nonatomic, strong) IPConfigViewController *ipConfigVC;
@property (nonatomic, strong) SandboxViewController *sbVC;

@property (strong, nonatomic) CMMotionManager *motionManager;
@property (nonatomic, strong) CLLocationManager *locationManager;


//
@property (strong, nonatomic) NSString *recordLogName;
@property (strong, nonatomic) NSMutableArray< NSString*>* logNarratives;

@end



@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initUI];
    [self initData];
    // Do any additional setup after loading the view, typically from a nib.

}

- (void)initData{
    //CMMotionmanager
    self.motionManager = [[CMMotionManager alloc] init];
    self.motionManager.deviceMotionUpdateInterval = 1.0f/30.0f; //1秒30次
    
    //CLLoacationmanager
    if ([CLLocationManager locationServicesEnabled]) {
        if (nil == self.locationManager) {
            self.locationManager = [[CLLocationManager alloc]init];
            self.locationManager.delegate = self;
            //设置定位精度
            self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
            //设置位置更新的最小距离
            self.locationManager.distanceFilter = 0.1f;
            if (IS_IOS8) {//ios8之后点版本需要使用下面的方法才能定位。使用一个即可。
                //[_lm requestAlwaysAuthorization];
                [self.locationManager requestWhenInUseAuthorization];
            }
        }
    }else{
        NSLog(@"定位服务不可利用");
    }
    
    //Log
    [self initRecordLogFileName];
    //
    //_stateFlag = initmode;//switch
    //send
    self.isSending = 0;
    
    // camera interal parameters

    
    
}

- (void) initRecordLogFileName{
    NSString *nowString = [VCCLogger nowString];
    NSString *prefix = @"VideoLog";
    NSString *postfix = @"txt";
    NSString *filename = [NSString stringWithFormat:@"%@-%@.%@", prefix, nowString, postfix];
    NSArray * paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString * documentDirectory = [paths objectAtIndex:0];
    
    self.recordLogName = [documentDirectory stringByAppendingPathComponent:filename];
}

-(void) logDroneStatuswhileShooting {

    NSFileManager *manager = [NSFileManager defaultManager];
    BOOL isExit = [manager fileExistsAtPath:self.recordLogName];
    
    if (!isExit) {
        NSLog(@"文件不存在，创建中\n");
        NSString *comment = [NSString stringWithFormat:@"#%@\t%@\t%@\t%@\t%@\t%@\t%@\t%@\n", @"lon", @"lat", @"hei", @"Yaw", @"Pitch", @"Roll", @"HFOV", @"VFOV"];
        if(![comment writeToFile:self.recordLogName atomically:YES encoding:NSUTF8StringEncoding error:nil])
            NSLog(@"FAILED to create file!\n");
        else{
            NSLog(@"file name: %@\n", self.recordLogName);
            NSLog(@"GUIDE: %@\n", comment);
            [self.logNarratives addObject:comment];
        }
    }
    
    NSFileHandle *logHandle = [NSFileHandle fileHandleForWritingAtPath:self.recordLogName];
    if (!logHandle) {
        NSLog(@"文件打开失败！\n");
    }
    [logHandle seekToEndOfFile];
    
    CameraStatusPacket pack;
    
    pack.longitude = self.logLongti;
    pack.latitude = self.logLati;
    pack.height = self.logHeight;
    
    pack.cPitch = self.logPitch;
    pack.cYaw = self.logYaw;
    pack.cRoll = self.logRoll;

   NSString *dataString = [NSString stringWithFormat: @"%10.7f\t%10.7f\t%10.3f\t%10.3f\t%10.3f\t%10.3f\t%10.3f\t%10.3f\n",  pack.longitude, pack.latitude, pack.height, pack.cYaw, pack.cPitch, pack.cRoll, pack.hFov, pack.vFov];
    [self.logNarratives addObject:dataString];

    NSString *text = self.logNarratives.firstObject;
    text = [text stringByAppendingString:[self.logNarratives lastObject]];
    
    
    NSData *buffer;
    buffer = [dataString dataUsingEncoding:NSUTF8StringEncoding];
    
    [logHandle writeData:buffer];
    [logHandle closeFile];
    
}



- (void)initUI{
    //cameraVC
    self.cameraVC = [[CameraViewController alloc]init];
    self.cameraVC.view.alpha = 0.5;
    //self.cameraVC.delegate = self;
    [self.view addSubview:self.cameraVC.view];
    //ipConfigVC
    self.ipConfigVC = [[IPConfigViewController alloc] initWithNibName:@"IPConfigViewController" bundle:[NSBundle mainBundle]];
    self.ipConfigVC.view.alpha = 0;
    self.ipConfigVC.view.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleBottomMargin;
    [self.ipConfigVC.view setCenter:self.view.center];
    self.ipConfigVC.delegate = self;
    [self.view addSubview:self.ipConfigVC.view];
    //sbVC
    self.sbVC = [[SandboxViewController alloc] initWithNibName:@"SandboxViewController" bundle:[NSBundle mainBundle]];
    self.sbVC.view.alpha = 0;
    self.sbVC.view.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleBottomMargin;
    [self.sbVC.view setCenter:self.view.center];
    self.sbVC.delegate = self;
    [self.view addSubview:self.sbVC.view];
    
}

- (void)controlHardware
{
    [self.motionManager startDeviceMotionUpdatesToQueue:[NSOperationQueue currentQueue] withHandler:^(CMDeviceMotion *motion, NSError *error) {
        //Acceleration
        //if(fabs(motion.userAcceleration.x)>1.3f)
            self.lblAccelerometerX.text = [NSString stringWithFormat:@"%.2f",motion.userAcceleration.x];
        //if(fabs(motion.userAcceleration.y)>1.3f)
            self.lblAccelerometerY.text = [NSString stringWithFormat:@"%.2f",motion.userAcceleration.y];
        //if(fabs(motion.userAcceleration.z)>1.3f)
            self.lblAccelerometerZ.text = [NSString stringWithFormat:@"%.2f",motion.userAcceleration.z];
        //Gravity
        self.lblGravityX.text = [NSString stringWithFormat:@"%.2f",motion.gravity.x];
        self.lblGravityY.text = [NSString stringWithFormat:@"%.2f",motion.gravity.y];
        self.lblGravityZ.text = [NSString stringWithFormat:@"%.2f",motion.gravity.z];
        //yaw,pitch,roll
//        self.logYaw = motion.attitude.yaw;
//        self.logPitch = motion.attitude.pitch;
//        self.logRoll = motion.attitude.roll;
        
        self.logYaw = motion.attitude.yaw;
        self.logPitch = motion.attitude.roll;// human
        self.logRoll = motion.attitude.pitch;// human
        self.lblYaw.text = [NSString stringWithFormat:@"%.2f", (180/M_PI)*self.logYaw];
        self.lblPitch.text = [NSString stringWithFormat:@"%.2f", (180/M_PI)*self.logPitch];
        self.lblRoll.text = [NSString stringWithFormat:@"%.2f", (180/M_PI)*self.logRoll];
        //Gyroscope's rotationRate(CMRotationRate)
        self.lblRotationRateX.text = [NSString stringWithFormat:@"%.2f",motion.rotationRate.x];
        self.lblRotationRateY.text = [NSString stringWithFormat:@"%.2f",motion.rotationRate.y];
        self.lblRotationRateZ.text = [NSString stringWithFormat:@"%.2f",motion.rotationRate.z];
        
        [self logDroneStatuswhileShooting];
    }];
    
    
}

#pragma mark - IBAcation
// start localization warming up
- (IBAction)startSwitchHandler:(id)sender
{
    UISwitch *motionSwitch = (UISwitch *)sender;
    if(motionSwitch.on)
    {
        
        [self.locationManager startUpdatingLocation];
        //[self controlHardware];
        //[_cameraVC videoStart];
        
    }
    else
    {
        //[self.motionManager stopDeviceMotionUpdates];
        [self.locationManager stopUpdatingLocation];
        //[_cameraVC videoStop];
    }
    
}
// record and log
- (IBAction)recordSwitchHandler:(id)sender
{
    UISwitch *motionSwitch = (UISwitch *)sender;
    
    if(motionSwitch.on)
    {
        
        //[self.locationManager startUpdatingLocation];
        [self controlHardware];
        [_cameraVC videoStart];
        
    }
    else
    {
         [_cameraVC videoStop];
        [self.motionManager stopDeviceMotionUpdates];
        //[self.locationManager stopUpdatingLocation];
    }
}

- (IBAction)debugSwitchHandler:(id)sender
{
    UISwitch *motionSwitch = (UISwitch *)sender;
    if(motionSwitch.on)
    {
        
        //[self.locationManager startUpdatingLocation];
        [self controlHardware];
        //[_cameraVC videoStart];
        
    }
    else
    {
        [self.motionManager stopDeviceMotionUpdates];
        //[self.locationManager stopUpdatingLocation];
        //[_cameraVC videoStop];
    }
    
}

//
- (IBAction)newTakeAction:(id)sender{
    NSLog(@"newTake to do");
}

//
- (IBAction)IPConfigAction:(id)sender{
    WeakRef(weakSelf);
    [UIView animateWithDuration:0.25 animations:^{
        WeakReturn(weakSelf);
        weakSelf.ipConfigVC.view.alpha = 1.0;
    }];
}

//
- (IBAction)sendAction:(id)sender{
    //NSLog(@"Send to do");
    if (!self.isSending) {
        [self startSendPackage];
        [self.btnSend setTitle:@"Stop" forState:UIControlStateNormal];
    }else
    {
        [self.btnSend setTitle:@"Send" forState:UIControlStateNormal];
        [self.timer invalidate];
    }
    
    self.isSending = !self.isSending;
    

}

- (IBAction)zoomSliderChanged:(id)sender{
    
    UISlider *slider = (UISlider *)sender;
    CGFloat zoomValue =slider.value;
    //NSLog(@"%f", zoomValue);
    [self.cameraVC cameraViewDidChangeZoom:zoomValue];
    
}

- (void)startSendPackage{
    // #init data
    NSString *dataheader = [NSString stringWithFormat: @"# I am a phone"];
    [self.clientSocket writeData:[dataheader dataUsingEncoding:NSUTF8StringEncoding] withTimeout:-1 tag:0];
    // send per second
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(sendPackageAction:) userInfo:nil repeats:YES];

    [[NSRunLoop mainRunLoop] addTimer:self.timer forMode:NSDefaultRunLoopMode];
}

- (void)sendPackageAction:(NSTimer *)sender {
    static int i = 0;
    NSLog(@"NSTimer: %d",i);
    i++;
    CameraStatusPacket pack;

    pack.longitude = self.logLongti;
    pack.latitude = self.logLati;
    pack.height = self.logHeight;

    pack.cPitch = self.logPitch;
    pack.cYaw = self.logYaw;
    pack.cRoll = self.logRoll;
//
    pack.hFov = [self.cameraVC getHFOV];
    pack.vFov = [self.cameraVC getVFOV];
    NSString *dataString = [NSString stringWithFormat: @"%10.7f\t%10.7f\t%10.3f\t%10.3f\t%10.3f\t%10.3f\t%10.3f\t%10.3f\n",  pack.longitude, pack.latitude, pack.height, pack.cYaw, pack.cPitch, pack.cRoll, pack.hFov, pack.vFov];
    //[self.logNarratives addObject:dataString];
    [self.clientSocket writeData:[dataString dataUsingEncoding:NSUTF8StringEncoding] withTimeout:-1 tag:0];
}



// file info
- (IBAction)sandboxAction:(id)sender{
    //NSLog(@"sandbox to do");
    WeakRef(weakSelf);
    [UIView animateWithDuration:0.25 animations:^{
        WeakReturn(weakSelf);
        weakSelf.sbVC.view.alpha = 1.0;
    }];
}



#pragma mark - ipConfigViewControllerDelegate Methods
- (void)cancelBtnActionInIPConfigViewController:(IPConfigViewController *)ipConfigVC{
    //
    WeakRef(weakSelf);
    [UIView animateWithDuration:0.25 animations:^{
        WeakReturn(weakSelf);
        weakSelf.ipConfigVC.view.alpha = 0.0;
    }];
}
- (void)finishBtnActionInIPConfigViewController:(IPConfigViewController *)ipConfigVC{
    NSLog(@"finishBtn to do");
    //todo
    //create socket
    self.clientSocket = [[GCDAsyncSocket alloc]initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
    //connect socket
    NSError * error = nil;
    [self.clientSocket connectToHost:self.ipConfigVC.ipTextField.text onPort:[self.ipConfigVC.portTextField.text integerValue] error:&error];
    
    WeakRef(weakSelf);
    [UIView animateWithDuration:0.25 animations:^{
        WeakReturn(weakSelf);
        weakSelf.ipConfigVC.view.alpha = 0.0;
    }];
}





#pragma mark - ipConfigViewControllerDelegate Methods
- (void)doneBtnActionInSandboxViewController:(SandboxViewController *)sbConfigVC{
NSLog(@"done btn in sandbox view to do");
    WeakRef(weakSelf);
    [UIView animateWithDuration:0.25 animations:^{
        WeakReturn(weakSelf);
        weakSelf.sbVC.view.alpha = 0.0;
    }];
    
}

//
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
    //NSLog(@"location %@",error);
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation{
    self.logLati = newLocation.coordinate.latitude;
    self.lblLati.text = [NSString stringWithFormat:@"%3.8f",self.logLati];
    self.logLongti = newLocation.coordinate.longitude;
    self.lblLongti.text = [NSString stringWithFormat:@"%3.8f",self.logLongti];
    self.logHeight = 1;
    
    
    
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations{
    // 设备的当前位置
    CLLocation *currLocation = [locations firstObject];
    //获取经纬度
    
    self.logLati = currLocation.coordinate.latitude;
    self.lblLati.text = [NSString stringWithFormat:@"%3.8f",self.logLati];
    self.logLongti = currLocation.coordinate.longitude;
    self.lblLongti.text = [NSString stringWithFormat:@"%3.8f",self.logLongti];
    self.logHeight = 1;
    
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark- GCDAsyncSocketDelegate
- (void)socket:(GCDAsyncSocket *)sock didConnectToHost:(NSString *)host port:(uint16_t)port
{
    //创建的socket单例
    VCCSocketManager * socketManager = [VCCSocketManager sharedSocketManager];
    socketManager.vccSocket = sock;
}

- (void)socketDidDisconnect:(GCDAsyncSocket *)sock withError:(NSError *)err
{
    NSLog(@"connect lost");
}

- (void)socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag
{
    NSString * receiveddata = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    
    NSLog(@"messeage %@ recieved,",receiveddata);
}


@end
