//
//  PlayingCard.h
//  Matchismo
//
//  Created by Josh Bruce on 28/01/2013.
//  Copyright (c) 2013 SurfTrack. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Card.h"

@interface PlayingCard : Card

@property (strong, nonatomic) NSString *suit;
@property (nonatomic) NSUInteger rank;

+ (NSArray *)validSuits;
+ (NSUInteger)maxRank;

@end