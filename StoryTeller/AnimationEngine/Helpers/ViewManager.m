//
//  ViewManager.m
//  StoryTeller
//
//  Created by Héctor Rodríguez Forniés on 03/08/12.
//  Copyright (c) 2012 Héctor Rodríguez Forniés. All rights reserved.
//

#import "ViewManager.h"
#import "DataStructuresManager.h"
#import "Constants.h"

#import "DragDropView.h"


@implementation ViewManager


+ (UIView *) prepareViewFromDictionary: (NSDictionary *) dict{
    
    if(!dict) return nil;
    
    if([[dict allKeys] count] == 0) return nil;
    
    
    //UIView *theView = nil;
    DragDropView *theView = nil;
    
    
    
    BOOL validViewForLanguageAndLocale = [self renderViewForCurrentLanguageAndLocaleFromDict: dict];
    
    if(!validViewForLanguageAndLocale) return nil;
    
    //Bounds
    
    CGRect rect = [self getViewRectValueFromDict:dict];
    
    //If the size is valid, assign to layer bounds
    if(rect.origin.x != CGFLOAT_MIN &&
       rect.origin.y != CGFLOAT_MIN &&
       rect.size.width != CGFLOAT_MIN &&
       rect.size.height != CGFLOAT_MIN){
        
        //theView = [[UIView alloc] initWithFrame:rect];
        theView = [[DragDropView alloc] initWithFrame:rect];
        BOOL dragable = [dict objectForKey:kDragableView];
        theView.isDragable = dragable;
        
    }
    
    
    //Position
    CGPoint position = [self getViewPositionPointValueFromDict:dict];
    
    //If the point isn't a valid point we return nil
    if(position.x != CGFLOAT_MIN && 
       position.y != CGFLOAT_MIN){
        
        theView.layer.position = position;
        
    }
    
    
    //Opacity
    NSNumber *opacity = [self getViewOpacityValueFromDict: dict];
    
    if(opacity){
        
        theView.layer.opacity = [opacity floatValue];
        
    }
    
    
    //Anchor Point
    CGPoint anchorPoint = [self getViewAnchorPointValueFromDict:dict];
    
    //If the point isn't a valid point we return nil
    if(anchorPoint.x != CGFLOAT_MIN && 
       anchorPoint.y != CGFLOAT_MIN){
        
        theView.layer.anchorPoint = anchorPoint;
        
    }
    
    
    //Image
    UIImage *image = [self getViewImageFromDict:dict];
    
    if(image){
        
        theView.layer.contents = (id)image.CGImage;
        
    }
    
    
    return theView;
    
    
}


+(BOOL) renderViewForCurrentLanguageAndLocaleFromDict: (NSDictionary *) dict {
    
    NSString *languageDevice = [[NSLocale preferredLanguages] objectAtIndex:0];
    NSString *localeDevice = [[NSLocale currentLocale] objectForKey: NSLocaleCountryCode];
    
    NSString *languageDict = [dict objectForKey:kLanguage];
    NSString *localeDict = [dict objectForKey:kLocale];
    
    
    BOOL render = YES;
    
    //If there isn't defined a language or a locale the view is visible in ALL languages
    if(!languageDict && !localeDict) {
        return YES;
    }
    
    
    //If there isn't locale defined in Dictionary
    if(!localeDict && [languageDict isEqualToString:languageDevice]){
        return YES;
    }else if(!localeDict && ![languageDict isEqualToString:languageDevice]){
        
        return NO;
        
    }
    
    //If there is defined both language and locale in Dictionary
    if(localeDict && languageDict){
        
        if([localeDict isEqualToString:localeDevice] && [languageDict isEqualToString:languageDevice]){
            return YES;
        }else {
            return NO;
        }
        
    }
    
    
    
    return render;
    
}


+ (CGRect) getViewRectValueFromDict: (NSDictionary *) dict {
    
    /* Bounds
     {
         "bounds" : [0, 0, 50, 50],
         "position" : [10, 10],
         "opacity" : 0.3,
         "anchorPoint" : [0, 0.5],
         "image" : "/relative/url/to/picture1.png",
    }
     */
    
    NSArray *boundsValues = [dict objectForKey:kViewBounds];
    
    
    CGRect rect = [DataStructuresManager rectFromArray:boundsValues];
    
    return rect;
    
}


+ (CGPoint ) getViewPositionPointValueFromDict: (NSDictionary *) dict{
    
    /* Position
     {
         "bounds" : [0, 0, 50, 50],
         "position" : [10, 10],
         "opacity" : 0.3,
         "anchorPoint" : [0, 0.5],
         "image" : "/relative/url/to/picture1.png",
         
     }
     */    
    
    NSArray *positionValues = [dict objectForKey:kViewPosition];
    
    CGPoint point = [DataStructuresManager pointFromArray:positionValues];
    
    return point;
    
}


+ (NSNumber *) getViewOpacityValueFromDict: (NSDictionary *) dict{
    
    //If dict is nil
    if(!dict) return nil;
    
    //Cheack values
    NSNumber *opacity = [dict objectForKey:kViewOpacity];
    
    
    return opacity;
}


+ (CGPoint ) getViewAnchorPointValueFromDict: (NSDictionary *) dict{
    
     
    
    NSArray *positionValues = [dict objectForKey:kViewAnchorPoint];
    
    CGPoint point = [DataStructuresManager pointFromArray:positionValues];
    
    return point;
    
}


+ (UIImage *) getViewImageFromDict: (NSDictionary *) dict{
    
      
    
    NSString *imagePath = [dict objectForKey:kViewImage];
    
    UIImage *image = [UIImage imageNamed:imagePath];
    
    return image;
    
}


@end
