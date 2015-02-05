//
//  SimultaneousAnimatorGroup.m
//  StoryTeller
//
//  Created by Héctor Rodríguez Forniés on 07/08/12.
//  Copyright (c) 2012 Héctor Rodríguez Forniés. All rights reserved.
//

#import "SimultaneousAnimatorGroup.h"

@interface SimultaneousAnimatorGroup ()

@property(nonatomic, strong) NSMutableArray *simultaneousAnimatorArrayCopy;

@end

@implementation SimultaneousAnimatorGroup

@synthesize simultaneousAnimatorArray;
@synthesize simultaneousAnimatorArrayCopy;

//delegate
@synthesize delegate;

- (id) initWithSimultaneousAnimatorArray: (NSMutableArray *) theArray andDelegate: (id <SimultaneousAnimatorGroupDelegate>) aDelegate {
    
    if (self = [super init]){
        
        simultaneousAnimatorArray = theArray;
        simultaneousAnimatorArrayCopy = [[NSMutableArray alloc] initWithArray:theArray copyItems:NO];
        
        
        delegate = aDelegate;
        
    }
    
    return self;
    
}


- (void) performAnimationSimultaneousAnimator{
    
    for (SimultaneousAnimator *simAnimator in self.simultaneousAnimatorArray) {
        
        //Perform the animation for every SimultaneousAnimator
        [simAnimator performAnimation];
        
    }
    
}



/*
 
 A delegate method that notifies that a SimultaneousAnimator has finished
 
 */

-(void) didFinishSimoultaneousAnimator:(SimultaneousAnimator *)simultaneousAnimator{
    
    //Remove the finish animation
    [self.simultaneousAnimatorArrayCopy removeObject:simultaneousAnimator];
    
    //If there isn't any animation the all of theme are finished
    if(self.simultaneousAnimatorArrayCopy.count == 0){
        
        //When all simultaneous animations finish, we notifies the delegate
        [self.delegate didFinishSimultaneousAnimatorGroup:self];
        
    }
    
    
    
}

@end
