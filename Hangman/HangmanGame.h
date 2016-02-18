//
//  HangmanGame.h
//  Hangman
//
//  Created by Magfurul Abeer on 2/16/16.
//  Copyright © 2016 Magfurul Abeer. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HangmanGame : NSObject

// Current word to guess
@property (strong, nonatomic) NSString *currentWord;

// String that will actually be displayed
@property (strong, nonatomic) NSMutableString *displayString;

// Number of strikes you currently have (5 to lose)
@property (nonatomic) NSUInteger strikes;

// Current letters left
@property (strong, nonatomic) NSMutableArray *alphabet;
@property (strong, nonatomic) NSMutableArray *usedLetters;
@property (strong, nonatomic) NSArray *wordList;
@property (strong, nonatomic) NSDictionary *wordDictionary;
@property (strong, nonatomic) NSString *currentWordUnchanged;
@property (strong, nonatomic) NSMutableArray *spaceIndexes;

-(instancetype)init;
-(void)newGame;
-(BOOL)letterIsInWord:(NSString *)letter;
-(void)incrementStrikes;
@end
