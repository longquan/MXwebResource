//
//  MXPlayVC.m
//  CocoaWebResource
//
//  Created by Bo Xiu on 13-7-23.
//
//

#import "MXPlayVC.h"


@interface MXPlayVC ()

@end

@implementation MXPlayVC

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
    
    NSString* docDir = [NSString stringWithFormat:@"%@/Documents", NSHomeDirectory()];
    NSString *path = [NSString stringWithFormat:@"%@/%@", docDir, self.filename];
    NSURL *url = [NSURL fileURLWithPath:path];
    //视频播放对象
    movie = [[MPMoviePlayerController alloc] initWithContentURL:url];
    movie.controlStyle = MPMovieControlStyleDefault;
    movie.view.frame = CGRectMake(0, 0, 320, 420);
    movie.initialPlaybackTime = -1;
    [self.view addSubview:movie.view];
    // 注册一个播放结束的通知
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(myMovieFinishedCallback:)
                                                 name:MPMoviePlayerPlaybackDidFinishNotification
                                               object:movie];
    [movie play];
}

- (void)PopViewController{
    [movie stop];
    [self.navigationController popToRootViewControllerAnimated:YES];
}

#pragma mark -------------------视频播放结束委托--------------------

/*
 @method 当视频播放完毕释放对象
 */
-(void)myMovieFinishedCallback:(NSNotification*)notify
{
    //视频播放对象
    MPMoviePlayerController* theMovie = [notify object];
    //销毁播放通知
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:MPMoviePlayerPlaybackDidFinishNotification
                                                  object:theMovie];
    [theMovie.view removeFromSuperview];
//    // 释放视频对象
//    [theMovie release];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
