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

@interface ListOfVocabularies () {
    
    NSArray *_savedVocabularies;
    
}

- (void)loadVocabFilesFromSandbox;


@end

@implementation ListOfVocabularies

#pragma mark - private methods

- (void)checksumTest {
    
    NSMutableDictionary *md = [NSMutableDictionary dictionary];
    
    NSArray *fileNames = [PocketVocabUtil filesInDirectory:@"kzstest" underTempDir:YES];
    
    for(NSString *fn in fileNames) {
        
        NSString *filePath = [[NSTemporaryDirectory() stringByAppendingPathComponent:@"/kzstest"] stringByAppendingPathComponent:fn];
        
        NSString *md5Hash = [PocketVocabUtil checksumForFile:filePath];
        
        if(md5Hash) {
            [md setObject:md5Hash forKey:fn];
        }
    }
        
    

    NSLog(@"md5 hashes for files in vocab: %@", md);
}



- (void)loadVocabFilesFromSandbox {
    if(_savedVocabularies != nil) {
        _savedVocabularies = nil;
    }
    
    NSMutableArray *tmpArray = [NSMutableArray array];
    
    //sub directory
    NSString *pathToDestionation = [NSTemporaryDirectory() stringByAppendingPathComponent:@"/kzstest"];
    
    
//    NSString *pathToTestFile = [[NSBundle mainBundle] pathForResource:@"TestData" ofType:@"zip"];
    
    NSString *pathToTestFile = [[NSBundle mainBundle] pathForResource:@"HolidayPlans" ofType:@"vcb"];

    
    [SSZipArchive unzipFileAtPath:pathToTestFile toDestination:pathToDestionation];
    
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    NSLog(@"path to documents directory: %@", documentsDirectory);
    
    NSFileManager *manager = [NSFileManager defaultManager];
    NSArray *fileList = [manager contentsOfDirectoryAtPath:documentsDirectory error:nil];
    for (NSString *s in fileList){
        NSLog(@"vocab file? %@", s);
        
        if([s rangeOfString:@".json"].location != NSNotFound) {
            //json file
            [tmpArray addObject:s];
        } else if([s rangeOfString:@".vcb"].location != NSNotFound) {
            //vocab file
            [tmpArray addObject:s];
        }
        
    }
    
    _savedVocabularies = [NSArray arrayWithArray:tmpArray];
}

#pragma mark - view lifecycle



- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    
}

- (void)viewWillAppear:(BOOL)animated {
//    [self loadVocabFilesFromSandbox];
    
    [self checksumTest];
    [self.tableView reloadData];
}


#pragma mark - UITableViewDatasource protocol

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_savedVocabularies count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"CellIdentifier";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if(cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    cell.textLabel.text = [_savedVocabularies objectAtIndex:indexPath.row];
    return cell;
}

#pragma mark - UITableViewDelegate protocol
- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *fileName = [_savedVocabularies objectAtIndex:indexPath.row];
    
    NSString *fullPath = [[PocketVocabUtil pathToDocumentsDirectory] stringByAppendingPathComponent:fileName];
    
    if([fileName rangeOfString:@".json"].location != NSNotFound) {
        Vocabulary *voc = [[Vocabulary alloc]initWithData:[NSData dataWithContentsOfFile:fullPath]];
        
        NSLog(@"Vocabulary content is going to be loaded: %@", voc);
        VocabularyContentViewController *vocabContent = [[VocabularyContentViewController alloc]initWithVocabulary:voc];
        [self.navigationController pushViewController:vocabContent animated:YES];
        
    }
}

@end
