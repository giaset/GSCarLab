//
//  GSCodeRougeLabCellController.h
//  CodeRougeLab
//
//  Created by Gianni Settino on 1/7/2014.
//  Copyright (c) 2014 WhereCloud Inc. All rights reserved.
//

#import <AppCoreKit/AppCoreKit.h>
#import "GSCodeRougeLabCarModel.h"

typedef enum GSCellLeftButtonShowing{
    GSCellLeftButtonShowingNone,
    GSCellLeftButtonShowingFirst,
    GSCellLeftButtonShowingSecond
}GSCellLeftButtonShowing;

@interface GSCodeRougeLabCellController : CKTableViewCellController <UIScrollViewDelegate, UIGestureRecognizerDelegate>

@property (nonatomic, assign) BOOL selected;

-(id)initWithCar:(GSCodeRougeLabCarModel*)car selectionBlock:(void(^)(GSCodeRougeLabCellController* clickedCellController))selectionBlock;

@end
