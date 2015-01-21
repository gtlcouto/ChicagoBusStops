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
#import "iCarousel.h"

@interface RootViewController () <MKMapViewDelegate, UITableViewDataSource, UITableViewDelegate, iCarouselDataSource, iCarouselDelegate>
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property NSMutableArray * annotationArray;
@property CustomAnnotation * currentAnnotation;
@property iCarousel * annotationCarousel;
@property (weak, nonatomic) IBOutlet UIView *carouselItemView;
@property (weak, nonatomic) IBOutlet UILabel *label1;
@property (weak, nonatomic) IBOutlet UILabel *label2;

@end

@implementation RootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //populate array with contents of parser getbus method
    self.annotationArray = [Parser getBusStops];
    [self loadPinsFromArray:self.annotationArray];
    self.currentAnnotation = [CustomAnnotation new];
    self.mapView.delegate = self;
    self.annotationCarousel.delegate = self;
    self.annotationCarousel.type = iCarouselTypeCoverFlow2;
    [self.annotationCarousel reloadData];
    //self.annotationCarousel.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"busStop.png"]];

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

#pragma mark - Carousel Delegate

- (NSInteger)numberOfItemsInCarousel:(iCarousel *)carousel
{
    //return the total number of items in the carousel
    return self.annotationArray.count;
}

- (UIView *)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSInteger)index reusingView:(UIView *)view
{
   	UIButton *button = (UIButton *)view;
    if (button == nil)
    {
        //no button available to recycle, so create new one
        //UIImage *image = [UIImage imageNamed:@"busStop.png"];
        button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(0.0f, 0.0f, 200, 200);
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        //[button setBackgroundImage:image forState:UIControlStateNormal];
        [button setBackgroundColor:[UIColor grayColor]];
        [button addTarget:self action:@selector(buttonTapped:) forControlEvents:UIControlEventTouchUpInside];
        button.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
        button.titleLabel.textAlignment = NSTextAlignmentCenter;
    }

    //set button label
    CustomAnnotation * myAnnotation = [CustomAnnotation new];
    myAnnotation = self.annotationArray[index];
//    [button setTitle:[NSString stringWithFormat:@"%@/n%@",myAnnotation.stopName, myAnnotation.routes ]];
    [button setTitle:[NSString stringWithFormat:@"%@\n%@",myAnnotation.stopName, myAnnotation.routes] forState:UIControlStateNormal];

    return button;
}

#pragma mark - IBAction Methods
- (IBAction)onSegmentedControlChanged:(UISegmentedControl *)sender {
    if (sender.selectedSegmentIndex == 0) {
        self.mapView.hidden = NO;
        self.tableView.hidden = YES;
        self.annotationCarousel.hidden = YES;
    } else if (sender.selectedSegmentIndex == 1)
    {
        self.mapView.hidden = YES;
        self.tableView.hidden = NO;
        self.annotationCarousel.hidden = YES;
    } else if (sender.selectedSegmentIndex == 2)
    {
        self.mapView.hidden = YES;
        self.tableView.hidden = YES;
        self.annotationCarousel.hidden = NO;
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

- (void)buttonTapped:(UIButton *)sender
{

    [self performSegueWithIdentifier:@"detailSegue" sender:sender];

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
    } else if([sender isKindOfClass:[UIButton class]])
    {
        //get item index for button
        NSInteger index = [self.annotationCarousel indexOfItemViewOrSubview:sender];
        dvc.selectedAnnotation = self.annotationArray[index];
    }

}




@end
