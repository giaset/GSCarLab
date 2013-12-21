//
//  CKSampleTwitterDataSources.h
//  TwitterTimeline
//
//  Created by  on 12-06-08.
//  Copyright (c) 2012 WhereCloud Inc. All rights reserved.
//

#import <AppCoreKit/AppCoreKit.h>

@interface CKSampleTwitterDataSources : NSObject

+ (CKFeedSource*)feedSourceForTweets;

@end
