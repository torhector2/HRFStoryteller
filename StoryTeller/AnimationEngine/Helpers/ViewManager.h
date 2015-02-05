//
//  ViewManager.h
//  StoryTeller
//
//  Created by Héctor Rodríguez Forniés on 03/08/12.
//  Copyright (c) 2012 Héctor Rodríguez Forniés. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>

@interface ViewManager : NSObject


+ (UIView *) prepareViewFromDictionary: (NSDictionary *) dict;

@end
