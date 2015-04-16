//
//  PlaySystemSoundManager.m
//  VideoMonitor
//
//  Created by Joblee on 14-9-18.
//  Copyright (c) 2014年 Andy. All rights reserved.
//

#import "PlaySystemSoundManager.h"
static PlaySystemSoundManager *_playSound = nil;
@implementation PlaySystemSoundManager
+(PlaySystemSoundManager*)sharePlaySound
{
    @synchronized(self){
        if (_playSound == nil) {
            _playSound = [[PlaySystemSoundManager alloc]init];
        }
    }
    return _playSound;
}
/**
 *  @brief 播放声音
 *
 *  @param soundName 音频名称
 */
-(void)playSoundWithSoundName:(NSString*)soundName
{
    SystemSoundID sound;
    NSString *path = [NSString stringWithFormat:@"/System/Library/Audio/UISounds/%@",soundName];//三全音
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)[NSURL fileURLWithPath:path],&sound);
    AudioServicesPlaySystemSound(sound);
}
@end
