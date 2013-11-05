//
//  MXMP3.m
//  CocoaWebResource
//
//  Created by Bo Xiu on 13-7-23.
//
//

#import "MXMP3VC.h"

@interface MXMP3VC ()

@end

@implementation MXMP3VC
@synthesize filename;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    UIBarButtonItem*backButton = [[UIBarButtonItem alloc] initWithTitle:@"我的地盘" style:UIBarButtonItemStyleBordered target:self action:@selector(PopViewController)];
    self.navigationItem.leftBarButtonItem= backButton;
//    self.mp3Name.framer
    self.mp3Name.text = [NSString stringWithFormat:@"正在播放: %@",filename];
    // Do any additional setup after loading the view from its nib.
    NSString* docDir = [NSString stringWithFormat:@"%@/Documents", NSHomeDirectory()];
    NSString *path = [NSString stringWithFormat:@"%@/%@", docDir, filename];
    NSURL *_url=[NSURL fileURLWithPath:path];
    NSError *error;
    player=[[AVAudioPlayer alloc]initWithContentsOfURL:_url
                                                 error:&error];
    if (error) {
        NSLog(@"error:%@",[error description]);
        return;
    }
    //准备播放
    [player prepareToPlay];
    //播放
    [player play];
//    _progressView.progress=0.0f;
    //用到了时间触发器，刷新进度条
    [NSTimer scheduledTimerWithTimeInterval:0.5
                                     target:self
                                   selector:@selector(refreshUR:)
                                   userInfo:nil
                                    repeats:YES];
    //滚动动画
    [self.mp3Name.layer removeAllAnimations];
    CGSize textSize =[self.mp3Name.text sizeWithFont:self.mp3Name.font];
    CGRect lframe =self.mp3Name.frame;lframe.size.width =textSize.width;
    self.mp3Name.frame =lframe;
    const float oriWidth =120;
    if(textSize.width > oriWidth){
        float offset =textSize.width -oriWidth;
        [UIView animateWithDuration:3.0 delay:0 options:UIViewAnimationOptionRepeat//动画重复的主开关
         |UIViewAnimationOptionAutoreverse//动画重复自动反向，需要和上面这个一起用
         |UIViewAnimationOptionCurveLinear//动画的时间曲线，滚动字幕线性比较合理
                        animations:^{
                            self.mp3Name.transform =CGAffineTransformMakeTranslation(-offset,0);
                        }completion:^(BOOL finished){
                        }];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)PopViewController{
    [player stop];
    [self.navigationController popToRootViewControllerAnimated:YES];
}

//刷新事件
-(void)refreshUR:(NSTimer *)aTimer{
//    float p=player.currentTime/player.duration;//当前时间、总时间
//    _progressView.progress=p;
}
//一下三个方法都是连接到已经布置好的BUTTON触发事件上的
//重新播放
-(IBAction)rePlay:(id)sender{
    player.currentTime=0.0f;
    [player play];
}
//暂停
-(IBAction)pause:(id)sender{
    [player pause];
}
//停止
-(IBAction)stop:(id)sender{
    if (player.isPlaying) {
        [player stop];
        player.currentTime=0.0f;
    }
}

- (IBAction)playClicked:(id)sender {
    if (player.isPlaying) {
        [player pause];
        [playBtn setImage:[UIImage imageNamed:@"PlayButton"] forState:UIControlStateNormal];
    }else{
        [player play];
        [playBtn setImage:[UIImage imageNamed:@"PauseButton"] forState:UIControlStateNormal];
    }
}
- (void)viewDidUnload {
    _mp3Name = nil;
    [super viewDidUnload];
}
@end
