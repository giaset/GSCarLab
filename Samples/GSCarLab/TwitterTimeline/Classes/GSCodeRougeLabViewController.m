//
//  GSCodeRougeLabViewController.m
//  CodeRougeLab
//
//  Created by Gianni Settino on 12-20-2013.
//  Copyright (c) 2013 WhereCloud Inc. All rights reserved.
//

#import "GSCodeRougeLabViewController.h"

@interface GSCodeRougeLabViewController ()
@property(nonatomic) CKArrayCollection *cars;
@property(nonatomic,retain) GSCodeRougeLabCarModel *selectedCar;
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

- (void)setup{
    self.title = @"Honda Civic";
    
    __unsafe_unretained GSCodeRougeLabViewController* bself = self;
    
    //Setup our collection with dummy cars
    NSMutableArray *array = [NSMutableArray array];
    for (int i = 0; i < 20; i++) {
        GSCodeRougeLabCarModel *car = [[GSCodeRougeLabCarModel alloc] initWithReferenceNumber:i];
        [array addObject:car];
    }
    self.cars = [[CKArrayCollection alloc] initWithObjectsFromArray:array];
    
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
        
        cell.backgroundColor = (bself.selectedCar == thisCar) ? [UIColor colorWithRGBValue:0x333333] : [UIColor whiteColor];
        
        [cell beginBindingsContextByRemovingPreviousBindings];
        
        [bself bind:@"selectedCar" executeBlockImmediatly:YES withBlock:^(id value) {
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
    //Get the car in order to create a custom cell controller for it
    GSCodeRougeLabCarModel *car = (GSCodeRougeLabCarModel *) cellController.value;
    
    //Get current section
    CKFormTableViewController *currentForm = (CKFormTableViewController *)cellController.containerController;
    CKFormSection *section = (CKFormSection *)[currentForm sectionAtIndex:cellController.indexPath.section];
    
    //Create a dummy cellController that has the toolbar as its view and add it to the section right under the selected cell
    
}

@end
