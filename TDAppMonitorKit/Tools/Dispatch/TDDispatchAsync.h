//
//  TDDispatchAsync.h
//  TDAppMonitor
//
//  Created by Beck.Wang on 2018/4/3.
//  Copyright © 2018年 TDW.CN. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, TDQualityOfService) {
    TDQualityOfServiceUserInteractive = NSQualityOfServiceUserInteractive,
    TDQualityOfServiceUserInitiated = NSQualityOfServiceUserInitiated,
    TDQualityOfServiceUtility = NSQualityOfServiceUtility,
    TDQualityOfServiceBackground = NSQualityOfServiceBackground,
    TDQualityOfServiceDefault = NSQualityOfServiceDefault,
};

dispatch_queue_t TDDispatchQueueAsyncBlockInQOS(TDQualityOfService qos, dispatch_block_t block);
dispatch_queue_t TDDispatchQueueAsyncBlockInUserInteractive(dispatch_block_t block);
dispatch_queue_t TDDispatchQueueAsyncBlockInUserInitiated(dispatch_block_t block);
dispatch_queue_t TDDispatchQueueAsyncBlockInBackground(dispatch_block_t block);
dispatch_queue_t TDDispatchQueueAsyncBlockInDefault(dispatch_block_t block);
dispatch_queue_t TDDispatchQueueAsyncBlockInUtility(dispatch_block_t block);
