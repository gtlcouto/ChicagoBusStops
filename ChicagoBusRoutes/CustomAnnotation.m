//
//  CustomAnnotation.m
//  ChicagoBusRoutes
//
//  Created by Gustavo Couto on 2015-01-20.
//  Copyright (c) 2015 Gustavo Couto. All rights reserved.
//

#import "CustomAnnotation.h"

@implementation CustomAnnotation

-(instancetype)initWithDictionary:(NSDictionary *)busDictionary
{
    self = [super self];
    if (self)
    {
        self.busId = busDictionary[@"_id"];
        self.stopId = busDictionary[@"stop_id"];
        self.stopName = busDictionary[@"cta_stop_name"];
        self.direction = busDictionary[@"direction"];
        self.routes = busDictionary[@"routes"];
        if([busDictionary[@"longitude"] floatValue] < 0)
        {
            self.longitude = busDictionary[@"longitude"];
        }
        else{
            self.longitude = [NSNumber numberWithFloat:([busDictionary[@"longitude"] floatValue] *-1)];
        }
        self.latitude = busDictionary[@"latitude"];
        self.interModal = busDictionary[@"inter_modal"];

        return self;
    }
    return self;
}

@end
