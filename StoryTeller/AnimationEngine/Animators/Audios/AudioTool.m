//
//  AudioTool.m
//  StoryTeller
//
//  Created by Héctor Rodríguez Forniés on 17/12/12.
//
//

#import "AudioTool.h"
#import "Constants.h"



@interface AudioTool ()

@property(nonatomic, strong) NSString *idProject;
@property(nonatomic, strong) NSString *soundFile;
@property(nonatomic, strong) NSNumber *repeat;

@end

@implementation AudioTool


-(id) initWithURLStr: (NSString *) theUrlStr AndRepeatCount: (NSNumber *) count AndProject: (NSString *) idProject{
    
    if(self = [super init]) {
        
        //Get URL
        NSURL *url = [self getTheUrl:theUrlStr FromProject:idProject];
        NSError *error = nil;
        
        self.player = [[AVAudioPlayer alloc] initWithContentsOfURL: url error:&error];
        
        //Config
        self.player.numberOfLoops = [count intValue];
        self.player.delegate = self;
        
    }
    
    return self;
}

-(id) initWithDict: (NSDictionary *)  theDict AndProjectId: (NSString *) idProject {
    

    if(!theDict) return nil;
    
    NSString *soundFile = [theDict objectForKey:kFile];
    
    NSNumber *repeat = [theDict objectForKey:kRepeat];
    
    
    self.idProject = idProject;
    self.soundFile = soundFile;
    self.repeat = repeat;
    
    return [self initWithURLStr:soundFile AndRepeatCount:repeat AndProject:idProject];
    
}


-(void) play {
    

    [self.player play];
    
    
}



-(NSURL *) getTheUrl: (NSString *) urlStr FromProject:(NSString *) idProject {
    
   
    
    NSString *url = nil;
    
    if(idProject && ![@"" isEqualToString:idProject]){
        url = [NSString stringWithFormat:@"%@_%@", idProject,  NSLocalizedString(urlStr, @"")];
    }else {
        
        url = NSLocalizedString(urlStr, @"");
        
    }
    
    NSURL *theUrl = [[NSBundle mainBundle] URLForResource: url  withExtension:@""];
    
    
    return theUrl;
    
}


-(BOOL) playerContainsOptionsInDict: (NSDictionary *) theDict AndProjectId: (NSString *) idProj{

    if(!theDict) return NO;
    
    NSString *soundFile = [theDict objectForKey:kFile];
    NSNumber *repeat = [theDict objectForKey:kRepeat];
    
    
    return [self playerContainsFile:soundFile ProjectId:idProj AndRepeatCount:[repeat intValue]];
    
}


-(BOOL) playerContainsFile: (NSString *) file ProjectId: (NSString *) projId AndRepeatCount: (int) repeat {
    
    
    BOOL equal = ([self.idProject isEqualToString:projId]) && ([file isEqualToString:self.soundFile]) && (repeat == [self.repeat intValue]);
    
    return equal;
    
    
}


@end
