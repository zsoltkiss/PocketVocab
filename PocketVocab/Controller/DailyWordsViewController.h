//
//  DailyWordsViewController.h
//  MyDailyWords
//
//  Created by Zsolt Kiss on 8/29/13.
//  Copyright (c) 2013 Zsolt Kiss. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <Slt/Slt.h>
#import <OpenEars/FliteController.h>

@interface DailyWordsViewController : UIViewController <UITextViewDelegate>

@property(nonatomic, strong) FliteController *fliteController;
@property(nonatomic, strong) Slt *slt;

@end
