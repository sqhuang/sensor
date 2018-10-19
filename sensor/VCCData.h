//
//  VCCData.h
//  sensor
//
//  Created by qiu on 2018/10/18.
//  Copyright © 2018 qiu. All rights reserved.
//

#ifndef VCCData_h
#define VCCData_h
//definition of A Aircraft Status Pack
typedef struct {
    //int32_t packID;
    
    double longitude;
    double latitude;
    double height;
    
    double cPitch;
    double cYaw;
    double cRoll;
}CameraStatusPacket;

#endif /* VCCData_h */
