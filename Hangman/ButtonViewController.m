//
//  ButtonViewController.m
//  Hangman
//
//  Created by Magfurul Abeer on 1/28/16.
//  Copyright © 2016 Magfurul Abeer. All rights reserved.
//

#import "ButtonViewController.h"

@interface ButtonViewController ()

@end

@implementation ButtonViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.buttons = @[self.buttonA, self.buttonB, self.buttonC, self.buttonD, self.buttonE,
                     self.buttonF, self.buttonG, self.buttonH, self.buttonI, self.buttonJ,
                     self.buttonK, self.buttonL, self.buttonM, self.buttonN, self.buttonO,
                     self.buttonP, self.buttonQ, self.buttonR, self. buttonS, self.buttonT,
                     self.buttonU, self.buttonV, self.buttonW, self.buttonX, self.buttonY,
                     self.buttonZ];
    [self updateViewElements];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Game Helper Methods

-(void)updateViewElements {
    NSLog(@"%@", self.game);
    // Set label to new string
    self.label.text = self.game.displayString;
    
    // Hide all android body parts except head
    self.androidBody.hidden = YES;
    self.androidLeftArm.hidden = YES;
    self.androidLeftLeg.hidden = YES;
    self.androidRightArm.hidden = YES;
    self.androidRightLeg.hidden = YES;
    
    NSUInteger numberOfStrikes = self.game.strikes;
    self.game.strikes = 0;
    for (NSUInteger i = 0; i < numberOfStrikes; i++) {
        self.game.strikes++;
        [self addToHangman];
    }
    
    for (NSString *letter in self.game.usedLetters) {
        for (UIButton* button in self.buttons) {
            if ([button.titleLabel.text isEqualToString:letter]) {
                button.enabled = NO;
                button.backgroundColor = [UIColor grayColor];
                break;
            }
        }
    }
}

-(void)newGame {
    [self.game newGame];
    for (UIButton *button in self.buttons) {
        NSLog(@"dtgfhjbkn");
        button.enabled = YES;
        button.backgroundColor = [UIColor colorWithRed:137/255.0 green:197/255.0 blue:22/255.0 alpha:1.0];
    }
    // Set label to new string
    self.label.text = self.game.displayString;
    
    // Hide all android body parts except head
    self.androidBody.hidden = YES;
    self.androidLeftArm.hidden = YES;
    self.androidLeftLeg.hidden = YES;
    self.androidRightArm.hidden = YES;
    self.androidRightLeg.hidden = YES;
}

-(void)gameOverByWin:(BOOL)playerWon {
    //    NSLog(@"GAME OVER: %d", playerWon);
    NSString *title;
    NSString *msg;
    if (playerWon) {
        title = @"You win!";
        msg = [NSString stringWithFormat:@"You won!\nThe answer was '%@'!", self.game.currentWord];
    } else {
        title = @"Game Over";
        msg = [NSString stringWithFormat:@"You lost!\nThe answer was '%@'!", self.game.currentWord];
        
    }
    
    UIAlertController *gameOverAlert = [UIAlertController alertControllerWithTitle:title message:msg preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *restart = [UIAlertAction actionWithTitle:@"Restart" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
        [self newGame];
    }];
    
    [gameOverAlert addAction:restart];
    
    [self presentViewController:gameOverAlert animated:YES completion:nil];
    
}



-(void)winCheck {
    //    NSLog(@"WINCHECK");
    NSMutableString *whatTheyGot = [[self.game.displayString stringByReplacingOccurrencesOfString:@" " withString:@""] mutableCopy];
    NSMutableString *whatItShouldBe = [[self.game.currentWord stringByReplacingOccurrencesOfString:@" " withString:@""] mutableCopy];
    if ([whatTheyGot length] < [self.game.displayString length]) {
        for (NSNumber *indexOfSpace in self.game.spaceIndexes) {
            NSUInteger i = [indexOfSpace integerValue];
            //        NSLog(@"i is %lu", i);
            [whatTheyGot insertString:@" " atIndex:i];
        }
    }
    
    //    NSLog(@"WHATTHEYGOT: %@", whatTheyGot);
    //    NSLog(@"WHATITSHOULDBE: %@", whatItShouldBe);
    whatTheyGot = [[whatTheyGot stringByReplacingOccurrencesOfString:@" " withString:@""] mutableCopy];
    if ([whatTheyGot isEqualToString:whatItShouldBe]) {
        [self gameOverByWin:YES];
    }
}


-(void)checkIfLetterIsInWord:(NSString *)letter {
    BOOL correct = [self.game letterIsInWord:letter];
    if (correct) {
        [self updateDisplay];
        [self winCheck];
    } else {
        [self addToHangman];
    }
}



-(void)updateDisplay {
    self.label.text = self.game.displayString;
}

-(void)addToHangman {
    switch (self.game.strikes) {
        case 1:
            self.androidBody.hidden = NO;
            break;
        case 2:
            self.androidLeftArm.hidden = NO;
            break;
        case 3:
            self.androidRightArm.hidden = NO;
            break;
        case 4:
            self.androidLeftLeg.hidden = NO;
            break;
        case 5:
            self.androidRightLeg.hidden = NO;
            [self gameOverByWin:NO];
            break;
        default:
            break;
    }
}

#pragma mark - IBActions

- (IBAction)guessAnswer:(UIButton *)sender {
    // Initialize Alert
    UIAlertController *guessAnswerAlert = [UIAlertController alertControllerWithTitle:@"Guess Answer" message:@"Try to guess the answer? If you're wrong, you lose!" preferredStyle:UIAlertControllerStyleAlert];
    
    [guessAnswerAlert addTextFieldWithConfigurationHandler:^(UITextField *textfield) {
        textfield.placeholder = @"Make a guess";
    }];
    
    // Initialize Alert Actions
    // TODO: Add lose function
    UIAlertAction *guess = [UIAlertAction actionWithTitle:@"Guess" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
        // Grab the textfield
        UITextField *textfield = guessAnswerAlert.textFields.firstObject;
        
        // Grab the text and make it uppercase
        NSString *playerGuess = [textfield.text uppercaseString];;
        
        // Set it to the display string
        self.game.displayString = [playerGuess mutableCopy];
        
        // Check for win
        [self winCheck];
        
        [self gameOverByWin:NO];
        
    }];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {}];
    
    // Add actions to Alert
    [guessAnswerAlert addAction:cancel];
    [guessAnswerAlert addAction:guess];
    
    [self presentViewController:guessAnswerAlert animated:YES completion:nil];
}



- (IBAction)hintButton:(UIButton *)sender {
    NSString *leHint = [NSString stringWithFormat:@"HINT: %@", self.game.wordDictionary[self.game.currentWordUnchanged]];
    
    UIAlertController *hint = [UIAlertController alertControllerWithTitle:@"Hint" message:leHint preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {}];
    
    [hint addAction:ok];
    
    [self presentViewController:hint animated:YES completion:nil];
}



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)buttonTapped:(UIButton *)sender {
    NSString *input = sender.titleLabel.text;
    [self checkIfLetterIsInWord:input];
    sender.enabled = NO;
    sender.backgroundColor = [UIColor grayColor];
}
@end
