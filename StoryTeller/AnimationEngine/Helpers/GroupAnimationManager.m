//
//  GroupAnimationManager.m
//  TestingAnimations
//
//  Created by Héctor Rodríguez Forniés on 28/07/12.
//  Copyright (c) 2012 Héctor Rodríguez Forniés. All rights reserved.
//

#import "GroupAnimationManager.h"
#import "AnimationManager.h"
#import "Constants.h"

@implementation GroupAnimationManager


/* 
    Returns an AnimationGroup based on the NSDictionary of the hole page and the identifier of the AnimationGroup desired
 
 */
+ (CAAnimationGroup *) prepareGroupAnimationFromDictionary: (NSDictionary *) dict WithGroupIdentifier: (NSString *) groupId {

    /*
     
     ...
     
     "group_name_1" : {
                         "options_group" : {
                                             "dato_1" : "",
                                             "dato_2" : "",
                                             "dato_n" : ""
                                           },
                    
                      "animations" : ["animation_name_1", "animation_name_5"]
                       }
     
     ...
     
     */
    
    
    NSDictionary *groups = [dict objectForKey:kGroupAnimations];
    
    if(!groups) return nil;
    
    
    NSDictionary *group = [groups objectForKey:groupId];
    
    if(!group) return nil;
    
    
    
    
    //First prepare the individual animations
    /////////////////////////////////////////
    
    //CAAnimationGroup *theAnimationGroup = [CAAnimationGroup animation];
    CAAnimationGroup *theAnimationGroup = [self prepareTheGroupFromDictionary:dict AndGroupId:groupId];
    
    if(!theAnimationGroup) return nil;
    
    
   
    NSArray *animationsArray = [group objectForKey:kAnimations];
    
    if(!animationsArray || animationsArray.count == 0) return nil;
    
    
    //Get the top level animations object 
    
    NSDictionary *animationsTopLevel = [dict objectForKey:kAnimations];
    
    //If not animations defined return nil
    if (!animationsTopLevel) return nil;
    
    
    NSMutableArray *animationsIndividualArray = [NSMutableArray array];
    
    for (NSString *keyAnimation in animationsArray) {
        
        //Get the correct dictionary
        NSDictionary *theIndividualAnimationDictionary = [animationsTopLevel objectForKey:keyAnimation];
        
        //Create the animation
        CAAnimation *theIndividualAnimation = [AnimationManager prepareAnimationFromDictionary:theIndividualAnimationDictionary];
        
        //Assign to the group
        if (theIndividualAnimation) {
            [animationsIndividualArray addObject:theIndividualAnimation];
        }
        
    }
    
    if(animationsIndividualArray.count == 0) return nil;
    
    [theAnimationGroup setAnimations:animationsIndividualArray];
    

    return theAnimationGroup;
    
}


+ (CAAnimationGroup *) prepareGroupAnimationFromDictionary: (NSDictionary *) dict
                                       WithGroupIdentifier: (NSString *) groupId
                                        AndAnimationsDictionary: (NSDictionary *) theAnims {
    
    
    
    CAAnimationGroup *theAnimationGroup = [self prepareTheGroupFromDictionary:dict AndGroupId:groupId];
    
    if(!theAnimationGroup) return nil;
   

    
    NSArray *animationsArray = [dict objectForKey:kAnimations];
    
    if(!animationsArray || animationsArray.count == 0) return nil;
    
    
    NSMutableArray *animationsIndividualArray = [NSMutableArray array];
    
    for (NSString *keyAnimation in animationsArray) {
        
        //Get the correct dictionary
        CAAnimation *anim = [theAnims objectForKey:keyAnimation];
        
        //Assign to the group
        if (anim) {
            [animationsIndividualArray addObject:anim];
        }
        
    }
    
    if(animationsIndividualArray.count == 0) return nil;
    
    
    [theAnimationGroup setAnimations: animationsIndividualArray];
    
        
    return theAnimationGroup;
    
    
}

+ (CAAnimationGroup *) prepareTheGroupFromDictionary: (NSDictionary *) dict AndGroupId: (NSString *) groupId {
    
    /*
     
     ...
     
     "group_name_1" : {
     "options_group" : {
     "dato_1" : "",
     "dato_2" : "",
     "dato_n" : ""
     },
     
     "animations" : ["animation_name_1", "animation_name_5"]
     }
     
     ...
     
     */

    
    CAAnimationGroup *theAnimationGroup = [CAAnimationGroup animation];
    
    
    
    //Second prepare the group
    /////////////////////////
    
    NSDictionary *theOptions = [dict objectForKey:kOptionsGroup];
    
    
    //Set duration
    NSNumber *duration = [AnimationManager getAnimationDurationFromDict:theOptions];
    
    if(duration){
        theAnimationGroup.duration = [duration doubleValue];
    }
    
    
    //Set autoreverses, default NO
    BOOL autoreverses = [AnimationManager getAnimationAutoreverseFromDict:theOptions];
    
    theAnimationGroup.autoreverses = autoreverses;
    
    
    //Set repeatCount
    NSNumber *repeatCount = [AnimationManager getAnimationRepeatCountFromDict:theOptions];
    
    if(repeatCount){
        theAnimationGroup.repeatCount = [repeatCount floatValue];
    }
    
    
    //Timing function
    theAnimationGroup.timingFunction = [AnimationManager getAnimationTimingFunctionFromDict:theOptions];
    
    
    //Fill Mode
    theAnimationGroup.fillMode = [AnimationManager getAnimationFillModeFromDict:theOptions];
    
    
    //Remove on completion
    theAnimationGroup.removedOnCompletion = [AnimationManager getAnimationRemovedOnCompletionFromDict:theOptions];
    
    

    
    
    return theAnimationGroup;
    
}

@end
