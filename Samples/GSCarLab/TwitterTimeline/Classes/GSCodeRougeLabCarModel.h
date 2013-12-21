//
//  GSCodeRougeLabCarModel.h
//  CodeRougeLab
//
//  Created by Gianni Settino on 12-20-2013.
//

#import <AppCoreKit/AppCoreKit.h>

@interface GSCodeRougeLabCarModel : CKObject

@property(nonatomic,copy) NSString* referenceNumber;
@property(nonatomic,copy) NSString* imageName;
@property(nonatomic,copy) NSString* title;
@property(nonatomic,assign) NSInteger year;
@property(nonatomic,assign) NSInteger discountedPrice;
@property(nonatomic,assign) NSInteger fullPrice;
@property(nonatomic,assign) NSInteger mileage;
@property(nonatomic,copy) NSString* transmission;
@property(nonatomic,retain) NSDate* expiryDate;

- (id)initWithReferenceNumber:(NSString *)referenceNumber;

@end
