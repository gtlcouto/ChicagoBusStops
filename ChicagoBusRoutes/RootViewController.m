//
//  ViewController.m
//  ChicagoBusRoutes
//
//  Created by Gustavo Couto on 2015-01-20.
//  Copyright (c) 2015 Gustavo Couto. All rights reserved.
//

#import "RootViewController.h"
#import <MapKit/MapKit.h>
#import "Bus.h"
#import "Parser.h"
#import "DetailViewController.h"
#import "CustomAnnotation.h"

@interface RootViewController () <MKMapViewDelegate, UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property NSMutableArray * annotationArray;
@property CustomAnnotation * currentAnnotation;

@end

@implementation RootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //populate array with contents of parser getbus method
    self.annotationArray = [Parser getBusStops];
    [self loadPinsFromArray:self.annotationArray];
    self.currentAnnotation = [CustomAnnotation new];
    self.mapView.delegate = self;
}

#pragma mark - MapView Delegate Methods

-(MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{

    MKPinAnnotationView * pin = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:nil];
    pin.canShowCallout = YES;
    pin.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    CustomAnnotation *  myAnnotation = [CustomAnnotation new];
    myAnnotation = annotation;
    if ([myAnnotation.interModal  isEqual: @"Metra"]) {
        pin.pinColor = MKPinAnnotationColorPurple;
        } else if ([myAnnotation.interModal  isEqual: @"Pace"])
        {
            pin.pinColor = MKPinAnnotationColorGreen;
        }

    return pin;
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view
calloutAccessoryControlTapped:(UIControl *)control
{
    [self performSegueWithIdentifier:@"detailSegue" sender:view];
}

#pragma mark - TableView Delegate

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    CustomAnnotation * myAnnotation = [self.annotationArray objectAtIndex:indexPath.row];
    cell.textLabel.text = myAnnotation.stopName;
    cell.detailTextLabel.text = myAnnotation.routes;
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.annotationArray.count;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self performSegueWithIdentifier:@"detailSegue" sender:tableView];
}

#pragma mark - IBAction Methods
- (IBAction)onSegmentedControlChanged:(UISegmentedControl *)sender {
    if (sender.selectedSegmentIndex == 0) {
        self.mapView.hidden = NO;
        self.tableView.hidden = YES;
    } else if (sender.selectedSegmentIndex == 1)
    {
        self.mapView.hidden = YES;
        self.tableView.hidden = NO;
    }
}

#pragma mark - Helper Methods
//Name:loadPinsFromArray
//Takes:NSMutableArray *
//Returns: Void
//Description: Loads the map with pins based on each bus inside the
//array lat/long
-(void)loadPinsFromArray:(NSMutableArray *)annotationArray
{
    NSMutableArray * myAnnotations = [NSMutableArray new];
    for(CustomAnnotation * annotation in annotationArray)
    {
        CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake([annotation.latitude floatValue], [annotation.longitude floatValue]);
        annotation.title = annotation.stopName;
        annotation.subtitle = annotation.routes;
        annotation.coordinate = coordinate;
        [self.mapView addAnnotation:annotation];
        [myAnnotations addObject:annotation];
    }
    [self.mapView showAnnotations:self.mapView.annotations animated:YES];
}

#pragma mark - Segue Methods

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    DetailViewController * dvc = segue.destinationViewController;
    if ([sender isKindOfClass:[MKAnnotationView class]])  {
        MKAnnotationView *annotationView = sender;
        dvc.selectedAnnotation = annotationView.annotation;
    } else if([sender isKindOfClass:[UITableView class]])
    {
        NSIndexPath *myIndexPath = [self.tableView
                                    indexPathForSelectedRow];
        dvc.selectedAnnotation = [self.annotationArray objectAtIndex:myIndexPath.row];
    }

    

}




@end
