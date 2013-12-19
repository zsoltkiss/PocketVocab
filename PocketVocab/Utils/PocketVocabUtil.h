//
//  PocketVocabUtil.h
//  PocketVocab
//
//  Created by Zsolt Kiss on 12/19/13.
//  Copyright (c) 2013 Kiss Rudolf Zsolt. All rights reserved.
//


@interface PocketVocabUtil : NSObject

+ (NSString *)checksumForFile:(NSString *)pathToFile;

+ (NSArray *)filesInDirectory:(NSString *)directoryName underTempDir:(BOOL)inTemp;

+ (NSString *)pathToDocumentsDirectory;

+ (void)clearDirectory:(NSString *)directoryName underTempDir:(BOOL)inTemp;

@end
