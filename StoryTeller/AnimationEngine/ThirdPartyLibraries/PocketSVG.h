//
//  PocketSVG.h
//
//  Based on SvgToBezier.h, created by Martin Haywood on 5/9/11.
//  Attribution-ShareAlike 3.0 Unported (CC BY-SA 3.0) license 2011 Ponderwell.
//
//  Cleaned up by Bob Monaghan - Glue Tools LLC 6 November 2011
//  Integrated into PocketSVG 10 August 2012
//

#if TARGET_OS_IPHONE
#import <UIKit/UIKit.h>
#else
#import <Cocoa/Cocoa.h>
#endif

@interface PocketSVG : NSObject {
	@private
	float			pathScale;
#if TARGET_OS_IPHONE
	UIBezierPath    *bezier;
#else
	NSBezierPath    *bezier;
#endif
	CGPoint			lastPoint;
	CGPoint			lastControlPoint;
	BOOL			validLastControlPoint;
	NSCharacterSet  *separatorSet;
	NSCharacterSet  *commandSet;
    
    NSMutableArray  *tokens;
}
#if TARGET_OS_IPHONE
@property(nonatomic, readonly) UIBezierPath *bezier;
#else
@property(nonatomic, readonly) NSBezierPath *bezier;
#endif

- (id)initFromSVGFileNamed:(NSString *)nameOfSVG;

#if !TARGET_OS_IPHONE
+ (CGPathRef)getCGPathFromNSBezierPath:(NSBezierPath *)quartzPath;
#endif

@end
