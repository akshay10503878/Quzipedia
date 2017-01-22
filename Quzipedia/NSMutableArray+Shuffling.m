//
//  NSArray+Shuffling.m
//  Quzipedia
//
//  Created by akshay bansal on 1/22/17.
//  Copyright © 2017 akshay bansal. All rights reserved.
//

#import "NSMutableArray+Shuffling.h"

@implementation NSMutableArray (Shuffling)

-(NSArray*)shuffle
{
    NSMutableArray *shuffledArray=[[NSMutableArray alloc] initWithArray:self];
    NSUInteger count = [self count];
    for (uint i = 0; i < count - 1; ++i)
    {
        int nElements = (int)count - i;
        int n = arc4random_uniform(nElements) + i;
        [shuffledArray exchangeObjectAtIndex:i withObjectAtIndex:n];
    }
    return shuffledArray;
    
}
@end
