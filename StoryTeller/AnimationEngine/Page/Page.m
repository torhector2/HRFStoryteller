//
//  Page.m
//  StoryTeller
//
//  Created by Héctor Rodríguez Forniés on 28/11/12.
//
//

#import "Page.h"
#import "Constants.h"
#import "ViewManager.h"
#import "LayerManager.h"
#import "AnimationManager.h"
#import "GroupAnimationManager.h"

#import "SimultaneousAnimator.h"
#import "SimultaneousAnimatorGroup.h"
#import "SecuentialAnimator.h"

#import "ActionsLoader.h"

#import "AudioTool.h"


@interface Page ()

- (SecuentialAnimator *) loadAnimatorsWithArray: (NSArray *) actions AndView: (UIView *) theView;

@property(nonatomic, strong) NSNumber *narrativeNumberKey;

@end

@implementation Page


-(id) initWithPageID: (NSString *) theId
            AndProjectID: (NSString *) theProjectId
            AndSceneViews: (NSMutableDictionary *) theViews
            AndSceneViewsKeys: (NSMutableArray *) theViewsKeys
            AndSceneLayers: (NSMutableDictionary *) theLayers
            AndSceneAnimations: (NSMutableDictionary *) theAnimations
            AndMetadata: (NSMutableDictionary *) theMetadata{
    
    if(self = [super init]) {
        self.pageID = theId;
        self.idProject = theProjectId;
        self.sceneViews = theViews;
        self.sceneViewsKeys = theViewsKeys;
        self.sceneLayers = theLayers;
        self.sceneAnimations = theAnimations;
        self.metadata = theMetadata;
        
        
    }
    
    return self;
}


-(id) initWithArray: (NSArray *) theArray AndNarrative:(BOOL) narrative AndIdPage: (NSString *) idStr AndIdProject: (NSString *) idProject{
    
    //Parse Array
    
    NSMutableArray *theViewKeys = [NSMutableArray array];
    NSMutableDictionary *theViews = [NSMutableDictionary dictionary];
    NSMutableDictionary *theLayersDict = [NSMutableDictionary dictionary];
    NSMutableDictionary *theAnimationsDict = [NSMutableDictionary dictionary];
    NSMutableDictionary *theGroupAnimationsDict = [NSMutableDictionary dictionary];
    NSMutableDictionary *metadataDict = [NSMutableDictionary dictionary];
    
    BOOL metadataLoaded = NO;
    
    self.narrativeActive = narrative;
    //Init the AudioToolsArray
    self.audioToolsDict = [NSMutableDictionary dictionary];
    
    for(NSDictionary *aDict in theArray){
        
        
        //Check metadata first
        if(!metadataLoaded){
        
            NSArray *keysMetadata = [aDict allKeys];
            if([keysMetadata containsObject:kNextPages] || [keysMetadata containsObject:kPrevPages]){
                
                metadataDict = [aDict mutableCopy];
                metadataLoaded = YES;
                continue;
            }
        }
        
        
        //Check if narrative is ON and if the current dictionary is the NarrativeDic
        
        NSDictionary *narrativeDict = [aDict objectForKey:kNarrative];
        if(self.narrativeActive && narrativeDict){
            
            
            
            if(narrativeDict) {
                
                //Hago un diccionario con el hash del audioDict, 1º buscamos en el diccionario la key con el has
                //2º hacemos play
                //3º si es nil, alloc, insert en el dict y play
                
                
                NSString *descriptionDict = [narrativeDict description];
                NSUInteger hash = [descriptionDict hash];
                
                NSNumber *numHash = [NSNumber numberWithInteger:hash];
                
                self.narrativeNumberKey = numHash;
                
                AudioTool *tool = (AudioTool *)[self.audioToolsDict objectForKey:numHash];
                [tool play]; //Si es nil no da error, así no perdemos tiempo en comprobar
                
                if(!tool) {
                    tool = [[AudioTool alloc] initWithDict:narrativeDict AndProjectId:self.idProject];
                    
                    [self.audioToolsDict setObject:tool forKey:numHash];
                    
                    //Set remain sounds
                    BOOL remain = [[narrativeDict objectForKey:kRemainSound] boolValue];
                    tool.remainAfterExitPage = remain;
                    
                  //  [tool play];
                    
                }
                
                
            }
            
            continue;
        }
        
        
        //Get UIView Key
        NSString *keyIdView = [aDict objectForKey:kIdView];
        [theViewKeys addObject:keyIdView];
        
        //Get UIView
        UIView *theView = [ViewManager prepareViewFromDictionary:aDict];
        
        if(theView) {
            [theViews setObject:theView forKey:keyIdView];
        }
        
        
        //Get Layers
        NSArray *theLayers = [aDict objectForKey:kLayers];
        
        for (NSDictionary *layerDict in theLayers) {
            
            //Get Layer key
            NSString *keyIdLayer = [layerDict objectForKey:kIdLayer];
            
            //Get Layer
            CALayer *theLayer = [LayerManager prepareLayerFromDictionary:layerDict];
            
            //Add the Layer to the View.layer
            if(theLayer){
                
                [theView.layer addSublayer:theLayer];
                
            }
            
            //Add Layer to Layer Dict
            [theLayersDict setObject:theLayer forKey:keyIdLayer];
            
        }
        
//        if([[theLayersDict allKeys] count] == 0){
//            theLayersDict = nil;
//        }
        
        //Get Animations
        NSArray *theAnimations = [aDict objectForKey:kAnimations];
        
        for (NSDictionary *animDict in theAnimations) {
            
            //Get Animation key
            NSString *keyIdAnimation = [animDict objectForKey:kIdAnimation];
            
            //Get Animation
            CAAnimation *theAnimation = [AnimationManager prepareAnimationFromDictionary:animDict];
            
            //Add Layer to Layer Dict
            [theAnimationsDict setObject:theAnimation forKey:keyIdAnimation];
            
        }
        
//        if([[theAnimationsDict allKeys] count] == 0){
//            theAnimationsDict = nil;
//        }
        
        
        //Get Group Animations
        NSDictionary *theAnimationsGroup = [aDict objectForKey:kGroupAnimations];
        NSArray *theAnimationsGroupKeys = [theAnimationsGroup allKeys];
        
        for (NSString *keyStr in theAnimationsGroupKeys) {
            
            NSDictionary *animDict = [theAnimationsGroup objectForKey:keyStr];
            
            //Get Animation
            CAAnimationGroup *theAnimationGroup = [GroupAnimationManager prepareGroupAnimationFromDictionary:animDict WithGroupIdentifier:keyStr AndAnimationsDictionary:theAnimationsDict];
            
            //Add Layer to Layer Dict
            [theGroupAnimationsDict setObject:theAnimationGroup forKey:keyStr];
            
        }
        
//        if([[theGroupAnimationsDict allKeys] count] == 0){
//            theGroupAnimationsDict = nil;
//        }
        
        
        //Load Animators
        [self loadActionFromDict:aDict WithView:theView];
        
    }
  
    //New Dict with AnimationsArray and GroupAnimations array
    
    NSMutableDictionary *dictGroupAnimationsAndIndividualAnimations = nil;
    
    if(theAnimationsDict || theGroupAnimationsDict) {
        dictGroupAnimationsAndIndividualAnimations = [NSMutableDictionary dictionary];
    }
    
    if(theAnimationsDict){
        [dictGroupAnimationsAndIndividualAnimations addEntriesFromDictionary:theAnimationsDict];
    }
    
    if(theGroupAnimationsDict){
        [dictGroupAnimationsAndIndividualAnimations addEntriesFromDictionary:theGroupAnimationsDict];
    }
    
    
    return [self initWithPageID:idStr AndProjectID: idProject AndSceneViews:theViews AndSceneViewsKeys:theViewKeys AndSceneLayers:theLayersDict AndSceneAnimations:dictGroupAnimationsAndIndividualAnimations AndMetadata:metadataDict];
    
}

#pragma mark - Load Actions

-(void) loadFile:(NSString *) fileStr InView: (UIView *) aView {
    
    NSString *filePath = [[NSBundle mainBundle] pathForResource:fileStr ofType:@"json"];
    
    NSError* error;
    
    NSArray *arrayAnim = [NSJSONSerialization JSONObjectWithData:[NSData dataWithContentsOfFile:filePath] options:nil error:&error];
    
    
    //self.thePage = [[Page alloc] initWithArray:arrayAnim AndIdPage:@"" AndIdProject:@""];
    
    NSArray *subViews = aView.subviews;
    
    [self setOwnerView: aView];
    
    for (UIView *view in subViews) {
        [view removeFromSuperview];
    }
    

}

-(void) loadWithPageID: (NSString *) theId
          AndProjectID: (NSString *) theProjectId
         AndSceneViews: (NSMutableDictionary *) theViews
     AndSceneViewsKeys: (NSMutableArray *) theViewsKeys
        AndSceneLayers: (NSMutableDictionary *) theLayers
    AndSceneAnimations: (NSMutableDictionary *) theAnimations
           AndMetadata: (NSMutableDictionary *) theMetadata {
    
    self.pageID = theId;
    self.idProject = theProjectId;
    self.sceneViews = theViews;
    self.sceneViewsKeys = theViewsKeys;
    self.sceneLayers = theLayers;
    self.sceneAnimations = theAnimations;
    self.metadata = theMetadata;
    
    //Init the AudioToolsArray
    self.audioToolsDict = [NSMutableDictionary dictionary];
    
}


- (void) loadActionFromDict: (NSDictionary *) actionsDict WithView: (UIView *) theView {
    
    
    NSMutableDictionary *actions = [actionsDict objectForKey:kActionsView];
    NSArray *actionsKeys = [actions allKeys];
    
    for (NSString *keyAction in actionsKeys) {
        
        NSNumber *timeSec = 0;
        
        if([keyAction isEqualToString:kActionInTime]){
            NSLog(@"");
            timeSec = (NSNumber *)[[actions objectForKey:keyAction] objectAtIndex:0];
        }
        
         [ActionsLoader linkView:theView WithActionType:keyAction WithTimeSeconds:timeSec AndBlock:^{
        
            
             NSArray *actionsArray = nil;
             
             if([keyAction isEqualToString:kActionInTime]){
                 
                 //In the Time Action, the first element is the time in seconds
                 
                 NSMutableArray *tail = [[actions objectForKey:keyAction] mutableCopy];
                 [tail removeObjectAtIndex:0];
                 actionsArray = [NSArray arrayWithArray:tail];
                 
             }else {
                 //In the other actions the first element isn't the time
                 actionsArray = [actions objectForKey:keyAction];
             }
             
             
             //Get userInteractionEnabled from JSON
             BOOL userInteractionEnabledFlag = NO;
             
             id firstElementAction = [actionsArray objectAtIndex:0];
             if([firstElementAction isKindOfClass:[NSMutableDictionary class]]){
                 
                 if ([[((NSDictionary *)firstElementAction) allKeys] containsObject:kUserInteractionEnabled]) {
                     
                     NSMutableArray *tail2 = [actionsArray mutableCopy];
                     
                     //Get UserInteraction
                     NSDictionary *userInteractionDict = [actionsArray objectAtIndex:0];
                     userInteractionEnabledFlag = [[userInteractionDict objectForKey:kUserInteractionEnabled] boolValue];
                     
                     [tail2 removeObjectAtIndex:0];
                     actionsArray = [NSArray arrayWithArray:tail2];
                     
                 }
                 
             }
             
        
            //Creamos los Animators
             SecuentialAnimator *theAnimator = [self loadAnimatorsWithArray:actionsArray AndView: theView];
            
            //Execute Animator
            [theAnimator performNextSequentialAnimation];
             
             //Audio
             
             
             //TEST BORRAR
             AudioTool *tool = (AudioTool *)[self.audioToolsDict objectForKey:self.narrativeNumberKey];
             [tool play];
             
             
             //Get Audio Dict from array
             NSDictionary *audioDict = nil;
             
             for (id obj in actionsArray) {
             
                 for (id obj2 in obj) {
                     if ([obj2 isKindOfClass:[NSDictionary class]]) {
                         
                         audioDict = [obj2 objectForKey:kSound];
                         
                         if(audioDict) {
                             
                             //Hago un diccionario con el hash del audioDict, 1º buscamos en el diccionario la key con el has
                             //2º hacemos play
                             //3º si es nil, alloc, insert en el dict y play
                             
                             
                             NSString *descriptionDict = [audioDict description];
                             NSUInteger hash = [descriptionDict hash];
                             
                             NSNumber *numHash = [NSNumber numberWithInteger:hash];
                             
                             AudioTool *tool = (AudioTool *)[self.audioToolsDict objectForKey:numHash];
                             [tool play]; //Si es nil no da error, así no perdemos tiempo en comprobar
                             
                             if(!tool) {
                                 tool = [[AudioTool alloc] initWithDict:audioDict AndProjectId:self.idProject];
                                 [tool play];
                                 [self.audioToolsDict setObject:tool forKey:numHash];
                                 
                                 //Set remain sounds
                                 BOOL remain = [[audioDict objectForKey:kRemainSound] boolValue];
                                 tool.remainAfterExitPage = remain;
                                 
                                 
                             }
                             
                             
                         }
                         
                         
                     }
                 }
                 
             }
             
             
             theView.userInteractionEnabled = userInteractionEnabledFlag;
        
         }];
        
    }
    
   
    
}


#pragma mark  -Load Animators

- (SecuentialAnimator *) loadAnimatorsWithArray: (NSArray *) actions AndView: (UIView *) theView {
    
    
    //Creamos los animators con el diccionario y lo devolvemos
    
    
    //Un Secuential Animator que contiene mínimo...
    
    //Un SimoultaneousAnimatorGroup que contiene mínimo un...
    
    //Simoultaneous Animator
    
    
    NSMutableArray *simAnimatorGroupArray = [NSMutableArray array];
    
    for (NSArray *simulGroup in actions) {
        
        
        NSMutableArray *simulAnimaArray = [NSMutableArray array];
        
        
        //SIMULTANEOUS ANIMATOR
        for (NSDictionary *simulDict in simulGroup) {
            
            NSString *layerKey = [simulDict objectForKey:kLayer];
            
            CALayer *layer = nil;
            
            if([layerKey isEqualToString: kUIViewLayer]){
                
                layer = theView.layer;
                
            }else {
            
                layer = [self.sceneLayers objectForKey:layerKey];
            }
            
            
            
            NSMutableArray *animsKeysArray = [simulDict objectForKey:kAnimsView];
            
            
            
            
            //NSMutableArray *anims = [[self.sceneAnimations objectsForKeys:animsKeysArray notFoundMarker:nil] mutableCopy];
            NSMutableArray *anims = [NSMutableArray array];
            
            for (NSString *key in animsKeysArray) {
                
                id obj = [self.sceneAnimations objectForKey:key];
                
                if(obj){
                    [anims addObject: obj];
                }
            
                
            }
            
            
            
            SimultaneousAnimator *simul = [[SimultaneousAnimator alloc] initWithLayer:layer Animations:anims AndAnimationsKeys:animsKeysArray AndDelegate:nil]; //Define delegate later
            
            if(simul){
                [simulAnimaArray addObject:simul];
            }
            
        }
        
        
        //SIMULTANEOUS GROUP
        SimultaneousAnimatorGroup *simAnimatorGroup = [[SimultaneousAnimatorGroup alloc] initWithSimultaneousAnimatorArray:simulAnimaArray andDelegate:nil]; //Define delegate later
        
        //Define SimoultaneousAniamtor Delegate
        for (SimultaneousAnimator *simAnim in simulAnimaArray) {
            
            simAnim.delegate = simAnimatorGroup;
            
        }
        
        [simAnimatorGroupArray addObject:simAnimatorGroup];
        
        
    }
    
    
    //SECUENTIAL ANIMATOR
    
    SecuentialAnimator *secuentialAnim = [[SecuentialAnimator alloc] initWithSimultaneousAnimatorGroupArray:simAnimatorGroupArray AndView:theView];
    
    //Define SimoultaneousGROUPAnimator delegate
    for (SimultaneousAnimatorGroup *group in simAnimatorGroupArray) {
        
        group.delegate = secuentialAnim;
        
    }
    
    secuentialAnim.delegate = self;
    
    return secuentialAnim;
    
}



#pragma mark - Owner ViewController

-(void) setOwnerView: (UIView *) aView {
    
    if(aView) {
        
        self.mainOwnerView = aView;
        
        for (NSString *keyView in self.sceneViewsKeys) {
            
            UIView *theView = [self.sceneViews objectForKey:keyView];
            if(theView){
                
                [aView addSubview:theView];
                
            }
            
        }
        
        //Load Navigation Pages Utils
        [self loadMetadataNavigationInView: aView];
        
    }
    
}

#pragma mark - SecuentialAnimatorDelegate Method

-(void) didFinishSecuentialAnimator: (SecuentialAnimator *) secAnimator {
    
    secAnimator.theViewAnimated.userInteractionEnabled = YES;
    
}





#pragma mark - Metadata Navigation Methods

//Load Arrows to navigate through the Tale
- (void) loadMetadataNavigationInView: (UIView *) aView {
    
    float porcentajeX = 0.02;
    float porcentajeY = 0.05;
    
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    
    
    //Always asume landscape
    CGRect temp;
    temp.size.width = screenRect.size.height;
    temp.size.height = screenRect.size.width;
    screenRect = temp;

    
    CGFloat screenWidth = screenRect.size.width;
    CGFloat screenHeight = screenRect.size.height;
    
    //Cargamos las flechas en pantalla y les seteamos el Action que harán (performNext y performPrev)
    
    NSString *leftArrowImgStr = [self.metadata objectForKey:kLeftArrow];
    NSString *rightArrowImgStr = [self.metadata objectForKey:kRightArrow];
    NSString *mainImgStr = [self.metadata objectForKey:kMainMenu];
    
    UIImage *leftArrowImg = [UIImage imageNamed:leftArrowImgStr];
    UIImage *rightArrowImg = [UIImage imageNamed:rightArrowImgStr];
    UIImage *mainImg = [UIImage imageNamed:mainImgStr];
    
    if(leftArrowImg) {
        //Position left arrow
        UIButton *leftArrowBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [leftArrowBtn setImage:leftArrowImg forState:UIControlStateNormal];
        leftArrowBtn.showsTouchWhenHighlighted = YES;
        leftArrowBtn.frame = CGRectMake(porcentajeX * screenWidth, screenHeight - (porcentajeY * screenHeight) - leftArrowImg.size.height, leftArrowImg.size.width, leftArrowImg.size.width);
        
        //Selector
        
        NSLog(@"SELF: %@",self);
        
        [leftArrowBtn addTarget:self
                         action:@selector(performPrev)
               forControlEvents:UIControlEventTouchUpInside];
        
        
        [aView addSubview:leftArrowBtn];
    }
    
    if(rightArrowImg) {
        //Position right arrow
        UIButton *rightArrowBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [rightArrowBtn setImage:rightArrowImg forState:UIControlStateNormal];
        rightArrowBtn.showsTouchWhenHighlighted = YES;
        rightArrowBtn.frame = CGRectMake(screenWidth - (porcentajeX * screenWidth) - rightArrowImg.size.width, screenHeight - (porcentajeY * screenHeight) - rightArrowImg.size.height, rightArrowImg.size.width, rightArrowImg.size.width);
        
        //Selector
        [rightArrowBtn addTarget:self
                          action:@selector(performNext)
                forControlEvents:UIControlEventTouchUpInside];
        
        [aView addSubview:rightArrowBtn];
        
    }

    if(mainImg) {
        //Position right arrow
        UIButton *mainBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [mainBtn setImage:mainImg forState:UIControlStateNormal];
        mainBtn.showsTouchWhenHighlighted = YES;
        mainBtn.frame = CGRectMake((porcentajeX * screenWidth), (porcentajeY * screenHeight), mainImg.size.width, mainImg.size.width);
        
        //Selector
        [mainBtn addTarget:self
                          action:@selector(performMainMenu)
                forControlEvents:UIControlEventTouchUpInside];
        
        [aView addSubview:mainBtn];
        
    }
    
}

//Action of the Next Button
-(void) performNext {
    
    [self stopSounds];
    
    //[self performNavigationWithDict:[self.metadata objectForKey: kNextPages] InView:self.mainOwnerView];
    
    [self.delegate performNextPageWithMetadataDict:self.metadata];
}

//Action of the Prev Button
-(void) performPrev {
    
    [self stopSounds];
    
    //[self performNavigationWithDict:[self.metadata objectForKey: kPrevPages] InView:self.mainOwnerView];
    [self.delegate performPrevPageWithMetadataDict:self.metadata];
    
}


-(void) stopSounds {
    
    NSArray *keys = [self.audioToolsDict allKeys];
    
    for (NSString *key in keys) {
        
        AudioTool *tool = [self.audioToolsDict objectForKey:key];
        
        if(!tool.remainAfterExitPage){
            [tool.player stop];
        }
    
        
    }
    
}

-(void) performMainMenu {
    
    [self.delegate manageMainButton];
}


@end
