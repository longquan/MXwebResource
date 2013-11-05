//
//  AdVC.m
//  CocoaWebResource
//
//  Created by Bo Xiu on 13-7-30.
//
//

#import "AdVC.h"
#import "YouMiSpot.h"

@interface AdVC ()

@end

@implementation AdVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
         [YouMiSpot requestSpotADs:NO];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidAppear:(BOOL)animated{
    [YouMiSpot showSpotDismiss:^{
        [[NSNotificationCenter defaultCenter]
         postNotificationName:@"DismissVC" object:self];
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
