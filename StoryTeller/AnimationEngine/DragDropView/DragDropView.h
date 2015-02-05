//
//  DragDropView.h
//  StoryTeller
//
//  Created by Héctor Rodríguez Forniés on 16/01/13.
//
//

#import <UIKit/UIKit.h>

@interface DragDropView : UIView{
    @private
    CGPoint touchStart;
}


@property(nonatomic) BOOL isDragable;


@end
