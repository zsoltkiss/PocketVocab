//
//  Vocabulary.m
//  PocketVocab
//
//  Created by Kiss Rudolf Zsolt on 2013.09.04..
//  Copyright (c) 2013 Kiss Rudolf Zsolt. All rights reserved.
//

/*
    JSON sample:
 
    {
        subject: "Some title for subject",
        lang1: "English",
        lang2: "Magyar",
        words: [
            ["some word in language 1", "translation in language 2", "some sentence using the lang1 word as an example"],
            [...],
            .
            .
            .
            [...]
 
        ]
    }
 
 */


#import "Vocabulary.h"
#import "DailyWord.h"

@implementation Vocabulary

- (id)initWithData:(NSData *)jsonData {
    self = [super init];
    
    if(self) {
        NSDictionary *topLevelJson = (NSDictionary *)[NSJSONSerialization JSONObjectWithData:jsonData options:(NSJSONReadingMutableContainers | NSJSONReadingMutableLeaves) error:nil];
        
        if(topLevelJson) {
            self.subject = ([[topLevelJson allKeys]containsObject:@"subject"]) ? [topLevelJson objectForKey:@"subject"] :@"";
            
            self.languagePair = [[LanguagePair alloc]init];
            
            self.languagePair.lang1 = ([[topLevelJson allKeys]containsObject:@"lang1"]) ? [topLevelJson objectForKey:@"lang1"] :@"";
            self.languagePair.lang2 = ([[topLevelJson allKeys]containsObject:@"lang2"]) ? [topLevelJson objectForKey:@"lang2"] :@"";
            
            NSMutableArray *ma = [NSMutableArray array];
            
            if([[topLevelJson allKeys]containsObject:@"words"]) {
                id someObject = [topLevelJson objectForKey:@"words"];
                if([someObject isKindOfClass:[NSArray class]]) {
                    for(NSArray *innerArray in (NSArray *)someObject) {
                        if([innerArray count] >= 2) {
                            DailyWord *dw = [[DailyWord alloc]initWithArray:innerArray];
                            [ma addObject:dw];
                        }
                    }
                }
            }
            
            self.words = [NSArray arrayWithArray:ma];
        }
    }
    
    return self;
}

- (NSString *)description {
    
    
    NSMutableString *ms = [NSMutableString string];
    
    [ms appendFormat:@"%@, {%@, %d word(s)}", [super description], self.subject, [self.words count]];
    
    return [NSString stringWithString:ms];
}

@end
