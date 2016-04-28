//
//  CutVideoViewController.h
//  VideoCropDemo
//
//  Created by dev7-59 on 16/4/26.
//  Copyright © 2016年 wanpeng. All rights reserved.
//

#import "CommonVideoViewController.h"
#import <MediaPlayer/MediaPlayer.h>
#import <AVFoundation/AVFoundation.h>
#import <MobileCoreServices/UTCoreTypes.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "SAVideoRangeSlider.h"
#import "CropViewModel.h"
#define ScreenWidth [UIScreen mainScreen].bounds.size.width
#define ScreenHeight [UIScreen mainScreen].bounds.size.height
@interface CutVideoViewController : CommonVideoViewController

@end
