//
//  CKSampleTwitterTimelineModel.h
//  TwitterTimeline
//
//  Created by Sebastien Morel on 13-06-07.
//  Copyright (c) 2013 WhereCloud Inc. All rights reserved.
//

#import <AppCoreKit/AppCoreKit.h>

@interface CKSampleTwitterTimelineModel : CKObject
@property(nonatomic) CKArrayCollection* tweets;
@end
