//
//  MXMP3.h
//  CocoaWebResource
//
//  Created by Bo Xiu on 13-7-23.
//
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@interface MXMP3VC : UIViewController<AVAudioPlayerDelegate>{
    AVAudioPlayer *player;
    IBOutlet UISlider *_progressView;
    IBOutlet UIButton *playBtn;
    NSString *filename;
}
@property (weak, nonatomic) IBOutlet UILabel *mp3Name;
@property (retain, nonatomic) NSString *filename;
- (IBAction)playClicked:(id)sender;

@end
