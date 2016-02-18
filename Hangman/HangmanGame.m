//
//  HangmanGame.m
//  Hangman
//
//  Created by Magfurul Abeer on 2/16/16.
//  Copyright © 2016 Magfurul Abeer. All rights reserved.
//

#import "HangmanGame.h"

@implementation HangmanGame

- (instancetype)init
{
    self = [super init];
    if (self) {
        // Import dictionary from pList
        NSURL *url = [[NSBundle mainBundle] URLForResource:@"words" withExtension:@"plist"];
        self.wordDictionary = [[NSDictionary alloc] initWithContentsOfURL:url];
        
        self.wordList = [self.wordDictionary allKeys];
    }
    return self;
}

// Chooses a random word and displays it
// TODO: Reset buttons and picker items. Hide body parts.
-(void)newGame {
    
//    NSLog(@"%@", self.wordDictionary);
//    NSLog(@"%@", self.wordList);
    self.usedLetters = [[NSMutableArray alloc] init];
    // Initialize new alphabet
    self.alphabet = [[@"A B C D E F G H I J K L M N O P Q R S T U V W X Y Z" componentsSeparatedByString:@" "] mutableCopy];
    
    // Initalize array for space index
    self.spaceIndexes = [@[] mutableCopy];
    
    // Select random word
    self.currentWord = [self randomWord];
    
    // Convert word into string of underscores and spaces
    self.displayString = [@"" mutableCopy];
    
    for (NSUInteger i = 0; i < [self.currentWord length]; i++) {
        
        NSString *character = [NSString stringWithFormat:@"%c", [self.currentWord characterAtIndex:i] ];
        
        // If char is a space, keep index in array and replace the string character with 2 spaces
        if ( [character isEqualToString:@" "] ) {
            [self.spaceIndexes addObject:@(i)];
            self.displayString = [[self.displayString stringByAppendingString:@"  "] mutableCopy];
        } else {
            self.displayString = [[self.displayString stringByAppendingString:@" _"] mutableCopy];
        }
        
    }
    
    // Set strikes to 0
    self.strikes = 0;
    
//    NSLog(@"%@", self.spaceIndexes);
}


-(BOOL)letterIsInWord:(NSString *)letter {
    [self.usedLetters addObject:letter];
    [self.alphabet removeObject:letter];
    // If word contains the letter then ...
    if ([self.currentWord containsString:letter]) {
        
        // Go through each letter
        for (NSUInteger i = 0; i < [self.currentWord length]; i++) {
            
            NSString *character = [NSString stringWithFormat:@"%c", [self.currentWord characterAtIndex:i]];
            // If letter matches up with the selected letter, then
            // 1. Replace the appropriate underscore with the letter
            // 2. Remove letter from the current alphabet array
            if ([character isEqualToString:letter]) {
                NSUInteger index = [self convertIndexToUnderscorePosition:i];
                [self.displayString replaceCharactersInRange:NSMakeRange(index, 1) withString:letter];
//                NSLog(@"%lu", index);
            }
        }
        return YES;
    }
    [self incrementStrikes];
    return NO;
}

-(void)incrementStrikes {
    self.strikes++;
}


#pragma mark - Helper Methods

-(NSString *)randomWord {
    NSUInteger rand = arc4random() % [self.wordList count];
    self.currentWordUnchanged = self.wordList[rand];
    NSString *uppercaseRandomWord = [self.currentWordUnchanged uppercaseString];
    return uppercaseRandomWord;
}

// Unnecessary for the most part now
-(NSUInteger)convertIndexToUnderscorePosition:(NSUInteger)index {
    
    // Default algorithm if word has no spaces or character is before any spaces
    NSUInteger underscorePosition = index * 2 + 1;
    
    return underscorePosition;
}

-(NSString *)description {
    NSString *desc = [NSString stringWithFormat:@"%@\n%@%@\n%@%@\n%@%lu\n%@%@",
                      @"HANGMAN GAME",
                      @"Current Word: ", self.currentWord,
                      @"Display String: ", self.displayString,
                      @"Strikes: ", self.strikes,
                      @"Alphabet Left: ", self.alphabet];
    return desc;
}
@end
