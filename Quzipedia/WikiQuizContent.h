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
@property (nonatomic,assign) NSArray *answerRanges;
@property (nonatomic,strong) NSArray *shuffledOptions;
@property (nonatomic,strong) NSString *wikiText;
+(instancetype)sharedInstance;
@end
