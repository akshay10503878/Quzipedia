//
//  ViewController.m
//  Quzipedia
//
//  Created by akshay bansal on 1/21/17.
//  Copyright © 2017 akshay bansal. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    TextDownloader *obj=[TextDownloader sharedInstance];
    [obj DownloadData];
    obj.delegate=self;
    [self rotateLayerInfinite:self.ActivityIndicatorImage.layer];
   
}

- (void)rotateLayerInfinite:(CALayer *)layer
{
    CABasicAnimation *rotation;
    rotation = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
    rotation.fromValue = [NSNumber numberWithFloat:0];
    rotation.toValue = [NSNumber numberWithFloat:(2 * M_PI)];
    rotation.duration = 1.0f; 
    rotation.repeatCount = HUGE_VALF;
    [layer removeAllAnimations];
    [layer addAnimation:rotation forKey:@"Spin"];
    //[_activityIndicatorImage.layer removeAllAnimations];
}



-(void)DownLoadCompletedWithData:(NSString *)WikiString
{
    


}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
