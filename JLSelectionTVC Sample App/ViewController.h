//
//  ViewController.h
//  JLSelectionTVC Sample App
//
//  Created by nvrtd frst on 4/14/14.
//  Copyright (c) 2014 j labs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JLSelectionTVC.h"


@interface ViewController : UIViewController <JLSelectionTVCDelegate>

@property (nonatomic, copy) NSString *chosenColor;

@end
