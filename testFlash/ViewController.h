//
//  ViewController.h
//  testFlash
//
//  Created by Ivan Gnatyuk on 19.07.15.
//  Copyright (c) 2015 daleijn. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface ViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *txtFUserInput;
@property (weak, nonatomic) IBOutlet UILabel *lblMorseCode;
@property (weak, nonatomic) IBOutlet UIButton *btnExpectedLang;

@end

