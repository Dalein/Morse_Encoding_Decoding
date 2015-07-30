//
//  VideoSource.m
//  OpenCVTutorial
//
//  Created by Paul Sholtz on 12/14/13.
//  Copyright (c) 2013 Razeware LLC. All rights reserved.
//

#import "VideoSource.h"

#pragma mark -
#pragma mark VideoSource Class Extension
@interface VideoSource () <AVCaptureVideoDataOutputSampleBufferDelegate>

@end

#pragma mark -
#pragma mark VideoSource Implementation
@implementation VideoSource

#pragma mark -
#pragma mark Object Lifecycle
- (id)init {
    self = [super init];
    if ( self ) {
        AVCaptureSession * captureSession = [[AVCaptureSession alloc] init];
        if ( [captureSession canSetSessionPreset:AVCaptureSessionPreset640x480] ) {
            [captureSession setSessionPreset:AVCaptureSessionPreset640x480];
            NSLog(@"Capturing video at 640x480");
        } else {
            NSLog(@"Could not configure AVCaptureSession video input");
        }
        _captureSession = captureSession;
    }
    return self;
}

- (void)dealloc {
    [_captureSession stopRunning];
}

#pragma mark -
#pragma mark Public Interface
- (BOOL)startWithDevicePosition:(AVCaptureDevicePosition)devicePosition {
    // (1) Find camera device at the specific position
    AVCaptureDevice * videoDevice = [self cameraWithPosition:devicePosition];
    if ( !videoDevice ) {
        NSLog(@"Could not initialize camera at position %ld", (long)devicePosition);
        return FALSE;
    }
    
    // (2) Obtain input port for camera device
    NSError * error;
    AVCaptureDeviceInput *videoInput = [AVCaptureDeviceInput deviceInputWithDevice:videoDevice error:&error];
    if ( !error ) {
        [self setDeviceInput:videoInput];
    } else {
        NSLog(@"Could not open input port for device %@ (%@)", videoDevice, [error localizedDescription]);
        return FALSE;
    }
    
    // (3) Configure input port for captureSession
    if ( [self.captureSession canAddInput:videoInput] ) {
        [self.captureSession addInput:videoInput];
    } else {
        NSLog(@"Could not add input port to capture session %@", self.captureSession);
        return FALSE;
    }
    
    // (4) Configure output port for captureSession
    [self addVideoDataOutput];
    
    // (5) Start captureSession running
    [self.captureSession startRunning];
    
    return TRUE;
}

#pragma mark -
#pragma mark Helper Methods
- (AVCaptureDevice*)cameraWithPosition:(AVCaptureDevicePosition)position {
    NSArray * devices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    for ( AVCaptureDevice * device in devices ) {
        if ( [device position] == position ) {
            return device;
        }
    }
    return nil;
}

- (void) addVideoDataOutput {
    // (1) Instantiate a new video data output object
    AVCaptureVideoDataOutput * captureOutput = [[AVCaptureVideoDataOutput alloc] init];
    captureOutput.alwaysDiscardsLateVideoFrames = YES;
    
    // (2) The sample buffer delegate requires a serial dispatch queue
    dispatch_queue_t queue;
    queue = dispatch_queue_create("com.raywenderlich.tutorials.opencv", DISPATCH_QUEUE_SERIAL);
    [captureOutput setSampleBufferDelegate:self queue:queue];
    //dispatch_release(queue);
    
    // (3) Define the pixel format for the video data output
    NSString * key = (NSString*)kCVPixelBufferPixelFormatTypeKey;
    NSNumber * value = [NSNumber numberWithUnsignedInt:kCVPixelFormatType_32BGRA];
    NSDictionary * settings = @{key:value};
    [captureOutput setVideoSettings:settings];
    
    // (4) Configure the output port on the captureSession property
    [self.captureSession addOutput:captureOutput];
}

#pragma mark -
#pragma mark Sample Buffer Delegate
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer
       fromConnection:(AVCaptureConnection *)connection {
    
    // (1) Convert CMSampleBufferRef to CVImageBufferRef
    CVImageBufferRef imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer);
    
    // (2) Lock pixel buffer
    CVPixelBufferLockBaseAddress(imageBuffer, kCVPixelBufferLock_ReadOnly);
    
    // (3) Construct VideoFrame struct
    uint8_t *baseAddress = (uint8_t*)CVPixelBufferGetBaseAddress(imageBuffer);
    size_t width = CVPixelBufferGetWidth(imageBuffer);
    size_t height = CVPixelBufferGetHeight(imageBuffer);
    size_t stride = CVPixelBufferGetBytesPerRow(imageBuffer);
    VideoFrame frame = {width, height, stride, baseAddress};
    
    // (4) Dispatch VideoFrame to VideoSource delegate
    [self.delegate frameReady:frame];
    
    // (5) Unlock pixel buffer
    CVPixelBufferUnlockBaseAddress(imageBuffer, 0);
}

@end
