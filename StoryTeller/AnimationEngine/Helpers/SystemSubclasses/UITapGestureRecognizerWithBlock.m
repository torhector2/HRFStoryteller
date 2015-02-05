//
//  UITapGestureRecognizerWithBlock.m
//  StoryTeller
//
//  Created by Héctor Rodríguez Forniés on 16/08/12.
//
//

#import "UITapGestureRecognizerWithBlock.h"

@implementation UITapGestureRecognizerWithBlock

@synthesize block;

- (id)initWithBlock:(recogniserBlock)aBlock
{
    self = [super initWithTarget:self action:@selector(dispatchBlock:)];
    
    if(self)
    {
        self.block = aBlock;
    }
    
    return self;
}

- (void)dispatchBlock:(UIGestureRecognizer *)recogniser
{
    block(recogniser);
}

- (void)dealloc
{
    self.block = nil;

}



@end
