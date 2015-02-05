//
//  EscenePlayerViewController.m
//  StoryTeller
//
//  Created by Héctor Rodríguez Forniés on 02/08/12.
//  Copyright (c) 2012 Héctor Rodríguez Forniés. All rights reserved.
//

#import "EscenePlayerViewController.h"
#import "UITapGestureRecognizerWithBlock.h"
#import "UISwipeGestureRecognizerWithBlock.h"
#import "Constants.h"
#import "ActionsLoader.h"
#import "Page.h"


@interface EscenePlayerViewController ()


@property(nonatomic, strong) Page *thePage;

@end

@implementation EscenePlayerViewController



//Mutable Array with the scene views....
@synthesize sceneViews;

//Mutable Dictionary with the Animations and GroupAnimations
@synthesize sceneAnimations;

//Mutable Dictionary with the scene Layers
@synthesize sceneLayers;



//Current Page
@synthesize currentPage;



- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
        
    
    //Init current page
    self.currentPage = 0;
    
    //Init the collections or clear it if we are reloading a page
    [self reloadSceneCollections];
    
    
}


#pragma mark Load Scene Methods


- (Page *) loadPageFromDictionary: (NSArray *) pagesArray {
    
    for (NSDictionary *dictView in pagesArray) {
        //load View
    }
    
    return nil; //return page
}

- (void) reloadSceneCollections {
    
    // Reset or instanciate the sceneViews
    if(!self.sceneViews) {
        self.sceneViews = [NSMutableArray array];
    }
    
    [self.sceneViews removeAllObjects];
   
    // Reset or instanciate the sceneAnimations
    if(!self.sceneAnimations) {
        self.sceneAnimations = [NSMutableDictionary dictionary];
    }
    
    [self.sceneAnimations removeAllObjects];
    
    
    // Reset or instanciate the sceneLayers
    if(!self.sceneLayers) {
        self.sceneLayers = [NSMutableDictionary dictionary];
    }
    
    [self.sceneLayers removeAllObjects];
    
    
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"barcoSprites" ofType:@"json"];
    
    NSError* error;
    NSArray *arrayAnim = [NSJSONSerialization JSONObjectWithData:[NSData dataWithContentsOfFile:filePath] options:nil error:&error];
    
    self.thePage = [[Page alloc] initWithArray:arrayAnim AndNarrative: YES AndIdPage:@"" AndIdProject:@""];
    self.thePage.delegate = self;
    self.thePage.narrativeActive = YES;
    [self.thePage setOwnerView:self.view];
    
    
}

#pragma mark - PageNavigableDelegate Methods

- (void) performNextPageWithMetadataDict:(NSDictionary *)theMetaData {
    
    NSLog(@" ============ Delegate Next");
    
    NSArray *nextPages = [theMetaData objectForKey: kNextPages];
    
    [self performNavigationWithArray:nextPages InView:self.view];
}

-(void) performPrevPageWithMetadataDict:(NSDictionary *)theMetaData {

    NSLog(@" ============ Delegate Prev");
    
    NSArray *prevPages = [theMetaData objectForKey: kPrevPages];
    
    [self performNavigationWithArray:prevPages InView:self.view];
    
}

-(void) manageMainButton {
    
    NSLog(@" ============ Delegate Main Menu");
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"You could customize any button action in the screen" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
    [alert show];
    
}

//General method to performing navigation
-(void) performNavigationWithArray: (NSArray *) theArray InView: (UIView *) aView{
    
    if(theArray && theArray.count > 0) {
        
        
        if(theArray.count == 1) {
            //If it is only 1 nextPage -> loadPage
            //Create a Page and load in view
            
            NSString *filePath = [[NSBundle mainBundle] pathForResource:[[theArray objectAtIndex:0] objectForKey:kIdPage] ofType:@"json"];
            NSError* error;
            NSArray *arrayAnim = [NSJSONSerialization JSONObjectWithData:[NSData dataWithContentsOfFile:filePath] options:nil error:&error];
            
            
            self.thePage = nil;
            self.thePage = [[Page alloc] initWithArray:arrayAnim AndNarrative: YES AndIdPage:[[theArray objectAtIndex:0] objectForKey:kIdPage] AndIdProject:@""];
            self.thePage.delegate = self;

            //Current Views
            NSArray *theViewsToRemove = [self.view subviews];
        
            [self.thePage setOwnerView:self.view];
            
            UIView *blackView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 1024, 768)];
            blackView.backgroundColor = [UIColor blackColor];
            [self.view addSubview:blackView];
            
            //Fade out prev to change page
            [UIView animateWithDuration:0.7 animations:^{
                blackView.alpha = 0.0;
            } completion:^(BOOL finished) {
                
                //Remove on completion
                [blackView removeFromSuperview];
                
            }];
            
                        
            for (UIView *aViewToRemove in theViewsToRemove) {
                [aViewToRemove removeFromSuperview];
                
            }
            
        }else {
            
            //If it is more nextPages -> loadChoices loadChoicesInView:
        }
    }
}


- (void) loadChoicesInView: (UIView *) aView {
    
}


- (void) performAnimationsForUIViewKey: (NSString *) theViewKey andActionKey: (NSString *) anActionKey{
    
    NSLog(@"From action: %@", theViewKey);
    
}



- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

@end
