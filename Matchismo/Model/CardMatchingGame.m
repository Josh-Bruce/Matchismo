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
@property (readwrite, nonatomic) int pointsScored;
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

- (NSMutableArray *)lastFlip
{
    if (!_lastFlip) {
        _lastFlip = [[NSMutableArray alloc] init];
    }
    
    return _lastFlip;
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
                        self.pointsScored = matchScore * MATCH_BONUS;
                        [self.lastFlip addObjectsFromArray:@[card.contents, otherCard.contents]];
                    } else {
                        otherCard.faceUp = NO;
                        self.score -= MISMATCH_PENALTY;
                        self.pointsScored = MISMATCH_PENALTY;
                        [self.lastFlip addObjectsFromArray:@[card.contents, otherCard.contents]];
                    }
                    break;
                }
            }
            self.score -= FLIP_COST;
            if (![self.lastFlip count]) {
                [self.lastFlip addObject:card.contents];
                self.pointsScored = FLIP_COST;
            }
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