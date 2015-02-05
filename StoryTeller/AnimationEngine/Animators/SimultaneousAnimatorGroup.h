//
//  SimultaneousAnimatorGroup.h
//  StoryTeller
//
//  Created by Héctor Rodríguez Forniés on 07/08/12.
//  Copyright (c) 2012 Héctor Rodríguez Forniés. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SimultaneousAnimator.h"
#import "SimultaneousAnimatorGroupDelegate.h"
#import "SimoultaneousAnimatorDelegate.h"

@interface SimultaneousAnimatorGroup : NSObject <SimoultaneousAnimatorDelegate>

@property(nonatomic, strong) NSMutableArray *simultaneousAnimatorArray;
@property(nonatomic, strong)  id <SimultaneousAnimatorGroupDelegate> delegate;


- (id) initWithSimultaneousAnimatorArray: (NSMutableArray *) theArray andDelegate: (id <SimultaneousAnimatorGroupDelegate>) aDelegate;

- (void) performAnimationSimultaneousAnimator;

@end
