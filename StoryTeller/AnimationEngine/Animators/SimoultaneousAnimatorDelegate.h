//
//  SimoultaneousAnimatorDelegate.h
//  StoryTeller
//
//  Created by Héctor Rodríguez Forniés on 08/08/12.
//  Copyright (c) 2012 Héctor Rodríguez Forniés. All rights reserved.
//

#import <Foundation/Foundation.h>
@class SimultaneousAnimator;

@protocol SimoultaneousAnimatorDelegate <NSObject>

- (void) didFinishSimoultaneousAnimator: (SimultaneousAnimator *) simultaneousAnimator;

@end
