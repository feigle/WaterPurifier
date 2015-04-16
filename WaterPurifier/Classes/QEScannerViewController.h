//
//  QEScannerViewController.h
//  WaterPurifier
//
//  Created by bjdz on 15-1-27.
//  Copyright (c) 2015年 joblee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@interface QEScannerViewController : UIViewController<AVCaptureMetadataOutputObjectsDelegate,UIAlertViewDelegate,RequestManagerDelegate>
{
    
}
@property (nonatomic) BOOL isReading;
@property (nonatomic, strong) AVAudioPlayer *audioPlayer;

@property (nonatomic, strong) AVCaptureSession *captureSession;
@property (nonatomic, strong) AVCaptureVideoPreviewLayer *videoPreviewLayer;
@property (weak, nonatomic) IBOutlet UILabel *lblStatus;
-(BOOL)startReading;
@end
