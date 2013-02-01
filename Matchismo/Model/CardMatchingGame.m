//
//  CardMatchingGame.m
//  Matchismo
//
//  Created by Josh Bruce on 30/01/2013.
//  Copyright (c) 2013 SurfTrack. All rights reserved.
//

#import "CardMatchingGame.h"

@interface CardMatchingGame ()
@property (readwrite, nonatomic) int score;
@property (nonatomic) int historyCount;
@property (strong, nonatomic) NSMutableArray *cards; // of Card
@end

@implementation CardMatchingGame

// Lazy instantiation for cards
- (NSMutableArray *)cards
{
    if (!_cards) {
        _cards = [[NSMutableArray alloc] init];
    }
    
    return _cards;
}

- (NSMutableDictionary *)flipHistory
{
    if (!_flipHistory) {
        _flipHistory = [[NSMutableDictionary alloc] init];
    }
    
    return _flipHistory;
}

#define MATCH_BONUS 4
#define MISMATCH_PENALTY 2
#define FLIP_COST 1

- (void)flipCardAtIndex:(NSUInteger)index
{
    Card *card = [self cardAtIndex:index];
    
    if (card && !card.isUnplayable) {
        if (!card.isFaceUp) {
            for (Card *otherCard in self.cards) {
                if (otherCard.isFaceUp && !otherCard.isUnplayable) {
                    int matchScore = [card match:@[otherCard]];
                    if (matchScore) {
                        card.unplayable = YES;
                        otherCard.unplayable = YES;
                        self.score += matchScore * MATCH_BONUS;
                        // Create the description of the move when there is a match
                        self.lastMoveDescription = [NSString stringWithFormat:@"Matched %@%@%@%@%d%@", card.contents, @" & ", otherCard.contents, @" for ", matchScore * MATCH_BONUS, @" points"];
                    } else {
                        otherCard.faceUp = NO;
                        self.score -= MISMATCH_PENALTY;
                        // Create the description of the move when there is a mismatch
                        self.lastMoveDescription = [NSString stringWithFormat:@"%@%@%@%@%d%@", card.contents, @" & ", otherCard.contents, @" don't match! ", MISMATCH_PENALTY, @" point penalty!"];
                    } 
                    break;
                } else {
                    // Create the description of the move when a card is flipped up
                    self.lastMoveDescription = [NSString stringWithFormat:@"Flipped up %@", card.contents];
                }
            }
            self.score -= FLIP_COST;
            // Add the description of the move to our dictionary of history
            [self.flipHistory setValue:self.lastMoveDescription forKey:[NSString stringWithFormat:@"%d", self.historyCount++]];
        }
        card.faceUp = !card.isFaceUp;
    }
}

- (Card *)cardAtIndex:(NSUInteger)index
{
    return (index < [self.cards count]) ? self.cards[index] : nil;
}

- (id)initWithCardCount:(NSUInteger)count usingDeck:(Deck *)deck
{
    self = [super init];
    
    if (self) {
        for (int i = 0; i < count; i++) {
            Card *card = [deck drawRandomCard];
            if (card) {
                self.cards[i] = card;
            } else {
                self = nil;
                break;
            }
        }
    }
    
    return self;
}

@end