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
//        UIImage *cardBack = [UIImage imageNamed:@"playing_card.png"];
//        [cardButton setTitle:@"" forState:UIControlStateNormal];
//        [cardButton setImage:cardBack forState:UIControlStateNormal];
//        if (card .isFaceUp) {
//            [cardButton setImage:nil forState:UIControlStateNormal];
//        }
    }
    self.scoreLabel.text = [NSString stringWithFormat:@"Score: %d", self.game.score];
    
    if ([self.game.lastFlip count] == 2) {
        self.lastFlipResult.text = [NSString stringWithFormat:@"Matched %@%@%d%@", [self.game.lastFlip componentsJoinedByString:@" & "], @"for ", self.game.pointsScored, @" points"];
        [self.game.lastFlip removeAllObjects];
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
}

@end