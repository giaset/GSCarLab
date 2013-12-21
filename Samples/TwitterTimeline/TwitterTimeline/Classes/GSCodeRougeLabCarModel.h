//
//  GSCodeRougeLabCarModel.h
//  CodeRougeLab
//
//  Created by Gianni Settino on 12-20-2013.
//  Copyright (c) 2013 WhereCloud Inc. All rights reserved.
//

#import <AppCoreKit/AppCoreKit.h>

@interface GSCodeRougeLabCarModel : CKObject
@property(nonatomic,copy) NSURL* imageUrl;
@property(nonatomic,copy) NSString* name;
@property(nonatomic,copy) NSString* message;
@property(nonatomic,copy) NSString* identifier;
@end
