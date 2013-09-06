//
//  EditWordCardViewController.m
//  PocketVocab
//
//  Created by Kiss Rudolf Zsolt on 2013.09.03..
//  Copyright (c) 2013 Kiss Rudolf Zsolt. All rights reserved.
//

#import "EditWordCardViewController.h"

#import <AVFoundation/AVFoundation.h>

@interface EditWordCardViewController () {
    NSURL *_audioFileUrl;
    
    AVAudioRecorder *_recorder;
    AVAudioPlayer *_player;
    
    UILabel *_lbAverageLevel;
    UILabel *_lbPeakLevel;
    
    UIButton *_btnRecord;
    UIButton *_btnPlay;
}

- (NSURL *)tempFileUrl;

@end

@implementation EditWordCardViewController

#pragma mark - private methods
- (NSURL *)tempFileUrl {
    NSString *outputPath = [NSString stringWithFormat:@"%@%@", NSTemporaryDirectory(), @"recording.wav"];
    
    NSURL *outputUrl = [[NSURL alloc]initFileURLWithPath:outputPath];
    
    NSFileManager *fileManager = [[NSFileManager alloc]init];
    if([fileManager fileExistsAtPath:outputPath]) {
        [fileManager removeItemAtPath:outputPath error:nil];
    }
    
    return outputUrl;
}

- (void)updateLabels {
    [_recorder updateMeters];
    
//    _lbAverageLevel.text = [NSString stringWithFormat:@"%f", [_recorder.a] ];
}

- (void)recordPressed:(id)sender {
    
    if([_recorder isRecording]) {
        [_recorder stop];
        [_btnRecord setTitle:@"Felvétel" forState:UIControlStateNormal];
    } else {
        [_recorder record];
        [_btnRecord setTitle:@"Leállítás" forState:UIControlStateNormal];
    }
    
}

- (void)playPressed:(id)sender {
    NSString *outputPath = [NSString stringWithFormat:@"%@%@", NSTemporaryDirectory(), @"recording.wav"];
    
    NSFileManager *fileManager = [[NSFileManager alloc]init];
    
    if(![_player isPlaying]) {
        
        
        if([fileManager fileExistsAtPath:outputPath]) {
            if(_player) {
                _player = nil;
            }
            
            _player = [[AVAudioPlayer alloc]initWithContentsOfURL:_audioFileUrl error:nil];
            _player.delegate = self;
            [_player play];
            [_btnPlay setTitle:@"Leállítás" forState:UIControlStateNormal];
        }
        
    } else {
        [_player pause];
        
        [_btnPlay setTitle:@"Lejátszás" forState:UIControlStateNormal];
    }
}

#pragma mark - view lifecycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    _lbAverageLevel = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, 100, 24)];
    
    _lbPeakLevel = [[UILabel alloc]initWithFrame:CGRectMake(10, 50, 100, 24)];
    
    [self.view addSubview:_lbAverageLevel];
    [self.view addSubview:_lbPeakLevel];
    
    
    _btnRecord = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    _btnRecord.frame = CGRectMake(10, 300, 200, 30);
    [_btnRecord setTitle:@"Felvétel" forState:UIControlStateNormal];
    [_btnRecord addTarget:self action:@selector(recordPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:_btnRecord];
    
    
    _btnPlay = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    _btnPlay.frame = CGRectMake(10, 350, 200, 30);
    [_btnPlay setTitle:@"Lejátszás" forState:UIControlStateNormal];
    [_btnPlay addTarget:self action:@selector(playPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:_btnPlay];
    
    
    
    _audioFileUrl = [self tempFileUrl];
    
    _recorder = [[AVAudioRecorder alloc]initWithURL:_audioFileUrl settings:nil error:nil];
    _recorder.meteringEnabled = YES;
    
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:0.01 target:self selector:@selector(updateLabels) userInfo:nil repeats:YES];
    [timer fire];
    
    [_recorder prepareToRecord];
    
}

#pragma mark - AVAudioPlayerDelegate protocol
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag {
    [_btnPlay setTitle:@"Lejátszás" forState:UIControlStateNormal];
}

@end
