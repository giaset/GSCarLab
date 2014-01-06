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
    CKCollectionCellControllerFactory* factory = [CKCollectionCellControllerFactory factory];
    [factory addItemForObjectOfClass:[GSCodeRougeLabCarModel class] withControllerCreationBlock:^CKCollectionCellController *(id object, NSIndexPath *indexPath) {
        GSCodeRougeLabCarModel* car = (GSCodeRougeLabCarModel *)object;
        return [bself cellControllerForCar:car];
    }];
    
    //Setup the section binded to the self.cars collection
    CKFormBindedCollectionSection *section = [CKFormBindedCollectionSection sectionWithCollection:self.cars factory:factory appendSpinnerAsFooterCell:NO];
    [self addSections:@[section]];
}


- (CKTableViewCellController*)cellControllerForCar:(GSCodeRougeLabCarModel *)car{
    __unsafe_unretained GSCodeRougeLabViewController *bself = self;
    
    CKTableViewCellController* cellController = [CKTableViewCellController cellControllerWithName:nil action:^(CKTableViewCellController *controller) {
        GSCodeRougeLabCarModel *thisCar = (GSCodeRougeLabCarModel *) controller.value;
        
        //Set the selected car and update the tableview to account for changing cell heights
        [bself.tableView beginUpdates];
        bself.selectedCar = (bself.selectedCar == thisCar) ? nil : thisCar;
        [bself.tableView endUpdates];
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
        
        void (^setProperAppearance)(void) = ^(void) {
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
        
        //Initial setup of cell appearance.
        //We do this here first because we don't want it to be animated when cells
        //get created, only when the selectedCar changes
        setProperAppearance();
        
        [cell beginBindingsContextByRemovingPreviousBindings];
        
        //Color transitions
        [bself bind:@"selectedCar" withBlock:^(id value) {
            [UIView animateWithDuration:0.3f animations:^{
                setProperAppearance();
            }];
        }];
        
        [cell endBindingsContext];
    }];
    
    return cellController;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat defaultHeight = [super tableView:tableView heightForRowAtIndexPath:indexPath];
    
    GSCodeRougeLabCarModel *thisCar = [self.cars objectAtIndex:indexPath.row];
    
    if (self.selectedCar == thisCar) {
        return defaultHeight*2;
    } else {
        return defaultHeight;
    }
}

@end
