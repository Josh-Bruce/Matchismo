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

- (void)resetGame
{
    // Create a new game by alloc and init a new set of cards
    self.game = nil;
    // Set our flipcount to 0
    self.flipCount = 0;
    // Set the textlabel to nil
    self.lastFlipResult.text = nil;
    // Set the difficulty button back to default
    self.gameDifficultySwitch.on = NO;
    // Enable user to toggle the game difficulty after dealing
    self.gameDifficultySwitch.enabled = YES;
    // Change our max value of our slider
    self.historySlider.maximumValue = 0;
    // Change our current value to max as well
    self.historySlider.value = 0;
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
        [cardButton setImage:[UIImage imageNamed:@"playing_card.png"] forState:UIControlStateNormal];
        [cardButton setTitle:@"" forState:UIControlStateNormal];
        if (card .isFaceUp) {
            // Setting to image to nil if the card isFaceUp
            [cardButton setImage:nil forState:UIControlStateNormal];
        }
    }
    
    // Set the score of the game in the label
    self.scoreLabel.text = [NSString stringWithFormat:@"Score: %d", self.game.score];
    // Update last move label
    self.lastFlipResult.text = self.game.lastMoveDescription;
    // Make sure the alpha is 1 on our label
    self.lastFlipResult.alpha = 1.0;
}

- (void)viewHistoryAtIndex:(NSUInteger)atIndex
{
    // Make sure there is some history first!
    if ([self.game.flipHistory count]) {
        // Set last move label to our point in history
        self.lastFlipResult.text = [self.game.flipHistory valueForKey:[NSString stringWithFormat:@"%d", atIndex]];
        // Set alpha to 0.3 so users know its history for all of the past and not the current move
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
    // Reset our game settings
    [self resetGame];
    // Update our UI
    [self updateUI];
}

- (IBAction)toggleGameType:(UISwitch *)sender
{
    // Turning the three card match game on and off
    self.game.threeCardMatch = (sender.isOn ? YES : NO);
}

- (IBAction)viewHistory:(UISlider *)sender
{
    // Get the point in history with the index as our slider value
    // roundl is used to get an integer value from the slider for our index
    [self viewHistoryAtIndex:roundl([sender value])];
}

@end