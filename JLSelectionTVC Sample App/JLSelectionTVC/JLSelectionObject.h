//
//  JLSelectionObject.h
//  
//
//  Created by nvrtd frst on 4/11/14.
//

#import <Foundation/Foundation.h>
#import "JLSelectionTVC.h"

@interface JLSelectionObject : NSObject <JLSelectionObjectProtocol, NSCopying>

@property (nonatomic, copy) NSString* displayName;
@property (nonatomic, strong) UIImage* image;
@property (nonatomic, copy) BOOL (^isSelectableBlock)();
@property (nonatomic, copy) void (^actionWhenTappedBlock)();
@property (nonatomic, copy) void (^stopActionBlock)();

//Constructors
+ (instancetype) objectWithDisplayName:(NSString*)displayName;
+ (instancetype) objectWithDisplayName:(NSString*)displayName
                                 image:(UIImage*)image;
+ (instancetype) objectWithDisplayName:(NSString*)displayName
                                 image:(UIImage*)image
                     isSelectableBlock:(BOOL (^)(void))isSelectableBlock
                 actionWhenTappedBlock:(void (^)(void))actionWhenTappedBlock
                       stopActionBlock:(void (^)(void))stopActionBlock;

//JLSelectionobjectProtocol methods
- (NSString*) getDisplayName;
- (UIImage*) getImage;
- (BOOL) isSelectable;
- (void) startActionWhenTapped;
- (void) stopAction;

@end
