//
//  MXPlayVC.h
//  CocoaWebResource
//
//  Created by Bo Xiu on 13-7-23.
//
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>

@interface MXPlayVC : UIViewController{
    MPMoviePlayerController *movie;
}

@property (retain, nonatomic) NSString *filename;

@end
