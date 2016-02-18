//
//  ViewController.m
//  Hangman
//
//  Created by Magfurul Abeer on 1/14/16.
//  Copyright © 2016 Magfurul Abeer. All rights reserved.
//
//

#import "ViewController.h"
#import "InputViewController.h"
#import "ButtonViewController.h"

@interface ViewController ()

@end



@implementation ViewController


#pragma mark - View Controller Methods

- (void)viewDidLoad {
    [super viewDidLoad];
  //@[ @"Flatiron", @"Hello", @"World"];
    self.game = [[HangmanGame alloc] init];
    [self newGame];
}

-(void)viewDidAppear:(BOOL)animated {
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
        [self removeRowWithLetter:letter];
    }
}

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
    
    // Reload the picker in case it's a new game
    // TODO: Possibly add check to see if new game. Not significant though.
    [self.picker reloadAllComponents];
    
    // Set label to new string
    self.label.text = self.game.displayString;
    
    // Hide all android body parts except head
    self.androidBody.hidden = YES;
    self.androidLeftArm.hidden = YES;
    self.androidLeftLeg.hidden = YES;
    self.androidRightArm.hidden = YES;
    self.androidRightLeg.hidden = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}



# pragma mark - Picker methods

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return [self.game.alphabet count];
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return self.game.alphabet[row];
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
    [self removeRowWithLetter:letter];
}


-(void)removeRowWithLetter:(NSString *)letter {
    [self.game.alphabet removeObject:letter];
    [self.picker reloadAllComponents];
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





#pragma mark - Prepare for Segue

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:@"InputViewControllerSegue"]) {
        InputViewController *nextViewController = segue.destinationViewController;
        nextViewController.game = self.game;
    }
    
    if ([segue.identifier isEqualToString:@"ButtonViewControllerSegue"]) {
        ButtonViewController *nextViewController = segue.destinationViewController;
        nextViewController.game = self.game;
    }
}







# pragma mark - Button Actions

- (IBAction)selectLetter:(UIButton *)sender {
    NSString *letter = [self pickerView:self.picker titleForRow:[self.picker selectedRowInComponent:0] forComponent:0];
    // TODO: Check if letter matches string then change accordingly
    [self checkIfLetterIsInWord:letter];
}

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

- (IBAction)inputButton:(UIBarButtonItem *)sender {
    [self performSegueWithIdentifier:@"InputViewControllerSegue" sender:nil];
}

- (IBAction)buttonButton:(UIBarButtonItem *)sender {
    [self performSegueWithIdentifier:@"ButtonViewControllerSegue" sender:nil];

}

























@end
