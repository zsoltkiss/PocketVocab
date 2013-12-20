//
//  AppDelegate.m
//  PocketVocab
//
//  Created by Kiss Rudolf Zsolt on 2013.08.31..
//  Copyright (c) 2013 Kiss Rudolf Zsolt. All rights reserved.
//

#import "AppDelegate.h"
#import "SettingsViewController.h"
#import "DailyWordsViewController.h"
#import "EditWordCardViewController.h"
#import "PlayVocabularyViewController.h"
#import "Vocabulary.h"
#import "LanguagePair.h"
#import "ListOfVocabularies.h"
#import "PocketVocabUtil.h"

@interface AppDelegate () {
    NSURL *_externalResourceUrl;
}



@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    
    LanguagePair *lp = [[LanguagePair alloc]init];
    lp.lang1 = @"English";
    lp.lang2 = @"Magyar";
    lp.imageName1 = @"flag_united_kingdom.png";
    lp.imageName2 = @"flag_hungary.png";
    
    Vocabulary *voc = nil;
    
    NSData *data = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"interview" ofType:@"json"]];
    voc = [[Vocabulary alloc]initWithData:data];
    
//    voc = [[Vocabulary alloc]init];
//    voc.subject = @"Preparing for interview";
//    voc.languagePair = lp;
//    
//    NSMutableArray *words = [NSMutableArray array];
//    [words addObject:[[DailyWord alloc]initWithWord:@"to establish" andItsPair:@"létrehozni"]];
//    [words addObject:[[DailyWord alloc]initWithWord:@"distressing" andItsPair:@"lehangoló"]];
//    [words addObject:[[DailyWord alloc]initWithWord:@"endurance" andItsPair:@"kitartás, állóképesség"]];
//    [words addObject:[[DailyWord alloc]initWithWord:@"hilarious" andItsPair:@"vicces, jókedvű"]];
//    
//    [words addObject:[[DailyWord alloc]initWithWord:@"summarily" andItsPair:@"summásan, röviden"]];
//    [words addObject:[[DailyWord alloc]initWithWord:@"particularly" andItsPair:@"különösen, főleg"]];
//    [words addObject:[[DailyWord alloc]initWithWord:@"rely on something" andItsPair:@"számít valamire"]];
//    [words addObject:[[DailyWord alloc]initWithWord:@"promote somebody to something" andItsPair:@"kinevez, előléptet"]];
//    
//    voc.words = words;
    
    
    UITabBarController *tabController = [[UITabBarController alloc]init];
    
    SettingsViewController *vcSettings = [[SettingsViewController alloc]init];
    PlayVocabularyViewController *vcPlayer = [[PlayVocabularyViewController alloc]initWithVocabulary:voc];
    
    ListOfVocabularies *vcVocabList = [[ListOfVocabularies alloc]initWithStyle:UITableViewStylePlain];
    UINavigationController *navController = [[UINavigationController alloc]initWithRootViewController:vcVocabList];
    

    
//    DailyWordsViewController *vcDailyWords = [[DailyWordsViewController alloc]init];
//    EditWordCardViewController *vcEditCard = [[EditWordCardViewController alloc]init];
    
    vcSettings.title = @"Settings";
    vcPlayer.title = @"Player";
    vcVocabList.title = @"Saved";
//    vcDailyWords.title = @"Learning";
//    vcEditCard.title = @"Edit";
    
    [tabController addChildViewController:vcSettings];
    [tabController addChildViewController:vcPlayer];
    [tabController addChildViewController:navController];
//    [tabController addChildViewController:vcDailyWords];
//    [tabController addChildViewController:vcEditCard];
    
    self.window.rootViewController = tabController;
    
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    return YES;
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    NSLog(@"url to handle: %@", [url absoluteString]);
    
    if([url.scheme isEqualToString:APPLICATION_SUPPORTED_URL_SCHEME]) {
        UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"PocketVocab app launched by an URL" message:[url absoluteString] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [av show];
        
        return YES;
    }
    
    return NO;
    
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    if (url){
        
        _externalResourceUrl = url;
        
        NSString *infoMessage = [NSString stringWithFormat:@"Would you like Pocket Vocab to open this file? %@", url];
        UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"External resource" message:infoMessage delegate:self cancelButtonTitle:@"No, thanks" otherButtonTitles:@"Open it!", nil];
        
        [av show];
        
//        NSData *fileContent = [NSData dataWithContentsOfURL:url];
//        NSString *str = [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:nil];
//        NSLog(@"The file contained: %@",str);
    }
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark - UIAlertViewDelegate protocol

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    switch (buttonIndex) {
        case 0: {
            _externalResourceUrl = nil;
            break;
        }
        case 1: {
            NSError *unzippingError;
            
            [PocketVocabUtil unzipVocabFileAtUrl:_externalResourceUrl error:&unzippingError];
            
        }
        default:
            break;
    }
}

@end
