//
//  ViewController.m
//  testFlash
//
//  Created by Ivan Gnatyuk on 19.07.15.
//  Copyright (c) 2015 daleijn. All rights reserved.
//

#import "ViewController.h"
#import "MorseAssistant.h"

@interface ViewController () <UITextFieldDelegate, MorseAssistantDelegate> {
    
    UIImageView *imageVRealWorld;
    UIImageView *imageVDebug;
    UIImageView *imageAim;
    
    MorseAssistant *myMorseAssistant;
    
}

@end

@implementation ViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    myMorseAssistant = [MorseAssistant initMorse];
    myMorseAssistant.delegate = self;
    
    _btnExpectedLang.hidden = YES;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
     [self setUpCameraImageViews];
}


- (void)setUpCameraImageViews {
    //Camera view
    NSUInteger iImageVSize = self.view.frame.size.width - 20;
    imageVRealWorld = [[UIImageView alloc] initWithFrame:CGRectMake(10, 159, iImageVSize, iImageVSize)];
    imageVRealWorld.layer.cornerRadius = imageVRealWorld.frame.size.width/2;
    imageVRealWorld.clipsToBounds = YES;
    //imageVRealWorld.contentMode = UIViewContentModeScaleAspectFit;
    CGAffineTransform transorm = CGAffineTransformMakeRotation(M_PI_2);
    imageVRealWorld.transform = transorm;
    [self.view addSubview:imageVRealWorld];
    
    
    //Camera aim view
    int width = imageVRealWorld.frame.size.width*0.15,
    height = width,
    x = imageVRealWorld.center.x,
    y = imageVRealWorld.center.y;
    imageAim = [[UIImageView alloc] initWithFrame:CGRectMake(x, y, width, height)];
    imageAim.center = imageVRealWorld.center;
    imageAim.image = [UIImage imageNamed:@"aimRed"];
    imageAim.contentMode = UIViewContentModeScaleAspectFit;
    imageAim.hidden = YES;
    [self.view addSubview:imageAim];
    
    
    //Camera debug view
    NSUInteger iImageVDebugImgSize = self.view.frame.size.width/2.5;
    imageVDebug = [[UIImageView alloc] initWithFrame:CGRectMake(10, iImageVDebugImgSize, 150, 150)];
    imageVDebug.transform = transorm;
    imageVDebug.contentMode = UIViewContentModeScaleAspectFit;
    [self.view addSubview:imageVDebug];
}



- (IBAction)beginTransmission:(id)sender {
    [myMorseAssistant doCodingInMorseString:_txtFUserInput.text afterDelay:5.0];
}

- (IBAction)beginDecoding:(id)sender {
    imageAim.hidden = NO;
    [_btnExpectedLang setTitle:myMorseAssistant.iPreferLanguage == MorseCodeMessageLanguageEN ? @"En" : @"Ru" forState:UIControlStateNormal];
    _btnExpectedLang.hidden = NO;
    
    [myMorseAssistant doDecoding];
}

- (IBAction)doCancel:(id)sender {
    [myMorseAssistant cancelCoding];
    [myMorseAssistant cancelDecoding];
    imageAim.hidden = YES;
    _btnExpectedLang.hidden = YES;
}

- (IBAction)changeExpectedLang:(id)sender {
    
    //TODO: При смене языка сразу пройтись по существующей строке кода Морзе и расшифровать ее нужным языком
    
    if (myMorseAssistant.iPreferLanguage == MorseCodeMessageLanguageEN) {
        myMorseAssistant.iPreferLanguage = MorseCodeMessageLanguageRU;
        [_btnExpectedLang setTitle:@"Ru" forState:UIControlStateNormal];
    }
    else {
        myMorseAssistant.iPreferLanguage = MorseCodeMessageLanguageEN;
        [_btnExpectedLang setTitle:@"En" forState:UIControlStateNormal];
    }
}



-(void)UIUpdate {
   NSLog(@"FlashValue: %f", myMorseAssistant.m_detector->getFlashValue());
    
    _lblMorseCode.text = myMorseAssistant.strFlashSignalInText;

    [imageVRealWorld setImage:myMorseAssistant.imageRealWorld];
    [imageVDebug setImage:myMorseAssistant.imageDebug];
    
    if (myMorseAssistant.m_detector->isFlashing()) {
        [imageAim setImage:[UIImage imageNamed:@"aimGreen"]];
        
    }
    else {
        [imageAim setImage:[UIImage imageNamed:@"aimRed"]];
    }
}



- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self.view endEditing:YES];
    return YES;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
