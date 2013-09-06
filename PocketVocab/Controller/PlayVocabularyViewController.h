//
//  PlayVocabularyViewController.h
//  PocketVocab
//
//  Created by Kiss Rudolf Zsolt on 2013.09.04..
//  Copyright (c) 2013 Kiss Rudolf Zsolt. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "WordCard.h"
#import "Vocabulary.h"

#import <Slt/Slt.h>
#import <OpenEars/FliteController.h>

@interface PlayVocabularyViewController : UIViewController <WordCardDelegate>

@property(nonatomic, strong) FliteController *fliteController;
@property(nonatomic, strong) Slt *slt;

- (id)initWithVocabulary:(Vocabulary *)vocabulary;

@end
