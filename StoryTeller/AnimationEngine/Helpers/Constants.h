//
//  Constants.h
//  StoryTeller
//
//  Created by Héctor Rodríguez Forniés on 03/08/12.
//  Copyright (c) 2012 Héctor Rodríguez Forniés. All rights reserved.
//

#ifndef StoryTeller_Constants_h
#define StoryTeller_Constants_h


//Screen Sizes

//iPhone 5 (4" screen) or ipod
#define IS_IPHONE_5 ( fabs( ( double )[ [ UIScreen mainScreen ] bounds ].size.height - ( double )568 ) < DBL_EPSILON )


//iPhone (3'5" screen) or ipod
#define IS_IPHONE ( fabs( ( double )[ [ UIScreen mainScreen ] bounds ].size.height - ( double )480 ) < DBL_EPSILON )


//iPad (9'7" sreen)
#define IS_IPAD ( fabs( ( double )[ [ UIScreen mainScreen ] bounds ].size.height - ( double )1024 ) < DBL_EPSILON )


//iPad Mini (7'85" sreen) //Roumor
#define IS_IPAD_MINI ( fabs( ( double )[ [ UIScreen mainScreen ] bounds ].size.height - ( double )1024 ) < DBL_EPSILON )



#define kGestureTap @"tap"
#define kGestureDoubleTap @"double-tap"
#define kGestureSwipeLeft @"swipe-left"
#define kGestureSwipeRight @"swipe-right"
#define kActionInTime @"inTime"
#define kUserInteractionEnabled @"userInteractionEnabled"



#define kKeyPATH @"keyPath"
#define kDuration @"duration"
#define kAutoreverses @"autoreverses"
#define kRepeatCount @"repeatCount"
#define kTimingFunction @"timingFunction"
#define kFillMode @"fillMode"
#define kRemovedOnCompletion @"removedOnCompletion"
#define kFromValue @"fromValue"
#define kToValue @"toValue"

#define kAutoreversesYES @"YES"
#define kAutoreversesNO @"NO"

#define kRepeatCountInfinity @"INFINITY"
#define kRepeatCountHughValue @"HUGE_VAL"
#define kRepeatCountHughValueF @"HUGE_VALF"

#define kTimingFunctionDefault @"Default"
#define kTimingFunctionLinear @"Linear"
#define kTimingFunctionEaseIn @"EaseIn"
#define kTimingFunctionEaseOut @"EaseOut"
#define kTimingFunctionEaseInEaseOut @"EaseInEaseOut"

#define kFillModeRemoved @"Removed"
#define kFillModeForwards @"Forwards"
#define kFillModeBackwards @"Backwards"
#define kFillModeBoth @"Both"

#define kRemovedOnCompletionYES @"YES"
#define kRemovedOnCompletionNO @"NO"

#define kValueType @"type"
#define kValueType3D @"3d"
#define kValueTypeInt @"int"
#define kValueTypeDouble @"double"
#define kValueTypeNumber @"number"
#define kValueTypeRect @"rect"
#define kValueTypePoint @"point"
#define kValueTypeSize @"size"



#define kValueSubType @"subtype"
#define kValueSubType3DIdentity @"3DIdentity"
#define kValueSubType3DRotation @"3DMakeRotation"

#define kValue @"value"


#define DEGREES_TO_RADIANS(d) (d * M_PI / 180)



#define kGroupAnimations @"group_animations"

#define kOptionsGroup @"options_group"

#define kAnimations @"animations"

#define kIdAnimation @"id_animation"

//LayerManager
#define kLayers @"layers"
#define kLayer @"layer"
#define kIdLayer @"id_layer"
#define kBounds @"bounds"
#define kPosition @"position"
#define kAnchorPoint @"anchorPoint"
#define kImage @"image"
#define kSublayerTransform @"sublayerTransform"

#define kSublayerTransformName @"name"
#define kSublayerTransformValue @"value"
#define kSublayerTransform3DMakePerspective @"3DMakePerspective"

#define kUIViewLayer @"__all_layers_composition__"

#define kSpriteLayerType @"sprite"
#define kLayerTypeName @"layerType"
#define kFixedSize @"fixedSize"
#define kKeyPathSpritesLayer @"sampleIndex"


//ViewManager

#define kIdView @"id_view"
#define kViewBounds @"bounds"
#define kViewPosition @"position"
#define kViewOpacity @"opacity"
#define kViewAnchorPoint @"anchorPoint"
#define kViewImage @"image"
#define kActionsView @"actions"
#define kAnimsView @"anims"
#define kDragableView @"dragable"

//Lang
#define kLanguage @"lang"
#define kLocale @"loc"

//Paths KeyframeAnimations

#define kPath @"path"
#define kPathQuadBezier @"quad_bezier"
#define kPathBezier @"bezier"
#define kPathArcBezier @"arc_bezier"
#define kPathLinear @"linear_path"
#define kPathCircle @"circle_path"
#define kPathCircleInRect @"circle_in_rect_path"
#define kSvgFilePath @"svg_path"

#define kRotationMode @"rotationMode"
#define kRotationModeAnimationRotateAuto @"kCAAnimationRotateAuto"
#define kRotationModeAnimationRotateAutoReverse @"kCAAnimationRotateAutoReverse"

#define kCalculationMode @"calculationMode"
#define kCalculationModeLinear @"kCAAnimationLinear"
#define kCalculationModeDiscrete @"kCAAnimationDiscrete"
#define kCalculationModePaced @"kCAAnimationPaced"
#define kCalculationModeCubic @"kCAAnimationCubic"
#define kCalculationModeCubicPaced @"kCAAnimationCubicPaced"

#define kStartPoint @"startPoint"
#define kFinalPoints @"finalPoints"
#define kControlPoints @"controlPoints"
#define kRadios @"radios"

#define kKeyTimes @"keyTimes"


#define kCircleCenter @"center"
#define kCircleRadius @"radius"
#define kCircleStartRadians @"startRadians"
#define kCircleFinishRadians @"finishRadians"
#define kCircleClockwise @"clockwise"

#define kCircleInRect @"rect"

#define kSvgFile @"svg-file"
#define kSvgFileiPad @"_ipad"
#define kSvgFileiPhone4 @"_iphone"
#define kSvgFileiPhone5 @"_iphone_5"


//Sound

#define kSound @"sound"
#define kRepeat @"repeat"
#define kFile @"file"
#define kRemainSound @"remainAfterExitPage"
#define kNarrative @"narrative"


//Metadata

#define kNextPages @"nextPages"
#define kPrevPages @"prevPages"
#define kLeftArrow @"leftArrow"
#define kRightArrow @"rightArrow"
#define kMainMenu @"mainMenu"
#define kIdPage @"idPage"

#endif
