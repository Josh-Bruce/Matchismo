//
//  CardGameViewController.m
//  Matchismo
//
//  Created by Josh Bruce on 28/01/2013.
//  Copyright (c) 2013 SurfTrack. All rights reserved.
//

#import "CardGameViewController.h"
#import "PlayingCardDeck.h"

@interface CardGameViewController ()
@property (weak, nonatomic) IBOutlet UILabel *flipsLabel;
@property (nonatomic) int flipCount;
@property (strong, nonatomic) PlayingCardDeck *deck;
@end

@implementation CardGameViewController

// Lazy instantiate our PlayingCardDeck
- (PlayingCardDeck *)deck
{
    if (!_deck) {
        _deck = [[PlayingCardDeck alloc] init];
    }
    
    return _deck;
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
    // Toggle the selected state of the card
    sender.selected = !sender.isSelected;
    
    if (sender.selected) {
        // Draw a random card from our deck of cards
        Card *card = [self.deck drawRandomCard];
        if (card) {
            // Increment the flipCount by 1, calls the Getter and Setter
            self.flipCount++;
            // Set the title of the selected card to be our playing card
            [sender setTitle:[card contents] forState:UIControlStateSelected];
        }
    }
}

@end