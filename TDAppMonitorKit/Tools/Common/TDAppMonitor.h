//
//  TDAppMonitor.h
//  TDAppMonitorKit
//
//  Created by Beck.Wang on 2018/4/4.
//  Copyright © 2018年 TDW.CN. All rights reserved.
//

#ifndef TDAppMonitor_h
#define TDAppMonitor_h

#import "TDAppFluencyMonitor.h"
#import "TDFPSMonitor.h"
#import "TDResourceMonitor.h"

#define TD_FLUENCYMONITOR [TDAppFluencyMonitor sharedMonitor]
#define TD_FPSMONITOR [TDFPSMonitor sharedMonitor]
#define TD_RESOURCEMONITOR [TDResourceMonitor new]

#endif /* TDAppMonitor_h */
