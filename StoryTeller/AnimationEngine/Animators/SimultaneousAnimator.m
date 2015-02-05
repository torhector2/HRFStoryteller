//
//  SimultaneousAnimator.m
//  StoryTeller
//
//  Created by Héctor Rodríguez Forniés on 07/08/12.
//  Copyright (c) 2012 Héctor Rodríguez Forniés. All rights reserved.
//

#import "SimultaneousAnimator.h"

@interface SimultaneousAnimator ()

//A mutable array of animations, the copy
@property(nonatomic, strong) NSMutableArray *animationsCopy;

@end


#define KVCkey @"id_anim"

@implementation SimultaneousAnimator


@synthesize layer;
@synthesize animations;
@synthesize animationsKeys;

@synthesize animationsCopy;

@synthesize delegate;


- (id) initWithLayer: (CALayer *) aLayer Animations: (NSMutableArray *) theAnimations AndAnimationsKeys: (NSMutableArray *) theKeys AndDelegate: (id<SimoultaneousAnimatorDelegate>) aDelegate{
    
    if (self = [super init]){
        
        layer = aLayer;
        
        animations = theAnimations;
        
        //animationsCopy = [[NSMutableArray alloc] initWithArray:theAnimations copyItems:YES];
        animationsCopy = [NSMutableArray array];
        for (id obj in animations) {
            [animationsCopy addObject:obj];
        }
        
        animationsKeys = theKeys;
        
        delegate = aDelegate;
        
    }
    
    return self;
    
}

/*
 
 Perform a list of animations that animates the layer
 
 */
- (void) performAnimation{
    
    int count = self.animations.count;
    
    for (int i=0; i < count; i++) {
        
        //Get the animation and animationKey
        CAAnimation *anim = (CAAnimation *)[self.animations objectAtIndex:i];
        anim.delegate = self;
        
        NSString *keyAnimation = (NSString *) [self.animationsKeys objectAtIndex:i];
        
        
        //Add the animation to the layer and perform the animation
        [anim setValue:keyAnimation forKey:KVCkey]; //KVC
        [self.layer addAnimation:anim forKey:keyAnimation];
        
    }    
}


//Animation delegate 
- (void)animationDidStop:(CAAnimation *)theAnimation finished:(BOOL)flag{
    
    
    //Remove the finish animation
    
    
    //The animation in the argument isn't the original animation. It is a copy (The system do that) so we have to
    //use KVC to check the identity of that animation
    
    NSString *keyAnimationArgument = [theAnimation valueForKey:KVCkey];
    
    for (CAAnimation *anim in self.animationsCopy) {
        
        if ([[anim valueForKey:KVCkey] isEqualToString:keyAnimationArgument]) {
            [self.animationsCopy removeObject:anim];
        }
        
    }
    
    
    if(self.animationsCopy.count == 0){
        
        //When all simultaneous animations finish, we notifies the delegate
        [self.delegate didFinishSimoultaneousAnimator:self];
        
    }
    
}






@end
