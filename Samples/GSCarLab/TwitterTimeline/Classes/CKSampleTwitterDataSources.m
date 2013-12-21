//
//  CKSampleTwitterDataSources.m
//  TwitterTimeline
//
//  Created by  on 12-06-08.
//  Copyright (c) 2012 WhereCloud Inc. All rights reserved.
//

#import "CKSampleTwitterDataSources.h"
#import <Twitter/Twitter.h>
#import <Accounts/Accounts.h>

#import "CKSampleTwitterTweetModel.h"
#import "CKSampleTwitterTimelineModel.h"

@implementation CKSampleTwitterDataSources

/* The Twitter public Timeline API is not available anymore.
   This sampe illustrates how to fetch data from the web using AppCoreKit high level http requests API that transforms the resulting payload into document objects.
   Connected to a collection, the array of document objects created in this method are inserted into the collection and the table view refreshes automatically
   As it is watching this collection content.
 */

/*
+ (CKFeedSource*)feedSourceForTweets{
    CKWebSource* webSource = [[CKWebSource alloc]init];
    webSource.requestBlock = ^(NSRange range){
        NSURL* tweetsAPIUrl = [NSURL URLWithString:@"https://api.twitter.com/1/statuses/public_timeline.json"];
        NSDictionary* params = [NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%d",range.length],@"count",@"true",@"include_entities", nil];
        
        CKWebRequest* request = [CKWebRequest requestForObjectsWithUrl:tweetsAPIUrl
                                                                params:(NSDictionary*)params
                                                                  body:nil
                                              mappingContextIdentifier:@"$Tweet"
                                                      transformRawData:nil
                                                            completion:nil
                                                                 error:nil];
        return request;
                                 
    };
    return webSource;
}
 */

+ (void)authentificationError{
    CKAlertView* alert = [[CKAlertView alloc]initWithTitle:_(@"kFeedSourceForTweetsAlertTitle") message:_(@"kFeedSourceForTweetsAlertMessage")];
    [alert addButtonWithTitle:_(@"kOK") action:nil];
    [alert show];
}

+ (void)requestTwitterAccountWithCompletionBlock:(void(^)(ACAccount* account))completionBlock{
    //  First, we need to obtain the account instance for the user's Twitter account
    ACAccountStore *store = [[ACAccountStore alloc] init];
    ACAccountType *twitterAccountType = [store accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
    
    //  Request permission from the user to access the available Twitter accounts
    [store requestAccessToAccountsWithType:twitterAccountType
                     withCompletionHandler:^(BOOL granted, NSError *error) {
                         if (!granted) {
                             // The user rejected your request
                             NSLog(@"User rejected access to the account.");
                             completionBlock(nil);
                         }
                         else {
                             // Grab the available accounts
                             NSArray *twitterAccounts =
                             [store accountsWithAccountType:twitterAccountType];
                             
                             if ([twitterAccounts count] > 0) {
                                 // Use the first account for simplicity 
                                 ACAccount *account = [twitterAccounts objectAtIndex:0];
                                 completionBlock(account);
                             }else{
                                 completionBlock(nil);
                             }
                         }
                     }];
}

+ (CKFeedSource*)feedSourceForTweets{
    CKFeedSource* feedSource = [CKFeedSource feedSource];
    
    feedSource.fetchBlock = ^(CKFeedSource* feedSource, NSRange range){
        NSString* lastId = (range.location > 0) ? [[[[CKSampleTwitterTimelineModel sharedInstance]tweets]objectAtIndex:range.location-1]identifier] : nil;
        
        [self requestTwitterAccountWithCompletionBlock:^(ACAccount* account){
            if(!account){
                [self performSelector:@selector(authentificationError) onThread:[NSThread mainThread] withObject:nil waitUntilDone:NO];
            }else{
                TWRequest *request = [[TWRequest alloc] initWithURL:[NSURL URLWithString:
                                                                     @"https://api.twitter.com/1.1/statuses/home_timeline.json"]
                                                         parameters:[NSDictionary dictionaryWithObjectsAndKeys:
                                                                     
                                                                     //As max_id returns the previous one in the payload we ask for 1 more
                                                                     [NSString stringWithFormat:@"%d",range.length + (lastId ? 1 : 0)],@"count",
                                                                     lastId,@"max_id",
                                                                     nil]
                                                      requestMethod:TWRequestMethodGET];
                request.account = account;
                
                // Notice this is a block, it is the handler to process the response
                [request performRequestWithHandler:^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error){
                     if ([urlResponse statusCode] == 200){
                         // The response from Twitter is in JSON format
                         // Move the response into a dictionary and print
                         NSError *error;
                         NSArray *dict = [NSObject objectFromJSONData:responseData error:&error];
                         CKMappingContext* context = [CKMappingContext contextWithIdentifier:@"$Tweet"];
                         NSArray* tweets = [context objectsFromValue:dict error:&error];
                         
                         if([tweets count] > 1){
                             //As max_id returns the previous one in the payload weremove the ist item from the returned list
                             [feedSource addItems:[NSArray arrayWithArray:[tweets objectsAtIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(1, [tweets count] - 1)]]]];
                         }else{
                             [feedSource cancelFetch];
                         }
                     }
                     else{
                         [feedSource cancelFetch];
                         NSLog(@"Twitter error, HTTP response: %i", [urlResponse statusCode]);
                     }
                 }];
            }
        }];
    };
    return feedSource;
}

@end
