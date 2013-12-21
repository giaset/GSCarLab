//
//  GSCodeRougeLabViewController.m
//  CodeRougeLab
//
//  Created by Gianni Settino on 12-20-2013.
//  Copyright (c) 2013 WhereCloud Inc. All rights reserved.
//

#import "GSCodeRougeLabViewController.h"

@interface GSCodeRougeLabViewController ()
@property(nonatomic) CKArrayCollection* cars;
@property(nonatomic,retain) GSCodeRougeLabCarModel* selectedCar;
@end

@implementation GSCodeRougeLabViewController

- (id)init
{
    self = [super init];
    if (self) {
        self.selectedCar = nil;
        [self setup];
    }
    return self;
}

//timeline.tweets.feedSource = [CKSampleTwitterDataSources feedSourceForTweets];

- (void)setup{
    self.title = @"Honda Civic";
    
    __unsafe_unretained GSCodeRougeLabViewController* bself = self;
    
    //Setup the factory that creates cell controllers from our collection
    CKCollectionCellControllerFactory* carFactory = [CKCollectionCellControllerFactory factory];
    [carFactory addItemForObjectOfClass:[GSCodeRougeLabCarModel class] withControllerCreationBlock:^CKCollectionCellController *(id object, NSIndexPath *indexPath) {
        GSCodeRougeLabCarModel* car = (GSCodeRougeLabCarModel *)object;
        return [bself cellControllerForCar:car];
    }];
    
    //Setup the section binded to the self.timeline.tweets collection
    CKFormBindedCollectionSection* section = [CKFormBindedCollectionSection sectionWithCollection:self.cars factory:carFactory appendSpinnerAsFooterCell:YES];
    [self addSections:@[section]];
}


- (CKTableViewCellController*)cellControllerForCar:(GSCodeRougeLabCarModel *)car{
    __unsafe_unretained GSCodeRougeLabViewController *bself = self;
    
    CKTableViewCellController* cellController = [CKTableViewCellController cellControllerWithName:nil action:^(CKTableViewCellController *controller) {
        GSCodeRougeLabCarModel *thisCar = (GSCodeRougeLabCarModel *) controller.value;
        bself.selectedCar = (bself.selectedCar == thisCar) ? nil : thisCar;
    }];
    cellController.value = car;
    
    //Setup block
    [cellController setSetupBlock:^(CKTableViewCellController *controller, UITableViewCell *cell) {        
        GSCodeRougeLabCarModel *thisCar = (GSCodeRougeLabCarModel *) controller.value;
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [cell beginBindingsContextByRemovingPreviousBindings];
        
        [bself bind:@"selectedTweet" executeBlockImmediatly:YES withBlock:^(id value) {
            [UIView animateWithDuration:0.5f animations:^{
                cell.backgroundColor = (bself.selectedCar == thisCar) ? [UIColor colorWithRGBValue:0x333333] : [UIColor whiteColor];
                cell.textLabel.textColor = (bself.selectedCar == thisCar) ? [UIColor whiteColor] : [UIColor blackColor];
                cell.detailTextLabel.textColor = (bself.selectedCar == thisCar) ? [UIColor whiteColor] : [UIColor blackColor];
                //toolbar.hidden = !(bself.selectedTweet == thisTweet);
            }];
        }];
        
        [cell endBindingsContext];
    }];
    
    return cellController;
}

- (void)addToolbarToCellController:(CKTableViewCellController *)cellController
{
    //Get the tweet and create a toolbar for it
    GSCodeRougeLabCarModel *car = (GSCodeRougeLabCarModel *) cellController.value;
    UIToolbar *toolbar = [self customToolbarForCar:car];
    
    //Get current section
    CKFormTableViewController *currentForm = (CKFormTableViewController *)cellController.containerController;
    CKFormSection *section = (CKFormSection *)[currentForm sectionAtIndex:cellController.indexPath.section];
    
    //Create a dummy cellController that has the toolbar as its view and add it to the section right under the selected cell
    
}

- (UIToolbar *)customToolbarForCar:(GSCodeRougeLabCarModel *)car{
    UIToolbar *toolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 44)];
    toolbar.tintColor = [UIColor whiteColor];
    toolbar.barTintColor = [UIColor redColor];
    
    UIBarButtonItem *previousButton = [[UIBarButtonItem alloc]initWithTitle:_(@"Previous") style:UIBarButtonItemStyleBordered block:^{
    }];
    
    UIBarButtonItem *nextButton = [[UIBarButtonItem alloc]initWithTitle:_(@"Next") style:UIBarButtonItemStyleBordered block:^{
    }];
    
    UIBarButtonItem *flexButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemDone block:^{
    }];
    
    NSArray *itemsArray = [NSArray arrayWithObjects:previousButton, nextButton, flexButton, doneButton, nil];
    
    [toolbar setItems:itemsArray];
    
    return toolbar;
}

@end
