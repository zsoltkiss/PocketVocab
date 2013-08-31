//
//  DailyWord.h
//  MyDailyWords
//
//  Created by Zsolt Kiss on 8/29/13.
//  Copyright (c) 2013 Zsolt Kiss. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DailyWord : NSObject

@property(nonatomic, strong) NSString *word;
@property(nonatomic, strong) NSString *pair;

- (id)initWithWord:(NSString *)someWord andItsPair:(NSString *)pair;

@end
