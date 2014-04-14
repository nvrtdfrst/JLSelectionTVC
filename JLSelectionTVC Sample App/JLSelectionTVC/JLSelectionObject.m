//
//  JLSelectionObject.m
//  
//
//  Created by nvrtd frst on 4/11/14.
//

#import "JLSelectionObject.h"

@implementation JLSelectionObject


#pragma mark - Copying Methods

- (id)copyWithZone:(NSZone *)zone
{
    JLSelectionObject *newObject = [[[self class] allocWithZone:zone] init];
    if (newObject)
    {
        newObject.displayName = self.displayName;
        newObject.image = self.image;
        newObject.isSelectableBlock = self.isSelectableBlock;
        newObject.actionWhenTappedBlock = self.actionWhenTappedBlock;
        newObject.stopActionBlock = self.stopActionBlock;
    }
    return newObject;
}


#pragma mark - Constructors

+ (instancetype) objectWithDisplayName:(NSString*)displayName
{
    JLSelectionObject *newObject = [[self class] new];
    newObject.displayName = displayName;
    
    return newObject;
}

+ (instancetype) objectWithDisplayName:(NSString*)displayName
                                 image:(UIImage*)image
{
    JLSelectionObject *newObject = [[self class] new];
    newObject.displayName = displayName;
    newObject.image = image;
    
    return newObject;
}

+ (instancetype) objectWithDisplayName:(NSString*)displayName
                                 image:(UIImage*)image
                     isSelectableBlock:(BOOL (^)(void))isSelectableBlock
                 actionWhenTappedBlock:(void (^)(void))actionWhenTappedBlock
                       stopActionBlock:(void (^)(void))stopActionBlock
{
    JLSelectionObject *newObject = [[self class] new];
    newObject.displayName = displayName;
    newObject.image = image;
    newObject.isSelectableBlock = isSelectableBlock;
    newObject.actionWhenTappedBlock = actionWhenTappedBlock;
    newObject.stopActionBlock = stopActionBlock;
    
    return newObject;
}


#pragma mark - JLSelectionTVCDataObject protocol methods

- (NSString*) getDisplayName
{
    return self.displayName;
}

- (UIImage*) getImage
{
    return self.image;
}

- (BOOL) isSelectable
{
    //defaults to YES
    if (self.isSelectableBlock)
        return self.isSelectableBlock();
    else
        return YES;
}

- (void) startActionWhenTapped
{
    if (self.actionWhenTappedBlock)
        self.actionWhenTappedBlock();
}

- (void) stopAction
{
    if (self.stopActionBlock)
        self.stopActionBlock();
}

@end
