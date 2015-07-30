//
//  MorseAssistant.h
//  testFlash
//
//  Created by Ivan Gnatyuk on 28.07.15.
//  Copyright (c) 2015 daleijn. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "VideoSource.h"
#import "OpenCVHelper.h"

enum MorseCodeMessageLanguage {
    MorseCodeMessageLanguageRU,
    MorseCodeMessageLanguageEN
};

#pragma mark MorseAssistant Delegate
@protocol MorseAssistantDelegate <NSObject>

@required
- (void)UIUpdate; //In this method user can get current info about Morse translation (see example in ViewController.mm)

@end

@interface MorseAssistant : NSObject <VideoSourceDelegate>

+(instancetype)initMorse;
@property (nonatomic, weak) id<MorseAssistantDelegate> delegate;


- (void)doDecoding; //Start light detection;
- (void)doCodingInMorseString:(NSString *)strToCode afterDelay:(float)fDelay;

- (void)cancelCoding;
- (void)cancelDecoding;

@property (nonatomic) int iPreferLanguage;
@property (strong, nonatomic) NSString *strFlashSignalInMorse;
@property (strong, nonatomic) NSString *strFlashSignalInText;

@property (strong, nonatomic) UIImage *imageRealWorld; //picture from camera
@property (strong, nonatomic) UIImage *imageDebug;

@property (nonatomic) OpenCVHelper *m_detector;

@end
