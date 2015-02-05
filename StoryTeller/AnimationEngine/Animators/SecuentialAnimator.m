//
//  SecuentialAnimator.m
//  StoryTeller
//
//  Created by Héctor Rodríguez Forniés on 08/08/12.
//  Copyright (c) 2012 Héctor Rodríguez Forniés. All rights reserved.
//

#import "SecuentialAnimator.h"



@interface SecuentialAnimator ()
    
@property (nonatomic, strong) NSMutableArray *sequenceCopy;

@end

@implementation SecuentialAnimator

@synthesize sequence;
@synthesize sequenceCopy;
@synthesize theViewAnimated;
@synthesize delegate;

- (id) initWithSimultaneousAnimatorGroupArray: (NSMutableArray *) theArray  AndView: (UIView *) theView{
    
    if (self = [super init]){
        
        sequence = theArray;
        sequenceCopy = [[NSMutableArray alloc] initWithArray:theArray copyItems:NO];
        theViewAnimated = theView;
        
    }
    
    return self;
    
}


/*
 
 Perform the sequential animation of the first animation object and removes it after do it
 
 */
- (void) performNextSequentialAnimation {
    
    if (self.sequenceCopy.count > 0) {
        
        
        //Perform animation
        SimultaneousAnimatorGroup *group = (SimultaneousAnimatorGroup *) [self.sequenceCopy objectAtIndex:0];
        
        if(group){
            [group performAnimationSimultaneousAnimator];
        }
        
        //Remove the animated object
        [self.sequenceCopy removeObjectAtIndex:0];
        
    }else{
        [self.delegate didFinishSecuentialAnimator:self];
    }
    
}

/* 
 
 When the SimultaneousAnimatorGroup finish perform the next animation
 
 */
- (void) didFinishSimultaneousAnimatorGroup: (SimultaneousAnimatorGroup *) simultaneousAnimatorGroup{

    [self performNextSequentialAnimation];

}

@end



