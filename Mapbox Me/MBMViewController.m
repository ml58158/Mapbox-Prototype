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

@end

#pragma mark -

@implementation MBMViewController

@synthesize mapView;
@synthesize segmentedControl;

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self customAnnotation];
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

   // [self customAnnotation];

    button = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *image = [UIImage imageNamed:@"Pin.png"];
    button.center = self.view.center;
    //button.frame = CGRectMake(self.view.center.x - image.size.width / 2, self.view.center.y - image.size.height / 2, image.size.width, image.size.height);
    button.frame = CGRectMake(0, 0, 347, 97);

    NSLog(@"Button Frame = %@",NSStringFromCGRect(button.frame));
    [button setImage:image forState:UIControlStateNormal];
    [button addTarget:self action:@selector(markerClicked:) forControlEvents:UIControlEventTouchUpInside];

    [self.view addSubview:button];

}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

    self.mapView.tileSource = [[RMMapboxSource alloc] initWithMapID:kRegularSourceID];

    self.navigationItem.rightBarButtonItem = [[RMUserTrackingBarButtonItem alloc] initWithMapView:self.mapView];

    self.navigationItem.rightBarButtonItem.tintColor = kTintColor;

    self.mapView.userTrackingMode = RMUserTrackingModeFollow;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait || [UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad);
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

-(void)customAnnotation
{
    // build first marker and title
    RMAnnotation *annotation1 = [[RMAnnotation alloc]
                                 initWithMapView:mapView
                                 coordinate:CLLocationCoordinate2DMake(38.913175, -77.032453)
                                 andTitle:@"Astronaut training"];

    annotation1.userInfo = @"training";

    [mapView addAnnotation:annotation1];

    // build second marker and title
    RMAnnotation *annotation2 = [[RMAnnotation alloc]
                                 initWithMapView:mapView
                                 coordinate:CLLocationCoordinate2DMake(38.911031, -80.030098)
                                 andTitle:@"Astronaut supplies"];

    annotation2.userInfo = @"supplies";

    [mapView addAnnotation:annotation2];


    // set coordinates
    CLLocationCoordinate2D center = CLLocationCoordinate2DMake(38.91235, -77.03128);

    // set zoom
    mapView.zoom = 15;

    // center the map to the coordinates
    mapView.centerCoordinate = center;

    // allows rotation
    mapView.autoresizingMask = UIViewAutoresizingFlexibleHeight |
    UIViewAutoresizingFlexibleWidth;

    
}



#pragma mark - RM Delegates

// add event when callout is tapped
- (void)tapOnCalloutAccessoryControl:(UIControl *)control
                       forAnnotation:(RMAnnotation *)annotation onMap:(RMMapView *)map
{
    NSLog(@"You tapped the callout button!");
}


#pragma mark - SMCallout Methods



-(void)customAnnotationTwo {

    RMPointAnnotation *hello = [[RMPointAnnotation alloc] init];
    hello.coordinate = CLLocationCoordinate2DMake(36.557257591,	-82.577556829);
    hello.title = @"Hello world!";
    hello.subtitle = @"Welcome to my marker";

    // Add marker `hello` to the map
    [mapView addAnnotation:hello];
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