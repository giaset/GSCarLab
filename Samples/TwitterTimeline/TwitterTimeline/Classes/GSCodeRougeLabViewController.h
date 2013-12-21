//
//  GSCodeRougeLabViewController.h
//  CodeRougeLab
//
//  Created by Gianni Settino on 12-20-2013.
//  Copyright (c) 2013 WhereCloud Inc. All rights reserved.
//

#import <AppCoreKit/AppCoreKit.h>
#import "CKSampleTwitterTweetModel.h"
#import "CKSampleTwitterTimelineModel.h"

@interface GSCodeRougeLabViewController : CKFormTableViewController

- (id)initWithTimeline:(CKSampleTwitterTimelineModel*)timeline;

@end
