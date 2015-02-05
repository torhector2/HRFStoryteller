//
//  ActionsLoader.m
//  StoryTeller
//
//  Created by Héctor Rodríguez Forniés on 24/11/12.
//
//

#import "ActionsLoader.h"
#import "UITapGestureRecognizerWithBlock.h"
#import "UISwipeGestureRecognizerWithBlock.h"
#import "Constants.h"


@implementation ActionsLoader

#pragma mark Actions


+ (void) linkView: (UIView *) theView WithActionType: (NSString *) actionType WithTimeSeconds: (NSNumber *) seconds AndBlock: (void (^)()) theBlock {
    
    
    //Prepare Gesture Recognizer or Timer
    UIGestureRecognizer *recognizer = nil;
    
    
    //check type of gesture recognizer
    
    if ([actionType isEqualToString:kGestureTap]) {
        
        //Gesture Tap
        recognizer = [[UITapGestureRecognizerWithBlock alloc] initWithBlock:^(UIGestureRecognizer *recogniser) {
            
            //The code
            NSLog(@"Tap Gesture");
            
            //Execute the block
            if(theBlock) {
                theBlock();
            }
            
            
        }];
        
        ((UITapGestureRecognizer *)recognizer).numberOfTapsRequired = 1;
        
        [self setSimoultaneosTapGesturesInArray:theView.gestureRecognizers AndCurrentGesture:recognizer];
        
        
    }else if ([actionType isEqualToString:kGestureDoubleTap]) {
        
        //Gesture DoubleTap
        recognizer = [[UITapGestureRecognizerWithBlock alloc] initWithBlock:^(UIGestureRecognizer *recogniser) {
            
            //The code
            NSLog(@"Double Tap Gesture");
            
            //Execute the block
            if(theBlock) {
                theBlock();
            }
            
            
        }];
        
        ((UITapGestureRecognizer *)recognizer).numberOfTapsRequired = 2;
        
        [self setSimoultaneosTapGesturesInArray:theView.gestureRecognizers AndCurrentGesture:recognizer];
        
        
    }else if ([actionType isEqualToString:kGestureSwipeLeft]) {
        
        //Gesture Swipe Left
        recognizer = [[UISwipeGestureRecognizerWithBlock alloc] initWithBlock:^(UIGestureRecognizer *recogniser) {
            
            //Code
            NSLog(@"Swipe left Gesture");
            
            //Execute the block
            if(theBlock) {
                theBlock();
            }
            
            
        }];
        ((UISwipeGestureRecognizer *)recognizer).direction = UISwipeGestureRecognizerDirectionLeft;
        
        
    }else if ([actionType isEqualToString:kGestureSwipeRight]) {
        
        //Gesture Swipe Right
        recognizer = [[UISwipeGestureRecognizerWithBlock alloc] initWithBlock:^(UIGestureRecognizer *recogniser) {
            
            //Code
            NSLog(@"Swipe right Gesture");
            
            
            //Execute the block
            if(theBlock) {
                theBlock();
            }
            
            
        }];
        ((UISwipeGestureRecognizer *)recognizer).direction = UISwipeGestureRecognizerDirectionRight;
        
    }else if ([actionType isEqualToString:kActionInTime]) {
        
        //DO Stuff with NSTimer
        
        //Execute the block
        if(theBlock) {
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, [seconds doubleValue] * NSEC_PER_SEC), dispatch_get_current_queue(), ^{

                theBlock();
                
            });
            
            
        }
        
    }
    
    
    //Add gesture recognizer to the view
    if(recognizer){
        
        [theView addGestureRecognizer:recognizer];
        
    }

}



/*
 
 Prepare a gesture recognizer or a timer and link it with the target UIView
 
 */
+ (void) linkView: (UIView *) theView withActionsFromDict: (NSDictionary *) actionDict WithActionType: (NSString *) actionType{
    
    /*
     
     
     
     */
    
    
    //Prepare Gesture Recognizer or Timer
    UIGestureRecognizer *recognizer = nil;
    
    
    //check type of gesture recognizer
    
    if ([actionType isEqualToString:kGestureTap]) {
        
        //Gesture Tap
        recognizer = [[UITapGestureRecognizerWithBlock alloc] initWithBlock:^(UIGestureRecognizer *recogniser) {
            
            //The code
            NSLog(@"Tap Gesture");
        
        }];
        
        ((UITapGestureRecognizer *)recognizer).numberOfTapsRequired = 1;
        
        [self setSimoultaneosTapGesturesInArray:theView.gestureRecognizers AndCurrentGesture:recognizer];
        
        
    }else if ([actionType isEqualToString:kGestureDoubleTap]) {
        
        //Gesture DoubleTap
        recognizer = [[UITapGestureRecognizerWithBlock alloc] initWithBlock:^(UIGestureRecognizer *recogniser) {
            
            //The code
            NSLog(@"Double Tap Gesture");
            
        }];
        
        ((UITapGestureRecognizer *)recognizer).numberOfTapsRequired = 2;
        
        [self setSimoultaneosTapGesturesInArray:theView.gestureRecognizers AndCurrentGesture:recognizer];
        
        
    }else if ([actionType isEqualToString:kGestureSwipeLeft]) {
        
        //Gesture Swipe Left
        recognizer = [[UISwipeGestureRecognizerWithBlock alloc] initWithBlock:^(UIGestureRecognizer *recogniser) {
            
            //Code
            NSLog(@"Swipe left Gesture");
        }];
        ((UISwipeGestureRecognizer *)recognizer).direction = UISwipeGestureRecognizerDirectionLeft;
        
        
    }else if ([actionType isEqualToString:kGestureSwipeRight]) {
        
        //Gesture Swipe Right
        recognizer = [[UISwipeGestureRecognizerWithBlock alloc] initWithBlock:^(UIGestureRecognizer *recogniser) {
            
            //Code
            NSLog(@"Swipe right Gesture");
            
        }];
        ((UISwipeGestureRecognizer *)recognizer).direction = UISwipeGestureRecognizerDirectionRight;
        
    }else if ([actionType isEqualToString:kActionInTime]) {
        
        //DO Stuff with NSTimer
        
        
    }
    
    
    //Add gesture recognizer to the view
    if(recognizer){
        
        [theView addGestureRecognizer:recognizer];
        
    }
    
}



/* 
 Private Method that avoids to execute two different TapGesutes with the same event
 If a double-tap is been triggered then the single tap ins't triggered
 */
+ (void) setSimoultaneosTapGesturesInArray: (NSArray *) gestures AndCurrentGesture: (UIGestureRecognizer *) currentGesture {
    
    //Get current number of taps required
    int currentTapNumber = ((UITapGestureRecognizer *)currentGesture).numberOfTapsRequired;
    
    for (UIGestureRecognizer *gest in gestures) {
        
        if([gest isKindOfClass:[UITapGestureRecognizer class]]) {
            
            int gestTapNumber = ((UITapGestureRecognizer *)gest).numberOfTapsRequired;
            if(gestTapNumber == currentTapNumber - 1){
                //
                [gest requireGestureRecognizerToFail:currentGesture];
                break;
            }
        }
        
    }
    
}






@end
