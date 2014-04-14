//
//  AdvancedExampleViewController.m
//  JLSelectionTVC Sample App
//
//  Created by nvrtd frst on 4/14/14.
//  Copyright (c) 2014 j labs. All rights reserved.
//

#import "AdvancedExampleViewController.h"

@implementation AdvancedExampleViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //set some defaults for the example
    self.chosenSounds = [NSMutableArray arrayWithObjects:@"Crickets", @"Digital", nil];
    self.playlistLabel.text = @"";
    for (NSString *soundName in self.chosenSounds)
    {
        NSString *soundNameFormatted = [NSString stringWithFormat:@"%@\n", soundName];
        self.playlistLabel.text = [self.playlistLabel.text stringByAppendingString:soundNameFormatted];
    }
}


#pragma mark - Delegate Methods

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    UINavigationController *navController = [segue destinationViewController];
    JLSelectionTVC *destinationVC = (JLSelectionTVC*)[navController topViewController];
    destinationVC.title = @"Choose Sounds";
    [destinationVC setIsMultipleSelection:YES];
    [destinationVC setDelegate:self];

///////////////////////////////////////////////////////////////////////
//    for this example we want their to be an icon on each cell and for each cell to play a sound when tapped. Thus instead of NSStrings like in the simple example, we'll populate it with objects that follow the JLSelectionObjectProtocol. In this case, I've included a simple class that implements the methods of the protocol called JLSelectionObject. For your use cases, you'd probably want to either subclass JLSelectionObject or create your own class that implements the JLSelectionObjectProtocol.
///////////////////////////////////////////////////////////////////////
    
    JLSelectionObject *cricketsSound = [JLSelectionObject objectWithDisplayName:@"Crickets"
                                                                        image:[UIImage imageNamed:@"icon-iPodMusic.png"]
                                                            isSelectableBlock:^{
                                                                return YES;
                                                            }
                                                        actionWhenTappedBlock:^{
                                                            [self playSoundWithName:@"crickets.mp3"];
                                                        }
                                                              stopActionBlock:^{
                                                                      [self.avPlayer stop];
                                                              }];
    
    JLSelectionObject *digitalSound = [JLSelectionObject objectWithDisplayName:@"Digital"
                                                                            image:[UIImage imageNamed:@"icon-iPodMusic.png"]
                                                                isSelectableBlock:^{
                                                                    return YES;
                                                                }
                                                            actionWhenTappedBlock:^{
                                                                [self playSoundWithName:@"digital.mp3"];
                                                            }
                                                                  stopActionBlock:^{
                                                                      [self.avPlayer stop];
                                                                  }];
    
    JLSelectionObject *doorbellPremiumSound = [JLSelectionObject objectWithDisplayName:@"Doorbell"
                                                                            image:[UIImage imageNamed:@"icon-iPodMusic.png"]
                                                                isSelectableBlock:^{
                                                                    return [self.hasPurchasedUpgradeSwitch isOn];
                                                                }
                                                            actionWhenTappedBlock:^{
                                                                if ([self.hasPurchasedUpgradeSwitch isOn])
                                                                    [self playSoundWithName:@"doorbell.mp3"];
                                                                else
                                                                    [[[UIAlertView alloc] initWithTitle:@"Sorry" message:@"You need to purchase the upgrade!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
                                                            }
                                                                  stopActionBlock:^{
                                                                      [self.avPlayer stop];
                                                                  }];
    JLSelectionObject *duckPremiumSound = [JLSelectionObject objectWithDisplayName:@"Duck"
                                                                            image:[UIImage imageNamed:@"icon-iPodMusic.png"]
                                                                isSelectableBlock:^{
                                                                    return [self.hasPurchasedUpgradeSwitch isOn];
                                                                }
                                                            actionWhenTappedBlock:^{
                                                                if ([self.hasPurchasedUpgradeSwitch isOn])
                                                                    [self playSoundWithName:@"duck.mp3"];
                                                                else
                                                                    [[[UIAlertView alloc] initWithTitle:@"Sorry" message:@"You need to purchase the upgrade!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
                                                            }
                                                                  stopActionBlock:^{
                                                                      [self.avPlayer stop];
                                                                  }];


    NSArray *normalObjectsArray = @[cricketsSound, digitalSound];
    NSArray *premiumObjectsArray = @[doorbellPremiumSound, duckPremiumSound];
    
    //creates the datasource for the table
    [destinationVC insertSectionWithTitle:nil withRows:normalObjectsArray];
    [destinationVC insertSectionWithTitle:@"Premium Sounds" withRows:premiumObjectsArray withSectionFooter:@"Choose any number of sounds"];
    
    //set which items are preselected
    [destinationVC setSelectionsByEnumeration:^BOOL(id object) {
        for (NSString *soundName in self.chosenSounds)
        {
            if ([[object getDisplayName] isEqualToString:soundName])
                return YES;
        }
        return NO;
    }];
}

- (void) playSoundWithName:(NSString*)name
{
    //method takes a selected sound and plays it
    
    NSString *fileName = [name stringByDeletingPathExtension];
    NSString *fileExtension = [name pathExtension];
    NSString* soundFilePath = [[NSBundle mainBundle] pathForResource:fileName ofType:fileExtension];
    NSURL *fileURL = [NSURL fileURLWithPath:soundFilePath];
    
    self.avPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:fileURL error:nil];
    self.avPlayer.numberOfLoops = -1;
    [self.avPlayer play];
}

//delegate method implementation
- (void) JLSelectionTVC:(JLSelectionTVC *)sender selection:(NSArray *)selectionObjectsArray
{
    self.playlistLabel.text = @"";
    [self.chosenSounds removeAllObjects];
    
    for (JLSelectionObject *obj in selectionObjectsArray)
    {
        [self.chosenSounds addObject:[obj getDisplayName]];
    }

    for (NSString *soundName in self.chosenSounds)
    {
        NSString *soundNameFormatted = [NSString stringWithFormat:@"%@\n", soundName];
        self.playlistLabel.text = [self.playlistLabel.text stringByAppendingString:soundNameFormatted];
    }
}

@end