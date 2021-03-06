//
//  myAnnotation.h
//  ChicagoBusRoutes
//
//  Created by Gustavo Couto on 2015-01-20.
//  Copyright (c) 2015 Gustavo Couto. All rights reserved.
//

#import <MapKit/MapKit.h>

@interface myAnnotation : MKPointAnnotation

@property NSNumber * busId;
@property NSNumber * stopId;
@property NSString * stopName;
@property NSString * direction;
@property NSString * routes;
@property NSNumber * longitude;
@property NSNumber * latitude;

-(instancetype)initWithDictionary:(NSDictionary *)busDictionary;


@end
