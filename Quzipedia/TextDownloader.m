//
//  TextDownloader.m
//  Quzipedia
//
//  Created by akshay bansal on 1/21/17.
//  Copyright © 2017 akshay bansal. All rights reserved.
//

#import "TextDownloader.h"

@implementation TextDownloader
+(instancetype)sharedInstance{
    
    static dispatch_once_t once;
    static id sharedInstance;
    dispatch_once(&once, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

-(void)DownloadData
{
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    NSURL *url = [NSURL URLWithString:@"https://api.flickr.com/services/feeds/photos_public.gne?format=json&nojsoncallback=?&lang=en-us"];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    /*
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    */
    NSURLSessionDataTask *postDataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        if (!error && data!=nil)
        {
            if ([response isKindOfClass:[NSHTTPURLResponse class]])
            {
                NSError *jsonError=nil;
                NSDictionary *jsonResponse = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&jsonError];
                
                if (jsonError) {
                    NSLog(@"Json Parsing Error");
                    //we have to remove this line
                    //As this api is not sending a valid json multiple time it is added
                    [self DownloadData];
                }
                else {
                    if ([[jsonResponse allKeys] containsObject:@"items"]) {
                        
                        [self.delegate DownLoadCompletedWithData:[self returnParsedData:[jsonResponse objectForKey:@"items"]]];
                    }
                }
            }
            else
            {
                NSLog(@"Response Error");
            }
        }
        else
        {
            NSLog(@"error : %@", error.description);
        }
    }] ;
    
    [postDataTask resume];
}


-(NSArray*)returnParsedData:(NSArray *)ImageItems
{
    
    
}


@end
