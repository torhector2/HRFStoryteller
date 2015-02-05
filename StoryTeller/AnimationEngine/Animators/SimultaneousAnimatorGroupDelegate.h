//
//  SimultaneousAnimatorGroupDelegate.h
//  StoryTeller
//
//  Created by Héctor Rodríguez Forniés on 08/08/12.
//  Copyright (c) 2012 Héctor Rodríguez Forniés. All rights reserved.
//

#import <Foundation/Foundation.h>
@class SimultaneousAnimatorGroup;

@protocol SimultaneousAnimatorGroupDelegate <NSObject>

- (void) didFinishSimultaneousAnimatorGroup: (SimultaneousAnimatorGroup *) simultaneousAnimatorGroup;

@end
