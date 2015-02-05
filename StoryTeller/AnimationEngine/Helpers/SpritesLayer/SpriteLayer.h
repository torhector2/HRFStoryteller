//
//  SpriteLayer.h
//  StoryTeller
//
//  Created by Héctor Rodríguez Forniés on 05/12/12.
//
//

//REFERENCE: http://mysterycoconut.com/blog/2011/01/cag1/

#import <QuartzCore/QuartzCore.h>

@interface SpriteLayer : CALayer {
    unsigned int sampleIndex;
}

// SampleIndex needs to be > 0
@property (readwrite, nonatomic) unsigned int sampleIndex;

// For use with sample rects set by the delegate
+ (id)layerWithImage:(CGImageRef)img;
- (id)initWithImage:(CGImageRef)img;

// If all samples are the same size
+ (id)layerWithImage:(CGImageRef)img sampleSize:(CGSize)size;
- (id)initWithImage:(CGImageRef)img sampleSize:(CGSize)size;

// Use this method instead of sprite.sampleIndex to obtain the index currently displayed on screen
- (unsigned int)currentSampleIndex;


@end