//
//  SimultaneousAnimator.h
//  StoryTeller
//
//  Created by Héctor Rodríguez Forniés on 07/08/12.
//  Copyright (c) 2012 Héctor Rodríguez Forniés. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>
#import "SimoultaneousAnimatorDelegate.h"

@interface SimultaneousAnimator : NSObject

//The layer to apply the animations
@property(nonatomic, strong) CALayer *layer;

//A mutable array of animations
@property(nonatomic, strong) NSMutableArray *animations;

//A mutable array of animations keys
@property(nonatomic, strong) NSMutableArray *animationsKeys;


@property(nonatomic, strong) id <SimoultaneousAnimatorDelegate> delegate;


//Init methods
- (id) initWithLayer: (CALayer *) aLayer Animations: (NSMutableArray *) theAnimations AndAnimationsKeys: (NSMutableArray *) theKeys AndDelegate: (id<SimoultaneousAnimatorDelegate>) aDelegate;

- (void) performAnimation;

@end
