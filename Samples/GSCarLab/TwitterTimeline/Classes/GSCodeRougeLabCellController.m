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
const int kCatchWidth = 50;

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
            } else {
                backgroundView.backgroundColor = [UIColor whiteColor];
                titleLabel.textColor = [UIColor blackColor];
                mileageAndTransmissionLabel.textColor = [UIColor blackColor];
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

@end
