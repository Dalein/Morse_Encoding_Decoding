//
//  UIImage+OpenCV.h
//  testFlash
//
//  Created by Admin on 22.07.15.
//  Copyright (c) 2015 daleijn. All rights reserved.
//

#import <UIKit/UIKit.h>
#include <opencv2/opencv.hpp>

@interface UIImage (OpenCV)

#pragma mark Generate UIImage from cv::Mat
+ (UIImage*)fromCVMat:(const cv::Mat&)cvMat;

#pragma mark Generate cv::Mat from UIImage
+ (cv::Mat)toCVMat:(UIImage*)image;
- (cv::Mat)toCVMat;

@end
