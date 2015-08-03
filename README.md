# Morse_Encoding_Decoding
This project allows you to encode and decode Morse code using your device flashlight and camera. 
For decoding was used augmented reality library OpenCV 2

All what you need to do:
* Copy "Morse Translation folders" to your project
* Conform your class to the protocol `<MorseAssistantDelegate>`
* Init Morse assistant:
   ` MorseAssistant * myMorseAssistant = [MorseAssistant initMorse];`
    `myMorseAssistant.delegate = self;`
* For begin transmission Morse code with your device flashlight you need to call: 
   `[myMorseAssistant doCodingInMorseString:@"Hello in Morse" afterDelay:5.0];`
* For begin decoding you need to call:
  `[myMorseAssistant doDecoding];`
This delegate method `-(void)UIUpdate;` will be helpful, in this method you can get 
live stream from camera and debug view, determine is flashing now or not, and get current morse transcript 
Example:
```ojectivec
- (void)UIUpdate {
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
```
    

By default coding/decoding language determined by device's language, but you can change it by any time:
`myMorseAssistant.iPreferLanguage = MorseCodeMessageLanguageEN;`
