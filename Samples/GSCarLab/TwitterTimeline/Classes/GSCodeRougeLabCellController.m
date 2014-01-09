//
//  GSCodeRougeLabCellController.m
//  CodeRougeLab
//
//  Created by Gianni Settino on 1/7/2014.
//  Copyright (c) 2014 WhereCloud Inc. All rights reserved.
//

#import "GSCodeRougeLabCellController.h"

@interface GSCodeRougeLabCellController ()

@property (nonatomic, retain) UIImageView* rightImage;
@property (nonatomic, assign) CGFloat rightImageOriginalX;

@end

@implementation GSCodeRougeLabCellController

// How far the user has to drag before the cell's horizontal scrollview "catches"
const int kCatchWidth = 60;

// The left and right margins for the rightImage
const int kRightImageMargin = 15;

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
        
        // Get all the views that form the contentView of our scrollView
        UIView *backgroundView = [scrollView viewWithKeyPath:@"BackgroundView"];
        UIView *cellMainContentView = [scrollView viewWithKeyPath:@"CellMainContentView"];
        UILabel *loremIpsum = [scrollView viewWithKeyPath:@"LoremIpsum"];
        UIView *cellBottomButtonRow = [scrollView viewWithKeyPath:@"CellBottomButtonRow"];
        
        // Get the views that are under the scrollView
        UIView *leftUnderView = [cell.contentView viewWithKeyPath:@"LeftUnderView"];
        UIView *rightUnderView = [cell.contentView viewWithKeyPath:@"RightUnderView"];
        bself.rightImage = [cell.contentView viewWithKeyPath:@"RightImage"];
        
        // Get all the labels and images we have to set in the main cell
        UIImageView *carImage = (UIImageView *)[cellMainContentView viewWithKeyPath:@"CarImage"];
        carImage.image = [UIImage imageNamed:thisCar.imageName];
        
        UILabel *titleLabel = (UILabel *)[cellMainContentView viewWithKeyPath:@"TitleLabel"];
        titleLabel.text = thisCar.title;
        
        UILabel *mileageAndTransmissionLabel = (UILabel *)[cellMainContentView viewWithKeyPath:@"MileageAndTransmissionLabel"];
        mileageAndTransmissionLabel.text = thisCar.transmission;
        
        /*UILabel *timeRemainingLabel = (UILabel *)[cellMainContentView viewWithKeyPath:@"TimeRemainingLabel"];
         timeRemainingLabel.text = thisCar.transmission;*/
        
        // Get all the buttons we have to manipulate in the bottomButtonRow
        UIButton *detailsButton = [cellBottomButtonRow viewWithKeyPath:@"DetailsButton"];
        [detailsButton setTitle:@"Details" forState:UIControlStateNormal];
        
        UIButton *contactButton = [cellBottomButtonRow viewWithKeyPath:@"ContactButton"];
        [contactButton setTitle:@"Contact" forState:UIControlStateNormal];
        
        UIButton *callButton = [cellBottomButtonRow viewWithKeyPath:@"CallButton"];
        [callButton setTitle:@"Call" forState:UIControlStateNormal];
        
        UIButton *freezeButton = [cellBottomButtonRow viewWithKeyPath:@"FreezeButton"];
        [freezeButton setTitle:@"Freeze" forState:UIControlStateNormal];
        
        void (^setProperAppearance)(void) = ^(void) {
            if (bself.selected) {
                backgroundView.backgroundColor = [UIColor colorWithRGBValue:0x333333];
                titleLabel.textColor = [UIColor whiteColor];
                mileageAndTransmissionLabel.textColor = [UIColor whiteColor];
                leftUnderView.backgroundColor = [UIColor colorWithRGBValue:0x1a1a1a];
                rightUnderView.backgroundColor = [UIColor colorWithRGBValue:0x262626];
                loremIpsum.hidden = NO;
                cellBottomButtonRow.hidden = NO;
            } else {
                backgroundView.backgroundColor = [UIColor whiteColor];
                titleLabel.textColor = [UIColor blackColor];
                mileageAndTransmissionLabel.textColor = [UIColor blackColor];
                leftUnderView.backgroundColor = [UIColor colorWithRGBValue:0xe6e6e6];
                rightUnderView.backgroundColor = [UIColor colorWithRGBValue:0xdedede];
                loremIpsum.hidden = YES;
                cellBottomButtonRow.hidden = YES;
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
    
    [self setLayoutBlock:^(CKTableViewCellController *controller, UITableViewCell *cell) {
        //[controller performLayout];
        //NSLog(@"rightImage frame = %@", NSStringFromCGRect(bself.rightImage.frame));
        // Now move this right image to kRightImageMargin pixels offscreen
        bself.rightImage.frame = CGRectMake(cell.bounds.size.width+kRightImageMargin, bself.rightImage.frame.origin.y, bself.rightImage.frame.size.width, bself.rightImage.frame.size.height);
        bself.rightImageOriginalX = bself.rightImage.frame.origin.x;
    }];
    
    return self;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat scrolledAmount = scrollView.contentOffset.x;
    NSLog(@"contentOffset = %f", scrolledAmount);
    
    CGFloat rightImageY = self.rightImage.frame.origin.y;
    CGFloat rightImageWidth = self.rightImage.frame.size.width;
    CGFloat rightImageHeight = self.rightImage.frame.size.height;
    
    // After this point, the right image will stop shifting with the scrollview
    CGFloat scrollThreshold = 2*kRightImageMargin + rightImageWidth;
    
    // Move the right image so it keeps up with the scrollView
    if (scrolledAmount <= scrollThreshold) {
        self.rightImage.frame = CGRectMake(self.rightImageOriginalX-scrolledAmount, rightImageY, rightImageWidth, rightImageHeight);
    } else {
        self.rightImage.frame = CGRectMake(self.rightImageOriginalX-scrollThreshold, rightImageY, rightImageWidth, rightImageHeight);
    }
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
