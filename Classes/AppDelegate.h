//
//  CocoaWebResourceAppDelegate.h
//  CocoaWebResource
//
//  Created by Robin Lu on 12/1/08.
//  Copyright robinlu.com 2008. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MXViewController;
#import "CHDraggableView.h"
#import "CHDraggableView+Avatar.h"
#import "CHDraggingCoordinator.h"

@interface AppDelegate : NSObject <UIApplicationDelegate,CHDraggingCoordinatorDelegate> {
    UIWindow *window;
    MXViewController *viewController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet MXViewController *viewController;
@property (strong, nonatomic) CHDraggingCoordinator *draggingCoordinator;
@end

