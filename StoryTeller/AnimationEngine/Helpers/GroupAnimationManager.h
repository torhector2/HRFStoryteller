//
//  GroupAnimationManager.h
//  TestingAnimations
//
//  Created by Héctor Rodríguez Forniés on 28/07/12.
//  Copyright (c) 2012 Héctor Rodríguez Forniés. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>

@interface GroupAnimationManager : NSObject


+ (CAAnimationGroup *) prepareGroupAnimationFromDictionary: (NSDictionary *) dict WithGroupIdentifier: (NSString *) groupId;

+ (CAAnimationGroup *) prepareGroupAnimationFromDictionary: (NSDictionary *) dict
                                       WithGroupIdentifier: (NSString *) groupId
                                        AndAnimationsDictionary: (NSDictionary *) theAnims;

@end
