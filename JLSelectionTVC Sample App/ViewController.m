//
//  ViewController.m
//  JLSelectionTVC Sample App
//
//  Created by nvrtd frst on 4/14/14.
//  Copyright (c) 2014 j labs. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //set some defaults for the example
    self.chosenColor = @"white";
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"simpleExample"])
    {
        JLSelectionTVC *destinationVC = [segue destinationViewController];
        destinationVC.title = @"Choose Color";
        [destinationVC setIsMultipleSelection:NO];
        [destinationVC setDelegate:self];
        
///////////////////////////////////////////////////////////////////////
//        the simplest use case is to just supply JLSelectionTVC with an array of NSStrings
///////////////////////////////////////////////////////////////////////
        
        NSArray *colorsArray = @[@"white", @"blue", @"green", @"red"];
        
        //creates the datasource for the table
        [destinationVC insertSectionWithTitle:@"Background Color" withRows:colorsArray withSectionFooter:@"Choose a color, any color!"];
        
        //set which item is preselected
        [destinationVC setSelectionsByEnumeration:^BOOL(id object) {
            if ([object isEqualToString:self.chosenColor])
                return YES;
            else
                return NO;
        }];
    }
}

//delegate method implementation
- (void) JLSelectionTVC:(JLSelectionTVC *)sender selection:(NSArray *)selectionObjectsArray
{
    self.chosenColor = selectionObjectsArray[0];
    
    if ([self.chosenColor isEqualToString:@"white"])
        self.view.backgroundColor = [UIColor whiteColor];
    else if ([self.chosenColor isEqualToString:@"blue"])
        self.view.backgroundColor = [UIColor blueColor];
    else if ([self.chosenColor isEqualToString:@"green"])
        self.view.backgroundColor = [UIColor greenColor];
    else if ([self.chosenColor isEqualToString:@"red"])
        self.view.backgroundColor = [UIColor redColor];
}


@end
