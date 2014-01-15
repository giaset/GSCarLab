//
//  GSCodeRougeLabViewController.m
//  CodeRougeLab
//
//  Created by Gianni Settino on 12-20-2013.
//  Copyright (c) 2013 WhereCloud Inc. All rights reserved.
//

#import "GSCodeRougeLabViewController.h"
#import "GSCarLabDataSources.h"
#import "GSCodeRougeLabCarModel.h"
#import "GSCodeRougeLabCellController.h"

@interface GSCodeRougeLabViewController ()
@property(nonatomic) CKArrayCollection *cars;
@property(nonatomic,retain) GSCodeRougeLabCellController *selectedCellController;
@end

@implementation GSCodeRougeLabViewController

- (id)init
{
    self = [super init];
    if (self) {
        self.cars = [[CKArrayCollection alloc] initWithFeedSource:[GSCarLabDataSources feedSourceForCars]];
        self.selectedCellController = nil;
        [self setup];
        self.tableView.delegate = self;
    }
    return self;
}

- (void)setup{
    __unsafe_unretained GSCodeRougeLabViewController *bself = self;
    
    self.title = @"Honda Civic";
    
    //Setup the factory that creates cell controllers from our collection
    CKCollectionCellControllerFactory* factory = [CKCollectionCellControllerFactory factory];
    [factory addItemForObjectOfClass:[GSCodeRougeLabCarModel class] withControllerCreationBlock:^CKCollectionCellController *(id object, NSIndexPath *indexPath) {
        GSCodeRougeLabCarModel* car = (GSCodeRougeLabCarModel *)object;
        GSCodeRougeLabCellController *cellController = [[GSCodeRougeLabCellController alloc]initWithCar:car selectionBlock:^(GSCodeRougeLabCellController *clickedCellController) {
            //Set the selected cellController and update the tableview to account for changing cell heights
            [bself.tableView beginUpdates];
            
            // If we're re-clicking an already selected cell
            if (bself.selectedCellController == clickedCellController) {
                bself.selectedCellController = nil;
                clickedCellController.selected = NO;
            } else {
                bself.selectedCellController.selected = NO;
                clickedCellController.selected = YES;
                bself.selectedCellController = clickedCellController;
            }
            
            [bself.tableView endUpdates];
        }];
        return cellController;
    }];
    
    //Setup the section binded to the self.cars collection
    CKFormBindedCollectionSection *section = [CKFormBindedCollectionSection sectionWithCollection:self.cars factory:factory appendSpinnerAsFooterCell:NO];
    [self addSections:@[section]];
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat scrolledAmount = scrollView.contentOffset.y;
    
    //NSLog(@"%f", scrolledAmount);
    
    UINavigationBar* navBar = self.navigationController.navigationBar;
    CGRect navBarFrame = navBar.frame;
    CGRect viewFrame = self.view.frame;
    
    if (scrolledAmount > 100) {
        navBarFrame.size.height = 20;
        viewFrame.size.height = 528;
        viewFrame.origin.y = 40;
    } else {
        navBarFrame.size.height = 44;
        viewFrame.size.height = 504;
        viewFrame.origin.y = 64;
    }
    [UIView animateWithDuration:0.3 animations:^{
        [navBar setFrame:navBarFrame];
        [self.view setFrame:viewFrame];
    }];
}

@end
