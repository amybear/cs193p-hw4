//
//  GameViewController.m
//  Matchismo
//
//  Created by Amy Bearman on 4/23/14.
//  Copyright (c) 2014 Amy Bearman. All rights reserved.
//

#import "GameViewController.h"
#import "PlayingCard.h"
#import "SetCard.h"
#import "PlayingCardView.h"
#import "CardGameViewController.h"
#import "SetGameViewController.h"

@interface GameViewController ()

@property (strong, nonatomic) IBOutlet UIButton *startNewGame;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (strong, nonatomic) UITapGestureRecognizer *tapRecognizer;

@end

@implementation GameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (!_game) _game = [[CardMatchingGame alloc] initWithCardCount:36 // Initialize the CardMatchingGame
                                                          usingDeck: [self createDeck]];
    
    [self.backgroundView setBackgroundColor:[UIColor clearColor]];
    self.scoreLabel.text = [NSString stringWithFormat:@"Score: %d", self.game.score];
    self.grid = [[Grid alloc] init];
    [self setUpGrid];
    [self setUpCards];
    
    self.tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction)];
    self.tapRecognizer.numberOfTapsRequired = 1;
    [self.backgroundView addGestureRecognizer:self.tapRecognizer];
}

- (void)tapAction {
    CGPoint point = [self.tapRecognizer locationInView:self.backgroundView];
    UIView *tappedView = [self.backgroundView hitTest:point withEvent:nil];
    if ([self isKindOfClass:[CardGameViewController class]]) {
        PlayingCardView *pcView = (PlayingCardView *)tappedView;
        int chosenCardIndex = (int)[self.cardViews indexOfObject:pcView]; // Retrieves the index of the chosen card
        [self.game chooseCardAtIndex:chosenCardIndex]; // Update the model to reflect that a card has been chosen
        [self updateAllCards]; // Should update the UI of all card views appropriately // TODO
        self.scoreLabel.text = [NSString stringWithFormat:@"Score: %ld", (long)self.game.score]; // Updates the score label accordingly
        
    } else if ([self isKindOfClass:[SetGameViewController class]]) {
        
    }
}

- (void)flipAllCards {
    for (PlayingCardView *pcView in self.cardViews) {
        if (pcView.faceUp) {
            [PlayingCardView transitionWithView:pcView
                                       duration:0.5
                                        options:UIViewAnimationOptionTransitionFlipFromRight
                                     animations:^{
                                         pcView.faceUp = NO;
                                     } completion:nil];
        }
    }
}

- (void)updateAllCards {
    for (PlayingCardView *pcView in self.cardViews) {
        NSUInteger cardViewIndex = [self.cardViews indexOfObject:pcView];
        Card *card = [self.game cardAtIndex:cardViewIndex];
        if ([self.game.lastCards containsObject:card]) {
            if (card.isChosen) {
                [PlayingCardView transitionWithView:pcView
                                           duration:0.5
                                            options:UIViewAnimationOptionTransitionFlipFromRight
                                         animations:^{
                                             pcView.faceUp = YES;
                                         } completion:nil];
            } else {
                [PlayingCardView transitionWithView:pcView
                                           duration:0.5
                                            options:UIViewAnimationOptionTransitionFlipFromRight
                                         animations:^{
                                             pcView.faceUp = NO;
                                         } completion:nil];
            }
        } else {
            if (card.isChosen) {
                pcView.faceUp = YES;
            } else {
                pcView.faceUp = NO;
            }
        }
    }
}

/* Reinitializes the CardMatchingGame object if the user restarts the game */
- (void)reinitializeGame {
    _game = [[CardMatchingGame alloc] initWithCardCount:[self.cardViews count]
                                              usingDeck: [self createDeck]];
    self.game.gameMode = 0; // Default 2-card playing mode
}

// Lazily instantiate the NSMutableArray of cardViews
- (NSMutableArray *)cardViews {
    if (!_cardViews) _cardViews = [[NSMutableArray alloc] init];
    return _cardViews;
}

- (void) setUpGrid {
    CGFloat width = self.backgroundView.frame.size.width;
    CGFloat height = self.backgroundView.frame.size.height;
    self.grid.size = CGSizeMake(width, height);
    self.grid.cellAspectRatio = 0.67;
    
    if ([self isKindOfClass:[CardGameViewController class]]) {
        self.grid.minimumNumberOfCells = 30;
    } else if ([self isKindOfClass:[SetGameViewController class]]) {
        self.grid.minimumNumberOfCells = 12;
    }
}

- (void) setUpCards { }
- (void) redrawCards { }

/*
 * Action method to handle the event that the user clicks on "Start New Game"
 */
- (IBAction)startNewGame:(UIButton *)sender {
    [self reinitializeGame]; // Redeal all cards by reinitializing the CardMatchingGame object
    [self flipAllCards];
    [self redrawCards];
    self.scoreLabel.text = [NSString stringWithFormat:@"Score: 0"]; // Resets the score label to 0
}

- (NSAttributedString *)titleForCard: (Card *)card { return nil; }
- (UIImage *)backgroundImageForCard:(Card *)card { return nil; }
- (Deck *)createDeck { return nil; }

@end
