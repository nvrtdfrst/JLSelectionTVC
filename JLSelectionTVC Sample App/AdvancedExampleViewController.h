//
//  AdvancedExampleViewController.h
//  JLSelectionTVC Sample App
//
//  Created by nvrtd frst on 4/14/14.
//  Copyright (c) 2014 j labs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JLSelectionTVC.h"
#import "JLSelectionObject.h"
#import <AVFoundation/AVFoundation.h>

@interface AdvancedExampleViewController : UIViewController <JLSelectionTVCDelegate>

@property (nonatomic, strong) NSMutableArray *chosenSounds;
@property (nonatomic, strong) AVAudioPlayer *avPlayer;
@property (weak, nonatomic) IBOutlet UILabel *playlistLabel;
@property (weak, nonatomic) IBOutlet UISwitch *hasPurchasedUpgradeSwitch;

@end
