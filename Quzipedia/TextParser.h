//
//  TextParser.h
//  Quzipedia
//
//  Created by akshay bansal on 1/22/17.
//  Copyright © 2017 akshay bansal. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WikiQuizContent.h"

@interface TextParser : NSObject

+(WikiQuizContent *)ParseWikiText:(NSString *)wikiText;

@end
