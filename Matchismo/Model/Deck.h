//
//  Deck.h
//  Matchismo
//
//  Created by Josh Bruce on 28/01/2013.
//  Copyright (c) 2013 SurfTrack. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Card.h"

@interface Deck : NSObject

- (void)addCard:(Card *)card atTop:(BOOL)atTop;
- (Card *)drawRandomCard;

@end