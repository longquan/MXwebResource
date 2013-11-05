//
//  CocoaWebResourceViewController.h
//  CocoaWebResource
//
//  Created by Robin Lu on 12/1/08.
//  Copyright robinlu.com 2008. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HTTPServer.h"
#import "FGalleryViewController.h"
#import "PullToRefreshTableView.h"
#import "MXPlayVC.h"
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MPMoviePlayerController.h>
#import "MXMP3VC.h"
#import "MXImageVC.h"
#import "ReaderViewController.h"
#import "MBProgressHUD.h"

@interface MXViewController : UIViewController <WebFileResourceDelegate,UITableViewDataSource,UITableViewDelegate,AVAudioPlayerDelegate,ReaderViewControllerDelegate> {
	IBOutlet UILabel *urlLabel;
	HTTPServer *httpServer;
    __weak IBOutlet UILabel *urlLabel1;
	NSMutableArray *fileList;
    IBOutlet UISwitch *OnFTPBtn;
    IBOutlet UITableView *tableView;
    PullToRefreshTableView *ptv;
    IBOutlet UIView *headerView;
    AVAudioPlayer		*player;
    UISlider			*volumeSlider;
    MBProgressHUD *HUD;
    BOOL  isShowGuide;
    NSString *ftpUrl;
    __weak IBOutlet UIView *frontView;
}

- (IBAction)toggleService:(id)sender;
@end