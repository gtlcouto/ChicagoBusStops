//
//  DetailViewController.m
//  ChicagoBusRoutes
//
//  Created by Gustavo Couto on 2015-01-20.
//  Copyright (c) 2015 Gustavo Couto. All rights reserved.
//

#import "DetailViewController.h"

@interface DetailViewController ()
@property (weak, nonatomic) IBOutlet UILabel *busIdLabel;
@property (weak, nonatomic) IBOutlet UILabel *stopIdLabel;
@property (weak, nonatomic) IBOutlet UILabel *routeLabel;
@property (weak, nonatomic) IBOutlet UILabel *stopNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *directionLabel;
@property (weak, nonatomic) IBOutlet UILabel *interModalLabel;

@end



@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadUI];

    
}

-(void)loadUI
{
    self.busIdLabel.text = [NSString stringWithFormat:@"%@",self.selectedAnnotation.busId];
    self.stopIdLabel.text = [NSString stringWithFormat:@"%@",self.selectedAnnotation.stopId];
    self.routeLabel.text = self.selectedAnnotation.routes;
    self.stopNameLabel.text = self.selectedAnnotation.stopName;
    self.directionLabel.text = self.selectedAnnotation.direction;
    self.interModalLabel.text = self.selectedAnnotation.interModal;
}




@end
