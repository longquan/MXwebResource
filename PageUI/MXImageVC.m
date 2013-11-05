//
//  MXImageVC.m
//  CocoaWebResource
//
//  Created by Bo Xiu on 13-7-23.
//
//

#import "MXImageVC.h"

@interface MXImageVC ()

@end

@implementation MXImageVC

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
    // Do any additional setup after loading the view from its nib.
    NSString *aPath=[NSString stringWithFormat:@"%@/Documents/%@",NSHomeDirectory(),self.filename];
    UIImage *imgFromUrl=[[UIImage alloc]initWithContentsOfFile:aPath];
    self.imageView.image = imgFromUrl;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
