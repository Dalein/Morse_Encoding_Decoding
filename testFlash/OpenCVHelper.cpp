//
//  OpenCVHelper.cpp
//  testFlash
//
//  Created by Admin on 22.07.15.
//  Copyright (c) 2015 daleijn. All rights reserved.
//

#include "OpenCVHelper.h"

const float thresholdValue = 255.0; //255 - max

void OpenCVHelper::scanFrame(VideoFrame frame)
{
    // (1) Build the grayscale query image from the camera data
    cv::Mat queryImageGray, queryImageGrayScale;
    cv::Mat queryImage = cv::Mat((int)frame.height, (int) frame.width, CV_8UC4, frame.data, frame.stride);
    cv::cvtColor(queryImage, queryImageGray, CV_BGR2GRAY);
    
    
    // (1) copy image
    //cv::Mat debugImage;
    
    int width = queryImageGray.size().width*0.15, height = width,
    x = queryImageGray.size().width/2 - width/2, //center of the image
    y = queryImageGray.size().height/2 - height/2;
    
    
    cv::Mat imgAim = queryImageGray(cv::Rect(x, y, width, height));
   // imgAim.copyTo(m_sampleImage);
    
    
    // (4) Find the min/max settings
    double minVal, maxVal;
    cv::Point minLoc, maxLoc;
    cv::minMaxLoc(imgAim, &minVal, &maxVal, &minLoc, &maxLoc, cv::Mat() );
    
    cv::Point m_matchPoint;
    float m_matchValue;
    
    m_matchPoint = maxLoc;
    m_matchValue = maxVal;

    flashValue = m_matchValue;

    cv::rectangle(imgAim, m_matchPoint, cv::Point(m_matchPoint.x + 20, m_matchPoint.y + 20), CV_RGB(0, 0, 0), 3);
    
    //save to member variable
    imgAim.copyTo(m_sampleImage);
    
}


bool  OpenCVHelper::isFlashing()
{
    if (flashValue >= thresholdValue) {
        return  1;
    }
    else {
        return 0;
    }
}

float OpenCVHelper::getFlashValue()
{
    return flashValue;
}

const cv::Mat& OpenCVHelper::sampleImage()
{
    return m_sampleImage;
}