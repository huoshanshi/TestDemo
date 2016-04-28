//
//  CommonVideoViewController.h
//  VideoEditingPart2
//
//  Created by Abdul Azeem Khan on 1/24/13.
//  Copyright (c) 2013 com.datainvent. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MobileCoreServices/UTCoreTypes.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <AVFoundation/AVFoundation.h>

@interface CommonVideoViewController : UIViewController 

//@property(nonatomic, strong) AVAsset *videoAsset;


- (void)exportDidFinish:(AVAssetExportSession*)session;

- (void)applyVideoEffectsToComposition:(AVMutableVideoComposition *)composition size:(CGSize)size subtitle:(NSString *)str;
//视频剪切
- (void)videoOutputWith:(CMTimeRange)cr videoAsset:(AVAsset *)asset;
//获取第一帧视频
-(UIImage *)getImage:(NSURL*)videoURL;
//视频合并
-(void)videoCombineOutputWith:(NSURL *)videoUrl1 videoUrl:(NSURL *)videoUrl2;
//视频插入
-(void)insertVideoOutputWith:(NSURL *)videoUrl1 videoUrl:(NSURL *)videoUrl2 currentTime:(Float64)currentTime;


@end
