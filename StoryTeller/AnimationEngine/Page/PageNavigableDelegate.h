//
//  PageNavigableDelegate.h
//  StoryTeller
//
//  Created by Héctor Rodríguez Forniés on 08/01/13.
//
//

#import <Foundation/Foundation.h>

@protocol PageNavigableDelegate <NSObject>


//Method to implements that is called when the previus button is taped
-(void) performNextPageWithMetadataDict: (NSDictionary *) theMetaData;

//Method to implements that is called when the next button is taped
-(void) performPrevPageWithMetadataDict: (NSDictionary *) theMetaData;

//Method to implements that is called when the Main button is taped
-(void) manageMainButton;

@end
