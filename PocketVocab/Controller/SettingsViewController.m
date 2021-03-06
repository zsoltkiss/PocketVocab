//
//  SettingsViewController.m
//  MyDailyWords
//
//  Created by Zsolt Kiss on 8/29/13.
//  Copyright (c) 2013 Zsolt Kiss. All rights reserved.
//

#import "SettingsViewController.h"

#import "WordCard.h"
#import "LanguagePair.h"
#import <AudioToolbox/AudioToolbox.h>

@interface SettingsViewController () {
    WordCard *_card;
    
    NSMutableArray *_myWords;
    
    NSInteger _nextIndex;
    
    
    UIButton *_button;
    
}

@end

@implementation SettingsViewController

- (DailyWord *)nextWord {
    DailyWord *nextWord = nil;
    
    if(_nextIndex < [_myWords count]) {
        nextWord = [_myWords objectAtIndex:_nextIndex];
    }
    
    _nextIndex++;
    
    if(_nextIndex == [_myWords count]) {
        _nextIndex = 0;
    }
    
    return nextWord;
}

- (void)valami:(id)sender {
    _button.userInteractionEnabled = NO;
    
    DailyWord *dw = [self nextWord];
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
    
    [_card updateContent:dw];
    [self.fliteController say:dw.word withVoice:self.slt];
    
    [_card revealCardAnimated:YES];
    
    [_card performSelector:@selector(flip) withObject:nil afterDelay:2];
    [_card performSelector:@selector(hideCardAnimated:) withObject:nil afterDelay:4];
    
    
    
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {

        _myWords = [NSMutableArray array];
        [_myWords addObject:[[DailyWord alloc]initWithWord:@"to establish" andItsPair:@"létrehozni"]];
        [_myWords addObject:[[DailyWord alloc]initWithWord:@"distressing" andItsPair:@"lehangoló"]];
        [_myWords addObject:[[DailyWord alloc]initWithWord:@"endurance" andItsPair:@"kitartás, állóképesség"]];
        [_myWords addObject:[[DailyWord alloc]initWithWord:@"hilarious" andItsPair:@"vicces, jókedvű"]];
        
        [_myWords addObject:[[DailyWord alloc]initWithWord:@"summarily" andItsPair:@"summásan, röviden"]];
        [_myWords addObject:[[DailyWord alloc]initWithWord:@"particularly" andItsPair:@"különösen, főleg"]];
        [_myWords addObject:[[DailyWord alloc]initWithWord:@"rely on something" andItsPair:@"számít valamire"]];
        [_myWords addObject:[[DailyWord alloc]initWithWord:@"promote somebody to something" andItsPair:@"kinevez, előléptet"]];
        
        
    }
    return self;
}

- (void)loadView {
    self.title = @"Settings";
    
    self.fliteController = [[FliteController alloc]init];
    self.slt = [[Slt alloc]init];
    
    //itt minel nagyobb erteket allitunk be, annal lassabban fogja mondani
    self.fliteController.duration_stretch = 1.2; // Change the speed
	self.fliteController.target_mean = 1.2; // Change the pitch
	self.fliteController.target_stddev = 1.5; // Change the variance
    
    
    
    CGRect bounds = [[UIScreen mainScreen]bounds];
    self.view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, bounds.size.width, bounds.size.height)];
    
    LanguagePair *lp = [[LanguagePair alloc]init];
    lp.lang1 = @"English";
    lp.lang2 = @"Magyar";
    lp.imageName1 = @"flag_united_kingdom";
    lp.imageName2 = @"flag_hungary";
    
    _card = [[WordCard alloc]initWithFrame:CGRectMake(0, 0, 300, 140) languages:lp];
    _card.delegate = self;
    
    [self.view addSubview:_card];
    _card.center = CGPointMake(bounds.size.width / 2, bounds.size.height / 2);
    [_card updateContent:[self nextWord]];
    
    _button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    _button.frame = CGRectMake(0, 0, 200, 30);
    [_button setTitle:@"Következő szó" forState:UIControlStateNormal];
    [_button addTarget:self action:@selector(valami:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:_button];
    _button.center = CGPointMake(bounds.size.width / 2, CGRectGetMaxY(bounds) - 100);
    
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
//            DailyWord *dw = [self nextWord];
//            [someCard updateContent:dw];
            _button.userInteractionEnabled = YES;
            break;
        }
            
        default:
            break;
    }
}

@end
