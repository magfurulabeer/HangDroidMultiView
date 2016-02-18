//
//  ViewController.h
//  Hangman
//
//  Created by Magfurul Abeer on 1/14/16.
//  Copyright © 2016 Magfurul Abeer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HangmanGame.h"
@interface ViewController : UIViewController <UIPickerViewDataSource, UIPickerViewDelegate>

#pragma mark - IBOutlets

// Android Parts
@property (weak, nonatomic) IBOutlet UIImageView *androidHead;
@property (weak, nonatomic) IBOutlet UIImageView *androidBody;
@property (weak, nonatomic) IBOutlet UIImageView *androidLeftArm;
@property (weak, nonatomic) IBOutlet UIImageView *androidRightArm;
@property (weak, nonatomic) IBOutlet UIImageView *androidLeftLeg;
@property (weak, nonatomic) IBOutlet UIImageView *androidRightLeg;

// Other Elements
@property (weak, nonatomic) IBOutlet UIPickerView *picker;
@property (weak, nonatomic) IBOutlet UILabel *label;

#pragma mark - Regular Properties
@property (strong, nonatomic) HangmanGame *game;

#pragma mark - IBActions
- (IBAction)selectLetter:(UIButton *)sender;
- (IBAction)guessAnswer:(UIButton *)sender;
- (IBAction)hintButton:(UIButton *)sender;
- (IBAction)inputButton:(UIBarButtonItem *)sender;
- (IBAction)buttonButton:(UIBarButtonItem *)sender;







@end

