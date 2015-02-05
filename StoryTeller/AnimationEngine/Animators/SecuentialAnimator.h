//
//  SecuentialAnimator.h
//  StoryTeller
//
//  Created by Héctor Rodríguez Forniés on 08/08/12.
//  Copyright (c) 2012 Héctor Rodríguez Forniés. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SimultaneousAnimatorGroup.h"
#import "SimultaneousAnimatorGroupDelegate.h"
#import "SecuentialAnimatorDelegate.h"


@interface SecuentialAnimator : NSObject <SimultaneousAnimatorGroupDelegate>

@property(nonatomic, strong) NSMutableArray *sequence;

@property(nonatomic, strong) UIView *theViewAnimated;

@property(nonatomic, strong) id <SecuentialAnimatorDelegate> delegate;

- (id) initWithSimultaneousAnimatorGroupArray: (NSMutableArray *) theArray AndView: (UIView *) theView;

-(void) performNextSequentialAnimation;


//Delegate method
- (void)  didFinishSimultaneousAnimatorGroup: (SimultaneousAnimatorGroup *) simultaneousAnimatorGroup;

@end
