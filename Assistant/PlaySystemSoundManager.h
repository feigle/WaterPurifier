//
//  PlaySystemSoundManager.h
//  VideoMonitor
//
//  Created by Joblee on 14-9-18.
//  Copyright (c) 2014年 Andy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AudioToolbox/AudioToolbox.h>
@interface PlaySystemSoundManager : NSObject
+(PlaySystemSoundManager*)sharePlaySound;
-(void)playSoundWithSoundName:(NSString*)soundName;
@end
