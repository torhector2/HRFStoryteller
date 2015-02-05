//
//  Page.h
//  StoryTeller
//
//  Created by Héctor Rodríguez Forniés on 28/11/12.
//
//

#import <Foundation/Foundation.h>
#import "SecuentialAnimatorDelegate.h"
#import "PageNavigableDelegate.h"

@class AudioTool;

@interface Page : NSObject <SecuentialAnimatorDelegate>


-(id) initWithPageID: (NSString *) theId
        AndProjectID: (NSString *) theProjectId
       AndSceneViews: (NSMutableDictionary *) theViews
   AndSceneViewsKeys: (NSMutableArray *) theViewsKeys
      AndSceneLayers: (NSMutableDictionary *) theLayers
  AndSceneAnimations: (NSMutableDictionary *) theAnimations
         AndMetadata: (NSMutableDictionary *) theMetadata;


-(id) initWithArray: (NSArray *) theArray AndNarrative:(BOOL) narrative AndIdPage: (NSString *) idStr AndIdProject: (NSString *) idProject;


/*
 Add the Page UIViews to the UIViewController Owner as subviews
 */
-(void) setOwnerView: (UIView *) aView;

-(void) loadFile:(NSString *) fileStr InView: (UIView *) aView;


@property(nonatomic, strong) NSMutableDictionary *audioToolsDict;


//The Project ID
@property(nonatomic, strong) NSString *idProject;

//The ID of the scene page
@property(nonatomic, strong) NSString *pageID;

//Mutable Array with the scene views keys (of the NSMutableDictionary)
@property(nonatomic, strong) NSMutableArray *sceneViewsKeys;

//Mutable Dictionary with the UIViews of the Page, asociated qith the property sceneViewsKeys
@property(nonatomic, strong) NSMutableDictionary *sceneViews;

//Mutable Dictionary with the scene Layers
@property(nonatomic, strong) NSMutableDictionary *sceneLayers;

//Mutable Dictionary with the Animations and GroupAnimations
@property(nonatomic, strong) NSMutableDictionary *sceneAnimations;


//Metadata Dictionary
@property(nonatomic, strong) NSMutableDictionary *metadata;

@property(nonatomic, strong) UIView *mainOwnerView;


//Activate narrative
@property(nonatomic) BOOL narrativeActive;




//Delegate
@property(nonatomic, weak) id<PageNavigableDelegate> delegate;



@end
