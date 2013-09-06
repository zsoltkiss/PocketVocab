//
//  WordCard.h
//  PocketVocab
//
//  Created by Kiss Rudolf Zsolt on 2013.08.31..
//  Copyright (c) 2013 Kiss Rudolf Zsolt. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DailyWord.h"
#import "LanguagePair.h"

@class WordCard;

//mivel egy animacio befejezodesekor valt at a statusz (masik szal!), celszeru delegate pattern alkalmazasaval ertesiteni a parent view-t hogy atfordult a kartya
@protocol WordCardDelegate <NSObject>

- (void)wordCard:(WordCard *)someCard changedStateTo:(WordCardState)newState;

@end


@interface WordCard : UIView

@property(nonatomic, weak) id<WordCardDelegate> delegate;

- (id)initWithFrame:(CGRect)frame languages:(LanguagePair *)languagePair;

- (void)updateContent:(DailyWord *)newContent;

- (void)flip;

- (void)revealCardAnimated:(BOOL)animated;
- (void)hideCardAnimated:(BOOL)animated;

- (void)toggleState;

@end
