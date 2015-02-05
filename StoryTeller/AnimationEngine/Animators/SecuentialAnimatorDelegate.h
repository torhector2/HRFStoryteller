//
//  SecuentialAnimatorDelegate.h
//  StoryTeller
//
//  Created by Héctor Rodríguez Forniés on 30/11/12.
//
//

#import <Foundation/Foundation.h>
@class SecuentialAnimator;

@protocol SecuentialAnimatorDelegate <NSObject>


-(void) didFinishSecuentialAnimator: (SecuentialAnimator *) secAnimator;


@end
