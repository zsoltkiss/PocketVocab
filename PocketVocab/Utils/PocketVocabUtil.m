//
//  PocketVocabUtil.m
//  PocketVocab
//
//  Created by Zsolt Kiss on 12/19/13.
//  Copyright (c) 2013 Kiss Rudolf Zsolt. All rights reserved.
//

#import "PocketVocabUtil.h"
#import "NSData+MD5.h"

@implementation PocketVocabUtil

+ (NSString *)checksumForFile:(NSString *)pathToFile {
    
    NSData *fileContent = [NSData dataWithContentsOfFile:pathToFile];
        
    return [fileContent MD5];
    
}

+ (NSArray *)filesInDirectory:(NSString *)directoryName underTempDir:(BOOL)inTemp {
    NSString *pathComponent = [NSString stringWithFormat:@"/%@", directoryName];
    
    NSString *fullPath = nil;
    
    if(inTemp) {
        fullPath = [NSTemporaryDirectory() stringByAppendingPathComponent:pathComponent];
    } else {
        fullPath = [[PocketVocabUtil pathToDocumentsDirectory] stringByAppendingPathComponent:pathComponent];
    }
    NSArray *directoryContent = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:fullPath error:NULL];
    
    return directoryContent;
    
}


+ (NSString *)pathToDocumentsDirectory {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    return documentsDirectory;
    
}

@end
