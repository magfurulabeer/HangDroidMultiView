//
//  InputViewController.m
//  Hangman
//
//  Created by Magfurul Abeer on 1/28/16.
//  Copyright © 2016 Magfurul Abeer. All rights reserved.
//

#import "InputViewController.h"
#import "ViewController.h"

@interface InputViewController ()

@end

@implementation InputViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.textfield.delegate = self;
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
}

-(void)newGame {
    [self.game newGame];
    
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
//    [self removeRowWithLetter:letter];
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


#pragma mark - Input Methods 

-(BOOL)textFieldShouldClear:(UITextField *)textField {
    self.textfield.text = @"";
    return YES;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    NSString *input = [textField.text uppercaseString];
    
    if ([self isValidInput:input]) {
        [self checkIfLetterIsInWord:input];
    } else {
        NSString *alertMessage = [self alreadyUsed:input] ? @"Letter already used!" : @"Please enter a single letter.";
        UIAlertController *invalidInput = [UIAlertController alertControllerWithTitle:@"Invalid Input" message:alertMessage preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
        [invalidInput addAction:ok];
        [self presentViewController:invalidInput animated:YES completion:nil];
    }
    self.textfield.text = @"";
    return YES;
}

#pragma mark - Helper Methods

-(BOOL)isValidInput:(NSString *)input {
    if ([self.game.alphabet containsObject:input]) {
        return YES;
    }
    return NO;
}

-(BOOL)alreadyUsed:(NSString *)input {
    if ([self.game.usedLetters containsObject:input]) {
        return YES;
    }
    return NO;
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



#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    if ([[segue.destinationViewController class] isKindOfClass:[ViewController class]]) {
        ViewController *nextViewController = segue.destinationViewController;
        nextViewController.game = self.game;
    }
}


@end
