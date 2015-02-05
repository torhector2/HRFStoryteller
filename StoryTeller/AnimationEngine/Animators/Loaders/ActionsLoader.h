//
//  ActionsLoader.h
//  StoryTeller
//
//  Created by Héctor Rodríguez Forniés on 24/11/12.
//
//

#import <Foundation/Foundation.h>

@interface ActionsLoader : NSObject

+ (void) linkView: (UIView *) theView WithActionType: (NSString *) actionType WithTimeSeconds: (NSNumber *) seconds AndBlock: (void (^)()) theBlock ;

+ (void) linkView: (UIView *) theView withActionsFromDict: (NSDictionary *) actionDict WithActionType: (NSString *) actionType;

@end
