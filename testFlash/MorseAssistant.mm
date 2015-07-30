//
//  MorseAssistant.m
//  testFlash
//
//  Created by Ivan Gnatyuk on 28.07.15.
//  Copyright (c) 2015 daleijn. All rights reserved.
//

#import "MorseAssistant.h"
#import <AVFoundation/AVFoundation.h>

#import "UIImage+OpenCV.h"

#import "DBManager.h"

const float kPointDuration = 0.35; //All values in sec

const float kDashDuration = 3 * kPointDuration;
const float kOneSignsElementBlankDuration = kPointDuration; //Пауза между элементами одного знака
const float kOneSignsBlankDuration = 3 * kPointDuration; //Пауза между знаками
const float kOneWordBlankDuration = 7 * kPointDuration; //Пауза между словами

const float kDeflexion = 0.26; /*Переменная, используемая для установки границ колебания временных промежутков.
                                Означает что мы смотрим каждый временной промежуток не до его реального окончания, а с запасом длительностью 26% от его заданной продолжительности.
                                */

NSString *strSymbolBwSigns = @" ";



@implementation MorseAssistant {
    AVCaptureDevice* device;
    
    NSOperationQueue *operationQueue; //Сама очередь
    NSInvocationOperation *operationFlashMorseCode; // операции
    
    VideoSource * videoSource;
    
    NSTimer* m_FlDetectionTimer;
    NSTimer* m_DebugTimer;
    
    float fSecFlashOn;
    float fSecFlashOff;
    
    NSString *strCurrMorseSymbol;
    NSDate *dateFlashingBegins;
    NSDate *dateFlashingOffBegins;
    
    DBManager *myDBManager;
    dispatch_queue_t concurrentQueue;

}

+ (id)initMorse {
    static MorseAssistant *mySinglton = nil;
    @synchronized(self) {
        if (mySinglton == nil)
            mySinglton = [[self alloc] init];
    }
    return mySinglton;
}

- (id)init {
    if (self = [super init]) {
        [self initialConfig];
    }
    return self;
}

- (void)initialConfig {
    device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    _m_detector = new OpenCVHelper();
    myDBManager = [DBManager initDB];
    concurrentQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    // Configure Video Source
    videoSource = [[VideoSource alloc] init];
    videoSource.delegate = self;
    //[self.videoSource startWithDevicePosition:AVCaptureDevicePositionBack];
    
    fSecFlashOn = 0;
    fSecFlashOff = 0;
    _strFlashSignalInMorse = @"";
    _strFlashSignalInText = @"";
    strCurrMorseSymbol = @"";
    
    
    if ([[[NSLocale preferredLanguages] objectAtIndex:0] isEqualToString:@"ru"]) {
        _iPreferLanguage = MorseCodeMessageLanguageRU;
    }
    else {
        _iPreferLanguage = MorseCodeMessageLanguageEN;
    }

}


                                            #pragma --==Morse Encoding==--

#pragma Morse Encoding entry point
- (void)doDecoding {
    //Config UIView for camera
    
    [videoSource startWithDevicePosition:AVCaptureDevicePositionBack];
    
    // Start the Flash detection Timer
    m_FlDetectionTimer = [NSTimer scheduledTimerWithTimeInterval:(1.0f/45.0f)
                                                          target:self
                                                        selector:@selector(updateFlashDetection:)
                                                        userInfo:nil
                                                         repeats:YES];
}


#pragma Morse detection loop
- (void)updateFlashDetection:(NSTimer*)timer {
    //NSLog(@"updateFlashDetection");
    
    //Flash ON
    if (_m_detector->isFlashing()) {
        
        // . -
        if (fSecFlashOn == 0) {
            fSecFlashOn = 1.0;
            dateFlashingBegins = [NSDate date];
        }
        
        //Blank spaces
        if (fSecFlashOff != 0) {
            NSDate *dateFlashBegins = [NSDate date];
            fSecFlashOff = [dateFlashBegins timeIntervalSinceDate:dateFlashingOffBegins];
            NSString *strNextMorseSymbol = [self getMorseCodeWithBlankDuration:fSecFlashOff];
            
            if ([strNextMorseSymbol isEqualToString:@"#"]) {
                //Call Encrypt func
                [self assyncEncryptWithCode:strCurrMorseSymbol];
                strCurrMorseSymbol = @"";
            }
            
            _strFlashSignalInMorse = [_strFlashSignalInMorse stringByAppendingString:strNextMorseSymbol];
            fSecFlashOff = 0;
        }
    }
    //Flash off
    else {
        
        //Blank spaces
        if (fSecFlashOff == 0) {
            dateFlashingOffBegins = [NSDate date];
            fSecFlashOff = 1;
        }
        else if ([[NSDate date] timeIntervalSinceDate:dateFlashingOffBegins] >= (kOneWordBlankDuration + kDeflexion*kOneWordBlankDuration) && strCurrMorseSymbol.length > 0) {
            //Call Encrypt func
            [self assyncEncryptWithCode:strCurrMorseSymbol];
            strCurrMorseSymbol = @"";
        }
        
        //. -
        if (fSecFlashOn != 0) {
            NSDate *dateFlashFinished = [NSDate date];
            fSecFlashOn = [dateFlashFinished timeIntervalSinceDate:dateFlashingBegins];
            
            NSString *strNextMorseSymbol = [self getMorseCodeWithFlashDuration:fSecFlashOn];
            strCurrMorseSymbol = [strCurrMorseSymbol stringByAppendingString:strNextMorseSymbol]; //Add to current Morse symbol
            _strFlashSignalInMorse = [_strFlashSignalInMorse stringByAppendingString:strNextMorseSymbol];
            fSecFlashOn = 0;
        }
    }
}


#pragma get Morse signs
- (NSString *)getMorseCodeWithFlashDuration:(float)fFlashDur {
    
    if (fFlashDur <= kPointDuration + kDeflexion*kPointDuration) {
        return @".";
    }
    else if (fFlashDur > kPointDuration && fFlashDur <= kDashDuration + kDeflexion*kDashDuration) {
        return @"-";
    }
    else {
        return @"........";
    }
}

- (NSString *)getMorseCodeWithBlankDuration:(float)fBlankDur {
    
    if (fBlankDur > kOneSignsElementBlankDuration && fBlankDur <= kOneSignsBlankDuration) {
        return @" ";
    }
    else if (fBlankDur > kOneSignsBlankDuration && fBlankDur <= kOneWordBlankDuration) {
        return @"#"; //#
    }
    else {
        return @"";
    }
}


#pragma Encryption of Morse symbols
- (void)assyncEncryptWithCode:(NSString *)strCode {
    //Assync encrypt Morse code (not to block and force to await until another symbol will be encrypted, not so usefull here for really, but in more compicated cases - necessary
    dispatch_async(concurrentQueue, ^{
        
        NSString *strEncrMorse = nil;
        //Send symbol in Morse code
        NSString *strCurrLang = _iPreferLanguage == MorseCodeMessageLanguageEN ? @"enStr" : @"ruStr";
        NSDictionary *dictSymbolInfo = [myDBManager getMorseElementWithParams:@{@"key" : @"morseCode",
                                                                                @"val" : strCode}];
        if (dictSymbolInfo) {
            strEncrMorse = dictSymbolInfo[strCurrLang];
        }
        else {
            strEncrMorse = @"(?)"; //unrecognized Morse sign
        }
        
        dispatch_sync(dispatch_get_main_queue(), ^{
           // NSLog(@"strFlashSignalInText = %@", _strFlashSignalInText);
            _strFlashSignalInText = [_strFlashSignalInText stringByAppendingString:strEncrMorse];
        });
    });
}







                                            #pragma --===Morse Coding==--

- (void)doCodingInMorseString:(NSString *)strToCode afterDelay:(float)fDelay {
    [self performSelector:@selector(startMorseCodingWithString:) withObject:strToCode afterDelay:fDelay];
}

- (void)startMorseCodingWithString:(NSString *)strOriginalText {
    if (strOriginalText.length == 0) {
        return;
    }
    
    //Formatting string
    strOriginalText = [strOriginalText lowercaseString];
    strOriginalText = [strOriginalText stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    strOriginalText= [[strOriginalText componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]] componentsJoinedByString:@""];
    strOriginalText = [strOriginalText stringByReplacingOccurrencesOfString:@" " withString:@""];
    //Litile fix for russian language
    strOriginalText = [strOriginalText stringByReplacingOccurrencesOfString:@"ё" withString:@"е"];
    strOriginalText = [strOriginalText stringByReplacingOccurrencesOfString:@"ъ" withString:@"ь"];
    
    if ([self isHasCyrillicString:strOriginalText]) {
        _iPreferLanguage = MorseCodeMessageLanguageRU;
    }
    else {
        _iPreferLanguage = MorseCodeMessageLanguageEN;
    }

    
    //Translate original string to Morse code
    NSString *strInMorseCode = [self translateToMorseCodeWithString:strOriginalText];
    
    //Send Morse code with torch
    operationFlashMorseCode =[[NSInvocationOperation alloc] initWithTarget:self  selector:@selector(flashAString:) object:strInMorseCode];
    operationQueue = [[NSOperationQueue alloc] init];
    [operationQueue addOperation:operationFlashMorseCode];
}


- (void)cancelCoding {
     [operationFlashMorseCode cancel];
}

- (void)cancelDecoding {
     [m_FlDetectionTimer invalidate];
}


#pragma Morse Conding Entry point
- (void)flashAString:(id)paramObject {
    NSString *strMorse = (NSString *)paramObject;
    for (int i = 0; i<strMorse.length; i++) {
        
        if ([operationFlashMorseCode isCancelled]) {
            return;
        }
        NSString * strCurrSymbol = [strMorse substringWithRange:NSMakeRange(i, 1)];
        [self flashASignWithSymol:strCurrSymbol];
    }
}


#pragma text to Morse translation functions
- (NSString *)translateToMorseCodeWithString:(NSString *)strOrign {
    NSString *strInMorseCode = @"";
    
    for (int i = 0; i < strOrign.length; i++) {
        NSString * strCurrSymbol = [strOrign substringWithRange:NSMakeRange(i, 1)]; //Get next symbol
        strInMorseCode = [strInMorseCode stringByAppendingString:[self getMorseSignWithSymol:strCurrSymbol]];
        strInMorseCode = [strInMorseCode stringByAppendingString:strSymbolBwSigns];
    }
    
    //Сделаем символом пробла м\у словами одиночный символ #
    strInMorseCode = [strInMorseCode stringByReplacingOccurrencesOfString:@" # " withString:@"#"];
    return strInMorseCode;
}

- (NSString *)getMorseSignWithSymol:(NSString *)str {
    
    //Send symbol in  russian or english and get Morse cose
    NSString *strCurrLang = _iPreferLanguage == MorseCodeMessageLanguageEN ? @"enStr" : @"ruStr";
    
    NSDictionary *dictSymbolInfo = [myDBManager getMorseElementWithParams:@{@"key" : strCurrLang,
                                                                            @"val" : str}];
    if (dictSymbolInfo) {
        return dictSymbolInfo[@"morseCode"];
    }
    else {
        return @"........"; //unrecognized symbol
    }
}


#pragma Torch use
- (void)flashASignWithSymol:(NSString *)strSymbol {
    
    if ([strSymbol isEqualToString:@"."] || [strSymbol isEqualToString:@"-"]) {
        float fCurrInterval = [strSymbol isEqualToString:@"."] ? kPointDuration : kDashDuration;
        
        [self setTorchOn:YES];
        [NSThread sleepForTimeInterval:fCurrInterval];
        [self setTorchOn:NO];
        [NSThread sleepForTimeInterval:kOneSignsElementBlankDuration];
    }
    
    else if ([strSymbolBwSigns isEqualToString:@" "]) {
        [NSThread sleepForTimeInterval:kOneSignsBlankDuration];
    }
    else if ([strSymbolBwSigns isEqualToString:@"#"]) {
        [NSThread sleepForTimeInterval:kOneWordBlankDuration];
    }
}

- (void)setTorchOn:(BOOL)isOn
{
    [device lockForConfiguration:nil]; //you must lock before setting torch mode
    [device setTorchMode:isOn ? AVCaptureTorchModeOn : AVCaptureTorchModeOff];
    [device unlockForConfiguration];
}



#pragma mark VideoSource Delegate
- (void)frameReady:(VideoFrame)frame {
   // NSLog(@"frameReady");
    //__weak typeof(self) _weakSelf = self;
    dispatch_sync( dispatch_get_main_queue(), ^{
        // Construct CGContextRef from VideoFrame
        CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
        CGContextRef newContext = CGBitmapContextCreate(frame.data,
                                                        frame.width,
                                                        frame.height,
                                                        8,
                                                        frame.stride,
                                                        colorSpace,
                                                        kCGBitmapByteOrder32Little |
                                                        kCGImageAlphaPremultipliedFirst);
        
        // Construct CGImageRef from CGContextRef
        CGImageRef newImage = CGBitmapContextCreateImage(newContext);
        CGContextRelease(newContext);
        CGColorSpaceRelease(colorSpace);
        
        // Construct UIImage from CGImageRef
        UIImage * image = [UIImage imageWithCGImage:newImage];
        CGImageRelease(newImage);
        
        if (image) {
           _imageRealWorld = image;
        }
        
        //Update debug image update
        UIImage *imageDebug = [UIImage fromCVMat:_m_detector->sampleImage()];
        if (imageDebug) {
            _imageDebug = imageDebug;
        }
        
        //Porion of new data send here
        [self.delegate UIUpdate];
        
    });
    
    _m_detector->scanFrame(frame);
}

- (BOOL)isHasCyrillicString:(NSString *)str{
    NSCharacterSet * set = [NSCharacterSet characterSetWithCharactersInString:@"абвгдеёжзийклмнопрстуфхцчшщъыьэюя"];
    return [str rangeOfCharacterFromSet:set].location != NSNotFound;
}




@end
