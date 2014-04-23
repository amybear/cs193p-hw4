//
//  CardGameViewController.m
//  Matchismo
//
//  Created by Amy Bearman on 4/3/14.
//  Copyright (c) 2014 Amy Bearman. All rights reserved.
//

#import "CardGameViewController.h"
#import "Deck.h"
#import "PlayingCardDeck.h"
#import "PlayingCard.h"
#import "GameViewController.h"
#import "PlayingCardView.h"

@interface CardGameViewController ()
@end

#define NUM_CARDS 30;

@implementation CardGameViewController

/* Initializes UI of game for each time the CardGameViewController is loaded,
 * and sets the game mode by be 2-card playing mode */
- (void)viewDidLoad {
    [super viewDidLoad];
    self.game.gameMode = 0; // 2-card playing mode, by default
}

/*
 * Method to allocate memory for the deck @property with a PlayingCardDeck
 */
- (Deck *)createDeck {
    return [[PlayingCardDeck alloc] init];
}

- (NSMutableAttributedString *)getCardAttributedContents:(Card *)card {
    NSMutableAttributedString *contents = [[NSMutableAttributedString alloc] initWithString:card.contents];
    PlayingCard *pc = (PlayingCard *)card;
    if ([pc.suit isEqualToString:@"♥︎"] || [pc.suit isEqualToString:@"♦︎"]) {
        [contents addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(0, [contents length])];
    } else {
        [contents addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(0, [contents length])];
    }
    return contents;
}

/* Helper method that returns the title of a card: either its contents, or the empty string,
depending on whether or not the card was flipped over */
- (NSMutableAttributedString *)titleForCard:(Card *)card {
    NSMutableAttributedString *contents = [self getCardAttributedContents:card];
    return card.isChosen ? contents: [[NSMutableAttributedString alloc] initWithString:@""];
}

/* Helper method that returns the background impage of a card: either cardfront or cardback */
- (UIImage *)backgroundImageForCard:(Card *)card {
    return [UIImage imageNamed:card.isChosen ? @"cardfront": @"cardback"];
}


@end
