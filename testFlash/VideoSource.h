//
//  VideoSource.h
//  OpenCVTutorial
//
//  Created by Paul Sholtz on 12/14/13.
//  Copyright (c) 2013 Razeware LLC. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>

#import "VideoFrame.h"

#pragma mark VideoSource Delegate
@protocol VideoSourceDelegate <NSObject>

@required
- (void)frameReady:(VideoFrame)frame;

@end

#pragma mark VideoSource Interface
@interface VideoSource : NSObject

@property (nonatomic, strong) AVCaptureSession * captureSession;
@property (nonatomic, strong) AVCaptureDeviceInput * deviceInput;
@property (nonatomic, weak) id<VideoSourceDelegate> delegate;

- (BOOL)startWithDevicePosition:(AVCaptureDevicePosition)devicePosition;

@end

