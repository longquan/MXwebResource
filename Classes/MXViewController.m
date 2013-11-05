//
//  CocoaWebResourceViewController.m
//  CocoaWebResource
//
//  Created by Robin Lu on 12/1/08.
//  Copyright robinlu.com 2008. All rights reserved.
//

#import "MXViewController.h"
#import "MediaObject.h"
#import "MXCell.h"
  
@implementation MXViewController

// load file list
- (void)loadFileList
{
	[fileList removeAllObjects];
	NSString* docDir = [NSString stringWithFormat:@"%@/Documents", NSHomeDirectory()];
	NSDirectoryEnumerator *direnum = [[NSFileManager defaultManager]
									  enumeratorAtPath:docDir];
	NSString *pname;
	while (pname = [direnum nextObject])
	{
		[fileList addObject:pname];
	}
    NSLog(@"xx:%@",fileList);
    [ptv reloadData];
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    self.title = @"我的地盘";
    isShowGuide = NO;
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"切换" style:UIBarButtonSystemItemStop target:self action:@selector(PopViewController)];
    self.navigationItem.rightBarButtonItem= backButton;
    UIBarButtonItem *refreshButton = [[UIBarButtonItem alloc] initWithTitle:@"刷新" style:UIBarButtonSystemItemRefresh target:self action:@selector(refreshVC)];
    self.navigationItem.leftBarButtonItem= refreshButton;
    
	fileList = [[NSMutableArray alloc] init];
	[self loadFileList];
	// set up the http server
	httpServer = [[HTTPServer alloc] init];
	[httpServer setType:@"_http._tcp."];	
	[httpServer setPort:8080];
	[httpServer setName:@"CocoaWebResource"];
	[httpServer setupBuiltInDocroot];
	httpServer.fileResourceDelegate = self;
    [super viewDidLoad];    
    
    ptv = [[PullToRefreshTableView alloc] initWithFrame:CGRectMake(0, 0, 320, 460)];
    ptv.separatorStyle = UITableViewCellSeparatorStyleNone;
    ptv.delegate = self;
    ptv.tableHeaderView = headerView;
    ptv.dataSource = self;
    ptv.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    ptv.showsVerticalScrollIndicator = NO;
    ptv.showsHorizontalScrollIndicator = NO;
    ptv.backgroundColor = [UIColor clearColor];
    [self.view addSubview:ptv];
    [ptv setHidden:YES];
    [self onService];
}

- (void)PopViewController{
    isShowGuide = !isShowGuide;
    [frontView setHidden:isShowGuide];
    [ptv setHidden:!isShowGuide];
}

- (void)refreshVC{
    [self offService];
    [self onService];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning]; // Releases the view if it doesn't have a superview
    // Release anything that's not essential, such as cached data
}

- (void)onService{
    NSError *error;
    BOOL serverIsRunning = [httpServer start:&error];
    if(!serverIsRunning)
    {
        NSLog(@"Error starting HTTP Server: %@", error);
    }
    ftpUrl = [NSString stringWithFormat:@"http://%@:%d", [httpServer hostName], [httpServer port]];
    [urlLabel setText:ftpUrl];
    [urlLabel1 setText:[NSString stringWithFormat:@"浏览器访问:%@",ftpUrl]];
    UIAlertView *altert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"服务开启成功！" delegate:self cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
    [altert show];
}

- (void)offService{
    [httpServer stop];
    ftpUrl = @"上传功能已关闭";
    [urlLabel setText:ftpUrl];
    [urlLabel1 setText:ftpUrl];
}

- (IBAction)toggleService:(id)sender
{
	NSError *error;
	if ([(UISwitch*)sender isOn])
	{
		BOOL serverIsRunning = [httpServer start:&error];
		if(!serverIsRunning)
		{
			NSLog(@"Error starting HTTP Server: %@", error);
		}		
		[urlLabel setText:[NSString stringWithFormat:@"浏览器访问：http://%@:%d", [httpServer hostName], [httpServer port]]];
	}
	else
	{
		[httpServer stop];
		[urlLabel setText:@"上传功能已关闭"];
	}
}

#pragma mark -
#pragma mark PullToRefreshTableView Methods

- (void)updateThread:(NSString *)returnKey{
    //    sleep(2);
    switch ([returnKey intValue]) {
        case k_RETURN_REFRESH:
            //            [WTStatusBar setStatusText:@"" timeout:20.0 animated:YES];
            
            break;
        case k_RETURN_LOADMORE:
            break;
            
        default:
            break;
    }
    [self performSelectorOnMainThread:@selector(updateTableView) withObject:nil waitUntilDone:NO];
}

- (void)updateTableView{
    [ptv reloadData:YES];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    NSInteger returnKey = [ptv tableViewDidEndDragging];
    
    if (returnKey != k_RETURN_DO_NOTHING) {
        NSString * key = [NSString stringWithFormat:@"%d", returnKey];
        [self updateThread:key];
    }
}
- (void)playMovieAtURL:(NSURL*)theURL
{
    MPMoviePlayerController *theMovie= [[MPMoviePlayerController alloc] initWithContentURL:theURL];
    theMovie.scalingMode=MPMovieScalingModeAspectFill;
    //    theMovie.userCanShowTransportControls=NO;
    
    // Register for the playback finished notification.
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(myMovieFinishedCallback:)
                                                 name:MPMoviePlayerPlaybackDidFinishNotification
                                               object:theMovie];
    // Movie playback is asynchronous, so this method returns immediately.
    [theMovie play];
}

// When the movie is done,release the controller.
- (void)myMovieFinishedCallback:(NSNotification*)aNotification
{
    MPMoviePlayerController* theMovie=[aNotification object];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:MPMoviePlayerPlaybackDidFinishNotification
                                                  object:theMovie];
    
    // Release the movie instance created in playMovieAtURL
}

- (void)video_play:(NSString*)filename
{
//    NSString *s = [[NSBundle mainBundle] pathForResource:filename ofType:@"mov"];
//    NSURL *url = [NSURL fileURLWithPath:s];
//    NSLog(@"Playing URL: %@", url);
    NSString* docDir = [NSString stringWithFormat:@"%@/Documents", NSHomeDirectory()];
    NSString *path = [NSString stringWithFormat:@"%@/%@", docDir, filename];
    [self playMovieAtURL:[NSURL URLWithString:path]];
}


#pragma mark - TableView Methods
//指定有多少个分区(Section)，默认为1
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

//指定每个分区中有多少行，默认为1
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [fileList count];
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *filename = [fileList objectAtIndex:[indexPath row]];
//    NSString* docDir = [NSString stringWithFormat:@"%@/Documents", NSHomeDirectory()];
//    NSString *path = [NSString stringWithFormat:@"%@/%@", docDir, filename];
    if ([filename hasSuffix:@"png"]|| [filename hasSuffix:@"jpeg"]|| [filename hasSuffix:@"jpg"] ) {
        MXImageVC *imageVC = [[MXImageVC alloc] init];
        imageVC.filename = filename;
        [self.navigationController pushViewController:imageVC animated:YES];
    }else if([filename hasSuffix:@"mov"] || [filename hasSuffix:@"m4v"] || [filename hasSuffix:@"MOV"] || [filename hasSuffix:@"MP4"] || [filename hasSuffix:@"mp4"]){
        MXPlayVC *playVC = [[MXPlayVC alloc] init];
        playVC.filename = filename;
        [self.navigationController pushViewController:playVC animated:YES];
    }else if([filename hasSuffix:@"MP3"] || [filename hasSuffix:@"mp3"] || [filename hasSuffix:@"AAC"] || [filename hasSuffix:@"aac"] || [filename hasSuffix:@"AMR"] || [filename hasSuffix:@"amr"] ||[filename hasSuffix:@"iLBC"] || [filename hasSuffix:@"ilbc"] ||[filename hasSuffix:@"IMA4"] ||[filename hasSuffix:@"ima4"]){
        MXMP3VC *mp3VC = [[MXMP3VC alloc] init];
        mp3VC.filename = filename;
        [self.navigationController pushViewController:mp3VC animated:YES];
    }else if([filename hasSuffix:@"pdf"]){
        [self toPDFVC:filename];
    }else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"此文件格式暂不支持浏览,请下载收费版" delegate:self cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
        [alert show];
    }
    
}
- (void)toPDFVC:(NSString *)filename{
#ifdef DEBUGX
	NSLog(@"%s", __FUNCTION__);
#endif
    
	NSString *phrase = nil; // Document password (for unlocking most encrypted PDF files)
    
    NSString *aPath=[NSString stringWithFormat:@"%@/Documents/%@",NSHomeDirectory(),filename];
    
	ReaderDocument *document = [ReaderDocument withDocumentFilePath:aPath password:phrase];
    
	if (document != nil) // Must have a valid ReaderDocument object in order to proceed with things
	{
		ReaderViewController *readerViewController = [[ReaderViewController alloc] initWithReaderDocument:document];
        
		readerViewController.delegate = self; // Set the ReaderViewController delegate to self
        
#if (DEMO_VIEW_CONTROLLER_PUSH == TRUE)
        
		[self.navigationController pushViewController:readerViewController animated:YES];
        
#else // present in a modal view controller
        
		readerViewController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
		readerViewController.modalPresentationStyle = UIModalPresentationFullScreen;
        
		[self presentModalViewController:readerViewController animated:YES];
        
#endif // DEMO_VIEW_CONTROLLER_PUSH
        
	}
}

#pragma mark ReaderViewControllerDelegate methods

- (void)dismissReaderViewController:(ReaderViewController *)viewController
{
#ifdef DEBUGX
	NSLog(@"%s", __FUNCTION__);
#endif
    
#if (DEMO_VIEW_CONTROLLER_PUSH == TRUE)
    
	[self.navigationController popViewControllerAnimated:YES];
    
#else // dismiss the modal view controller
    
	[self dismissModalViewControllerAnimated:YES];
    
#endif // DEMO_VIEW_CONTROLLER_PUSH
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *tableCellIdentifier = @"MXCell";
    MXCell *cell = (MXCell *)[tableView dequeueReusableCellWithIdentifier:tableCellIdentifier];
    if(cell == nil){
        NSArray *nib = [[NSBundle mainBundle]loadNibNamed:@"MXCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.filename.text =[fileList objectAtIndex:[indexPath row]];
    return cell;
    
}
#pragma mark –
#pragma mark UITableView
-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

#pragma mark WebFileResourceDelegate
// number of the files
- (NSInteger)numberOfFiles
{
	return [fileList count];
}

// the file name by the index
- (NSString*)fileNameAtIndex:(NSInteger)index
{
	return [fileList objectAtIndex:index];
}

// provide full file path by given file name
- (NSString*)filePathForFileName:(NSString*)filename
{
	NSString* docDir = [NSString stringWithFormat:@"%@/Documents", NSHomeDirectory()];
	return [NSString stringWithFormat:@"%@/%@", docDir, filename];
}

// handle newly uploaded file. After uploading, the file is stored in
// the temparory directory, you need to implement this method to move
// it to proper location and update the file list.
- (void)newFileDidUpload:(NSString*)name inTempPath:(NSString*)tmpPath
{
    HUD = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:HUD];
    HUD.labelText = @"正在上传";
    
    //设置模式为进度框形的
    HUD.mode = MBProgressHUDModeDeterminate;
    [HUD showAnimated:YES whileExecutingBlock:^{
        float progress = 0.0f;
        while (progress < 1.0f) {
            progress += 0.01f;
            HUD.progress = progress;
            usleep(50000);
        }
    } completionBlock:^{
        [HUD removeFromSuperview];
        HUD = nil;
    }];

	if (name == nil || tmpPath == nil)
		return;
	NSString* docDir = [NSString stringWithFormat:@"%@/Documents", NSHomeDirectory()];
	NSString *path = [NSString stringWithFormat:@"%@/%@", docDir, name];
	NSFileManager *fm = [NSFileManager defaultManager];
	NSError *error;
	if (![fm moveItemAtPath:tmpPath toPath:path error:&error])
	{
		NSLog(@"can not move %@ to %@ because: %@", tmpPath, path, error );
	}
		
	[self loadFileList];
	
}

// implement this method to delete requested file and update the file list
- (void)fileShouldDelete:(NSString*)fileName
{
	NSString *path = [self filePathForFileName:fileName];
	NSFileManager *fm = [NSFileManager defaultManager];
	NSError *error;
	if(![fm removeItemAtPath:path error:&error])
	{
		NSLog(@"%@ can not be removed because:%@", path, error);
	}
	[self loadFileList];
}

- (void)viewDidUnload {
    frontView = nil;
    urlLabel1 = nil;
    [super viewDidUnload];
}
@end
