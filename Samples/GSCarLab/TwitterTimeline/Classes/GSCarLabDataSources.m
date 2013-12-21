//
//  GSCarLabDataSources.m
//
//  Created by Gianni Settino on 12/21/2013.
//

#import "GSCarLabDataSources.h"
#import "GSCodeRougeLabCarModel.h"

@implementation GSCarLabDataSources

+ (CKFeedSource*)feedSourceForCars{
    CKFeedSource* feedSource = [CKFeedSource feedSource];
    
    feedSource.fetchBlock = ^(CKFeedSource* feedSource, NSRange range){
        //Create and return an array with 10 dummy cars
        NSMutableArray *array = [NSMutableArray array];
        for (int i = 0; i < 10; i++) {
            GSCodeRougeLabCarModel *car = [[GSCodeRougeLabCarModel alloc] init];
            [array addObject:car];
        }
        
        [feedSource addItems:array];
    };
    
    return feedSource;
}

@end
