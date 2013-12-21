//
//  GSCodeRougeLabCarModel.m
//  CodeRougeLab
//
//  Created by Gianni Settino on 12-20-2013.
//

#import "GSCodeRougeLabCarModel.h"

@implementation GSCodeRougeLabCarModel

- (id)init
{
    self = [super init];
    if (self) {
        self.imageName = @"car";
        self.title = @"Honda Civic";
        self.year = 2011;
        self.discountedPrice = 50000;
        self.fullPrice = 60000;
        self.mileage = 2938;
        self.transmission = @"manuelle";
        self.expiryDate = [NSDate dateWithTimeIntervalSinceNow:604800]; // one week from now = 6048000 seconds
    }
    return self;
}

- (id)initWithReferenceNumber:(NSString *)referenceNumber{
    self = [self init];
    self.referenceNumber = referenceNumber;
    return self;
}

@end
