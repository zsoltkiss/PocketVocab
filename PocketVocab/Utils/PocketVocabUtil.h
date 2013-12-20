//
//  PocketVocabUtil.h
//  PocketVocab
//
//  Created by Zsolt Kiss on 12/19/13.
//  Copyright (c) 2013 Kiss Rudolf Zsolt. All rights reserved.
//


@interface PocketVocabUtil : NSObject

//+ (NSString *)checksumForFile:(NSString *)pathToFile;


// Methods to retrieve system paths on the device
+ (NSString *)pathToDocumentsDirectory;
+ (NSString *)pathToUserDirectory;
+ (NSString *)pathToInboxDirectory;

// Directory listing methods
+ (NSArray *)filesInUserDirectory;
+ (NSArray *)filesInWorkingDirectory;
+ (NSArray *)filesInInboxDirectory;


+ (BOOL)clearWorkingDirectory:(NSError **)error;

+ (BOOL)unzipVocabFileAtUrl:(NSURL *)url error:(NSError **)error;
+ (BOOL)unzipVocabFileAtPath:(NSString *)path error:(NSError **)error;

@end
