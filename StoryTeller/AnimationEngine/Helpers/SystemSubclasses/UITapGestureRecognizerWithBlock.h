//
//  UITapGestureRecognizerWithBlock.h
//  StoryTeller
//
//  Created by Héctor Rodríguez Forniés on 16/08/12.
//
//

#import <UIKit/UIKit.h>
#import "UIGestureRecognizerTypedef.h"

@interface UITapGestureRecognizerWithBlock : UITapGestureRecognizer

//The block
@property (nonatomic, copy) recogniserBlock block;

//Init method
- (id)initWithBlock:(recogniserBlock)block;


@end
