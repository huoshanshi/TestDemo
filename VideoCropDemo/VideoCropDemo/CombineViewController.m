//
//  CombineViewController.m
//  VideoCropDemo
//
//  Created by dev7-59 on 16/4/26.
//  Copyright © 2016年 wanpeng. All rights reserved.
//

#import "CombineViewController.h"
#import <MediaPlayer/MediaPlayer.h>
#import <SVProgressHUD.h>

@interface CombineViewController ()<UIImagePickerControllerDelegate,UINavigationBarDelegate>
@property (weak, nonatomic) IBOutlet UIButton *addVideo1Btn;
@property (weak, nonatomic) IBOutlet UIButton *addVideo2Btn;
@property (weak, nonatomic) IBOutlet UILabel *durationLab1;
@property (weak, nonatomic) IBOutlet UILabel *durationLab2;
@property (weak, nonatomic) IBOutlet UILabel *timeLab;
@property (nonatomic,assign)BOOL isFirst;
@property (nonatomic,strong)NSURL *videoUrl1;
@property (nonatomic,strong)NSURL *videoUrl2;
@property (nonatomic,strong)MPMoviePlayerController *pc;
@property (nonatomic,strong)AVURLAsset *videoAsset;
@property (nonatomic,assign)Float64  totalTime;
@property (nonatomic,assign)Float64  currentTime;
@end

@implementation CombineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title=@"视频合并";
    
}
- (IBAction)valueChangedClick:(UISlider *)sender {
    
    
    _currentTime=sender.value*_totalTime;
    _timeLab.text=[NSString stringWithFormat:@"把视频2插入在视频1第%f秒的位置",_currentTime];
    
    
    
    
    
    
    
}
- (IBAction)addVideo1:(id)sender {
    _isFirst=YES;
    UIButton *btn =(UIButton *)sender;
    if ([btn.titleLabel.text isEqualToString: @"添加一个视频"]) {
        [self presentAlbumControllelr];
    }
    
    if ([btn.titleLabel.text isEqualToString: @"播放"]) {
        [self playVideoUrl:_videoUrl1];
    }
}

- (IBAction)addVideo2:(id)sender {
    
    _isFirst=NO;
    
    UIButton *btn =(UIButton *)sender;
    
    if ([btn.titleLabel.text isEqualToString: @"添加一个视频"]) {
        [self presentAlbumControllelr];
    }
    if ([btn.titleLabel.text isEqualToString: @"播放"]) {
        
        
         [self playVideoUrl:_videoUrl2];
        
        
    }
    
    
}

- (IBAction)insertVideoBtnClick:(id)sender {
    
    
    if (_videoUrl1!=nil&&_videoUrl2!=nil) {
        
        
        [self insertVideoOutputWith:_videoUrl1 videoUrl:_videoUrl2 currentTime:_currentTime];
        
        
        
        
    }else{
        
        
        [SVProgressHUD showErrorWithStatus:@"现在不能进行插入"];
        
        
    }

    
    
    
    
    
    
    
}


-(void)playVideoUrl:(NSURL *)url{
    
    if (_pc == nil) {
        
        _pc=[[MPMoviePlayerController alloc]initWithContentURL:url];
        _pc.shouldAutoplay = YES;
        
        [_pc setControlStyle:MPMovieControlStyleDefault];
        [_pc.view setFrame:CGRectMake(600,64, 400, 300)];
        [self.view addSubview:_pc.view];
        
        [_pc  prepareToPlay];
        
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(movieFinishedCallBack:) name:MPMoviePlayerPlaybackDidFinishNotification object:nil];
        
    }
    

     
    
    

    
    
    
}
-(void)movieFinishedCallBack:(NSNotification*)noti{
    
    [_pc .view removeFromSuperview];
     _pc=nil;
    
    
    
    
    
    
}
- (IBAction)deleteVideo1:(id)sender {
    
    [self deleteStateChange:_addVideo1Btn isfirst:1];
    
    
}

- (IBAction)deleteVideo2:(id)sender {
    
     [self deleteStateChange:_addVideo2Btn isfirst:2];
    
    
}

- (IBAction)combineVideo:(id)sender {
    
    
    
    if (_videoUrl1!=nil&&_videoUrl2!=nil) {
        
        
        [self videoCombineOutputWith:_videoUrl1 videoUrl:_videoUrl2];
        
        
        
        
        
        
    }else{
        
        
        [SVProgressHUD showErrorWithStatus:@"现在不能进行合并"];
        
    
    }
    
}
-(void)presentAlbumControllelr{
    
    UIImagePickerController *mediaUI = [[UIImagePickerController alloc] init];
    mediaUI.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    mediaUI.mediaTypes = [[NSArray alloc] initWithObjects: (NSString *) kUTTypeMovie, nil];
    mediaUI.allowsEditing = YES;
    
    mediaUI.delegate = self;
    
   [self presentViewController:mediaUI animated:YES completion:nil];
    
    
    
    
    
}

#pragma mark  --------相册代理
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    _videoAsset=nil;
    NSString *mediaType = [info objectForKey: UIImagePickerControllerMediaType];
    [self dismissViewControllerAnimated:YES completion:nil];
    if (CFStringCompare ((__bridge_retained CFStringRef) mediaType, kUTTypeMovie, 0) == kCFCompareEqualTo) {
        
        if (_isFirst) {
            
             _videoUrl1 =[info objectForKey:UIImagePickerControllerMediaURL];
            [self btnStateChange:_addVideo1Btn videoUrl:_videoUrl1 durationLab:_durationLab1];
            
            

        }else{
            
            _videoUrl2 =[info objectForKey:UIImagePickerControllerMediaURL];
            
           [self btnStateChange:_addVideo2Btn videoUrl:_videoUrl2 durationLab:_durationLab2];
    }
    }
}
-(void)btnStateChange:(UIButton*)btn videoUrl:(NSURL*)url durationLab:(UILabel *)lab{
    
    if (_videoAsset==nil) {
        _videoAsset=[AVURLAsset URLAssetWithURL:url options:[NSDictionary dictionaryWithObject:[NSNumber numberWithBool:YES] forKey:AVURLAssetPreferPreciseDurationAndTimingKey]];
    }
    
    if (url==_videoUrl1) {
        
        _totalTime=CMTimeGetSeconds(_videoAsset.duration);
    }
    
    [btn setBackgroundImage:[self getImage:url] forState:UIControlStateNormal];
    
    [btn setTitle:@"播放" forState:UIControlStateNormal];
    
    lab.text=[NSString stringWithFormat:@"%fs",CMTimeGetSeconds(_videoAsset.duration)];
    
    
}


-(void)deleteStateChange:(UIButton *)btn isfirst:(int)isfirst{
    
    [btn setBackgroundImage:nil forState:UIControlStateNormal];
    
    [btn setTitle:@"添加一个视频" forState:UIControlStateNormal];
    
    [_pc .view removeFromSuperview];
    _pc=nil;
    _videoAsset=nil;
    
    
    
    if (isfirst==1) {
        _videoUrl1=nil;
        _durationLab1.text=@"0s";
    }
    
    if (isfirst==2) {
        _videoUrl2=nil;
        _durationLab2.text=@"0s";
    }
    
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
