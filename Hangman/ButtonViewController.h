//
//  ButtonViewController.h
//  Hangman
//
//  Created by Magfurul Abeer on 1/28/16.
//  Copyright © 2016 Magfurul Abeer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HangmanGame.h"

@interface ButtonViewController : UIViewController

// Android Parts
@property (weak, nonatomic) IBOutlet UIImageView *androidHead;
@property (weak, nonatomic) IBOutlet UIImageView *androidBody;
@property (weak, nonatomic) IBOutlet UIImageView *androidLeftArm;
@property (weak, nonatomic) IBOutlet UIImageView *androidRightArm;
@property (weak, nonatomic) IBOutlet UIImageView *androidLeftLeg;
@property (weak, nonatomic) IBOutlet UIImageView *androidRightLeg;

// Label
@property (weak, nonatomic) IBOutlet UILabel *label;

// Buttons
// Alphabet Letters
@property (weak, nonatomic) IBOutlet UIButton *buttonA;
@property (weak, nonatomic) IBOutlet UIButton *buttonB;
@property (weak, nonatomic) IBOutlet UIButton *buttonC;
@property (weak, nonatomic) IBOutlet UIButton *buttonD;
@property (weak, nonatomic) IBOutlet UIButton *buttonE;
@property (weak, nonatomic) IBOutlet UIButton *buttonF;
@property (weak, nonatomic) IBOutlet UIButton *buttonG;
@property (weak, nonatomic) IBOutlet UIButton *buttonH;
@property (weak, nonatomic) IBOutlet UIButton *buttonI;
@property (weak, nonatomic) IBOutlet UIButton *buttonJ;
@property (weak, nonatomic) IBOutlet UIButton *buttonK;
@property (weak, nonatomic) IBOutlet UIButton *buttonL;
@property (weak, nonatomic) IBOutlet UIButton *buttonM;
@property (weak, nonatomic) IBOutlet UIButton *buttonN;
@property (weak, nonatomic) IBOutlet UIButton *buttonO;
@property (weak, nonatomic) IBOutlet UIButton *buttonP;
@property (weak, nonatomic) IBOutlet UIButton *buttonQ;
@property (weak, nonatomic) IBOutlet UIButton *buttonR;
@property (weak, nonatomic) IBOutlet UIButton *buttonS;
@property (weak, nonatomic) IBOutlet UIButton *buttonT;
@property (weak, nonatomic) IBOutlet UIButton *buttonU;
@property (weak, nonatomic) IBOutlet UIButton *buttonV;
@property (weak, nonatomic) IBOutlet UIButton *buttonW;
@property (weak, nonatomic) IBOutlet UIButton *buttonX;
@property (weak, nonatomic) IBOutlet UIButton *buttonY;
@property (weak, nonatomic) IBOutlet UIButton *buttonZ;

#pragma mark - Regular Properties
@property (strong, nonatomic) HangmanGame *game;
@property (strong, nonatomic) NSArray *buttons;

- (IBAction)buttonTapped:(UIButton *)sender;

@end
