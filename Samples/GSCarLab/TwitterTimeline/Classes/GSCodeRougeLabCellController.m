//
//  GSCodeRougeLabCellController.m
//  CodeRougeLab
//
//  Created by Gianni Settino on 1/7/2014.
//  Copyright (c) 2014 WhereCloud Inc. All rights reserved.
//

#import "GSCodeRougeLabCellController.h"

@implementation GSCodeRougeLabCellController

// How far the user has to drag before the cell's horizontal scrollview "catches"
const int kCatchWidth = 80;

- (id)initWithCar:(GSCodeRougeLabCarModel*)car selectionBlock:(void(^)(GSCodeRougeLabCellController* clickedCellController))selectionBlock
{
    if(!(self = [super init])) {return nil;}
    
    __unsafe_unretained GSCodeRougeLabCellController *bself = self;
    
    self.value = car;
    
    // Setup block
    [self setSetupBlock:^(CKTableViewCellController *controller, UITableViewCell *cell) {
        GSCodeRougeLabCarModel *thisCar = (GSCodeRougeLabCarModel *) controller.value;
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        // Set up the horizontal scrollView that manages the reveal actions on our cell
        UIScrollView *scrollView = (UIScrollView *)[cell.contentView viewWithKeyPath:@"CellHorizontalScrollView"];
        scrollView.contentSize = CGSizeMake(CGRectGetWidth(cell.bounds) + kCatchWidth, scrollView.height);
        scrollView.showsHorizontalScrollIndicator = NO;
        scrollView.scrollsToTop = NO; // need to do this because if not tapping the status bar to scroll the tableview to the top no longer works...
        scrollView.delegate = bself;
        
        UITapGestureRecognizer *singleTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithBlock:^(UIGestureRecognizer *gestureRecognizer) {
            selectionBlock(bself);
        }];
        singleTapGestureRecognizer.numberOfTapsRequired = 1;
        singleTapGestureRecognizer.enabled = YES;
        singleTapGestureRecognizer.cancelsTouchesInView = NO;
        [scrollView addGestureRecognizer:singleTapGestureRecognizer];
        
        UIView *backgroundView = [scrollView viewWithKeyPath:@"BackgroundView"];
        
        // Get the views that are under the scrollView
        UIView *leftUnderView = [cell.contentView viewWithKeyPath:@"LeftUnderView"];
        UIView *rightUnderView = [cell.contentView viewWithKeyPath:@"RightUnderView"];
        
        //Get all the labels and images we have to set
        UIImageView *carImage = (UIImageView *)[scrollView viewWithKeyPath:@"CarImage"];
        carImage.image = [UIImage imageNamed:thisCar.imageName];
        
        UILabel *titleLabel = (UILabel *)[scrollView viewWithKeyPath:@"TitleLabel"];
        titleLabel.text = thisCar.title;
        
        UILabel *mileageAndTransmissionLabel = (UILabel *)[scrollView viewWithKeyPath:@"MileageAndTransmissionLabel"];
        mileageAndTransmissionLabel.text = thisCar.transmission;
        
        /*UILabel *timeRemainingLabel = (UILabel *)[scrollview viewWithKeyPath:@"TimeRemainingLabel"];
         timeRemainingLabel.text = thisCar.transmission;*/
        
        void (^setProperAppearance)(void) = ^(void) {
            if (bself.selected) {
                backgroundView.backgroundColor = [UIColor colorWithRGBValue:0x333333];
                titleLabel.textColor = [UIColor whiteColor];
                mileageAndTransmissionLabel.textColor = [UIColor whiteColor];
                leftUnderView.backgroundColor = [UIColor colorWithRGBValue:0x1a1a1a];
                rightUnderView.backgroundColor = [UIColor colorWithRGBValue:0x262626];
            } else {
                backgroundView.backgroundColor = [UIColor whiteColor];
                titleLabel.textColor = [UIColor blackColor];
                mileageAndTransmissionLabel.textColor = [UIColor blackColor];
                leftUnderView.backgroundColor = [UIColor colorWithRGBValue:0xe6e6e6];
                rightUnderView.backgroundColor = [UIColor colorWithRGBValue:0xdedede];
            }
        };
        
        //Initial setup of cell appearance.
        //We do this here first because we don't want it to be animated when cells
        //get created, only when the selectedCar changes
        setProperAppearance();
        
        [cell beginBindingsContextByRemovingPreviousBindings];
        
        //Color transitions
        [bself bind:@"selected" withBlock:^(id value) {
            [UIView animateWithDuration:0.3f animations:^{
                setProperAppearance();
            }];
        }];
        
        [cell endBindingsContext];
    }];
    
    return self;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    // do stuff here
    NSLog(@"contentOffset = %f", scrollView.contentOffset.x);
}

//http://www.teehanlax.com/blog/reproducing-the-ios-7-mail-apps-interface/
- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset
{
    // if we've scrolled far enough, our scrollview should "catch"
    if (scrollView.contentOffset.x > kCatchWidth) {
        // do something here if we scroll left far enough!
        //targetContentOffset->x = kCatchWidth;
    } else if (scrollView.contentOffset.x < (-kCatchWidth)) {
        // do something here if we scroll right far enough!
    }
    
    // Now reset our scrollView to origin
    *targetContentOffset = CGPointZero;
    
    // Need to call this subsequently to remove flickering.
    dispatch_async(dispatch_get_main_queue(), ^{
        [scrollView setContentOffset:CGPointZero animated:YES];
    });
}

@end
