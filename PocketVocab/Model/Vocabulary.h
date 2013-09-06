//
//  Vocabulary.h
//  PocketVocab
//
//  Created by Kiss Rudolf Zsolt on 2013.09.04..
//  Copyright (c) 2013 Kiss Rudolf Zsolt. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LanguagePair.h"

@interface Vocabulary : NSObject

@property(nonatomic, strong) NSString *subject;
@property(nonatomic, strong) NSArray *words;
@property(nonatomic, strong) LanguagePair *languagePair;

- (id)initWithData:(NSData *)jsonData;

@end
