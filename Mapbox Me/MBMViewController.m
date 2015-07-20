//
//  MBMViewController.m
//  Mapbox Me
//
//  Copyright (c) 2014 Mapbox, Inc. All rights reserved.
//

#import "MBMViewController.h"

#import "Mapbox.h"
#import <SMCalloutView/SMCalloutView.h>
//#import "mapboxGL.h"

#define kRegularSourceID   @"ml58158.ml047dgo"
#define kTerrainSourceID   @"ml58158.ml46nehj"
#define kSatelliteSourceID @"ml58158.ml47016m"

#define kTintColor [UIColor colorWithRed:0.120 green:0.550 blue:0.670 alpha:1.000]

@interface MBMViewController () {
    UIButton *button;
}

@property (nonatomic, strong) IBOutlet RMMapView *mapView;
@property (nonatomic, strong) IBOutlet UISegmentedControl *segmentedControl;
@property SMCalloutView *callout;
@property RMAnnotation *annotationView;
@property CLLocationManager *locationManager;

@end

#pragma mark -

@implementation MBMViewController

@synthesize mapView;
@synthesize segmentedControl;

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self getLocation];
    //[self customAnnotation];
    //[self customAnnotationTwo];

    // Set the delegate property of our map view to self after instantiating it.
    mapView.delegate = self;
    self.callout = [SMCalloutView platformCalloutView];
  //  self.callout.delegate = self;

    

    [self.view addSubview:mapView];
    
    self.title = @"MapBox Prototype";
    
    [self.segmentedControl addTarget:self action:@selector(toggleMode:) forControlEvents:UIControlEventValueChanged];
    [self.segmentedControl setSelectedSegmentIndex:0];
    
    [[UINavigationBar appearance] setTintColor:kTintColor];
    [[UISegmentedControl appearance] setTintColor:kTintColor];
    [[UIToolbar appearance] setTintColor:kTintColor];

    /**
     *  Map Pin Button
     */

    button = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *image = [UIImage imageNamed:@"Pin.png"];
    button.center = self.view.center;
    //button.frame = CGRectMake(self.view.center.x - image.size.width / 2, self.view.center.y - image.size.height / 2, image.size.width, image.size.height);
    button.frame = CGRectMake(0, 0, 347, 97);

    NSLog(@"Button Frame = %@",NSStringFromCGRect(button.frame));
    [button setImage:image forState:UIControlStateNormal];
    [button addTarget:self action:@selector(markerClicked:) forControlEvents:UIControlEventTouchUpInside];

    [self.view addSubview:button];


    /**
     RMPointAnnotation

     :returns: Annotation
     */

    RMPointAnnotation *annotation = [[RMPointAnnotation alloc]
                                     initWithMapView:mapView
                                     coordinate:mapView.centerCoordinate
                                     andTitle:@"Hello, world!"];

    [mapView addAnnotation:annotation]; //error


}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

    self.mapView.tileSource = [[RMMapboxSource alloc] initWithMapID:kRegularSourceID];

    self.navigationItem.rightBarButtonItem = [[RMUserTrackingBarButtonItem alloc] initWithMapView:self.mapView];

    self.navigationItem.rightBarButtonItem.tintColor = kTintColor;

    self.mapView.userTrackingMode = RMUserTrackingModeFollow;
}

-(void)getLocation{

    self.locationManager = [CLLocationManager new];
    self.locationManager.delegate = self;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    self.locationManager.distanceFilter = 500;
    self.locationManager.pausesLocationUpdatesAutomatically = NO;
    self.locationManager.activityType = CLActivityTypeFitness;

    [self.locationManager requestWhenInUseAuthorization];

    [self.locationManager startUpdatingLocation];
  
}


/**
 *  Autorotate Interface
 *
 *  @param interfaceOrientation uiInterfaceOrientation
 *
 *  @return true
 */
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait || [UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad);
}

#pragma mark - RMMap Helper Methods

- (RMMapLayer *)mapView:(RMMapView *)mapView layerForAnnotation:(RMPointAnnotation *)annotation
{
    if (annotation.isUserLocationAnnotation)
        return nil;

    // add Maki icon and color the marker
    RMMarker *marker = [[RMMarker alloc]
                        initWithMapboxMarkerImage:@"rocket"
                        tintColor:[UIColor colorWithRed:.5 green:.466 blue:.733 alpha:1]];

    marker.canShowCallout = YES;

    // add callout image
    marker.leftCalloutAccessoryView = [[UIImageView alloc]
                                       initWithImage:
                                       [UIImage imageNamed:@"astro-training.png"]];

    marker.rightCalloutAccessoryView = [UIButton
                                        buttonWithType:UIButtonTypeDetailDisclosure];

    return marker;

}






#pragma mark - Toggle Maps

- (void)toggleMode:(UISegmentedControl *)sender
{
    NSString *mapID;
    
    if (sender.selectedSegmentIndex == 2)
        mapID = kSatelliteSourceID;
    else if (sender.selectedSegmentIndex == 1)
        mapID = kTerrainSourceID;
    else if (sender.selectedSegmentIndex == 0)
        mapID = kRegularSourceID;
    
    self.mapView.tileSource = [[RMMapboxSource alloc] initWithMapID:mapID];
}




#pragma mark - RM Delegates

/**
 *  Adds Event when callout is tapped
 *
 *  @param control    tapOnCallOutAccessoryControl
 *  @param annotation annotation
 *  @param map        map
 */
- (void)tapOnCalloutAccessoryControl:(UIControl *)control
                       forAnnotation:(RMAnnotation *)annotation onMap:(RMMapView *)map
{
    NSLog(@"You tapped the callout button!");
}


#pragma mark - SMCallout Methods


/**
 *  Defines the Custom Annotation
 */
-(void)customAnnotationTwo {



    RMPointAnnotation *annotation = [[RMPointAnnotation alloc]
                                     initWithMapView:mapView
                                     coordinate:mapView.centerCoordinate
                                     andTitle:@"Hello, world!"];

    [mapView addAnnotation:annotation];
}

/**
 *  Defines SMCallout View
 *
 *  @param sender markerClicked
 */
- (void)markerClicked:(id)sender {
    UIView *contentView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 347, 97)];
    contentView.backgroundColor = [UIColor grayColor];

    UIImage *placeholderImage = [UIImage imageNamed:@"calloutImage"];//220x150
    UIImageView *imageView = [[UIImageView alloc] initWithImage:placeholderImage];

    [imageView setBackgroundColor:[UIColor blackColor]];
    [imageView setContentMode:UIViewContentModeScaleAspectFit];

    CGRect imageViewFrame = imageView.frame;
    imageViewFrame.size.width = placeholderImage.size.width;
    imageViewFrame.size.height = placeholderImage.size.height;
    [imageView setFrame:imageViewFrame];

    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(10, 50, 100, 25)];
    label.backgroundColor = [UIColor clearColor];
    label.text = @"SMCallout Sample";

    [contentView addSubview:imageView];

    SMCalloutView *calloutView = [[SMCalloutView alloc]init];
    calloutView.contentView = contentView;


    UIButton *accessoryButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [accessoryButton addTarget:self action:@selector(tapOnCalloutAccessoryControl:) forControlEvents:UIControlEventTouchUpInside];
    calloutView.rightAccessoryView = accessoryButton;
    calloutView.permittedArrowDirection = SMCalloutArrowDirectionAny;


    /**
     *  Presents Custom Callout to View Controller
     */
    [calloutView presentCalloutFromRect:button.frame inView:self.view constrainedToView:self.view animated:YES];
}

- (void)tapOnCalloutAccessoryControl:(UIControl *)control
{
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"SMCallout" message:@"AccessoryView clicked" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alert show];
}

@end