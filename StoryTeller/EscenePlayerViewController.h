//
//  EscenePlayerViewController.h
//  StoryTeller
//
//  Created by Héctor Rodríguez Forniés on 02/08/12.
//  Copyright (c) 2012 Héctor Rodríguez Forniés. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PageNavigableDelegate.h"

@interface EscenePlayerViewController : UIViewController <PageNavigableDelegate>


//Collections
@property (nonatomic, strong) NSMutableArray *sceneViews;

@property (nonatomic, strong) NSMutableDictionary *sceneAnimations;

@property (nonatomic, strong) NSMutableDictionary *sceneLayers;


//Current page
@property (nonatomic) int currentPage;



@end

