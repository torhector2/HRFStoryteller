//
//  AudioTool.h
//  StoryTeller
//
//  Created by Héctor Rodríguez Forniés on 17/12/12.
//
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVAudioPlayer.h>

@interface AudioTool : NSObject <AVAudioPlayerDelegate>


@property(nonatomic, strong) AVAudioPlayer *player;

@property(nonatomic) BOOL remainAfterExitPage;

-(id) initWithDict: (NSDictionary *)  theDict AndProjectId: (NSString *) idProject;

-(id) initWithURLStr: (NSString *) theUrlStr AndRepeatCount: (NSNumber *) count AndProject: (NSString *) idProject;

-(void) play;

-(BOOL) playerContainsOptionsInDict: (NSDictionary *) theDict AndProjectId: (NSString *) idProj;

@end
