//
//  demoViewController.h
//  demo
//
//  Created by  on 12-3-14.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ImageFlow;
@interface demoViewController : UIViewController{
    ImageFlow* imgf;
    NSMutableArray* demoArray;
}

-(IBAction)loadArrayAction:(id)sender;

@end
