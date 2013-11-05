//
//  CocoaWebResourceAppDelegate.m
//  CocoaWebResource
//
//  Created by Robin Lu on 12/1/08.
//  Copyright robinlu.com 2008. All rights reserved.
//

#import "AppDelegate.h"
#import "MXViewController.h"
#import "YouMiSpot.h"
#import "AdVC.h"

@implementation AppDelegate

@synthesize window;
@synthesize viewController;


- (void)applicationDidFinishLaunching:(UIApplication *)application {
    
    // [YouMiConfig setShouldGetLocation:NO];
    //替换AppID和appSecret为你的AppID和appSecret
    [YouMiConfig launchWithAppID:@"10d5dec38512692c" appSecret:@"0685c728bc7de791"];
    // 开启积分管理
    [YouMiPointsManager enable];
    // 启动积分墙
    [YouMiWall enable];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.viewController = [[MXViewController alloc] initWithNibName:@"MXViewController" bundle:nil];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:self.viewController];
    nav.navigationBar.tintColor = [UIColor blackColor];
    self.window.rootViewController = nav;
    [self.window makeKeyAndVisible];
    [window makeKeyAndVisible];
    
    [YouMiSpot requestSpotADs:NO];
    
    //隐藏广告入口
    
//    CHDraggableView *draggableView = [CHDraggableView draggableViewWithImage:[UIImage imageNamed:@"tuijian1.jpg"]];
//    draggableView.tag = 1;
//    
//    _draggingCoordinator = [[CHDraggingCoordinator alloc] initWithWindow:self.window draggableViewBounds:draggableView.bounds];
//    _draggingCoordinator.delegate = self;
//    _draggingCoordinator.snappingEdge = CHSnappingEdgeBoth;
//    draggableView.delegate = _draggingCoordinator;
//    
//    [self.window addSubview:draggableView];

}

-(BOOL)shouldAutorotate

{
    return NO;
}
-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation

{
    return YES;
}
- (UIViewController *)draggingCoordinator:(CHDraggingCoordinator *)coordinator viewControllerForDraggableView:(CHDraggableView *)draggableView
{
    return  [AdVC alloc];
}

@end
