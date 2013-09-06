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

- (id)initWithArray:(NSArray *)array {
    self = [super init];
    
    if(self) {
        
        self.word = [array count] > 0 ? [array objectAtIndex:0] : @"";
        self.pair = [array count] > 1 ? [array objectAtIndex:1] : @"";
        self.usageSample = [array count] > 2 ? [array objectAtIndex:2] : @"";
    }
    
    return self;
}

- (NSString *)description {
    NSMutableString *ms = [NSMutableString string];
    [ms appendFormat:@"%@, {%@, %@, %@}", [super description], self.word, self.pair, self.usageSample];
    return ms;
}

@end
