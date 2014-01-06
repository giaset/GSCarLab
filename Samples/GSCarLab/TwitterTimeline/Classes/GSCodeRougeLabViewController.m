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
        
        // Setup toolbar
        UIToolbar *toolbar = [bself toolbarForCar:thisCar];
        toolbar.frame = CGRectMake(0, 80, 320, 44);
        [cell.contentView addSubview:toolbar];
        
        void (^setProperAppearance)(void) = ^(void) {
            if (bself.selectedCar == thisCar) {
                cell.backgroundColor = [UIColor colorWithRGBValue:0x333333];
                titleLabel.textColor = [UIColor whiteColor];
                mileageAndTransmissionLabel.textColor = [UIColor whiteColor];
                toolbar.alpha = 1;
            } else {
                cell.backgroundColor = [UIColor whiteColor];
                titleLabel.textColor = [UIColor blackColor];
                mileageAndTransmissionLabel.textColor = [UIColor blackColor];
                toolbar.alpha = 0;
            }
        };
        
        //Initial setup of cell appearance
        setProperAppearance();
        
        [cell beginBindingsContextByRemovingPreviousBindings];
        
        //Color transitions
        [bself bind:@"selectedCar" withBlock:^(id value) {
            [UIView animateWithDuration:0.5f animations:^{
                setProperAppearance();
            }];
            [bself.tableView beginUpdates];
            [bself.tableView endUpdates];
        }];
        
        [cell endBindingsContext];
    }];
    
    return cellController;
}

- (UIToolbar*)toolbarForCar:(GSCodeRougeLabCarModel*)car
{
    UIToolbar *toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    toolbar.tintColor = [UIColor whiteColor];
    toolbar.barTintColor = [UIColor redColor];
    
    UIBarButtonItem *flexButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:nil];
    
    NSArray *itemsArray = [NSArray arrayWithObjects:flexButton, doneButton, nil];
    
    [toolbar setItems:itemsArray];
    
    return toolbar;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat defaultHeight = [super tableView:tableView heightForRowAtIndexPath:indexPath];
    
    GSCodeRougeLabCarModel *thisCar = [self.cars objectAtIndex:indexPath.row];
    
    if (self.selectedCar == thisCar) {
        return defaultHeight+44;
    } else {
        return defaultHeight;
    }
}

@end
