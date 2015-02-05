//
//  AnimationManager.m
//  TestingAnimations
//
//  Created by Héctor Rodríguez Forniés on 26/07/12.
//  Copyright (c) 2012 Héctor Rodríguez Forniés. All rights reserved.
//

#import "AnimationManager.h"
#import "DataStructuresManager.h"
#import "Constants.h"
#import "PocketSVG.h"



@implementation AnimationManager


/*
 
 "animation_name_1" : {
                         "keyPath" : "transform",
                         "fromValue" : {
                                         "type" : "3d",
                                         "subtype" : "3DIdentity"
                                        },
                         "toValue" : {
                                         "type" : "3d",
                                         "subtype" : "3DMakeRotation",
                                         "value" : [85, 0, 1, 0]
                                     },
                         "duration" : 10,
                         "autoreverses" : "YES",
                         "repeatCount" : "INFINITY",
                         "timingFunction" : "EaseInEaseOut",
                         "fillMode" : "kCAFillModeForwards",
                         "removedOnCompletion" : "NO"
                    }
 
 */

+(CAAnimation *) prepareAnimationFromDictionary: (NSDictionary *) dict{
        
    //Get the key path to create the animation
    NSString *keyPath = [self getAnimationKeyPathFromDict:dict];
    
    NSString *curve = [dict objectForKey:kPath];
    
    
    CAAnimation *animation = nil;
    
    if(curve && ![curve isEqualToString:@""]) {
        
        return [self prepareKeyFrameAnimationFromDict:dict];
        
    }else {
        animation = [CABasicAnimation animationWithKeyPath:keyPath];
    }
    
    
    //Set duration
    NSNumber *duration = [self getAnimationDurationFromDict:dict];

    if(duration){
        animation.duration = [duration doubleValue];
    }
    
    
    //Set autoreverses, default NO
    BOOL autoreverses = [self getAnimationAutoreverseFromDict:dict];
    
    animation.autoreverses = autoreverses;
    
    
    //Set repeatCount
    NSNumber *repeatCount = [self getAnimationRepeatCountFromDict:dict];
    
    if(repeatCount){
        animation.repeatCount = [repeatCount floatValue];
    }
    
    
    //Timing function

    if([keyPath isEqualToString:kKeyPathSpritesLayer]){
        
        //Only if it defines a timingFunction
        
        NSString *timingFunctionType = [dict objectForKey:kTimingFunction];
        
        if (timingFunctionType) {
            animation.timingFunction = [self getAnimationTimingFunctionFromDict:dict];
        }
        
    }else {
        animation.timingFunction = [self getAnimationTimingFunctionFromDict:dict];
    }
    
    //Fill Mode
    animation.fillMode = [self getAnimationFillModeFromDict:dict];

    
    //Remove on completion
    animation.removedOnCompletion = [self getAnimationRemovedOnCompletionFromDict:dict];
    
    //From value, only in CABasicAnimation
    
    
    NSValue *fromVal = [self getAnimationFromValueFromDict:dict];
    if(fromVal){
        ((CABasicAnimation *)animation).fromValue = fromVal;
    }
    
    //To value
    NSValue *toVal = [self getAnimationToValueFromDict:dict];
    if(toVal){
        ((CABasicAnimation *)animation).toValue = toVal;
    }
    
    
    return animation;
}

//Key Frame Animation
+(CAAnimation *) prepareKeyFrameAnimationFromDict: (NSDictionary *) theDict {
    
    NSString *pathType = [theDict objectForKey:kPath];
    
    
    if([pathType isEqualToString:kPathLinear]){
        
        //Linear
        
        return [self prepareLinearPathAnimationFromDict:theDict];
        
    }else if ([pathType isEqualToString:kPathBezier] ||
              [pathType isEqualToString:kPathQuadBezier] ||
              [pathType isEqualToString:kPathArcBezier] ||
              [pathType isEqualToString:kPathCircle] ||
              [pathType isEqualToString:kPathCircleInRect] ||
              [pathType isEqualToString:kSvgFilePath]){

        //Bezier and other curves
        return [self prepareBezierPathAnimationFromDict:theDict];
        
    }else {
        
        return nil;
    }
    
}

+(CAAnimation *) prepareLinearPathAnimationFromDict: (NSDictionary *) theDict {
    
    
    /*
     
     
     {
     "id_animation" : "linear_path",
     "path" : "linear_path",
     "keyPath" : "position",
     "startPoint" : [100, 400],
     "finalPoints" : [200, 200, 400, 400, 600, 200],
     "keyTimes" : [0.0, 0.3, 0.6, 1.0],
     "rotationMode" : "kCAAnimationRotateAutoReverse",
     "calculationMode" : "kCAAnimationPaced",
     "duration" : 6
     }
     
     */
    
    NSString *keyPath = [self getAnimationKeyPathFromDict:theDict];
    
    CAKeyframeAnimation *anim = [CAKeyframeAnimation animationWithKeyPath:keyPath];
    

    //Rotation Mode
    NSString *theRotationMode = [self getAnimationPathRotationModeFromDict:theDict];
    if(theRotationMode) {
        anim.rotationMode = theRotationMode;
    }
    
    //Calculation Mode
    NSString *theCalculationMode = [self getAnimationPathCalculationModeFromDict:theDict];
    if(theCalculationMode) {
        anim.calculationMode = theCalculationMode;
    }
    ////////////////
    //The Path
    ////////////////
    
    double x,y = 0.0;
    
    NSArray *fPoint = [theDict objectForKey:kStartPoint];
    
    //The x
    x = [[fPoint objectAtIndex:0] doubleValue];
    //The y
    y = [[fPoint objectAtIndex:1] doubleValue];
    
    CGPoint firstPoint = CGPointMake(x, y);
    
    //Get Values
    NSMutableArray *theValuesPoints = [NSMutableArray array];
    
    NSArray *finishPointsArray = [theDict objectForKey:kFinalPoints];
    
    for (int i = 1; i< finishPointsArray.count; i = i + 2) {
        int j = i;

        double x2 = [[finishPointsArray objectAtIndex:j - 1] doubleValue];
        double y2 = [[finishPointsArray objectAtIndex:j] doubleValue];
        
        CGPoint point = CGPointMake(x2, y2);
        [theValuesPoints addObject:[NSValue valueWithCGPoint:point]];
        
    }
    
    //The Path
    UIBezierPath *animationPath = [UIBezierPath bezierPath];
    
    [animationPath moveToPoint:firstPoint];
    
    for (NSValue *val in theValuesPoints) {
        
        CGPoint point = [val CGPointValue];
        [animationPath addLineToPoint: point];
        
    }
    
    
    anim.path = animationPath.CGPath;
    
    
    //Key Times
    NSArray *keyTimesArray = [theDict objectForKey:kKeyTimes];
    anim.keyTimes = keyTimesArray;

    
    
    //Basic Animation properties
    
    //Fill Mode
    anim.fillMode = [self getAnimationFillModeFromDict:theDict];
    
    
    //Remove on completion
    anim.removedOnCompletion = [self getAnimationRemovedOnCompletionFromDict:theDict];
    
    //Timing function
    NSString *timingStr = [theDict objectForKey:kTimingFunction];
    if(timingStr){
        anim.timingFunction = [self getAnimationTimingFunctionFromDict:theDict];
    }
    
    //Set duration
    NSNumber *duration = [self getAnimationDurationFromDict:theDict];
    
    if(duration){
        anim.duration = [duration doubleValue];
    }
    
    
    //Set autoreverses, default NO
    BOOL autoreverses = [self getAnimationAutoreverseFromDict:theDict];
    
    anim.autoreverses = autoreverses;
    
    
    //Set repeatCount
    NSNumber *repeatCount = [self getAnimationRepeatCountFromDict:theDict];
    
    if(repeatCount){
        anim.repeatCount = [repeatCount floatValue];
    }
    
    
    return anim;
}

+(CAAnimation *) prepareBezierPathAnimationFromDict: (NSDictionary *) theDict {
    
    /*
     
     //QUAD Curve
     
     {
     "id_animation" : "curva_quad_bezier",
     "path" : "quad_bezier",
     "keyPath" : "position",
     "startPoint" : [x, y],
     "controlPoints" : [cx1, cy1, cx2, cy2],
     "finalPoints" : [x1, y1, x2, y2],
     "keyTimes" : [array de porcentajes de tiempo para cada keyframe],
     "rotationMode" : "kCAAnimationRotateAutoReverse",
     "calculationMode" : "kCAAnimationLinear"
     }
     
     
     //BEZIER Complete Curve
     
     {
     "id_animation" : "curva_bezier",
     "path" : "bezier",
     "keyPath" : "position",
     "startPoint" : [x, y],
     "controlPoints" : [cx1, cy1, cx2, cy2, cx3, cy3, cx4, cy4],
     "finalPoints" : [x1, y1, x2, y2],
     "keyTimes" : [array de porcentajes de tiempo para cada keyframe],
     "rotationMode" : "kCAAnimationRotateAutoReverse",
     "calculationMode" : "kCAAnimationLinear"
     }
     
     
     
     //BEZIER ARC Curve
     
     {
     "id_animation" : "arc_bezier",
     "path" : "arc_bezier",
     "keyPath" : "position",
     "startPoint" : [x, y],
     "finalPoint" : [x2, y2],
     "radio" : 2,
     "keyTimes" : [array de porcentajes de tiempo para cada keyframe],
     "rotationMode" : "kCAAnimationRotateAutoReverse",
     "calculationMode" : "kCAAnimationLinear"
     }
     
     */
    
    
    NSString *keyPath = [self getAnimationKeyPathFromDict:theDict];
    
    CAKeyframeAnimation *anim = [CAKeyframeAnimation animationWithKeyPath:keyPath];
    
    //Rotation Mode
    NSString *theRotationMode = [self getAnimationPathRotationModeFromDict:theDict];
    if(theRotationMode) {
        anim.rotationMode = theRotationMode;
    }
    
    //Calculation Mode
    NSString *theCalculationMode = [self getAnimationPathCalculationModeFromDict:theDict];
    if(theCalculationMode) {
        anim.calculationMode = theCalculationMode;
    }
    
    //Key Times
    NSArray *keyTimesArray = [theDict objectForKey:kKeyTimes];
    anim.keyTimes = keyTimesArray;
    
    
    
    //Basic Animation properties
    
    //Fill Mode
    anim.fillMode = [self getAnimationFillModeFromDict:theDict];
    
    
    //Remove on completion
    anim.removedOnCompletion = [self getAnimationRemovedOnCompletionFromDict:theDict];
    
    //Timing function
    NSString *timingStr = [theDict objectForKey:kTimingFunction];
    if(timingStr){
        anim.timingFunction = [self getAnimationTimingFunctionFromDict:theDict];
    }
    
    //Set duration
    NSNumber *duration = [self getAnimationDurationFromDict:theDict];
    
    if(duration){
        anim.duration = [duration doubleValue];
    }
    
    
    //Set autoreverses, default NO
    BOOL autoreverses = [self getAnimationAutoreverseFromDict:theDict];
    
    anim.autoreverses = autoreverses;
    
    
    //Set repeatCount
    NSNumber *repeatCount = [self getAnimationRepeatCountFromDict:theDict];
    
    if(repeatCount){
        anim.repeatCount = [repeatCount floatValue];
    }
    

    
    //The Path
    NSString *pathType = [theDict objectForKey:kPath];
    CGMutablePathRef thePath;
    
    if([pathType isEqualToString:kPathQuadBezier]) {
    
        //Quad Path
        thePath = [self getQuadPathFromDict:theDict];
        anim.path = thePath;
        
        
        
        
    }else if ([pathType isEqualToString:kPathBezier]){
        
        //Bezier Path
        thePath = [self getBezierPathFromDict:theDict];
        anim.path = thePath;
        
    }else if([pathType isEqualToString:kPathArcBezier]){
        
        //Arc Path
        thePath = [self getArcPathFromDict:theDict];
        anim.path = thePath;
        
    }else if([pathType isEqualToString:kPathCircle]){
        
        thePath = [self getCircleArcPathFromDict:theDict];
        anim.path = thePath;
        
        
    } else if([pathType isEqualToString:kPathCircleInRect]) {

        thePath = [self getEllipsePathInRectFromDict:theDict];
        anim.path = thePath;
        
    }else if([pathType isEqualToString:kSvgFilePath]) {
        
        thePath = [self getPathFromSVGFileFromDict:theDict];
        anim.path = thePath;
        
    }else return nil;
    
    
    //Release path
    if(thePath) CGPathRelease(thePath);
    
    
    return anim;

}


+(CGMutablePathRef) getQuadPathFromDict: (NSDictionary *) theDict {
    
    /*
     
     //QUAD Curve
     
     {
     "id_animation" : "curva_quad_bezier",
     "path" : "quad_bezier",
     "keyPath" : "position",
     "startPoint" : [x, y],
     "controlPoints" : [cx1, cy1, cx2, cy2],
     "finalPoints" : [x1, y1, x2, y2],
     "keyTimes" : [array de porcentajes de tiempo para cada keyframe],
     "rotationMode" : "kCAAnimationRotateAutoReverse",
     "calculationMode" : "kCAAnimationLinear"
     }

     */
    
    
    CGMutablePathRef path = CGPathCreateMutable();
    
    ////////////////
    //The Path
    ////////////////
    
    double x,y = 0.0;
    
    NSArray *fPoint = [theDict objectForKey:kStartPoint];
    
    //The x
    x = [[fPoint objectAtIndex:0] doubleValue];
    //The y
    y = [[fPoint objectAtIndex:1] doubleValue];
    
    CGPoint firstPoint = CGPointMake(x, y);
    
    //Get Final Points
    NSMutableArray *theValuesPoints = [NSMutableArray array];
    
    NSArray *finishPointsArray = [theDict objectForKey:kFinalPoints];
    
    for (int i = 1; i< finishPointsArray.count; i = i + 2) {
        int j = i;
        
        double x2 = [[finishPointsArray objectAtIndex:j - 1] doubleValue];
        double y2 = [[finishPointsArray objectAtIndex:j] doubleValue];
        
        CGPoint point = CGPointMake(x2, y2);
        [theValuesPoints addObject:[NSValue valueWithCGPoint:point]];
        
    }
    
    
    //Get Control Points
    NSMutableArray *theControlPoints = [NSMutableArray array];
    
    NSArray *controlPointsArray = [theDict objectForKey:kControlPoints];
    
    for (int i = 1; i< controlPointsArray.count; i = i + 2) {
        int j = i;
        
        double cx2 = [[controlPointsArray objectAtIndex:j - 1] doubleValue];
        double cy2 = [[controlPointsArray objectAtIndex:j] doubleValue];
        
        CGPoint controlPoint = CGPointMake(cx2, cy2);
        [theControlPoints addObject:[NSValue valueWithCGPoint:controlPoint]];
        
    }

    
    
    CGPathMoveToPoint(path, NULL, firstPoint.x, firstPoint.y);
    
    for (int i = 0; i < theValuesPoints.count; i++) {
        
        NSValue *val = [theValuesPoints objectAtIndex:i];
        CGPoint point = [val CGPointValue];
        
        NSValue *valControl = [theControlPoints objectAtIndex:i];
        CGPoint controlPoint = [valControl CGPointValue];
        
        CGPathAddQuadCurveToPoint(path, NULL, controlPoint.x, controlPoint.y, point.x, point.y);
        
    }
    
    CGPathRetain(path);
    
    return (CGMutablePathRef)path;
    
    
}


+(CGMutablePathRef) getBezierPathFromDict: (NSDictionary *) theDict {
    
    //BEZIER Complete Curve
    
    /*
     
    {
        "id_animation" : "curva_bezier",
        "path" : "bezier",
        "keyPath" : "position",
        "startPoint" : [x, y],
        "controlPoints" : [cx1, cy1, cx2, cy2, cx3, cy3, cx4, cy4],
        "finalPoints" : [x1, y1, x2, y2],
        "keyTimes" : [array de porcentajes de tiempo para cada keyframe],
        "rotationMode" : "kCAAnimationRotateAutoReverse",
        "calculationMode" : "kCAAnimationLinear"
    }
    
    */
    
    
    CGMutablePathRef path = CGPathCreateMutable();
    
    
    ////////////////
    //The Path
    ////////////////
    
    double x,y = 0.0;
    
    NSArray *fPoint = [theDict objectForKey:kStartPoint];
    
    //The x
    x = [[fPoint objectAtIndex:0] doubleValue];
    //The y
    y = [[fPoint objectAtIndex:1] doubleValue];
    
    CGPoint firstPoint = CGPointMake(x, y);
    
    //Get Final Points
    NSMutableArray *theValuesPoints = [NSMutableArray array];
    
    NSArray *finishPointsArray = [theDict objectForKey:kFinalPoints];
    
    for (int i = 1; i< finishPointsArray.count; i = i + 2) {
        int j = i;
        
        double x2 = [[finishPointsArray objectAtIndex:j - 1] doubleValue];
        double y2 = [[finishPointsArray objectAtIndex:j] doubleValue];
        
        CGPoint point = CGPointMake(x2, y2);
        [theValuesPoints addObject:[NSValue valueWithCGPoint:point]];
        
    }
    
    
    //Get Control Points
    NSMutableArray *theControlPoints = [NSMutableArray array];
    
    NSArray *controlPointsArray = [theDict objectForKey:kControlPoints];
    
    for (int i = 0; i< controlPointsArray.count; i = i + 4) {
        
        double cx2 = [[controlPointsArray objectAtIndex: i] doubleValue];
        double cy2 = [[controlPointsArray objectAtIndex: i + 1] doubleValue];
        
        CGPoint controlPoint = CGPointMake(cx2, cy2);
        
        
        double cx3 = [[controlPointsArray objectAtIndex: i + 2] doubleValue];
        double cy3 = [[controlPointsArray objectAtIndex: i + 3] doubleValue];
        
        CGPoint controlPoint2 = CGPointMake(cx3, cy3);
        
        
        NSArray *arrayValues = [NSArray arrayWithObjects:[NSValue valueWithCGPoint:controlPoint], [NSValue valueWithCGPoint:controlPoint2], nil];
        
        
        [theControlPoints addObject:arrayValues];
        
    }
    
    
    //First Points
    CGPathMoveToPoint(path, NULL, firstPoint.x, firstPoint.y);
    
    for (int i = 0; i < theValuesPoints.count; i++) {
        

        
        NSValue *val = [theValuesPoints objectAtIndex:i];
        CGPoint point = [val CGPointValue];
        
        NSArray *controlPointsArray = [theControlPoints objectAtIndex:i];

        CGPoint controlPointA = [[controlPointsArray objectAtIndex:0] CGPointValue];
        CGPoint controlPointB = [[controlPointsArray objectAtIndex:1] CGPointValue];
        
        CGPathAddCurveToPoint(path, NULL, controlPointA.x, controlPointA.y, controlPointB.x, controlPointB.y, point.x, point.y);
        
    }
    

    CGPathRetain(path);
    
    return (CGMutablePathRef)path;
    
    
}


+(CGMutablePathRef) getArcPathFromDict: (NSDictionary *) theDict {
    
    /*
     
     //BEZIER ARC Curve
     
     {
     "id_animation" : "arc_bezier",
     "path" : "arc_bezier",
     "keyPath" : "position",
     "finalPoints" : [x2, y2, x3, y3, x4, y4, x5, y5],
     "radios" : [2, 5],
     "keyTimes" : [array de porcentajes de tiempo para cada keyframe],
     "rotationMode" : "kCAAnimationRotateAutoReverse",
     "calculationMode" : "kCAAnimationLinear"
     }
     
     */
    
    
    
    CGMutablePathRef path = CGPathCreateMutable();
    
    //Get Final Points
    NSMutableArray *theValuesPoints = [NSMutableArray array];
    
    NSArray *finishPointsArray = [theDict objectForKey:kFinalPoints];
    
    for (int i = 0; i< finishPointsArray.count; i = i + 4) {
       
        
        double x2 = [[finishPointsArray objectAtIndex: i] doubleValue];
        double y2 = [[finishPointsArray objectAtIndex: i + 1] doubleValue];
        double x3 = [[finishPointsArray objectAtIndex: i + 2] doubleValue];
        double y3 = [[finishPointsArray objectAtIndex: i + 3] doubleValue];
        
        
        CGPoint point1 = CGPointMake(x2, y2);
        CGPoint point2 = CGPointMake(x3, y3);
        
        NSArray *arrayValues = [NSArray arrayWithObjects:[NSValue valueWithCGPoint:point1], [NSValue valueWithCGPoint:point2], nil];
        
        [theValuesPoints addObject: arrayValues];
        
    }
    
    
    NSArray *radiosArray = [theDict objectForKey:kRadios];
    
    for (int i = 0; i < radiosArray.count; i++) {
        
        float radio = [[radiosArray objectAtIndex:i] floatValue];
        
        CGPoint point1 = [[[theValuesPoints objectAtIndex:i] objectAtIndex:0] CGPointValue];
        CGPoint point2 = [[[theValuesPoints objectAtIndex:i] objectAtIndex:1] CGPointValue];
        
        //If it is the first point, move to the point
        if(i == 0) {
        
            CGPathMoveToPoint(path, NULL, point1.x, point1.y);
            
        }
        
        CGPathAddArcToPoint(path, NULL, point1.x, point1.y, point2.x, point2.y, radio);
        
    }
    
    
    CGPathRetain(path);
    
    return (CGMutablePathRef)path;

    
}


+(CGMutablePathRef) getCircleArcPathFromDict: (NSDictionary *) theDict {
    
    /*
     
     //Circle Path
     
     {
     "id_animation" : "circle_anim",
     "path" : "circle_path",
     "keyPath" : "position",
     "center" : [400, 400],
     "radius" : 300,
     "startRadians" : 0,
     "finishRadians" : 2,
     "clock" : "YES",
     "keyTimes" : [array de porcentajes de tiempo para cada keyframe],
     "rotationMode" : "kCAAnimationRotateAutoReverse",
     "calculationMode" : "kCAAnimationLinear"
     }
     
     */
    
    
    //Center
    
    double x = 0.0;
    double y = 0.0;
    
    NSArray *fPoint = [theDict objectForKey:kCircleCenter];
    
    //The x
    x = [[fPoint objectAtIndex:0] doubleValue];
    //The y
    y = [[fPoint objectAtIndex:1] doubleValue];
    
    CGPoint firstPoint = CGPointMake(x, y);
    
    
    //Radius
    float radiusCircle = [[theDict objectForKey:kCircleRadius] floatValue];
    
    
    //Start Radians Scalar
    float startRadian = [[theDict objectForKey:kCircleStartRadians] floatValue];
    
    //Finish Radians Scalar
    float finishRadian = [[theDict objectForKey:kCircleFinishRadians] floatValue];
    
    
    //Clockwise
    BOOL clock = [[theDict objectForKey:kCircleClockwise] boolValue];

    UIBezierPath *bezier = [UIBezierPath bezierPathWithArcCenter:firstPoint radius:radiusCircle startAngle:startRadian * M_PI endAngle:finishRadian * M_PI clockwise: [[NSNumber numberWithBool:clock] floatValue] ];
    
    CGPathRef path = (CGPathRef)bezier.CGPath;
    CGPathRetain(path);
    
    return (CGMutablePathRef)path;
    
}


+(CGMutablePathRef) getEllipsePathInRectFromDict: (NSDictionary *) theDict {

    /*
     
     //Circle Path
     
     {
     "id_animation" : "circle_rect_anim",
     "path" : "circle_in_rect_path",
     
     "keyPath" : "position",
     "rect" : [100, 200, 400, 500],
     "rotationMode" : "kCAAnimationRotateAutoReverse",
     "calculationMode" : "kCAAnimationLinear"
     }
     
     */
    
    //Rect
    NSArray *rect = [theDict objectForKey:kCircleInRect];
    
    CGRect rectEllipse = CGRectMake([[rect objectAtIndex:0] floatValue],
                                    [[rect objectAtIndex:1] floatValue],
                                    [[rect objectAtIndex:2] floatValue],
                                    [[rect objectAtIndex:3] floatValue]);
    
    UIBezierPath *bezier = [UIBezierPath bezierPathWithOvalInRect:rectEllipse];
    
    CGPathRef path = (CGPathRef)bezier.CGPath;
    CGPathRetain(path);
    
    return (CGMutablePathRef)path;
    


}


+(CGMutablePathRef) getPathFromSVGFileFromDict: (NSDictionary *) theDict {
    
    /*
     
     //Circle Path
     
     {
     "id_animation" : "svg_path_anim",
     "path" : "svg_path",
     "keyPath" : "position",
     "svg-file" : "miBezierFile.svg",
     "rotationMode" : "kCAAnimationRotateAutoReverse",
     "calculationMode" : "kCAAnimationLinear"
     }
     
     */
    
    NSString *svgFileStr = [theDict objectForKey:kSvgFile];
    
    NSString *svgFileStrForDevice = [self getSVGFilePathForDeviceWithName:svgFileStr];
    
    //1: Create a PocketSVG object from your SVG file:
    PocketSVG *myVectorDrawing = [[PocketSVG alloc] initFromSVGFileNamed:svgFileStrForDevice];
    
    //2: Its bezier property is the corresponding UIBezierPath:
    UIBezierPath *bezier = myVectorDrawing.bezier;
    
    CGPathRef path = (CGPathRef)bezier.CGPath;
    CGPathRetain(path);
    
    return (CGMutablePathRef)path;
    
    
}

+(NSString *) getSVGFilePathForDeviceWithName: (NSString *) theName {
    
    //TO-DO
    
    NSString *tailStr = nil;
    
    if(IS_IPHONE) {
        
        tailStr = kSvgFileiPhone4;
        
    }else if(IS_IPHONE_5){
        
        tailStr = kSvgFileiPhone5;
        
    }else if (IS_IPAD){
        
        tailStr = kSvgFileiPad;
    }
    
    
    NSString *result = [theName stringByAppendingString:tailStr];
    
    return result;
    
}


/*
 * Returns the key path defined in the JSON for the new animation 
 */
+ (NSString *) getAnimationKeyPathFromDict: (NSDictionary *)dict{
    
    NSString *keyPath = [dict objectForKey:kKeyPATH];
    
    return keyPath;
    
}

/*
 * Returns the animation duration defined in the JSON for the new animation 
 */
+ (NSNumber *) getAnimationDurationFromDict: (NSDictionary *)dict{
    
    NSNumber *duration = [dict objectForKey:kDuration];
    
    
    return duration;
    
}


/*
 * Returns the animation repeat count defined in the JSON for the new animation 
 */
+ (NSNumber *) getAnimationRepeatCountFromDict: (NSDictionary *)dict{
    
    id repeatCount = [dict objectForKey:kRepeatCount];
    
        
    if ([repeatCount isKindOfClass:[NSNumber class]]) {
        
        return (NSNumber *)repeatCount;
        
    } else if ([repeatCount isKindOfClass:[NSString class]]) {
        
        NSString *repeatStr = (NSString *) repeatCount;
        
        if([repeatStr isEqualToString:kRepeatCountInfinity]){
            
            return [NSNumber numberWithFloat:INFINITY];
            
        }else if ([repeatStr isEqualToString:kRepeatCountHughValueF]) {
            
            return [NSNumber numberWithFloat:HUGE_VALF];
            
        }else if ([repeatStr isEqualToString:kRepeatCountHughValue]) {
            
            return [NSNumber numberWithDouble:HUGE_VAL];
            
        }else {
            return 0;
        }
        
        
    } else {
        return nil;
    }

    
}


/*
 * Returns the autoreverse value defined in the JSON for the new animation 
 */
+ (BOOL) getAnimationAutoreverseFromDict: (NSDictionary *)dict{
   
    //Default result
    BOOL autoreverses = NO;
    
    NSString *autoreversesString = [dict objectForKey:kAutoreverses];
    
    if (autoreversesString && ![autoreversesString isEqualToString:@""]) {
        
        if([autoreversesString isEqualToString:kAutoreversesYES]){
            
            autoreverses = YES;
        }
    }        
    
    return autoreverses;
}




+ (CAMediaTimingFunction *) getAnimationTimingFunctionFromDict: (NSDictionary *)dict{
    
    CAMediaTimingFunction *timing = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault];
    
    NSString *timingFunctionType = [dict objectForKey:kTimingFunction];
    
    if(timingFunctionType && ![timingFunctionType isEqualToString:@""]){
        
        if ([timingFunctionType isEqualToString:kTimingFunctionDefault]) {
         
            timing = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault];
            
        }else if ([timingFunctionType isEqualToString:kTimingFunctionLinear]) {
        
            timing = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
        
        }else if ([timingFunctionType isEqualToString:kTimingFunctionEaseIn]) {
            
            timing = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
            
        }else if ([timingFunctionType isEqualToString:kTimingFunctionEaseOut]) {
            
            timing = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
            
        }else if ([timingFunctionType isEqualToString:kTimingFunctionEaseInEaseOut]) {
            
            timing = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
            
        }
        
        
    }
    
    
    return timing;
}


+ (NSString *) getAnimationFillModeFromDict: (NSDictionary *)dict{
    
    NSString *fillMode = kCAFillModeRemoved;
    
    NSString *fillModeFromDict = [dict objectForKey:kFillMode];
    
    if(fillModeFromDict && ![fillModeFromDict isEqualToString:@""]){
        
        if ([fillModeFromDict isEqualToString:kFillModeRemoved]) {
            
            fillMode = kCAFillModeRemoved;
            
        }else if ([fillModeFromDict isEqualToString:kFillModeForwards]) {
            
            fillMode = kCAFillModeForwards;
            
        }else if ([fillModeFromDict isEqualToString:kFillModeBackwards]) {
            
            fillMode = kCAFillModeForwards;
            
        }else if ([fillModeFromDict isEqualToString:kFillModeBoth]) {
            
            fillMode = kCAFillModeBoth;
            
        }
        
        
    }
    
    
    return fillMode;
}



+ (NSString *) getAnimationPathRotationModeFromDict: (NSDictionary *)dict{
    
    //The default mode is nil, which indicates that objects should not rotate to follow the path.
    NSString *rotationMode = nil;
    
    NSString *rotationModeFromDict = [dict objectForKey:kRotationMode];
    
    if(rotationModeFromDict && ![rotationModeFromDict isEqualToString:@""]){
        
        if ([rotationModeFromDict isEqualToString:kRotationModeAnimationRotateAuto]) {
            
            rotationMode = kCAAnimationRotateAuto;
            
        }else if ([rotationModeFromDict isEqualToString:kRotationModeAnimationRotateAutoReverse]) {
            
            rotationMode = kCAAnimationRotateAutoReverse;
            
        }
        
        
    }
    
    
    return rotationMode;
}


+ (NSString *) getAnimationPathCalculationModeFromDict: (NSDictionary *)dict{
    
    //The default mode is nil, which indicates that objects should not rotate to follow the path.
    NSString *calculationMode = kCAAnimationLinear;
    
    NSString *calculationModeFromDict = [dict objectForKey:kRotationMode];
    
    if(calculationModeFromDict && ![calculationModeFromDict isEqualToString:@""]){
        
        if ([calculationModeFromDict isEqualToString:kCalculationModeLinear]) {
            
            calculationMode = kCAAnimationLinear;
            
        }else if ([calculationModeFromDict isEqualToString:kCalculationModeDiscrete]) {
            
            calculationMode = kCAAnimationDiscrete;
            
        }else if ([calculationModeFromDict isEqualToString:kCalculationModePaced]) {
            
            calculationMode = kCAAnimationPaced;
            
        }else if ([calculationModeFromDict isEqualToString:kCalculationModeCubic]) {
            
            calculationMode = kCAAnimationCubic;
            
        }else if ([calculationModeFromDict isEqualToString:kCalculationModeCubicPaced]) {
            
            calculationMode = kCAAnimationCubicPaced;
            
        }

        
        
    }
    
    
    return calculationMode;
}



/*
 * Returns the remove on completion value defined in the JSON for the new animation 
 * Default YES
 */
+ (BOOL) getAnimationRemovedOnCompletionFromDict: (NSDictionary *)dict{
    
    //Default result
    BOOL removed = YES;
    
    NSString *removedString = [dict objectForKey:kRemovedOnCompletion];
    
    if (removedString && ![removedString isEqualToString:@""]) {
        
        if([removedString isEqualToString:kRemovedOnCompletionNO]){
            
            removed = NO;
        }
    }        
    
    return removed;
}


+ (NSValue *) getAnimationFromValueFromDict: (NSDictionary *) dict{

    NSDictionary *fromValueDict = [dict objectForKey:kFromValue];
    
    return [self getAnimationValueFromDict:fromValueDict];
    
}

+ (NSValue *) getAnimationToValueFromDict: (NSDictionary *) dict{
    
    NSDictionary *fromValueDict = [dict objectForKey:kToValue];
    
    return [self getAnimationValueFromDict:fromValueDict];
}


+ (NSValue *) getAnimationValueFromDict: (NSDictionary *) dict{

    /* 
     
     {
         "type" : "3d",
         "subtype" : "3DMakeRotation",
         "value" : [85, 0, 1, 0]
     }
     
     {
         "type" : "size",
         "value" : [100, 40]
     }
     
     {
         "type" : "float",
         "value" : [4.5]
     }
     
     */
    
    
    
    
    //Get the correct Dictionary
    NSString *type = [dict objectForKey:kValueType];
    

    
    //If there isn't a dict then return nil
    if(!dict){
        return nil;
    }
    
    //If type is nil then the default is number
    
    if (!type || 
        [type isEqualToString:@""] || 
        [type isEqualToString:kValueTypeNumber]) {
        
        return [self getAnimationNumberValueFromDict:dict];
    }
    
    
    //Point
    if([type isEqualToString:kValueTypePoint]){
        return [self getAnimationPointValueFromDict:dict];
    }
    
    //Size
    if([type isEqualToString:kValueTypeSize]){
        return [self getAnimationSizeValueFromDict:dict];
    }
    
    //Rect
    if([type isEqualToString:kValueTypeRect]){
        return [self getAnimationRectValueFromDict:dict];
    }
    
    
    //3D
    if([type isEqualToString:kValueType3D]){
        return [self getAnimation3DValueFromDict:dict];
    }

    return nil;
}


#pragma mark Value Makers

+ (NSValue *) getAnimation3DValueFromDict: (NSDictionary *) dict{

    /*
     
     {
         "type" : "3d",
         "subtype" : "3DIdentity"
     },
     
     {
         "type" : "3d",
         "subtype" : "3DMakeRotation",
         "value" : [85, 0, 1, 0]
     }
     
     */
    
    
    if(!dict) return nil;
    
    NSString *type = [dict objectForKey:kValueType];
    
    if (!type || [type isEqualToString:@""] || ![type isEqualToString:kValueType3D]) {
        return nil;
    }
    
    NSString *subtype = [dict objectForKey:kValueSubType];
    
    if(!subtype || [subtype isEqualToString:@""]){
        return nil;
    }
    
    
    //3D identity
    if([subtype isEqualToString:kValueSubType3DIdentity]){
        
        return [NSValue valueWithCATransform3D:CATransform3DIdentity];
        
    }
    
    
    // 3D Rotation
    if([subtype isEqualToString:kValueSubType3DRotation]){
        
        //[NSValue valueWithCATransform3D:CATransform3DMakeRotation(DEGREES_TO_RADIANS(85), 0, 1, 0)];
        
        NSArray *values = [dict objectForKey:kValue];
        
        if (values || values.count >= 4) {
         
            float arg0 = [[values objectAtIndex:0] floatValue];
            float arg1 = [[values objectAtIndex:1] floatValue];
            float arg2 = [[values objectAtIndex:2] floatValue];
            float arg3 = [[values objectAtIndex:3] floatValue];
            
            return [NSValue valueWithCATransform3D:CATransform3DMakeRotation(DEGREES_TO_RADIANS(arg0), arg1, arg2, arg3)];
            
        }
    }
    
    return nil;
    
    
}


+ (NSValue *) getAnimationNumberValueFromDict: (NSDictionary *) dict{
    
    //If dict is nil
    if(!dict) return nil;
    
    //Cheack values
    NSNumber *value = [dict objectForKey:kValue];
    
    //NSNumber *num = [DataStructuresManager numberFromArray:values];
    
    return value;
}


+ (NSValue *) getAnimationRectValueFromDict: (NSDictionary *) dict{
    
    /*
     
     {
     "type" : "rect",
     "value" : [10, 10, 100, 100]
     }
     
     */
    
    
    //If dict is nil
    if(!dict) return nil;
    
    NSString *type = [dict objectForKey:kValueType];
    
    if(!type || [type isEqualToString:@""]) return nil;
    
    if([type isEqualToString:kValueTypeRect]){
        
        //Cheack values
        NSArray *values = [dict objectForKey:kValue];
        
        CGRect rect = [DataStructuresManager rectFromArray:values];
        
        //If the size isn't a valid point we return nil
        if(rect.origin.x == CGFLOAT_MIN || 
           rect.origin.y == CGFLOAT_MIN || 
           rect.size.width == CGFLOAT_MIN ||
           rect.size.height == CGFLOAT_MIN) return nil;
        
        
        return [NSValue valueWithCGRect:rect];
        
    }
    
    return nil;
}


+ (NSValue *) getAnimationPointValueFromDict: (NSDictionary *) dict{
    
    /*
     
     {
         "type" : "point",
         "value" : [100, 40]
     }
     
     */
    
    
    //If dict is nil
    if(!dict) return nil;
    
    NSString *type = [dict objectForKey:kValueType];
    
    if(!type || [type isEqualToString:@""]) return nil;
    
    if([type isEqualToString:kValueTypePoint]){
    
        //Cheack values
        NSArray *values = [dict objectForKey:kValue];
        
        CGPoint point = [DataStructuresManager pointFromArray:values];
        
        //If the point isn't a valid point we return nil
        if(point.x == CGFLOAT_MIN || point.y == CGFLOAT_MIN) return nil;
        

        return [NSValue valueWithCGPoint:point];
    
    }
    
    return nil;
    
}

+ (NSValue *) getAnimationSizeValueFromDict: (NSDictionary *) dict{
    
    /*
     
     {
     "type" : "size",
     "value" : [100, 100]
     }
     
     */
    
    
    //If dict is nil
    if(!dict) return nil;
    
    NSString *type = [dict objectForKey:kValueType];
    
    if(!type || [type isEqualToString:@""]) return nil;
    
    if([type isEqualToString:kValueTypeSize]){
        
        //Cheack values
        NSArray *values = [dict objectForKey:kValue];
        
        CGSize size = [DataStructuresManager sizeFromArray:values];
        
        //If the size isn't a valid point we return nil
        if(size.width == CGFLOAT_MIN || size.height == CGFLOAT_MIN) return nil;
        
        
        return [NSValue valueWithCGSize:size];
        
    }
    
    return nil;
}





@end
