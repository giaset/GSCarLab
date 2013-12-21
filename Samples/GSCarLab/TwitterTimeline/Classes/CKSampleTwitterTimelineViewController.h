//
//  CKSampleTwitterTimelineViewController.h
//  TwitterTimeline
//
//  Created by Sebastien Morel on 13-06-07.
//  Copyright (c) 2013 WhereCloud Inc. All rights reserved.
//

#import <AppCoreKit/AppCoreKit.h>
#import "CKSampleTwitterTweetModel.h"
#import "CKSampleTwitterTimelineModel.h"

@interface CKSampleTwitterTimelineViewController : CKFormTableViewController

- (id)initWithTimeline:(CKSampleTwitterTimelineModel*)timeline;

@end
