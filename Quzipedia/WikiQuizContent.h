//
//  WikiQuizContent.h
//  Quzipedia
//
//  Created by akshay bansal on 1/22/17.
//  Copyright © 2017 akshay bansal. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WikiQuizContent : NSObject
@property (nonatomic,strong) NSArray *answers;
@property (nonatomic,strong) NSArray *options;
@property (nonatomic,strong) NSArray *startRanges;
@property (nonatomic,strong) NSArray *endRanges;
@property (nonatomic,strong) NSString *wikiText;
+(instancetype)sharedInstance;
@end
