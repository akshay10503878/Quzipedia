//
//  TextParser.m
//  Quzipedia
//
//  Created by akshay bansal on 1/22/17.
//  Copyright © 2017 akshay bansal. All rights reserved.
//

#import "TextParser.h"
#import "NSMutableArray+Shuffling.h"

@implementation TextParser

+(WikiQuizContent *)ParseWikiText:(NSString *)wikiText{

    WikiQuizContent *WQC=[[WikiQuizContent alloc] init];

    //For Split into Sentences
    
    __block NSMutableArray *selectedWords=[[NSMutableArray alloc] init];
    __block NSMutableArray *selectedwordRanges=[[NSMutableArray alloc] init];
    
    NSRange range = {0, [wikiText length]};
    
    [wikiText enumerateSubstringsInRange:range options:NSStringEnumerationBySentences usingBlock:^(NSString *sentence, NSRange substringRange, NSRange enclosingRange, BOOL *stopSentence) {
    
        //For spliting into words
        NSLinguisticTagger *tagger = [[NSLinguisticTagger alloc] initWithTagSchemes:[NSArray arrayWithObject:NSLinguisticTagSchemeLexicalClass] options:~NSLinguisticTaggerOmitWords];
        [tagger setString:sentence];
        
        __block NSMutableArray *words=[[NSMutableArray alloc] init];
        __block NSRange wordRange;
        wordRange.location=substringRange.location;
        [tagger enumerateTagsInRange:NSMakeRange(0, [sentence length])
                              scheme:NSLinguisticTagSchemeLexicalClass
                             options:~NSLinguisticTaggerOmitWords
                          usingBlock:^(NSString *tag, NSRange tokenRange, NSRange sentenceRange, BOOL *stop) {
                              
                              if ([tag isEqualToString:@"Noun"]) {
                                  if (![words containsObject:[sentence substringWithRange:tokenRange]]) {
                                      [words addObject:[sentence substringWithRange:tokenRange]];
                                  }
                                                             }
                          }];
        
        if([words count]>0)
        {
            while (true) {
                NSString *selectedword=[words objectAtIndex:arc4random()%[words count]];
                if (![selectedWords containsObject:selectedword]) {
                    [selectedWords addObject:selectedword];
                    wordRange.length=[selectedword length];
                    wordRange.location=wordRange.location+[sentence rangeOfString:selectedword].location;
                    [selectedwordRanges addObject:[NSValue valueWithRange:wordRange]];
                    break;
                }
            }
            
        }
        if ([selectedWords count]==10) {
            WQC.wikiText=[wikiText substringWithRange:NSMakeRange(0, substringRange.location+substringRange.length)];
            *stopSentence=YES;
        }
        
    }];
    
    WQC.answers=selectedWords;
    
    WQC.shuffledOptions=[selectedWords shuffle];
    WQC.answerRanges=selectedwordRanges;
    
    NSLog(@"%@",WQC.answers);
    NSLog(@"%@", WQC.shuffledOptions);
    NSLog(@"%@",WQC.answerRanges);
    NSLog(@"%@",WQC.wikiText);
    
    return WQC;
}

@end
