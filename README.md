# Storyteller
Storyteller is a JSON to CoreAnimation conversion library that you could use to create awesome tales 

## Installation

1. Drag and drop the AnimationEngine folder to your project.
2. Add the AVFoundation.framework to your project
3. Add the QuartzCore.framework to your project
4. Add the CoreGraphics.framework to your project

## Usage

```objc
- (void)viewDidLoad
{
    [super viewDidLoad];
	  // Do any additional setup after loading the view.
    //Init current page
    self.currentPage = 0;
    
    //Init the collections or clear it if we are reloading a page
    [self reloadSceneCollections];
}
```

```objc
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
    
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"yourPageFile" ofType:@"json"];
    
    NSError* error;
    NSArray *arrayAnim = [NSJSONSerialization JSONObjectWithData:[NSData dataWithContentsOfFile:filePath] options:nil error:&error];
    
    self.thePage = [[Page alloc] initWithArray:arrayAnim AndNarrative: YES AndIdPage:@"" AndIdProject:@""];
    self.thePage.delegate = self;
    self.thePage.narrativeActive = YES;
    [self.thePage setOwnerView:self.view];
    
}
```
### PageNavigableDelegate

```objc
- (void) performNextPageWithMetadataDict:(NSDictionary *)theMetaData {
    NSLog(@"Delegate Next");
    NSArray *nextPages = [theMetaData objectForKey: kNextPages];
    [self performNavigationWithArray:nextPages InView:self.view]; //Your custom navigation method
}

-(void) performPrevPageWithMetadataDict:(NSDictionary *)theMetaData {
    NSLog(@"Delegate Prev");
    NSArray *prevPages = [theMetaData objectForKey: kPrevPages];
    [self performNavigationWithArray:prevPages InView:self.view]; //Your custom method
}

-(void) manageMainButton {
    NSLog(@"Delegate Main Menu");
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"You could customize any button action in the screen" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
    [alert show];
}

```
