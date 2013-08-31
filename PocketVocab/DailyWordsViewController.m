//
//  DailyWordsViewController.m
//  MyDailyWords
//
//  Created by Zsolt Kiss on 8/29/13.
//  Copyright (c) 2013 Zsolt Kiss. All rights reserved.
//

#import "DailyWordsViewController.h"
#import "DailyWord.h"
#import <QuartzCore/QuartzCore.h>
#import <AudioToolbox/AudioToolbox.h>

//#define LABEL_COLOR [UIColor colorWithRed:143.0f/255.0 green:188.0/255.0 blue:143.0/255.0 alpha:1.0]
#define LABEL_COLOR [UIColor colorWithRed:34.0f/255.0 green:139.0/255.0 blue:34.0/255.0 alpha:1.0]



@interface DailyWordsViewController () {
    
    UITextView *_textView;
    
    NSTimer *_timer;
    
    NSMutableArray *_myWords;
    
    NSInteger _nextIndex;
    
    UIButton *_btnStartStop;
    
    UILabel *_label;
    
    BOOL _sessionActive;
    
}

- (void)readOutButtonTapped:(id)sender;

- (void)readOutNext;

- (void)startLearningSession:(id)sender;

- (void)stopLearningSession:(id)sender;

- (void)animateLabelWithText:(NSString *)translation;

@end

@implementation DailyWordsViewController

#pragma mark - private methods

- (void)readOutButtonTapped:(id)sender {
    NSLog(@"%@ called", NSStringFromSelector(_cmd));
    
    [self.fliteController say:_textView.text withVoice:self.slt];
}

- (void)animateLabelWithText:(NSString *)translation {
    
    [UIView animateWithDuration:0.6 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        _label.text = translation;
        _label.alpha = 1.0;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.6 delay:5.0 options:UIViewAnimationOptionCurveLinear animations:^{
            _label.alpha = 0.0;
        } completion:^(BOOL finished) {
            _label.text = nil;
        }];
    }];
    
}

- (void)readOutNext {
    
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
    
    DailyWord *dw = nil;
    
    if(_nextIndex < [_myWords count]) {
        dw = [_myWords objectAtIndex:_nextIndex];
    }
    
    
    if(dw != nil) {
        _label.text = dw.pair;
    }
    
    [self animateLabelWithText:dw.pair];
    [self.fliteController say:dw.word withVoice:self.slt];
    
    _nextIndex++;
    
    if(_nextIndex == [_myWords count]) {
        _nextIndex = 0;
    }
    
}

- (void)startLearningSession:(id)sender {
    
    if(!_sessionActive) {
        if(_timer == nil) {
            _timer = [NSTimer scheduledTimerWithTimeInterval: 10.0
                                                      target: self
                                                    selector:@selector(readOutNext)
                                                    userInfo:nil repeats:YES];
        }
    
        [_btnStartStop setTitle:@"Stop Learning" forState:UIControlStateNormal];
        [_btnStartStop addTarget:self action:@selector(stopLearningSession:) forControlEvents:UIControlEventTouchUpInside];
        
        _sessionActive = YES;
    
    }
    
}


- (void)stopLearningSession:(id)sender {
    
    if(_sessionActive) {
    
        [_timer invalidate];
        
        _timer = nil;
        _sessionActive = NO;
        _btnStartStop.userInteractionEnabled = NO;
    }
    
}

#pragma mark - init and lifecycle
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
    
    self.fliteController = [[FliteController alloc]init];
    self.slt = [[Slt alloc]init];
    
    //itt minel nagyobb erteket allitunk be, annal lassabban fogja mondani
    self.fliteController.duration_stretch = 1.2; // Change the speed
	self.fliteController.target_mean = 1.2; // Change the pitch
	self.fliteController.target_stddev = 1.5; // Change the variance
    
    
    //this title will reflect as the tab bar item's title as well
    //self.title = @"My words";
    
    CGRect bounds = [[UIScreen mainScreen]bounds];

    
    self.view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, bounds.size.width, bounds.size.height)];
    
    self.view.backgroundColor = [UIColor colorWithRed:143.0f/255.0 green:188.0/255.0 blue:143.0/255.0 alpha:1.0];
    
    _label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 260, 80)];
    _label.font = [UIFont boldSystemFontOfSize:20];
    _label.textColor = [UIColor whiteColor];
    _label.backgroundColor = LABEL_COLOR;
    _label.textAlignment = NSTextAlignmentCenter;
    _label.layer.cornerRadius = 5;
    _label.layer.masksToBounds = YES;
    _label.alpha = 0.0f;
    
    [self.view addSubview:_label];
    _label.center = CGPointMake(bounds.size.width / 2, bounds.size.height / 2 - 40);
    
    
    _btnStartStop = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    _btnStartStop.frame = CGRectMake(0, 0, 200, 30);
    [_btnStartStop setTitle:@"Start learning" forState:UIControlStateNormal];
    [_btnStartStop addTarget:self action:@selector(startLearningSession:) forControlEvents:UIControlEventTouchUpInside];
//    _btnStartStop.backgroundColor = [UIColor yellowColor];
    
    [self.view addSubview:_btnStartStop];
    _btnStartStop.center = CGPointMake(bounds.size.width / 2, CGRectGetMaxY(bounds) - 100);
    
    
    /*
	_textView = [[UITextView alloc]initWithFrame:CGRectMake(0, 0, 280, 100)];
    _textView.font = [UIFont systemFontOfSize:12.0f];
    
    UIButton *btnReadOut = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    btnReadOut.frame = CGRectMake(0, 0, 200, 30);
    [btnReadOut setTitle:@"Read out" forState:UIControlStateNormal];
    [btnReadOut addTarget:self action:@selector(readOutButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:_textView];
    [self.view addSubview:btnReadOut];
     
    _textView.center = CGPointMake(bounds.size.width / 2, 60);
    btnReadOut.center = CGPointMake(bounds.size.width / 2, CGRectGetMaxY(_textView.frame) + 40);
     
    _textView.delegate = self;
     */
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _textView.text = @"Dear John! How are you? We are well. I am writing to ask you to give me a piece of good advice...";
}

#pragma mark - accessors


#pragma mark - UITextFieldDelegate

- (BOOL)textViewShouldEndEditing:(UITextView *)textView {
    
    [textView resignFirstResponder];
    
    return YES;
}

@end
