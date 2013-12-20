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
@property(nonatomic,retain) CKSampleTwitterTweetModel* selectedTweet;
@end

@implementation CKSampleTwitterTimelineViewController


- (id)initWithTimeline:(CKSampleTwitterTimelineModel*)theTimeline{
    self = [super init];
    self.timeline = theTimeline;
    self.selectedTweet = nil;
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
    __unsafe_unretained CKSampleTwitterTimelineViewController *bself = self;
    
    //Create block that will be executed when cell is clicked
    void (^clickBlock)(CKTableViewCellController*) = ^(CKTableViewCellController *controller){
        CKSampleTwitterTweetModel *thisTweet = (CKSampleTwitterTweetModel *) controller.value;
        bself.selectedTweet = thisTweet;
    };
    
    //Setup the cell controller to display a tweet model
    CKTableViewCellController* cellController =  [CKTableViewCellController cellControllerWithTitle:tweet.name
                                                                                           subtitle:tweet.message
                                                                                       defaultImage:[UIImage imageNamed:@"default_avatar"]
                                                                                           imageURL:tweet.imageUrl
                                                                                          imageSize:CGSizeMake(44,44)
                                                                                             action:clickBlock];
    cellController.value = tweet;
    
    //Customize the layout to keep the cell imageview on top with insets
    [cellController setLayoutBlock:^(CKTableViewCellController *controller, UITableViewCell *cell) {
        [controller performLayout];
        cell.imageView.frame = CGRectMake(controller.contentInsets.left,controller.contentInsets.top,44,44);
    }];
    
    //Set setup block
    [cellController setSetupBlock:^(CKTableViewCellController *controller, UITableViewCell *cell) {
        CKSampleTwitterTweetModel *thisTweet = (CKSampleTwitterTweetModel *) controller.value;
        
        CKImageView *img = (CKImageView *) cell.imageView;
        img.imageURL = thisTweet.imageUrl;
    }];
    
    return cellController;
}

@end
