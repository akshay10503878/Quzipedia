//
//  ViewController.h
//  Quzipedia
//
//  Created by akshay bansal on 1/21/17.
//  Copyright © 2017 akshay bansal. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TextDownloader.h"
#import "TextParser.h"

@interface ViewController : UIViewController<DownloadCompleteDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *ActivityIndicatorImage;
@property (strong, nonatomic) IBOutlet UITextView *WikiTextView;
@property (strong, nonatomic) IBOutlet UIButton *Submit;
@property (strong, nonatomic) IBOutlet UIButton *RefreshQuiz;

@end

