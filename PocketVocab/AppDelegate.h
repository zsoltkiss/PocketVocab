//
//  AppDelegate.h
//  PocketVocab
//
//  Created by Kiss Rudolf Zsolt on 2013.08.31..
//  Copyright (c) 2013 Kiss Rudolf Zsolt. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "PlayVocabularyViewController.h"

typedef enum {
    kApplicationTabSettings,
    kApplicationTabPlayer,
    kApplicationTabSavedVocabs

} ApplicationTab;

@interface AppDelegate : UIResponder <UIApplicationDelegate, UIAlertViewDelegate>

@property (strong, nonatomic) UIWindow *window;

@property(nonatomic, readonly) PlayVocabularyViewController *player;

- (void)changeTabTo:(ApplicationTab)newTab;

@end
