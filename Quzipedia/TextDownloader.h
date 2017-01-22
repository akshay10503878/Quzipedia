//
//  TextDownloader.h
//  Quzipedia
//
//  Created by akshay bansal on 1/21/17.
//  Copyright © 2017 akshay bansal. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol DownloadCompleteDelegate <NSObject>
- (void)DownLoadCompletedWithData:(NSString *)WikiString;
@end


@interface TextDownloader : NSObject
+(instancetype)sharedInstance;
-(void)DownloadData;
@property (nonatomic, weak) id <DownloadCompleteDelegate> delegate;
@end


