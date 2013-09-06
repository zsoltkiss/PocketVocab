//
//  PlayVocabularyViewController.m
//  PocketVocab
//
//  Created by Kiss Rudolf Zsolt on 2013.09.04..
//  Copyright (c) 2013 Kiss Rudolf Zsolt. All rights reserved.
//

#import "PlayVocabularyViewController.h"

@interface PlayVocabularyViewController () {
    WordCard *_card;
    UIButton *_btnStartStop;
    
    BOOL _isPlaying;
    
    BOOL _shouldPausePlaying;
    
    Vocabulary *_vocab;
    
    NSInteger _nextIndex;
}

- (void)startStopPlaying:(id)sender;

- (DailyWord *)nextWord;

- (void)playNextWord;

@end

@implementation PlayVocabularyViewController

#pragma mark - private methods

- (void)startStopPlaying:(id)sender {
    if(!_isPlaying) {
        
        _shouldPausePlaying = NO;
        [self playNextWord];
        
        [_btnStartStop setTitle:@"Leállítás" forState:UIControlStateNormal];
        _isPlaying = YES;
    } else {
        
        _shouldPausePlaying = YES;
        [_btnStartStop setTitle:@"Lejátszás" forState:UIControlStateNormal];
        _isPlaying = NO;
    }
}

- (DailyWord *)nextWord {
    DailyWord *nextWord = nil;
    
    if(_nextIndex < [_vocab.words count]) {
        nextWord = [_vocab.words objectAtIndex:_nextIndex];
    }
    
    _nextIndex++;
    
    if(_nextIndex == [_vocab.words count]) {
        _nextIndex = 0;
    }
    
    return nextWord;
}

- (void)playNextWord {
    if(!_shouldPausePlaying) {
        
        DailyWord *dw = [self nextWord];
        [_card updateContent:dw];
        
        NSString *textToRead = (dw.usageSample != nil && dw.usageSample.length > 0) ? [NSString stringWithFormat:@"%@. %@", dw.word, dw.usageSample] : dw.word;
        
        float delayToUseBeforeHiding = (dw.usageSample.length > 0) ? 8.0f : 4.0f;
        
        [self.fliteController say:textToRead withVoice:self.slt];
        
        [_card revealCardAnimated:YES];
        
        [_card performSelector:@selector(flip) withObject:nil afterDelay:2];
        
        [_card performSelector:@selector(hideCardAnimated:) withObject:nil afterDelay:delayToUseBeforeHiding];
        
    }
    
}

#pragma mark - view lifecycle
- (id)initWithVocabulary:(Vocabulary *)vocabulary {
    self = [super initWithNibName:nil bundle:nil];
    
    if(self) {
        _vocab = vocabulary;
    }
    
    return self;
    
}

- (void)loadView {
    self.title = @"Player";
    
    self.fliteController = [[FliteController alloc]init];
    self.slt = [[Slt alloc]init];
    
    //itt minel nagyobb erteket allitunk be, annal lassabban fogja mondani
    self.fliteController.duration_stretch = 1.2; // Change the speed
	self.fliteController.target_mean = 1.2; // Change the pitch
	self.fliteController.target_stddev = 1.5; // Change the variance
    
    
    CGRect bounds = [[UIScreen mainScreen]bounds];
    self.view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, bounds.size.width, bounds.size.height)];
    
    _card = [[WordCard alloc]initWithFrame:CGRectMake(0, 0, 300, 140) languages:_vocab.languagePair];
    _card.delegate = self;
    
    [self.view addSubview:_card];
    _card.center = CGPointMake(bounds.size.width / 2, bounds.size.height / 2);
    [_card updateContent:[self nextWord]];
    
    _btnStartStop = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    _btnStartStop.frame = CGRectMake(0, 0, 200, 30);
    [_btnStartStop setTitle:@"Lejátszás" forState:UIControlStateNormal];
    [_btnStartStop addTarget:self action:@selector(startStopPlaying:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:_btnStartStop];
    _btnStartStop.center = CGPointMake(bounds.size.width / 2, CGRectGetMaxY(bounds) - 100);
    
}


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

#pragma mark - WordCardDelegate protocol
- (void)wordCard:(WordCard *)someCard changedStateTo:(WordCardState)newState {
    switch (newState) {
        case kWordCardStateHidden: {
            [self playNextWord];
            
            break;
        }
            
        default:
            break;
    }
}


@end
