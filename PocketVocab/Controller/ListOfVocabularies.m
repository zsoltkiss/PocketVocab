//
//  ListOfVocabularies.m
//  PocketVocab
//
//  Created by Kiss Rudolf Zsolt on 2013.09.04..
//  Copyright (c) 2013 Kiss Rudolf Zsolt. All rights reserved.
//

#import "ListOfVocabularies.h"
#import "Vocabulary.h"
#import "VocabularyContentViewController.h"
#import "SSZipArchive.h"
#import "PocketVocabUtil.h"
#import "AppDelegate.h"
#import "PlayVocabularyViewController.h"

@interface ListOfVocabularies () {
    
    NSArray *_externalFiles;
    NSArray *_internalFiles;
    
}

//- (void)loadVocabFilesFromSandbox;


- (void)loadExternalVocabFiles;
- (void)loadInternalVocabFiles;

@end

@implementation ListOfVocabularies


#pragma mark - private methods

- (void)loadExternalVocabFiles {
    _externalFiles = [PocketVocabUtil filesInInboxDirectory];
}

- (void)loadInternalVocabFiles {
    _internalFiles = [PocketVocabUtil filesInUserDirectory];
}

//- (void)checksumTest {
//    
//    NSMutableDictionary *md = [NSMutableDictionary dictionary];
//    
//    NSArray *fileNames = [PocketVocabUtil filesInDirectory:@"kzstest" underTempDir:YES];
//    
//    for(NSString *fn in fileNames) {
//        
//        NSString *filePath = [[NSTemporaryDirectory() stringByAppendingPathComponent:@"/kzstest"] stringByAppendingPathComponent:fn];
//        
//        NSString *md5Hash = [PocketVocabUtil checksumForFile:filePath];
//        
//        if(md5Hash) {
//            [md setObject:md5Hash forKey:fn];
//        }
//    }
//        
//    
//
//    NSLog(@"md5 hashes for files in vocab: %@", md);
//}



#pragma mark - view lifecycle



- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    [self loadExternalVocabFiles];
    [self loadInternalVocabFiles];
    
    
}

- (void)viewWillAppear:(BOOL)animated {

}


#pragma mark - UITableViewDatasource protocol

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    switch (section) {
        case 0:
            return [_externalFiles count];
            break;
            
        case 1:
            return [_internalFiles count];
            break;
            
        default:
            break;
    }
    
    return 0;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    
    if(section == 0)
        return @"External vocabulary files";
    if(section == 1)
        return @"User defined vocabulary files";
    
    return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"CellIdentifier";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if(cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
//    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
    
    NSArray *arrayToUse = (indexPath.section == 0) ? _externalFiles : _internalFiles;
    
    cell.textLabel.text = [arrayToUse objectAtIndex:indexPath.row];
    return cell;
}

#pragma mark - UITableViewDelegate protocol
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSError *clearDirectoryError;
    NSError *unzippingError;
    if([PocketVocabUtil clearWorkingDirectory:&clearDirectoryError]) {
        
        NSString *fileName = (indexPath.section == 0) ? [_externalFiles objectAtIndex:indexPath.row] : [_internalFiles objectAtIndex:indexPath.row];
        
        NSString *directoryPath = (indexPath.section == 0) ? [PocketVocabUtil pathToInboxDirectory] : [PocketVocabUtil pathToUserDirectory];
        
        NSString *fullPath = [directoryPath stringByAppendingPathComponent:fileName];
        
        if([PocketVocabUtil unzipVocabFileAtPath:fullPath error:&unzippingError]) {
            
            NSString *pathToMainFile = [GetWorkingDirectoryPath() stringByAppendingString:MAIN_FILE_PATH];
            NSData *jsonData = [NSData dataWithContentsOfFile:pathToMainFile];
            Vocabulary *voc = [[Vocabulary alloc] initWithData:jsonData];
            
            PlayVocabularyViewController *vcPlayer = [(AppDelegate *)[[UIApplication sharedApplication] delegate] player];
            [vcPlayer changeVocabulary:voc];
            
        } else {
            //unzip was not successful
            NSLog(@"Unzipping vocab file %@ FAILED. %@", fileName, clearDirectoryError);
        }
        
    } else {
        //clean was not successful
        NSLog(@"Cleaning working directory FAILED. %@", clearDirectoryError);
    }
    
    
    
    
//    if([fileName rangeOfString:@".json"].location != NSNotFound) {
//        Vocabulary *voc = [[Vocabulary alloc]initWithData:[NSData dataWithContentsOfFile:fullPath]];
//        
//        NSLog(@"Vocabulary content is going to be lpo fuloaded: %@", voc);
//        VocabularyContentViewController *vocabContent = [[VocabularyContentViewController alloc]initWithVocabulary:voc];
//        [self.navigationController pushViewController:vocabContent animated:YES];
//        
//    }
    

    
    
}

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath {
    
}

@end
