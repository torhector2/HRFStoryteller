//
//  AnimationManager.h
//  TestingAnimations
//
//  Created by Héctor Rodríguez Forniés on 26/07/12.
//  Copyright (c) 2012 Héctor Rodríguez Forniés. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>

@interface AnimationManager : NSObject



+(CAAnimation *) prepareAnimationFromDictionary: (NSDictionary *) dict;


+ (NSValue *) getAnimation3DValueFromDict: (NSDictionary *) dict;   
+ (NSValue *) getAnimationNumberValueFromDict: (NSDictionary *) dict;
+ (NSValue *) getAnimationRectValueFromDict: (NSDictionary *) dict;
+ (NSValue *) getAnimationPointValueFromDict: (NSDictionary *) dict;
+ (NSValue *) getAnimationSizeValueFromDict: (NSDictionary *) dict;


+ (NSNumber *) getAnimationDurationFromDict: (NSDictionary *)dict;
+ (BOOL) getAnimationAutoreverseFromDict: (NSDictionary *)dict;
+ (NSNumber *) getAnimationRepeatCountFromDict: (NSDictionary *)dict;
+ (CAMediaTimingFunction *) getAnimationTimingFunctionFromDict: (NSDictionary *)dict;
+ (NSString *) getAnimationFillModeFromDict: (NSDictionary *)dict;
+ (BOOL) getAnimationRemovedOnCompletionFromDict: (NSDictionary *)dict;

@end
