//
//  ViewController.m
//  sensor
//
//  Created by qiu on 2018/10/17.
//  Copyright © 2018 qiu. All rights reserved.
//

#import "ViewController.h"

#define IS_IOS8 ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8)

@interface ViewController ()
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

- (IBAction)motionSwitchHandler:(id)sender;

@property (strong, nonatomic) CMMotionManager *motionManager;
@property (nonatomic, strong) CLLocationManager *locationManager;

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

    
    
}

- (void)initUI{
    
    
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
        self.lblYaw.text = [NSString stringWithFormat:@"%.2f",motion.attitude.yaw];
        self.lblPitch.text = [NSString stringWithFormat:@"%.2f",motion.attitude.pitch];
        self.lblRoll.text = [NSString stringWithFormat:@"%.2f",motion.attitude.roll];
        //Gyroscope's rotationRate(CMRotationRate)
        self.lblRotationRateX.text = [NSString stringWithFormat:@"%.2f",motion.rotationRate.x];
        self.lblRotationRateY.text = [NSString stringWithFormat:@"%.2f",motion.rotationRate.y];
        self.lblRotationRateZ.text = [NSString stringWithFormat:@"%.2f",motion.rotationRate.z];
    }];
}

- (IBAction)motionSwitchHandler:(id)sender
{
    UISwitch *motionSwitch = (UISwitch *)sender;
    if(motionSwitch.on)
    {
        [self controlHardware];
        [self.locationManager startUpdatingLocation];
    }
    else
    {
        [self.motionManager stopDeviceMotionUpdates];
        [self.locationManager stopUpdatingLocation];
    }
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
    //NSLog(@"location %@",error);
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation{
    self.lblLati.text = [NSString stringWithFormat:@"%3.8f",newLocation.coordinate.latitude];
    self.lblLongti.text = [NSString stringWithFormat:@"%3.8f",newLocation.coordinate.longitude];
    
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations{
    // 设备的当前位置
    CLLocation *currLocation = [locations firstObject];
    //获取经纬度
    self.lblLati.text = [NSString stringWithFormat:@"%3.8f",currLocation.coordinate.latitude];
    self.lblLongti.text = [NSString stringWithFormat:@"%3.8f",currLocation.coordinate.longitude];

    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
