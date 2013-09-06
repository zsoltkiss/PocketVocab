//
//  SettingsViewController.h
//  MyDailyWords
//
//  Created by Zsolt Kiss on 8/29/13.
//  Copyright (c) 2013 Zsolt Kiss. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WordCard.h"

#import <Slt/Slt.h>
#import <OpenEars/FliteController.h>

@interface SettingsViewController : UIViewController <WordCardDelegate>

@property(nonatomic, strong) FliteController *fliteController;
@property(nonatomic, strong) Slt *slt;

@end
