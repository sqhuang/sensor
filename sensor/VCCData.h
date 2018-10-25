//
//  VCCData.h
//  sensor
//
//  Created by qiu on 2018/10/18.
//  Copyright © 2018 qiu. All rights reserved.
//

#ifndef VCCData_h
#define VCCData_h


#define WeakRef(__obj) __weak typeof(self) __obj = self
#define WeakReturn(__obj) if(__obj ==nil)return;

#define DEGREE(x) ((x)*180.0/M_PI)
#define RADIAN(x) ((x)*M_PI/180.0)

//definition of A Aircraft Status Pack
typedef struct {
    //int32_t packID;
    
    double longitude;
    double latitude;
    double height;
    
    double cPitch;
    double cYaw;
    double cRoll;
    
    double hFov;
    double vFov;
}CameraStatusPacket;

#endif /* VCCData_h */
