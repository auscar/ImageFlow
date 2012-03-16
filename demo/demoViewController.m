//
//  demoViewController.m
//  demo
//
//  Created by  on 12-3-14.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import "demoViewController.h"
#import "ImageFlow.h"

@implementation demoViewController

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    
    // Do any additional setup after loading the view, typically from a nib.

    imgf = [[ImageFlow alloc] init];
    imgf.images = [[NSMutableArray alloc] initWithObjects:[UIImage imageNamed:@"1.jpg"],[UIImage imageNamed:@"2.jpg"],[UIImage imageNamed:@"3.jpg"],[UIImage imageNamed:@"4.jpg"],[UIImage imageNamed:@"5.jpg"],[UIImage imageNamed:@"6.jpg"],[UIImage imageNamed:@"7.jpg"],[UIImage imageNamed:@"8.jpg"],[UIImage imageNamed:@"9.jpg"],[UIImage imageNamed:@"10.jpg"],[UIImage imageNamed:@"11.jpg"],[UIImage imageNamed:@"12.jpg"], nil];
    [imgf calculatePosition];
    [imgf logImagePos];
   
    
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:imgf.view];
    
    [imgf check:CGPointMake(0, 0)];
    
    [imgf toFit];
    
    [super viewDidLoad];
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}
-(void) dealloc{
    [imgf release];
    [super dealloc];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

@end
