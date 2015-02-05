//
//  DataStructuresManager.m
//  TestingAnimations
//
//  Created by Héctor Rodríguez Forniés on 26/07/12.
//  Copyright (c) 2012 Héctor Rodríguez Forniés. All rights reserved.
//

#import "DataStructuresManager.h"

@implementation DataStructuresManager



+ (NSNumber *) numberFromArray: (NSArray *) arrayNumbers{
    
    
    if(!arrayNumbers) return nil;
    
    if(arrayNumbers.count == 0) return nil;
    
    
    
    float numberFloat = [[arrayNumbers objectAtIndex:0] floatValue];
    
    
    NSNumber *number = [NSNumber numberWithFloat: numberFloat];
    
    
    return number;
    
}



+ (CGPoint) pointFromArray: (NSArray *) arrayNumbers{

    //Since a {0,0} CGPoint its a valid point and nil isn't acceptable because CGPoint isn't a NSObject
    //we set an improbable poitn with the minimun float value
    CGPoint improbablePoint = CGPointMake(CGFLOAT_MIN, CGFLOAT_MIN);  
    
    if(!arrayNumbers) return improbablePoint;
    
    if(arrayNumbers.count < 2) return improbablePoint;
    
    //A correct point
    
    float x = [[arrayNumbers objectAtIndex:0] floatValue];
    float y = [[arrayNumbers objectAtIndex:1] floatValue];
    
    CGPoint point = CGPointMake(x, y);
    
    return point;
    
}


+ (CGSize) sizeFromArray: (NSArray *) arrayNumbers{
    
    //Since a {0,0} CGSize its a valid size and nil isn't acceptable because CGSize isn't a NSObject
    //we set an improbable size with the minimun float value
    CGSize improbableSize = CGSizeMake(CGFLOAT_MIN, CGFLOAT_MIN);  
    
    if(!arrayNumbers) return improbableSize;
    
    if(arrayNumbers.count < 2) return improbableSize;
    
    //A correct size
    
    float width = [[arrayNumbers objectAtIndex:0] floatValue];
    float height = [[arrayNumbers objectAtIndex:1] floatValue];
    
    CGSize size = CGSizeMake(width, height);
    
    return size;
    
}

+ (CGRect) rectFromArray: (NSArray *) arrayNumbers{

    //Since a {0,0,0,0} CGRect its a valid rect and nil isn't acceptable because CGRect isn't a NSObject
    //we set an improbable rect with the minimun float value
    CGRect improbableRect = CGRectMake(CGFLOAT_MIN, CGFLOAT_MIN, CGFLOAT_MIN, CGFLOAT_MIN);  
    
    if(!arrayNumbers) return improbableRect;
    
    if(arrayNumbers.count < 4) return improbableRect;
    
    //A correct size
    
    float x = [[arrayNumbers objectAtIndex:0] floatValue];
    float y = [[arrayNumbers objectAtIndex:1] floatValue];
    float width = [[arrayNumbers objectAtIndex:2] floatValue];
    float height = [[arrayNumbers objectAtIndex:3] floatValue];
    
    CGRect rect = CGRectMake(x, y, width, height);
    
    return rect;
    
}




@end
