//
//  CommonVideoViewController.m
//  VideoEditingPart2
//
//  Created by Abdul Azeem Khan on 1/24/13.
//  Copyright (c) 2013 com.datainvent. All rights reserved.
//

#import "CommonVideoViewController.h"
#import <SVProgressHUD.h>
@interface CommonVideoViewController ()

@end

@implementation CommonVideoViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        // Custom initialization
    }
    return self;
}


- (void)applyVideoEffectsToComposition:(AVMutableVideoComposition *)composition size:(CGSize)size subtitle:(NSString *)str
{
  // no-op - override this method in the subclass
    
}

//视频剪切
- (void)videoOutputWith:(CMTimeRange)cr videoAsset:(AVAsset *)asset
{
  // 1 - Early exit if there's no video file selected
  if (!asset) {
      
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Please Load a Video Asset First" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
    return;
      
  }

   // 2 - Create AVMutableComposition object. This object will hold your AVMutableCompositionTrack instances.
    
   AVMutableComposition *mixComposition = [[AVMutableComposition alloc] init];

  // 3 - Video track
    
   AVMutableCompositionTrack *videoTrack = [mixComposition addMutableTrackWithMediaType:AVMediaTypeVideo preferredTrackID:kCMPersistentTrackID_Invalid];
    [videoTrack insertTimeRange:cr ofTrack:[[asset tracksWithMediaType:AVMediaTypeVideo] objectAtIndex:0] atTime:kCMTimeZero error:nil];
    
    AVMutableCompositionTrack *AudioTrack = [mixComposition addMutableTrackWithMediaType:AVMediaTypeAudio preferredTrackID:kCMPersistentTrackID_Invalid];
    [AudioTrack insertTimeRange:cr ofTrack:[[asset tracksWithMediaType:AVMediaTypeAudio] objectAtIndex:0] atTime:kCMTimeZero error:nil];
  // 3.1 - Create AVMutableVideoCompositionInstruction
  AVMutableVideoCompositionInstruction *mainInstruction = [AVMutableVideoCompositionInstruction videoCompositionInstruction];
   
   CMTimeRange timeRange=CMTimeRangeMake(kCMTimeZero, asset.duration);
    
    mainInstruction.timeRange = timeRange;
    
  // 3.2 - Create an AVMutableVideoCompositionLayerInstruction for the video track and fix the orientation.
    
  AVMutableVideoCompositionLayerInstruction *videolayerInstruction = [AVMutableVideoCompositionLayerInstruction videoCompositionLayerInstructionWithAssetTrack:videoTrack];
  AVAssetTrack *videoAssetTrack = [[asset tracksWithMediaType:AVMediaTypeVideo] objectAtIndex:0];
    
  UIImageOrientation videoAssetOrientation_  = UIImageOrientationUp;
    
  BOOL isVideoAssetPortrait_  = NO;
  CGAffineTransform videoTransform = videoAssetTrack.preferredTransform;
  if (videoTransform.a == 0 && videoTransform.b == 1.0 && videoTransform.c == -1.0 && videoTransform.d == 0) {
    videoAssetOrientation_ = UIImageOrientationRight;
    isVideoAssetPortrait_ = YES;
  }
  if (videoTransform.a == 0 && videoTransform.b == -1.0 && videoTransform.c == 1.0 && videoTransform.d == 0) {
    videoAssetOrientation_ =  UIImageOrientationLeft;
    isVideoAssetPortrait_ = YES;
  }
  if (videoTransform.a == 1.0 && videoTransform.b == 0 && videoTransform.c == 0 && videoTransform.d == 1.0) {
    videoAssetOrientation_ =  UIImageOrientationUp;
  }
  if (videoTransform.a == -1.0 && videoTransform.b == 0 && videoTransform.c == 0 && videoTransform.d == -1.0) {
    videoAssetOrientation_ = UIImageOrientationDown;
  }
    
    
  [videolayerInstruction setTransform:videoAssetTrack.preferredTransform atTime:cr.start];
    
    
    
    
  [videolayerInstruction setOpacity:0.0 atTime:cr.duration];

    
    
  // 3.3 - Add instructions
    
  mainInstruction.layerInstructions = [NSArray arrayWithObjects:videolayerInstruction,nil];

  AVMutableVideoComposition *mainCompositionInst = [AVMutableVideoComposition videoComposition];

  CGSize naturalSize;
    
  if(isVideoAssetPortrait_){
    naturalSize = CGSizeMake(videoAssetTrack.naturalSize.height, videoAssetTrack.naturalSize.width);
  } else {
    naturalSize = videoAssetTrack.naturalSize;
  }

  float renderWidth, renderHeight;
  renderWidth = naturalSize.width;
  renderHeight = naturalSize.height;
  mainCompositionInst.renderSize = CGSizeMake(renderWidth, renderHeight);
  mainCompositionInst.instructions = [NSArray arrayWithObject:mainInstruction];
  mainCompositionInst.frameDuration = CMTimeMake(1, 30);
    

 // [self applyVideoEffectsToComposition:mainCompositionInst size:naturalSize subtitle:str];
  
  // 4 - Get path
    NSURL *url = [self getUrl];
  // 5 - Create exporter
   AVAssetExportSession *exporter = [[AVAssetExportSession alloc] initWithAsset:mixComposition
                                                                    presetName:AVAssetExportPresetHighestQuality];
  exporter.outputURL=url;
  exporter.outputFileType = AVFileTypeQuickTimeMovie;
  exporter.shouldOptimizeForNetworkUse = YES;
  exporter.videoComposition = mainCompositionInst;
  [exporter exportAsynchronouslyWithCompletionHandler:^{
    dispatch_async(dispatch_get_main_queue(), ^{
      [self exportDidFinish:exporter];
    });
  }];
}

- (void)exportDidFinish:(AVAssetExportSession*)session {
  if (session.status == AVAssetExportSessionStatusCompleted) {
    NSURL *outputURL = session.outputURL;
    ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
    if ([library videoAtPathIsCompatibleWithSavedPhotosAlbum:outputURL]) {
      [library writeVideoAtPathToSavedPhotosAlbum:outputURL completionBlock:^(NSURL *assetURL, NSError *error){
        dispatch_async(dispatch_get_main_queue(), ^{
            
          if (error) {
           
              [SVProgressHUD showErrorWithStatus:@"存储到相册失败"];
              
              
          } else {
              
              
              [SVProgressHUD showSuccessWithStatus:@"存储到相册成功 "];
              
            
          }
        });
      }];
    }
  }
}
-(NSURL *)getUrl{
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *myPathDocs =  [documentsDirectory stringByAppendingPathComponent:
                             [NSString stringWithFormat:@"FinalVideo-%d.mov",arc4random() % 1000]];
    NSURL *url = [NSURL fileURLWithPath:myPathDocs];
    
    return url;
    
    
}
//视频合并
-(void)videoCombineOutputWith:(NSURL *)videoUrl1 videoUrl:(NSURL *)videoUrl2{
    
    
    //创建存放媒体资源的容器
    AVMutableComposition *mixComposition = [[AVMutableComposition alloc] init];
    //创建存放视频的轨道
     AVMutableCompositionTrack *videoTrack = [mixComposition addMutableTrackWithMediaType:AVMediaTypeVideo preferredTrackID:kCMPersistentTrackID_Invalid];
    //创建存放音频的轨道
    AVMutableCompositionTrack *AudioTrack = [mixComposition addMutableTrackWithMediaType:AVMediaTypeAudio preferredTrackID:kCMPersistentTrackID_Invalid];

    
    NSDictionary *opts = [NSDictionary dictionaryWithObject:[NSNumber numberWithBool:YES] forKey:AVURLAssetPreferPreciseDurationAndTimingKey];
    //创建包含视频和音频的容器
    AVURLAsset * asset1 = [AVURLAsset URLAssetWithURL:videoUrl1 options:opts];
    //截取一段视频并把这段视频加在视频轨道的特定的位置
    [videoTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, asset1.duration) ofTrack:[[asset1 tracksWithMediaType:AVMediaTypeVideo] objectAtIndex:0] atTime:kCMTimeZero error:nil];
    [AudioTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, asset1.duration) ofTrack:[[asset1 tracksWithMediaType:AVMediaTypeAudio] objectAtIndex:0] atTime:kCMTimeZero error:nil];
    
    AVURLAsset * asset2 = [AVURLAsset URLAssetWithURL:videoUrl2 options:opts];
   
    [videoTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, asset2.duration) ofTrack:[[asset2 tracksWithMediaType:AVMediaTypeVideo] objectAtIndex:0] atTime: CMTimeAdd(kCMTimeZero, asset1.duration) error:nil];
    [AudioTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, asset2.duration) ofTrack:[[asset2 tracksWithMediaType:AVMediaTypeAudio] objectAtIndex:0] atTime: CMTimeAdd(kCMTimeZero, asset1.duration) error:nil];
    
    NSURL *url = [self getUrl];
    
    
 
    AVAssetExportSession *exporter = [[AVAssetExportSession alloc] initWithAsset:mixComposition presetName:AVAssetExportPresetHighestQuality];
    exporter.outputURL=url;
    exporter.outputFileType = AVFileTypeQuickTimeMovie;
    exporter.shouldOptimizeForNetworkUse = YES;
    [exporter exportAsynchronouslyWithCompletionHandler:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"完成MIX");
           [self exportDidFinish:exporter];
            
        });
    }];
}
//获取视频的第一帧
-(UIImage *)getImage:(NSURL *)videoURL

{
    AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:videoURL options:nil];
    
    AVAssetImageGenerator *gen = [[AVAssetImageGenerator alloc] initWithAsset:asset];
    
    gen.appliesPreferredTrackTransform = YES;
    
    CMTime time = CMTimeMakeWithSeconds(1, 60);
    
    NSError *error = nil;
    
    CMTime actualTime;
    
    CGImageRef image = [gen copyCGImageAtTime:time actualTime:&actualTime error:&error];
    
    UIImage *thumb = [[UIImage alloc] initWithCGImage:image];
    
    CGImageRelease(image);
    
    return thumb;
    
}
//视频插入
-(void)insertVideoOutputWith:(NSURL *)videoUrl1 videoUrl:(NSURL *)videoUrl2 currentTime:(Float64)currentTime
{
    CMTime ct=CMTimeMake(currentTime, 1);
    //创建存放媒体资源的容器
    AVMutableComposition *mixComposition = [[AVMutableComposition alloc] init];
    //创建存放视频的轨道
    AVMutableCompositionTrack *AudioTrack = [mixComposition addMutableTrackWithMediaType:AVMediaTypeAudio preferredTrackID:kCMPersistentTrackID_Invalid];
    //创建存放音频的轨道
    AVMutableCompositionTrack *videoTrack = [mixComposition addMutableTrackWithMediaType:AVMediaTypeVideo preferredTrackID:kCMPersistentTrackID_Invalid];
    
    NSDictionary *opts = [NSDictionary dictionaryWithObject:[NSNumber numberWithBool:YES] forKey:AVURLAssetPreferPreciseDurationAndTimingKey];
    //创建包含视频和音频的容器
    AVURLAsset * asset1 = [AVURLAsset URLAssetWithURL:videoUrl1 options:opts];
    //截取一段视频并把这段视频加在视频轨道的特定的位置
    [videoTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, asset1.duration) ofTrack:[[asset1 tracksWithMediaType:AVMediaTypeVideo] objectAtIndex:0] atTime:kCMTimeZero error:nil];
    [AudioTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, asset1.duration) ofTrack:[[asset1 tracksWithMediaType:AVMediaTypeAudio] objectAtIndex:0] atTime:kCMTimeZero error:nil];
   
    AVURLAsset * asset2 = [AVURLAsset URLAssetWithURL:videoUrl2 options:opts];
    
    [videoTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, asset2.duration) ofTrack:[[asset2 tracksWithMediaType:AVMediaTypeVideo] objectAtIndex:0] atTime: CMTimeAdd(kCMTimeZero, ct) error:nil];
    [AudioTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, asset2.duration) ofTrack:[[asset2 tracksWithMediaType:AVMediaTypeAudio] objectAtIndex:0] atTime: CMTimeAdd(kCMTimeZero, ct) error:nil];
    
    NSURL *url = [self getUrl];
    
    
    
    AVAssetExportSession *exporter = [[AVAssetExportSession alloc] initWithAsset:mixComposition presetName:AVAssetExportPresetHighestQuality];
    exporter.outputURL=url;
    exporter.outputFileType = AVFileTypeQuickTimeMovie;
    exporter.shouldOptimizeForNetworkUse = YES;
    [exporter exportAsynchronouslyWithCompletionHandler:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            
            NSLog(@"完成MIX");
            [self exportDidFinish:exporter];
            
        });
    }];

    
    
    
    
    
    
    
    
    
}
@end
