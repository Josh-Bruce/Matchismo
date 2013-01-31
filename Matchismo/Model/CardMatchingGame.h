//
//  CardMatchingGame.h
//  Matchismo
//
//  Created by Josh Bruce on 30/01/2013.
//  Copyright (c) 2013 SurfTrack. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Card.h"
#import "Deck.h"

@interface CardMatchingGame : NSObject

@property (readonly, nonatomic) int score;
@property (readonly, nonatomic) int pointsScored;
@property (strong, nonatomic) NSMutableArray *lastFlip;
@property (strong, nonatomic) NSMutableDictionary *flipHistory;

// Designated initializer
- (id)initWithCardCount:(NSUInteger)count usingDeck:(Deck *)deck;
- (void)flipCardAtIndex:(NSUInteger)index;
- (Card *)cardAtIndex:(NSUInteger)index;

@end