//
//  PocketVocabUtil.m
//  PocketVocab
//
//  Created by Zsolt Kiss on 12/19/13.
//  Copyright (c) 2013 Kiss Rudolf Zsolt. All rights reserved.
//

#import "PocketVocabUtil.h"
#import "NSData+MD5.h"
#import "SSZipArchive.h"

@implementation PocketVocabUtil

//+ (NSString *)checksumForFile:(NSString *)pathToFile {
//    
//    NSData *fileContent = [NSData dataWithContentsOfFile:pathToFile];
//        
//    return [fileContent MD5];
//    
//}


+ (NSArray *)filesInInboxDirectory {
    NSArray *directoryContent = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:[PocketVocabUtil pathToInboxDirectory] error:NULL];
    
    NSPredicate *fileExtensionPredicate = [NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
        NSString *fileName = (NSString *)evaluatedObject;
        return [[fileName pathExtension] isEqualToString:APPLICATION_SUPPORTED_FILE_EXTENSION];
    }];
    
    return [directoryContent filteredArrayUsingPredicate:fileExtensionPredicate];
}

+ (NSArray *)filesInUserDirectory {
    NSArray *directoryContent = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:[PocketVocabUtil pathToUserDirectory] error:NULL];
    
    NSPredicate *fileExtensionPredicate = [NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
        NSString *fileName = (NSString *)evaluatedObject;
        return [[fileName pathExtension] isEqualToString:APPLICATION_SUPPORTED_FILE_EXTENSION];
    }];
    
    return [directoryContent filteredArrayUsingPredicate:fileExtensionPredicate];
}


+ (NSArray *)filesInWorkingDirectory {
    NSArray *directoryContent = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:GetWorkingDirectoryPath() error:NULL];
    
    NSPredicate *fileExtensionPredicate = [NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
        NSString *fileName = (NSString *)evaluatedObject;
        return [[fileName pathExtension] isEqualToString:APPLICATION_SUPPORTED_FILE_EXTENSION];
    }];
    
    return [directoryContent filteredArrayUsingPredicate:fileExtensionPredicate];
}


+ (NSString *)pathToDocumentsDirectory {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    return documentsDirectory;
    
}

+ (NSString *)pathToUserDirectory {
    return [[PocketVocabUtil pathToDocumentsDirectory] stringByAppendingPathComponent:USER_DIRECTORY_PATH];
}

+ (NSString *)pathToInboxDirectory {
    return [[PocketVocabUtil pathToDocumentsDirectory] stringByAppendingPathComponent:INBOX_DIRECTORY_PATH];
}

+ (BOOL)clearWorkingDirectory:(NSError *__autoreleasing *)error {
    return [[NSFileManager defaultManager] removeItemAtPath:GetWorkingDirectoryPath() error:error];
}

+ (BOOL)unzipVocabFileAtPath:(NSString *)path error:(NSError **)error {
    if([[path pathExtension] isEqualToString:APPLICATION_SUPPORTED_FILE_EXTENSION]) {
        return [SSZipArchive unzipFileAtPath:path toDestination:GetWorkingDirectoryPath()];
    }
    
    NSString *errorMessage = [NSString stringWithFormat:@"This url or path points to an unsupported resource: %@", path];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:NSLocalizedDescriptionKey, errorMessage, nil];
    
    *error = [NSError errorWithDomain:@"hu.zsoltkiss.pocketvocab" code:EC_NOT_SUPPORTED_FILE_EXTENSION userInfo:dic];
    
    return NO;
}

+ (BOOL)unzipVocabFileAtUrl:(NSURL *)url error:(NSError *__autoreleasing *)error {
    return [PocketVocabUtil unzipVocabFileAtPath:[url path] error:error];
}

@end
