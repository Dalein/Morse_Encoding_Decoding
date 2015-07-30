//
//  OpenCVHelper.h
//  testFlash
//
//  Created by Admin on 22.07.15.
//  Copyright (c) 2015 daleijn. All rights reserved.
//

#ifndef __testFlash__OpenCVHelper__
#define __testFlash__OpenCVHelper__

#include "VideoFrame.h"
#include <opencv2/opencv.hpp>


#endif /* defined(__testFlash__OpenCVHelper__) */

class OpenCVHelper
{

#pragma mark Public Interface
public:
    
    //Scan the input video frame
    void scanFrame(VideoFrame frame);
    
    float getFlashValue();
    
    //Video frame analys
    bool isFlashing();
    
    const cv::Mat& sampleImage();
    
#pragma mark Private Members
private:
    float flashValue;
    
    cv::Mat m_sampleImage;

};
