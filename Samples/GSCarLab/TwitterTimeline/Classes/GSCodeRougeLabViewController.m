//
//  GSCodeRougeLabViewController.m
//  CodeRougeLab
//
//  Created by Gianni Settino on 12-20-2013.
//  Copyright (c) 2013 WhereCloud Inc. All rights reserved.
//

#import "GSCodeRougeLabViewController.h"
#import "GSCarLabDataSources.h"

@interface GSCodeRougeLabViewController ()
@property(nonatomic) CKArrayCollection *cars;
@property(nonatomic,retain) GSCodeRougeLabCarModel *selectedCar;
@end

@implementation GSCodeRougeLabViewController

- (id)init
{
    self = [super init];
    if (self) {
        self.cars = [[CKArrayCollection alloc] initWithFeedSource:[GSCarLabDataSources feedSourceForCars]];
        self.selectedCar = nil;
        [self setup];
    }
    return self;
}

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
    CKFormBindedCollectionSection *section = [CKFormBindedCollectionSection sectionWithCollection:self.cars factory:carFactory appendSpinnerAsFooterCell:NO];
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
        
        //Get all the labels and images we have to set
        UIImageView *carImage = (UIImageView *)[cell.contentView viewWithKeyPath:@"CarImage"];
        carImage.image = [UIImage imageNamed:thisCar.imageName];
        
        UILabel *titleLabel = (UILabel *)[cell.contentView viewWithKeyPath:@"TitleLabel"];
        titleLabel.text = thisCar.title;
        
        UILabel *mileageAndTransmissionLabel = (UILabel *)[cell.contentView viewWithKeyPath:@"MileageAndTransmissionLabel"];
        mileageAndTransmissionLabel.text = thisCar.transmission;
        
        /*UILabel *timeRemainingLabel = (UILabel *)[cell.contentView viewWithKeyPath:@"TimeRemainingLabel"];
        timeRemainingLabel.text = thisCar.transmission;*/
        
        void (^setProperColors)(void) = ^(void) {
            if (bself.selectedCar == thisCar) {
                cell.backgroundColor = [UIColor colorWithRGBValue:0x333333];
                titleLabel.textColor = [UIColor whiteColor];
                mileageAndTransmissionLabel.textColor = [UIColor whiteColor];
            } else {
                cell.backgroundColor = [UIColor whiteColor];
                titleLabel.textColor = [UIColor blackColor];
                mileageAndTransmissionLabel.textColor = [UIColor blackColor];
            }
        };
        
        //Initial setup of colors
        setProperColors();
        
        [cell beginBindingsContextByRemovingPreviousBindings];
        
        //Color transitions
        [bself bind:@"selectedCar" withBlock:^(id value) {
            [UIView animateWithDuration:0.5f animations:^{
                setProperColors();
                if (bself.selectedCar == thisCar) {
                    [bself addDetailsCellBelowCellController:controller];
                }
                //toolbar.hidden = !(bself.selectedTweet == thisTweet);
            }];
        }];
        
        [cell endBindingsContext];
    }];
    
    return cellController;
}

- (void)addDetailsCellBelowCellController:(CKTableViewCellController *)cellController
{
    //Get the car in order to create a custom cell controller for it
    //GSCodeRougeLabCarModel *car = (GSCodeRougeLabCarModel *) cellController.value;
    
    //Get current section
    CKFormSection *section = (CKFormSection *)[self sectionAtIndex:0];
    
    //Create a custom cellController and add it right under the selected cell
    CKTableViewCellController *detailsCellController = [CKTableViewCellController cellController];
    detailsCellController.text = @"Details";
    [detailsCellController setInitBlock:^(CKTableViewCellController *controller, UITableViewCell *cell) {
        cell.backgroundColor = [UIColor colorWithRGBValue:0x333333];
        cell.textLabel.textColor = [UIColor whiteColor];
    }];
    
    //[section insertCellController:detailsCellController atIndex:cellController.indexPath.row + 1];
    //[section removeCellControllerAtIndex:cellController.indexPath.row + 1];
}

@end
