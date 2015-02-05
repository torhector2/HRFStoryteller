//
//  LayerManager.m
//  TestingAnimations
//
//  Created by Héctor Rodríguez Forniés on 01/08/12.
//  Copyright (c) 2012 Héctor Rodríguez Forniés. All rights reserved.
//

#import "LayerManager.h"
#import "DataStructuresManager.h"
#import "Constants.h"
#import "SpriteLayer.h"



@implementation LayerManager


/*
 
 Creates a CALAyer from a NSDictionary
 
 */
+(CALayer *) prepareLayerFromDictionary: (NSDictionary *) dict{
    
    /*
     
     {
         "bounds" : [0, 0, 50, 50],
         "position" : [10, 10],
         "opacity" : 0.3,
         "anchorPoint" : [0, 0.5],
         "image" : "/relative/url/to/picture1.png",
         "sublayerTransform" : {
                                    "name" : "CATransform3DMakePerspective", 
                                    "value" : "1000"
                                }
     }
     
     
     //Sprite Layer
     {
     "layerType" : "sprite",
     "bounds" : [0, 0, 50, 50],
     "fixedSize" : [45, 47],  //Es el tamaño de cada elemento del sprite
     "position" : [10, 10],
     "opacity" : 0.3,
     "anchorPoint" : [0, 0.5],
     "image" : "/relative/url/to/picture1.png",
     "sublayerTransform" : {
     "name" : "CATransform3DMakePerspective",
     "value" : "1000"
     }
     
     
     
     
     */
    
    
    
    if(!dict) return nil;
    
    if([[dict allKeys] count] == 0) return nil;
    
    
    //Image
    UIImage *image = [self getLayerImageFromDict:dict];
    
    
    //Fixed Sized
    NSArray *fixedSizeArray = [dict objectForKey:kFixedSize];
    NSValue *fixedSizeValue = nil;
    if(fixedSizeArray){
        
        CGSize fixedSize = CGSizeMake([[fixedSizeArray objectAtIndex:0] floatValue], [[fixedSizeArray objectAtIndex:1] floatValue]);
        fixedSizeValue = [NSValue valueWithCGSize:fixedSize];
        
    }
    
    //If it is a valid dictionary then parse it and create a layer
    
    NSString *typeLayer = [dict objectForKey:kLayerTypeName];
    
    CALayer *layer = nil;
    
    if(typeLayer && [typeLayer isEqualToString:kSpriteLayerType]){
        
        if(image && fixedSizeValue){
        
            CGSize theSize = [fixedSizeValue CGSizeValue];
            layer = [SpriteLayer layerWithImage:image.CGImage sampleSize:theSize];
        }
        
    
        
    }else {
        layer = [CALayer layer];
        
        if(image){
            
            layer.contents = (id)image.CGImage;
            
        }
    }
    
    
    
    //Bounds
    
    CGRect rect = [self getLayerRectValueFromDict:dict];
    
    //If the size is valid, assign to layer bounds
    if(rect.origin.x != CGFLOAT_MIN &&
       rect.origin.y != CGFLOAT_MIN &&
       rect.size.width != CGFLOAT_MIN &&
       rect.size.height != CGFLOAT_MIN){
    
        layer.bounds = rect;
        
    }
    
    
    //Position
    CGPoint position = [self getLayerPositionPointValueFromDict:dict];
    
    //If the point isn't a valid point we return nil
    if(position.x != CGFLOAT_MIN && 
       position.y != CGFLOAT_MIN){
        
        layer.position = position;
        
    }
    
    //Anchor point
    CGPoint anchorPoint = [self getLayerAnchorPointValueFromDict:dict];
    
    //If the point isn't a valid point we return nil
    if(anchorPoint.x != CGFLOAT_MIN && 
       anchorPoint.y != CGFLOAT_MIN){
        
        layer.anchorPoint = anchorPoint;
        
    }
    
    
        
    //Sublayer transform
    NSValue *sublayerTransform = [self getLayerSublayerTransformFromDict:dict];
    if(sublayerTransform){
        
        layer.sublayerTransform = [sublayerTransform CATransform3DValue];
    }
    
    
    return layer;
}


+ (CGRect) getLayerRectValueFromDict: (NSDictionary *) dict {
    
   /* Bounds
    {
        "bounds" : [0, 0, 50, 50],
        "position" : [10, 10],
        "opacity" : 0.3,
        "anchorPoint" : [0, 0.5],
        "image" : "/relative/url/to/picture1.png",
        "sublayerTransform" : {
            "name" : "CATransform3DMakePerspective", 
            "value" : "1000"
        }
    }
    */
    
    NSArray *boundsValues = [dict objectForKey:kBounds];
    
     
    CGRect rect = [DataStructuresManager rectFromArray:boundsValues];

    return rect;

}


+ (CGPoint ) getLayerPositionPointValueFromDict: (NSDictionary *) dict{
    
    /* Position
     {
         "bounds" : [0, 0, 50, 50],
         "position" : [10, 10],
         "opacity" : 0.3,
         "anchorPoint" : [0, 0.5],
         "image" : "/relative/url/to/picture1.png",
         "sublayerTransform" : {
                                 "name" : "CATransform3DMakePerspective", 
                                 "value" : "1000"
                               }
     }
     */    
    
    NSArray *positionValues = [dict objectForKey:kPosition];
        
    CGPoint point = [DataStructuresManager pointFromArray:positionValues];
    
    return point;
        
}


+ (CGPoint ) getLayerAnchorPointValueFromDict: (NSDictionary *) dict{
    
    /* AnchorPoint
     {
     "bounds" : [0, 0, 50, 50],
     "position" : [10, 10],
     "opacity" : 0.3,
     "anchorPoint" : [0, 0.5],
     "image" : "/relative/url/to/picture1.png",
     "sublayerTransform" : {
                             "name" : "CATransform3DMakePerspective", 
                             "value" : "1000"
                            }
     }
     */    
    
    NSArray *positionValues = [dict objectForKey:kAnchorPoint];
    
    CGPoint point = [DataStructuresManager pointFromArray:positionValues];
    
    return point;
    
}


+ (UIImage *) getLayerImageFromDict: (NSDictionary *) dict{
    
    /* Image
     {
     "bounds" : [0, 0, 50, 50],
     "position" : [10, 10],
     "opacity" : 0.3,
     "anchorPoint" : [0, 0.5],
     "image" : "/relative/url/to/picture1.png",
     "sublayerTransform" : {
                                 "name" : "CATransform3DMakePerspective", 
                                 "value" : "1000"
                            }
     }
     */    
    
    NSString *imagePath = [dict objectForKey:kImage];
    
    UIImage *image = [UIImage imageNamed:imagePath];
    
    return image;
       
}

+ (NSValue *) getLayerSublayerTransformFromDict: (NSDictionary *) dict{
    
    /* sublayerTransform
     {
         "bounds" : [0, 0, 50, 50],
         "position" : [10, 10],
         "opacity" : 0.3,
         "anchorPoint" : [0, 0.5],
         "image" : "/relative/url/to/picture1.png",
         "sublayerTransform" : {
                                     "name" : "3DMakePerspective", 
                                     "value" : "1000"
                                }
     }
     */    
    
    if(!dict) return nil;
    
    NSDictionary *sublayerDict = [dict objectForKey:kSublayerTransform];
    
    if(!sublayerDict || ([sublayerDict allKeys].count == 0)) return nil;
    
    
    NSString *sublayerTransformType = [sublayerDict objectForKey:kSublayerTransformName];
    
    NSNumber *value = [dict objectForKey:kSublayerTransformValue];
    
    if ([sublayerTransformType isEqualToString:kSublayerTransform3DMakePerspective]) {
        return [NSValue valueWithCATransform3D:CATransform3DMakePerspective([value floatValue])] ;
    }
    
    return nil;
}



static CATransform3D CATransform3DMakePerspective(CGFloat z) {
    CATransform3D t = CATransform3DIdentity;
    t.m34 = - 1.0 / z;
    return t;
}

@end
