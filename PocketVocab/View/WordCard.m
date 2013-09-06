//
//  WordCard.m
//  PocketVocab
//
//  Created by Kiss Rudolf Zsolt on 2013.08.31..
//  Copyright (c) 2013 Kiss Rudolf Zsolt. All rights reserved.
//

#import "WordCard.h"
#import <QuartzCore/QuartzCore.h>

#define TAG_FOR_FRONT 9876
#define TAG_FOR_BACK 9875

@interface WordCard () {
    UIView *_front;
    UIView *_back;
    
    UILabel *_frontLabel;
    UILabel *_backLabel;
    
    WordCardState _cardState;
    
    DailyWord *_data;
}

- (UIView *)upsideView;

- (void)reset;

@end

@implementation WordCard

#pragma mark - private methods

- (UIView *)upsideView {
    if([self viewWithTag:TAG_FOR_FRONT] != nil) {
        return _front;
    } else {
        return _back;
    }
}

- (void)reset {
    _front.alpha = 0;
    _back.alpha = 1.0;
    _frontLabel.text = nil;
    _backLabel.text = nil;
    
    UIView *upsideView = [self upsideView];
    
    if([upsideView isEqual:_back]) {
        [_back removeFromSuperview];
        [self addSubview:_front];
    }
}

#pragma mark - initialization
- (id)initWithFrame:(CGRect)frame languages:(LanguagePair *)languagePair {
    self = [super initWithFrame:frame];
    if (self) {
        
        _front = [[UIView alloc]initWithFrame:frame];
        _front.tag = TAG_FOR_FRONT;
        _front.backgroundColor = [UIColor orangeColor];
        UIImageView *flag1 = [[UIImageView alloc]initWithImage:[UIImage imageNamed:languagePair.imageName1]];
        flag1.frame = CGRectMake(_front.frame.size.width - flag1.frame.size.width / 2 - 40, 10, flag1.frame.size.width, flag1.frame.size.height);
        [_front addSubview:flag1];
        
        _frontLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 260, 80)];
        _frontLabel.font = [UIFont boldSystemFontOfSize:20];
        _frontLabel.textColor = [UIColor whiteColor];
        _frontLabel.backgroundColor = [UIColor clearColor];
        _frontLabel.textAlignment = NSTextAlignmentCenter;
        _frontLabel.layer.cornerRadius = 5;
        _frontLabel.layer.masksToBounds = YES;
        
        [_front addSubview:_frontLabel];
        _frontLabel.center = CGPointMake(_front.frame.size.width / 2, _front.frame.size.height / 2);
        _front.alpha = 0.0;
        _front.layer.cornerRadius = 5;
        _front.layer.masksToBounds = YES;
        
        
        _back = [[UIView alloc]initWithFrame:frame];
        _back.tag = TAG_FOR_BACK;
        _back.backgroundColor = [UIColor purpleColor];
        UIImageView *flag2 = [[UIImageView alloc]initWithImage:[UIImage imageNamed:languagePair.imageName2]];
        flag2.frame = CGRectMake(_back.frame.size.width - flag2.frame.size.width / 2 - 40, 10, flag2.frame.size.width, flag2.frame.size.height);
        [_back addSubview:flag2];
        
        _backLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 260, 80)];
        _backLabel.font = [UIFont boldSystemFontOfSize:20];
        _backLabel.textColor = [UIColor whiteColor];
        _backLabel.backgroundColor = [UIColor clearColor];
        _backLabel.textAlignment = NSTextAlignmentCenter;
        _backLabel.layer.cornerRadius = 5;
        _backLabel.layer.masksToBounds = YES;
        
        [_back addSubview:_backLabel];
        _backLabel.center = CGPointMake(_back.frame.size.width / 2, _back.frame.size.height / 2);
        _back.layer.cornerRadius = 5;
        _back.layer.masksToBounds = YES;
        
        
        [self addSubview:_front];
        _cardState = kWordCardStateHidden;
        
        
    }
    
    
    return self;
}


#pragma mark - public methods
- (void)flip {
    if(_cardState != kWordCardStateHidden) {
        
        if(_cardState == kWordCardStateLang1) {
            [UIView transitionFromView:_front toView:_back duration:0.8 options:UIViewAnimationOptionTransitionFlipFromBottom completion:^(BOOL finished) {
                _cardState = kWordCardStateLang2;
                
            }];
        } else {
            [UIView transitionFromView:_back toView:_front duration:0.8 options:UIViewAnimationOptionTransitionFlipFromBottom completion:^(BOOL finished) {
                _cardState = kWordCardStateLang1;
                [self.delegate wordCard:self changedStateTo:kWordCardStateLang1];
            }];
        }
        
        [self.delegate wordCard:self changedStateTo:_cardState];
    }
}

- (void)updateContent:(DailyWord *)newContent {
    _data = nil;
    _data = newContent;
    
    _frontLabel.text = newContent.word;
    _backLabel.text = newContent.pair;
    
}

- (void)revealCardAnimated:(BOOL)animated {
    
    UIView *upsideView = [self upsideView];
    
    if(animated) {
        [UIView animateWithDuration:0.8 animations:^{
            upsideView.alpha = 1.0;
        }];
    } else {
        upsideView.alpha = 1.0;
    }
    
    _cardState = (upsideView == _front) ? kWordCardStateLang1 : kWordCardStateLang2;
    [self.delegate wordCard:self changedStateTo:_cardState];
}

- (void)hideCardAnimated:(BOOL)animated {
    UIView *upsideView = [self upsideView];
    
    if(YES) {
        [UIView animateWithDuration:0.8 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
            upsideView.alpha = 0.0;
        } completion:^(BOOL finished) {
            [self reset];
            _cardState = kWordCardStateHidden;
            [self.delegate wordCard:self changedStateTo:_cardState];
        }];
    } else {
        upsideView.alpha = 0.0;
    }
    
    
}

- (void)toggleState {
    switch (_cardState) {
        case kWordCardStateHidden: {
            [self revealCardAnimated:YES];
            break;
        }
            
        case kWordCardStateLang1: {
            [self flip];
            break;
        }
            
        case kWordCardStateLang2: {
            if(_data.usageSample == nil || _data.usageSample.length == 0) {
                [self hideCardAnimated:YES];
            }
            
            break;
        }
            
        default:
            break;
    }
}

@end
