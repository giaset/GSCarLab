//
//  CKSampleTwitterTimelineViewController.m
//  TwitterTimeline
//
//  Created by Sebastien Morel on 13-06-07.
//  Copyright (c) 2013 WhereCloud Inc. All rights reserved.
//

#import "CKSampleTwitterTimelineViewController.h"

@interface CKSampleTwitterTimelineViewController ()
@property(nonatomic,retain) CKSampleTwitterTimelineModel* timeline;
@end

@implementation CKSampleTwitterTimelineViewController


- (id)initWithTimeline:(CKSampleTwitterTimelineModel*)theTimeline{
    self = [super init];
    self.timeline = theTimeline;
    [self setup];
    return self;
}

- (void)setup{
    self.title = _(@"kTimelineTitle");
    
    __unsafe_unretained CKSampleTwitterTimelineViewController* bself = self;
    
    //Setup the factory allowing to create cell controller when tweet models gets inserted into self.timeline.tweets collection asynchronously
    CKCollectionCellControllerFactory* tweetsFactory = [CKCollectionCellControllerFactory factory];
    [tweetsFactory addItemForObjectOfClass:[CKSampleTwitterTweetModel class] withControllerCreationBlock:^CKCollectionCellController *(id object, NSIndexPath *indexPath) {
        CKSampleTwitterTweetModel* tweet = (CKSampleTwitterTweetModel*)object;
        return [bself cellControllerForTweet:tweet];
    }];
    
    //Setup the section binded to the self.timeline.tweets collection
    CKFormBindedCollectionSection* section = [CKFormBindedCollectionSection sectionWithCollection:self.timeline.tweets factory:tweetsFactory appendSpinnerAsFooterCell:YES];
    [self addSections:@[section]];
}


- (CKTableViewCellController*)cellControllerForTweet:(CKSampleTwitterTweetModel*)tweet{
    //Setup the cell controller to display a tweet model
    CKTableViewCellController* cellController =  [CKTableViewCellController cellControllerWithTitle:tweet.name
                                                                                           subtitle:tweet.message
                                                                                       defaultImage:[UIImage imageNamed:@"default_avatar"]
                                                                                           imageURL:tweet.imageUrl
                                                                                          imageSize:CGSizeMake(44,44)
                                                                                             action:nil];
    
    //Customize the layout to keep the cell imageview on top with insets
    [cellController setLayoutBlock:^(CKTableViewCellController *controller, UITableViewCell *cell) {
        [controller performLayout];
        cell.imageView.frame = CGRectMake(controller.contentInsets.left,controller.contentInsets.top,44,44);
    }];
    
    return cellController;
}

@end
