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

@property (nonatomic, getter=isThreeCardMatch) BOOL threeCardMatch;
@property (readonly, nonatomic) int score;
@property (strong, nonatomic) NSString *lastMoveDescription;
@property (strong, nonatomic) NSMutableDictionary *flipHistory;

// Designated initializer
- (id)initWithCardCount:(NSUInteger)count usingDeck:(Deck *)deck;
- (void)flipCardAtIndex:(NSUInteger)index;
- (Card *)cardAtIndex:(NSUInteger)index;

@end