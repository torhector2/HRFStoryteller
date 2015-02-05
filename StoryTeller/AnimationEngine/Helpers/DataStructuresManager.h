//
//  DataStructuresManager.h
//  TestingAnimations
//
//  Created by Héctor Rodríguez Forniés on 26/07/12.
//  Copyright (c) 2012 Héctor Rodríguez Forniés. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DataStructuresManager : NSObject


+ (NSNumber *) numberFromArray: (NSArray *) arrayNumbers;
+ (CGPoint) pointFromArray: (NSArray *) arrayNumbers;
+ (CGSize) sizeFromArray: (NSArray *) arrayNumbers;
+ (CGRect) rectFromArray: (NSArray *) arrayNumbers;

@end
