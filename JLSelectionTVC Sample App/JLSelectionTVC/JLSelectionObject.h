//
//  JLSelectionObject.h
//  
//
//  Created by nvrtd frst on 4/11/14.
//

#import <Foundation/Foundation.h>
#import "JLSelectionTVC.h"

@interface JLSelectionObject : NSObject <JLSelectionObjectProtocol, NSCopying>


/** displayName represents the title of the object when it appears in a JLSelectionTVC tableviewCell **/
@property (nonatomic, copy) NSString* displayName;

/** image represents the UIImage* of the object when it appears in a JLSelectionTVC tableviewCell **/
@property (nonatomic, strong) UIImage* image;

/** isSelectableBlock returns a BOOL which sets whether the JLSelectionTVC tableviewCell is selectable by the user **/
@property (nonatomic, copy) BOOL (^isSelectableBlock)();

/** actionWhenTappedBlock is executed when the JLSelectionTVC tableviewCell is tapped by the user **/
@property (nonatomic, copy) void (^actionWhenTappedBlock)();

/** stopActionBlock is executed when any actions performed by this object need to be stopped **/
@property (nonatomic, copy) void (^stopActionBlock)();


/** Constructors **/
+ (instancetype) objectWithDisplayName:(NSString*)displayName;
+ (instancetype) objectWithDisplayName:(NSString*)displayName
                                 image:(UIImage*)image;
+ (instancetype) objectWithDisplayName:(NSString*)displayName
                                 image:(UIImage*)image
                     isSelectableBlock:(BOOL (^)(void))isSelectableBlock
                 actionWhenTappedBlock:(void (^)(void))actionWhenTappedBlock
                       stopActionBlock:(void (^)(void))stopActionBlock;


/** JLSelectionobjectProtocol methods. Refer to protocol definition in JLSelectionTVC.h for information regarding these methods **/
- (NSString*) getDisplayName;
- (UIImage*) getImage;
- (BOOL) isSelectable;
- (void) startActionWhenTapped;
- (void) stopAction;

@end
