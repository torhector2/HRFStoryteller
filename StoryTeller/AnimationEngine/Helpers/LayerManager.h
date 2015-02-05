//
//  LayerManager.h
//  TestingAnimations
//
//  Created by Héctor Rodríguez Forniés on 01/08/12.
//  Copyright (c) 2012 Héctor Rodríguez Forniés. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>

@interface LayerManager : NSObject


+(CALayer *) prepareLayerFromDictionary: (NSDictionary *) dict;

@end
