//
//  DailyWord.m
//  MyDailyWords
//
//  Created by Zsolt Kiss on 8/29/13.
//  Copyright (c) 2013 Zsolt Kiss. All rights reserved.
//

#import "DailyWord.h"

@implementation DailyWord

- (id)initWithWord:(NSString *)someWord andItsPair:(NSString *)pair {
    
    self = [super init];
    
    if(self) {
        self.word = someWord;
        self.pair = pair;
    }
    
    return self;
}

@end
