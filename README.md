# Storyteller
Storyteller is a JSON to CoreAnimation conversion library that you could use to create awesome tales 

<img src="http://i.giphy.com/3xz2BzhsHzBOKsFWi4.gif"/>

Víctor Jimémez from <a href="https://www.youtube.com/user/pasacotv">PasaCo TV!</a> is working in an awesome tale. You could see his work <a href="https://github.com/capitangolo/HRFStoryteller_Examples">here</a>.

<img src="http://i.giphy.com/3xz2BQfZe2UMFQCEXC.gif" width="480px"/>

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
### Page delegate methods

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
## JSON Sample

```json
 [
  {"narrative" : {
        "repeat" : 0,
        "file" : "hello.mp3"
        },
  "leftArrow" : "left.png",
  "rightArrow" : "right.png",
  "mainMenu" : "up.png",
  "nextPages": [
                {
                "idPage" : "simple",
                "image" : "right.png"
                }
                ],
  "prevPages": [
                {
                "idPage" : "simple",
                "image" : "left.png"
                }
                ]
  },
  {
  "id_view" : "fondo1",
  "bounds": [0, 0, 1024, 768],
  "position": [1024, 768],
  "anchorPoint" : [1, 1],
  "image" : "fondo1.png"
  },
  {
  "id_view" : "ritcherView",
  "bounds": [0, 0, 46, 47],
  "position": [80, 90],
  "anchorPoint" : [0, 0],
  "layers" : [
              {
              "id_layer" : "richter",
              "layerType" : "sprite",
              "bounds" : [0, 0, 46, 47],
              "fixedSize" : [46, 47],
              "position" : [0, 0],
              "opacity" : 1,
              "anchorPoint" : [0.5, 0.5],
              "image" : "Richter.png"
              }
              ],
  "animations" : [
                  {
                  "id_animation" : "alpha_fondo",
                  "keyPath" : "opacity",
                  "fromValue" : {
                  "type" : "number",
                  "value" : 1.0
                  },
                  "toValue" : {
                  "type" : "number",
                  "value" : 0.1
                  },
                  "duration" : 5
                  },
                  {
                  "id_animation" : "sprites_anim",
                  "keyPath" : "sampleIndex",
                  "fromValue" : {
                  "type" : "number",
                  "value" : 1
                  },
                  "toValue" : {
                  "type" : "number",
                  "value" : 9
                  },
                  "duration" : 0.75,
                  "repeatCount" : 1
                  },
                  {
                  "id_animation" : "mover_richter",
                  "keyPath" : "transform.translation.x",
                  "fromValue" : {
                  "type" : "number",
                  "value" : 0
                  },
                  "toValue" : {
                  "type" : "number",
                  "value" : 1000
                  },
                  "duration" : 6,
                  "autoreverses" : "YES",
                  "repeatCount" : "INFINITY",
                  "timingFunction" : "EaseInEaseOut",
                  "removedOnCompletion" : "NO"
                  },
                  {
                  "id_animation" : "circle_anim",
                  "path" : "circle_path",
                  "keyPath" : "position",
                  "center" : [400, 400],
                  "radius" : 300,
                  "startRadians" : 0,
                  "finishRadians" : 2,
                  "clock" : "YES",
                  "duration" : 6,
                  "repeatCount" : 5,
                  "rotationMode" : "kCAAnimationRotateAuto",
                  "calculationMode" : "kCAAnimationPaced"
                  }
                  ],
  "actions" : {
  "tap" :
  [ {"userInteractionEnabled" : "YES"},
   [
    {
    "layer": "richter",
    "anims" : ["sprites_anim"]
    }
    ]
   ]
  }
  },
  {
  "id_view" : "ola1",
  "bounds": [0, 0, 1562, 361],
  "position": [0, 598],
  "opacity" : 1,
  "anchorPoint" : [0, 0],
  "image" : "olas1_2.png",
  "layers" :[],
  "animations" : [
                  {
                  "id_animation" : "mover_ola_1",
                  "keyPath" : "transform.translation.x",
                  "fromValue" : {
                  "type" : "number",
                  "value" : 0
                  },
                  "toValue" : {
                  "type" : "number",
                  "value" : -265
                  },
                  "duration" : 3,
                  "autoreverses" : "YES",
                  "repeatCount" : "INFINITY",
                  "timingFunction" : "EaseInEaseOut",
                  "removedOnCompletion" : "NO"
                  }
                  ],
  "actions" : {
  "inTime" :
  [     0.5,
   [
    {
    "layer": "__all_layers_composition__",
    "anims" : ["mover_ola_1"]
    }
    ]
   ]
  }
  },
  {
  "id_view" : "barco",
  "bounds": [0, 0, 509, 479],
  "position": [300, 230],
  "opacity" : 1,
  "anchorPoint" : [0, 0],
  "image" : "barco_3.png",
  "layers" :[],
  "animations" : [
                  {
                  "id_animation" : "mover_barco_x",
                  "keyPath" : "transform.translation.x",
                  "fromValue" : {
                  "type" : "number",
                  "value" : 0
                  },
                  "toValue" : {
                  "type" : "number",
                  "value" : -150
                  },
                  "duration" : 3,
                  "autoreverses" : "YES",
                  "repeatCount" : "INFINITY",
                  "timingFunction" : "EaseInEaseOut",
                  "removedOnCompletion" : "NO"
                  }
                  ],
  "actions" : {
  "inTime" :
  [     0.5,
   [
    {
    "layer": "__all_layers_composition__",
    "anims" : ["mover_barco_x"]
    }
    ]
   ]
  }
  },
  {
  "id_view" : "marino",
  "bounds": [0, 0, 140, 228],
  "position": [461, 339],
  "opacity" : 1,
  "anchorPoint" : [0, 0],
  "image" : "marinero.png",
  "layers" :[{
             "id_layer" : "brazo_layer",
             "bounds" : [0, 0, 116, 127],
             "position" : [120, 160],
             "opacity" : 1,
             "anchorPoint" : [0, 1],
             "image" : "brazo.png"
             },
             {
             "id_layer" : "gorro_layer",
             "bounds" : [0, 0, 110, 74],
             "position" : [0, 25],
             "opacity" : 1,
             "anchorPoint" : [0, 1],
             "image" : "gorro.png"
             }],
  "animations" : [
                  {
                  "id_animation" : "mover_brazo",
                  "keyPath" : "transform.rotation.z",
                  "fromValue" : {
                  "type" : "number",
                  "value" : 0
                  },
                  "toValue" : {
                  "type" : "number",
                  "value" : -0.8
                  },
                  "duration" : 0.5,
                  "autoreverses" : "YES",
                  "repeatCount" : 2,
                  "timingFunction" : "",
                  "removedOnCompletion" : "NO"
                  },
                  {
                  "id_animation" : "mover_marino",
                  "keyPath" : "transform.translation.x",
                  "fromValue" : {
                  "type" : "number",
                  "value" : 0
                  },
                  "toValue" : {
                  "type" : "number",
                  "value" : -150
                  },
                  "duration" : 3,
                  "autoreverses" : "YES",
                  "repeatCount" : "INFINITY",
                  "timingFunction" : "EaseInEaseOut",
                  "removedOnCompletion" : "NO"
                  },
                  {
                  "id_animation" : "mover_gorro",
                  "keyPath" : "transform.translation.y",
                  "fromValue" : {
                  "type" : "number",
                  "value" : 0
                  },
                  "toValue" : {
                  "type" : "number",
                  "value" : -200
                  },
                  "duration" : 0.5,
                  "autoreverses" : "YES",
                  "repeatCount" : 1,
                  "timingFunction" : "",
                  "removedOnCompletion" : "NO"
                  }
                  ],
  "actions" : {
  "inTime" :
  [ 0.5, {"userInteractionEnabled" : "YES"},
   [
    {
    "layer": "__all_layers_composition__",
    "anims" : ["mover_marino"]
    }
    ]
   ],
  "tap" :
  [
   [
    {
    "layer": "brazo_layer",
    "anims" : ["mover_brazo"],
    "sound" : {"repeat" : 0, "file" : "bell.mp3"}
    },
    {
    "layer": "gorro_layer",
    "anims" : ["mover_gorro"],
    "sound" : {"repeat" : 0, "file" : "bell.mp3"}
    }
    ]
   ]
  }
  },
  {
  "id_view" : "ola2",
  "bounds": [0, 0, 1375, 352],
  "position": [-352, 630],
  "opacity" : 1,
  "anchorPoint" : [0, 0],
  "image" : "olas2_4.png",
  "layers" :[],
  "animations" : [
                  {
                  "id_animation" : "mover_ola_2",
                  "keyPath" : "transform.translation.x",
                  "fromValue" : {
                  "type" : "number",
                  "value" : 0
                  },
                  "toValue" : {
                  "type" : "number",
                  "value" : 320
                  },
                  "duration" : 3,
                  "autoreverses" : "YES",
                  "repeatCount" : "INFINITY",
                  "timingFunction" : "EaseInEaseOut",
                  "removedOnCompletion" : "NO"
                  }
                  ],
  "actions" : {
  "inTime" :
  [     0.5,
   [
    {
    "layer": "__all_layers_composition__",
    "anims" : ["mover_ola_2"]
    }
    ]
   ]
  }
  },
  {
  "id_view" : "star",
  "dragable" : "YES",
  "bounds": [0, 0, 124, 120],
  "position": [58, 368],
  "opacity" : 1,
  "anchorPoint" : [0.5, 0.5],
  "image" : "star.png",
  "layers" :[],
  "animations" : [
                  {
                  "id_animation" : "star-anim-x",
                  "keyPath" : "transform.translation.x",
                  "fromValue" : {
                  "type" : "number",
                  "value" : 0
                  },
                  "toValue" : {
                  "type" : "number",
                  "value" : 320
                  },
                  "duration" : 3,
                  "autoreverses" : "NO",
                  "repeatCount" : 1,
                  "timingFunction" : "EaseInEaseOut",
                  "removedOnCompletion" : "NO",
                  "fillMode" : "Backwards"
                  },
                  {
                  "id_animation" : "star-anim-y",
                  "keyPath" : "transform.translation.y",
                  "fromValue" : {
                  "type" : "number",
                  "value" : 0
                  },
                  "toValue" : {
                  "type" : "number",
                  "value" : 20
                  },
                  "duration" : 3,
                  "autoreverses" : "NO",
                  "repeatCount" : 1,
                  "timingFunction" : "EaseInEaseOut",
                  "removedOnCompletion" : "NO",
                  "fillMode" : "Backwards"
                  },
                  {
                  "id_animation" : "star-rotate",
                  "keyPath" : "transform.rotation.z",
                  "fromValue" : {
                  "type" : "number",
                  "value" : 1.0
                  },
                  "toValue" : {
                  "type" : "number",
                  "value" : 10.0
                  },
                  "duration" : 3,
                  "autoreverses" : "NO",
                  "repeatCount" : 0,
                  "timingFunction" : "EaseInEaseOut",
                  "removedOnCompletion" : "NO",
                  "fillMode" : "Backwards"
                  },
                  {
                  "id_animation" : "alpha_star",
                  "keyPath" : "opacity",
                  "fromValue" : {
                  "type" : "number",
                  "value" : 1.0
                  },
                  "toValue" : {
                  "type" : "number",
                  "value" : 0.1
                  },
                  "duration" : 3,
                  "removedOnCompletion" : "NO",
                  "fillMode" : "Backwards"
                  },
                  {
                  "id_animation" : "star_scale",
                  "keyPath" : "transform.scale",
                  "fromValue" : {
                  "type" : "number",
                  "value" : 1.0
                  },
                  "toValue" : {
                  "type" : "number",
                  "value" : 0.1
                  },
                  "duration" : 3,
                  "removedOnCompletion" : "NO",
                  "fillMode" : "Backwards"
                  },
                  {
                  "id_animation" : "alpha_star_constant",
                  "keyPath" : "opacity",
                  "fromValue" : {
                  "type" : "number",
                  "value" : 1.0
                  },
                  "toValue" : {
                  "type" : "number",
                  "value" : 0.2
                  },
                  "autoreverses" : "YES",
                  "duration" : 1,
                  "repeatCount" : "INFINITY"
                  }
                  ],
  
  "actions" : {
  "inTime" : [0, {"userInteractionEnabled" : "YES"},
              [{
               "layer": "__all_layers_composition__",
               "anims" : ["alpha_star_constant"]
               }]],
  "tap" :
  [
   [
    {
        "layer": "__all_layers_composition__",
        "anims" : ["star-anim-x", "star-anim-y", "star-rotate", "alpha_star", "star_scale"],
        "sound" : {"repeat" : 1, "file" : "bell.mp3"}
    }
    ]
   ]
  }
  }
  
  
  ]
```
