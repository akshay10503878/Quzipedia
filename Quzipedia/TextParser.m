//
//  TextParser.m
//  Quzipedia
//
//  Created by akshay bansal on 1/22/17.
//  Copyright © 2017 akshay bansal. All rights reserved.
//

#import "TextParser.h"

@implementation TextParser

-(void)ParseWikiText:(NSString *)wikiText{

    
    
    NSLinguisticTagger *tagger = [[NSLinguisticTagger alloc] initWithTagSchemes:[NSArray arrayWithObject:NSLinguisticTagSchemeLexicalClass] options:~NSLinguisticTaggerOmitWords];
    [tagger setString:wikiText];
    __block int i=0;
    [tagger enumerateTagsInRange:NSMakeRange(0, [wikiText length])
                          scheme:NSLinguisticTagSchemeLexicalClass
                         options:~NSLinguisticTaggerOmitWords
                      usingBlock:^(NSString *tag, NSRange tokenRange, NSRange sentenceRange, BOOL *stop) {
                          
                          if ([tag isEqualToString:@"Noun"]) {
                              NSLog(@"found: %@ (%@)", [wikiText substringWithRange:tokenRange], tag);
                              i=i+1;
                              
                          }
                      }];
    
    
    
    
    NSLog(@"%d",i);

}

@end
