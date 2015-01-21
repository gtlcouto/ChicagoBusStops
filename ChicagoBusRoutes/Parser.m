//
//  Parser.m
//  ChicagoBusRoutes
//
//  Created by Gustavo Couto on 2015-01-20.
//  Copyright (c) 2015 Gustavo Couto. All rights reserved.
//

#import "Parser.h"
#import "CustomAnnotation.h"

@implementation Parser

+(NSMutableArray *)getBusStops{
    NSMutableArray * busArray = [NSMutableArray new];
    NSURL * url = [NSURL URLWithString:@"https://s3.amazonaws.com/mobile-makers-lib/bus.json"];
    NSData * busData = [NSData dataWithContentsOfURL:url];
    NSDictionary * busDataDictionary = [NSJSONSerialization JSONObjectWithData:busData options:0 error:nil];
        NSArray * busDataArray = busDataDictionary[@"row"];
        for (NSDictionary * busStop in busDataArray){
            CustomAnnotation * myBus = [[CustomAnnotation alloc] initWithDictionary:busStop];
            [busArray addObject:myBus];
        }
    return busArray;
}


@end
