//
//  DragDropView.m
//  StoryTeller
//
//  Created by Héctor Rodríguez Forniés on 16/01/13.
//
//

#import "DragDropView.h"

@implementation DragDropView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.isDragable = NO;
    }
    return self;
}


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    touchStart = [[touches anyObject] locationInView:self];
    
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    CGPoint touchPoint = [[touches anyObject] locationInView:self];
    
    
    if(self.isDragable) {
        self.center = CGPointMake(self.center.x + touchPoint.x - touchStart.x,
                                  self.center.y + touchPoint.y - touchStart.y);
    }
}



@end
