//
//  UIGestureRecognizerTypedef.h
//  StoryTeller
//
//  Created by Héctor Rodríguez Forniés on 24/11/12.
//
//

#import <UIKit/UIKit.h>

@interface UIGestureRecognizerTypedef : NSObject

//Type of block that the UIGestureRecognizerWithBlock accepts
typedef void (^ recogniserBlock)(UIGestureRecognizer *recogniser);

@end
