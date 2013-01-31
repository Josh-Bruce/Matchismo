//
//  CardGameViewController.m
//  Matchismo
//
//  Created by Josh Bruce on 28/01/2013.
//  Copyright (c) 2013 SurfTrack. All rights reserved.
//

#import "CardGameViewController.h"
#import "PlayingCardDeck.h"
#import "CardMatchingGame.h"

@interface CardGameViewController ()
@property (weak, nonatomic) IBOutlet UILabel *flipsLabel;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *lastFlipResult;
@property (weak, nonatomic) IBOutlet UISlider *historySlider;
@property (weak, nonatomic) IBOutlet UISwitch *gameDifficultySwitch;
@property (nonatomic) int flipCount;
@property (strong, nonatomic) CardMatchingGame *game;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *cardButtons;
@end

@implementation CardGameViewController

// Lazy instantiation of our game
- (CardMatchingGame *)game
{
    if (!_game) {
        _game = [[CardMatchingGame alloc] initWithCardCount:[self.cardButtons count] usingDeck:[[PlayingCardDeck alloc] init]];
    }
    
    return _game;
}

- (void)setCardButtons:(NSArray *)cardButtons
{
    _cardButtons = cardButtons;
    [self updateUI];
}

- (void)updateUI
{
    for (UIButton *cardButton in self.cardButtons) {
        Card *card = [self.game cardAtIndex:[self.cardButtons indexOfObject:cardButton]];
        [cardButton setTitle:card.contents forState:UIControlStateSelected];
        [cardButton setTitle:card.contents forState:UIControlStateSelected|UIControlStateDisabled];
        cardButton.selected = card.isFaceUp;
        cardButton.enabled = !card.isUnplayable;
        cardButton.alpha = (card.isUnplayable ? 0.3 : 1.0);
        
        // Setting the background of the card
        // Un-comment if you wish you to use the playing card background
        [cardButton setImage:[UIImage imageNamed:@"playing_card.png"] forState:UIControlStateNormal];
        [cardButton setTitle:@"" forState:UIControlStateNormal];
        if (card .isFaceUp) {
            [cardButton setImage:nil forState:UIControlStateNormal];
        }
    }
    self.scoreLabel.text = [NSString stringWithFormat:@"Score: %d", self.game.score];
    
    // Using the cards in an NSMutableArray inserted by the model and displaying their points
    if ([self.game.lastFlip count] && self.game.pointsScored == 16) {
        self.lastFlipResult.text = [NSString stringWithFormat:@"Matched %@%@%d%@", [self.game.lastFlip componentsJoinedByString:@" & "], @"for ", self.game.pointsScored, @" points"];
    } else if ([self.game.lastFlip count] && self.game.pointsScored == 4) {
        self.lastFlipResult.text = [NSString stringWithFormat:@"Matched %@%@%d%@", [self.game.lastFlip componentsJoinedByString:@" & "], @"for ", self.game.pointsScored, @" points"];
    } else if ([self.game.lastFlip count] && self.game.pointsScored == 2) {
        self.lastFlipResult.text = [NSString stringWithFormat:@"%@%@%d%@", [self.game.lastFlip componentsJoinedByString:@" & "], @" don't match! ", self.game.pointsScored, @" point penalty!"];
    } else if ([self.game.lastFlip count] && self.game.pointsScored == 1) {
        self.lastFlipResult.text = [NSString stringWithFormat:@"Flipped up %@", [self.game.lastFlip lastObject]];
    }

    [self.game.lastFlip removeAllObjects];
}

- (void)viewHistoryAtIndex:(NSUInteger)atIndex
{
    // Create an array from our dictionary of history and use the index from the slider
    NSMutableArray *pointInHistory = [[self.game.flipHistory valueForKey:[NSString stringWithFormat:@"%d", atIndex]] mutableCopy];
    // Get the points score from the end of the array
    NSString  *points = [pointInHistory lastObject];
    // Remove the points from the end of the array
    [pointInHistory removeObjectAtIndex:[pointInHistory count] - 1];
    // Go through each combination
    if ([pointInHistory count]) {
        if ([pointInHistory count] == 1) {
            self.lastFlipResult.text = [NSString stringWithFormat:@"Flipped up %@", [pointInHistory lastObject]];
        } else if ([pointInHistory count] == 2 && [points isEqualToString:@"16"]) {
            self.lastFlipResult.text = [NSString stringWithFormat:@"Matched %@%@%@%@", [pointInHistory componentsJoinedByString:@" & "], @"for ", points, @" points"];
        } else if ([pointInHistory count] == 2 && [points isEqualToString:@"4"]) {
            self.lastFlipResult.text = [NSString stringWithFormat:@"Matched %@%@%@%@", [pointInHistory componentsJoinedByString:@" & "], @"for ", points, @" points"];
        } else if ([pointInHistory count] == 2 && [points isEqualToString:@"2"]) {
            self.lastFlipResult.text = [NSString stringWithFormat:@"%@%@%@%@", [pointInHistory componentsJoinedByString:@" & "], @" don't match! ", points, @" point penalty!"];
        }
        // Set alpha to 0.3 so users know its history
        self.lastFlipResult.alpha = (atIndex != [self.game.flipHistory count] - 1 ? 0.3 : 1.0);
    }
}

- (void)setFlipCount:(int)flipCount
{
    // Set instance variable value to the new set value
    _flipCount = flipCount;
    // Update the label when we set our property
    self.flipsLabel.text = [NSString stringWithFormat:@"Flips: %d", self.flipCount];
}

- (IBAction)flipCard:(UIButton *)sender
{
    // Flip a new card with the index of our sender card
    [self.game flipCardAtIndex:[self.cardButtons indexOfObject:sender]];
    // Incremenet out flip countere
    self.flipCount++;
    // Set the toggle game difficulty switch to disabled
    self.gameDifficultySwitch.enabled = NO;
    // Change our max value of our slider
    self.historySlider.maximumValue = [self.game.flipHistory count] - 1;
    // Change our current value to max as well
    self.historySlider.value = [self.game.flipHistory count] - 1;
    // Update our UI
    [self updateUI];
}

- (IBAction)dealNewGame:(UIButton *)sender
{
    // Create a new game by alloc and init a new set of cards
    //self.game = [[CardMatchingGame alloc] initWithCardCount:[self.cardButtons count] usingDeck:[[PlayingCardDeck alloc] init]];
    self.game = nil;
    // Set our flipcount to 0
    self.flipCount = 0;
    // Set the textlabel to nil
    self.lastFlipResult.text = nil;
    // Update our UI
    [self updateUI];
    // Enable user to toggle the game difficulty after dealing
    self.gameDifficultySwitch.enabled = YES;
    // Change our max value of our slider
    self.historySlider.maximumValue = 0;
    // Change our current value to max as well
    self.historySlider.value = 0;
}

- (IBAction)toggleGameType:(UISwitch *)sender
{

}

- (IBAction)viewHistory:(UISlider *)sender
{
    // Get the point in history with the index as our slider value
    [self viewHistoryAtIndex:roundl([sender value])];
}

@end