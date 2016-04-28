//
//  CutVideoViewController.m
//  VideoCropDemo
//
//  Created by dev7-59 on 16/4/26.
//  Copyright © 2016年 wanpeng. All rights reserved.
//

#import "CutVideoViewController.h"

#import "CombineViewController.h"
@interface CutVideoViewController ()<UIImagePickerControllerDelegate, UINavigationControllerDelegate,SAVideoRangeSliderDelegate>
@property (nonatomic,strong)AVPlayer *player;
@property (nonatomic,strong)AVPlayerItem *playerItem;
@property (nonatomic,strong)UIView        *toolView;
@property (nonatomic,strong)UIView          *backView;
@property (nonatomic,strong)NSURL           *videoUrl;
@property (nonatomic,assign)BOOL            isPlaying;
@property (nonatomic,strong)UIButton        *playBtn;
@property (nonatomic,strong)UIButton        *addMarkerBtn;
@property (nonatomic,strong)UIButton        *cutVideoBtn;
@property (strong, nonatomic) SAVideoRangeSlider *mySAVideoRangeSlider;
@property (nonatomic,strong)NSMutableArray *markerArr;
@property (nonatomic,strong)NSMutableArray *xPointArr;
@property (nonatomic,strong)NSMutableArray *cutTimeArr;
@property(nonatomic, strong)AVAsset *videoAsset;

@property (nonatomic, strong)NSMutableArray *labArr;
@property (nonatomic,strong) UILabel        *durationLab;
@property (nonatomic,strong) UIButton       *combineVideo;


@end

@implementation CutVideoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"视频切分";
    [self.view addSubview:self.backView];
    [self.view addSubview:self.toolView];
    self.markerArr=[NSMutableArray new];
    self.xPointArr=[NSMutableArray new];
    self.labArr=[NSMutableArray new];
}

-(UIView *)backView{
    
    if (_backView==nil) {
        
        _backView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight*0.60f)];
        
        _backView.backgroundColor=[UIColor blackColor];
        
    }
    
    return _backView;
    
}
#pragma mark  --------添加工具View
-(UIView *)toolView{
    
    if (_toolView==nil) {
        _isPlaying=NO;
        _toolView=[[UIView alloc]initWithFrame:CGRectMake(0, ScreenHeight*0.60f, ScreenWidth, ScreenHeight*0.40f)];
        _toolView.backgroundColor=[UIColor grayColor];
        
        UIButton *addVideoBtn=[UIButton buttonWithType:UIButtonTypeSystem];
        addVideoBtn.frame=CGRectMake(20.0f, _toolView.frame.size.height*0.50f, 100, 50);
        addVideoBtn.backgroundColor=[UIColor whiteColor];
        [addVideoBtn setTitle:@"添加视频" forState:UIControlStateNormal];
        [addVideoBtn addTarget:self action:@selector(addVideoBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        _playBtn=[UIButton buttonWithType:UIButtonTypeSystem];
        _playBtn.frame=CGRectMake(140.0f, _toolView.frame.size.height*0.50f, 100, 50);
        _playBtn.backgroundColor=[UIColor purpleColor];
        [_playBtn setTitle:@"播放" forState:UIControlStateNormal];
        [_playBtn addTarget:self action:@selector(playBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        
        _addMarkerBtn=[UIButton buttonWithType:UIButtonTypeSystem];
        _addMarkerBtn.frame=CGRectMake(260.0f, _toolView.frame.size.height*0.50f, 100, 50);
        _addMarkerBtn.backgroundColor=[UIColor redColor];
        [_addMarkerBtn setTitle:@"添加标记区间" forState:UIControlStateNormal];
        [_addMarkerBtn addTarget:self action:@selector(addMarkerBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        _addMarkerBtn.enabled=NO;
        
        _cutVideoBtn=[UIButton buttonWithType:UIButtonTypeSystem];
        _cutVideoBtn.frame=CGRectMake(380.0f, _toolView.frame.size.height*0.50f, 100, 50);
        _cutVideoBtn.backgroundColor=[UIColor whiteColor];
        [_cutVideoBtn setTitle:@"切分视频" forState:UIControlStateNormal];
        [_cutVideoBtn addTarget:self action:@selector(cutVideoBtnClick:) forControlEvents:UIControlEventTouchUpInside];
         _cutVideoBtn.enabled=NO;
        
        UIButton *resetBtn=[UIButton buttonWithType:UIButtonTypeSystem];
        resetBtn.frame=CGRectMake(500.0f, _toolView.frame.size.height*0.50f, 100, 50);
        resetBtn.backgroundColor=[UIColor whiteColor];
        [resetBtn setTitle:@"重置" forState:UIControlStateNormal];
        [resetBtn addTarget:self action:@selector(resetBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        _durationLab=[[UILabel alloc]initWithFrame:CGRectMake(620.0f, _toolView.frame.size.height*0.50f, 200, 50)];
        
        _combineVideo=[UIButton buttonWithType:UIButtonTypeSystem];
        _combineVideo.frame=CGRectMake(300.0f, _toolView.frame.size.height*0.70f, 100, 50);
        _combineVideo.backgroundColor=[UIColor whiteColor];
         [_combineVideo setTitle:@"视频合并" forState:UIControlStateNormal];
        [_combineVideo addTarget:self action:@selector(combineVideoBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        [_toolView addSubview:addVideoBtn];[_toolView addSubview:_playBtn];[_toolView addSubview:_addMarkerBtn];[_toolView addSubview:_cutVideoBtn]; [_toolView addSubview:resetBtn]; [_toolView addSubview:_durationLab];[_toolView addSubview:_combineVideo];
        
    }
    
    return _toolView;
}
-(void)combineVideoBtnClick:(id)sender{
    
    CombineViewController *cvc=[[CombineViewController alloc]init];
    [self.navigationController pushViewController:cvc animated:YES];
    
    
    
    
    
    
    
}
-(void)resetBtnClick:(id)sender{
    
    
    [self resetCutState];
    
    
    
    
    
}








#pragma mark  --------重置剪切状态
-(void)resetCutState{
    
    
    [_markerArr removeAllObjects];
    [_xPointArr removeAllObjects];
    _cutVideoBtn.enabled=NO;
    for (UILabel *lab in _labArr) {
        [lab removeFromSuperview];
    }

    
    
    
}
-(void)playBtnClick:(id)sender{
    
    
    if (_isPlaying==NO) {
        
        [_player play];
        
    }else{
        
        [_player pause];
        
    }
    
    _isPlaying=!_isPlaying;
    [sender setTitle:_isPlaying==NO?@"播放":@"暂停" forState:UIControlStateNormal];
    
}
-(NSMutableArray *)cutTimeArr{
    
    if (_cutTimeArr==nil) {
        _cutTimeArr=[NSMutableArray new];
        
        for (int i=0; i<_markerArr.count; i++) {
            if (i==0) {
                
                CMTimeRange cr=CMTimeRangeMake(CMTimeMakeWithSeconds(0, 30),CMTimeMakeWithSeconds([[_markerArr objectAtIndex:0] floatValue], 30));
                NSValue *crv=[NSValue valueWithCMTimeRange:cr];
                
                [_cutTimeArr addObject:crv];
                
            }else{
                
                CMTimeRange cr=CMTimeRangeMake(CMTimeMakeWithSeconds([[_markerArr objectAtIndex:i-1] floatValue], 30),CMTimeMakeWithSeconds([[_markerArr objectAtIndex:i] floatValue]-[[_markerArr objectAtIndex:i-1] floatValue], 30));
                
                NSValue *crv=[NSValue valueWithCMTimeRange:cr];
                [_cutTimeArr addObject:crv];
            }
            
            
            
        }
        
        
        
        
        
        
        
    }
    return _cutTimeArr;
}
-(AVAsset *)videoAsset{
    
    
    if (_videoAsset==nil) {
        _videoAsset=[AVURLAsset URLAssetWithURL:_videoUrl options:[NSDictionary dictionaryWithObject:[NSNumber numberWithBool:YES] forKey:AVURLAssetPreferPreciseDurationAndTimingKey]];
    }
    
    return _videoAsset;
    
    
}

#pragma mark ---------切分视频
-(void)cutVideoBtnClick:(id)sender{
    
    
    NSLog(@"需要切分视频的数组：%@",_markerArr);
    
    if (_markerArr.count>0) {
                   for (int i=0; i<self.cutTimeArr.count; i++) {
                
                
                NSValue *crv=_cutTimeArr[i];
              
                
                [self videoOutputWith:crv.CMTimeRangeValue videoAsset:self.videoAsset];
                
                
            }

        
            
            UIAlertController *alertController=[UIAlertController alertControllerWithTitle:@"标题" message:@"切分完成" preferredStyle:UIAlertControllerStyleAlert];
       
            UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
                [self resetCutState];
                
                
            }];
            
            
            [alertController addAction:okAction];
            
            
            [self presentViewController:alertController animated:YES completion:nil];
            
            
            
            
            
       
      
        
       
        

    }
    
    
}
#pragma mark ---------添加标记区间
-(void)addMarkerBtnClick:(id)sender{
    
    
    NSLog(@"+++++++++++%@",NSStringFromCGRect(_mySAVideoRangeSlider.leftThumb.frame));
    //NSLog(@"----------%@",NSStringFromCGRect(_mySAVideoRangeSlider.rightThumb.frame));
    if (_mySAVideoRangeSlider.leftPosition==0) {
        return;
    }
    CGFloat left =(float)_mySAVideoRangeSlider.leftPosition;
    _cutVideoBtn.enabled=YES;
    if ([CropViewModel markerIsEffectiveWith:_markerArr leftPoint:left ]) {
        
        [ _markerArr addObject:[NSString stringWithFormat:@"%g",left]];
        UILabel *lab=[[UILabel alloc]initWithFrame:_xPointArr.count>0?CGRectMake([[_xPointArr objectAtIndex:0] floatValue]+2, 0, _mySAVideoRangeSlider.leftThumb.frame.origin.x-[[_xPointArr objectAtIndex:0] floatValue], 70):CGRectMake(2, 0, _mySAVideoRangeSlider.leftThumb.frame.origin.x, 70)];
        
        lab.backgroundColor=[UIColor redColor];
        lab.text=[NSString stringWithFormat:@"第%lu段",(unsigned long)_markerArr.count];
        [_labArr addObject:lab];
        [_mySAVideoRangeSlider.bgView addSubview:lab];
        [_xPointArr removeAllObjects];
        [_xPointArr addObject:[NSString stringWithFormat:@"%g",_mySAVideoRangeSlider.leftThumb.frame.origin.x]];
        
    }
    
    
    
    
    
    
}
-(void)addVideoBtnClick:(id)sender{
    
    [self pausePlayVideo];
    UIImagePickerController *mediaUI = [[UIImagePickerController alloc] init];
    mediaUI.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    mediaUI.mediaTypes = [[NSArray alloc] initWithObjects: (NSString *) kUTTypeMovie, nil];
    mediaUI.allowsEditing = YES;
    mediaUI.delegate = self;
    
    [self presentViewController:mediaUI animated:YES completion:nil];
    
    
    
    
}
//添加AVPlay
-(AVPlayer *)player{
    
    _playerItem = [AVPlayerItem playerItemWithURL:_videoUrl];
    _player = [AVPlayer playerWithPlayerItem:_playerItem];
    AVPlayerLayer *playerLayer = [AVPlayerLayer playerLayerWithPlayer:_player];
    playerLayer.frame = CGRectMake(200, 0, _backView.frame.size.width*0.50f, _backView.frame.size.height);
    playerLayer.videoGravity = AVLayerVideoGravityResize;
    [self.view.layer addSublayer:playerLayer];
    //AVPlayer播放完成通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(moviePlayDidEnd:) name:AVPlayerItemDidPlayToEndTimeNotification object:_player.currentItem];
    
    
    return _player;
}
-(void)pausePlayVideo{
    
    _isPlaying=NO;
    [_playBtn setTitle:@"播放" forState:UIControlStateNormal];
    [_player pause];
    
    
}
-(void)moviePlayDidEnd:(NSNotification *)noti{
    
    
    [self pausePlayVideo];
    
    
    
}
#pragma mark  --------相册代理
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    NSString *mediaType = [info objectForKey: UIImagePickerControllerMediaType];
    [self dismissViewControllerAnimated:YES completion:nil];
    if (CFStringCompare ((__bridge_retained CFStringRef) mediaType, kUTTypeMovie, 0) == kCFCompareEqualTo) {
        self.videoUrl =[info objectForKey:UIImagePickerControllerMediaURL];
        //[self.player play];
        [self.player pause];
        _addMarkerBtn.enabled=YES;
        
        [_markerArr removeAllObjects];
        [_xPointArr removeAllObjects];
        
    }
    if (self.mySAVideoRangeSlider!=nil) {
        [self.mySAVideoRangeSlider removeFromSuperview];
    }
    
    
    self.mySAVideoRangeSlider = [[SAVideoRangeSlider alloc] initWithFrame:CGRectMake(10,60, self.view.frame.size.height-20, 70) videoUrl:_videoUrl ];
    [self.mySAVideoRangeSlider setPopoverBubbleSize:200 height:70];
    self.mySAVideoRangeSlider.delegate=self;
    
    _durationLab.text=[NSString stringWithFormat:@"总时长%fs",self.mySAVideoRangeSlider.durationSeconds];
    [_toolView addSubview:self.mySAVideoRangeSlider];
    
    
}
#pragma mark - SAVideoRangeSliderDelegate

- (void)videoRange:(SAVideoRangeSlider *)videoRange didChangeLeftPosition:(CGFloat)leftPosition rightPosition:(CGFloat)rightPosition
{
    NSLog(@"%f,%f",leftPosition,rightPosition);
    //拖动改变视频播放进度
    if (_player.status == AVPlayerStatusReadyToPlay) {
        
        //    //计算出拖动的当前秒数
        CGFloat total = (CGFloat)_playerItem.duration.value / _playerItem.duration.timescale;
        
        //    NSLog(@"%f", total);
        
        
        NSInteger dragedSeconds = floorf(total * leftPosition/_mySAVideoRangeSlider.durationSeconds);
        
        NSLog(@"dragedSeconds:%ld",dragedSeconds);
        
        //转换成CMTime才能给player来控制播放进度
        
        CMTime dragedCMTime = CMTimeMake(dragedSeconds, 1);
        
        [_player pause];
        
        [_player seekToTime:dragedCMTime completionHandler:^(BOOL finish){
            
            _isPlaying=NO;
            [_playBtn setTitle:@"播放" forState:UIControlStateNormal];
            
            
        }];
        
    }
    
    
}


- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [self dismissViewControllerAnimated:YES completion:nil];
}








@end
