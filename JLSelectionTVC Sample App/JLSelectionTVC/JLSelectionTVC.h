//
//  JLSelectionTVC.h
//  
//
//  Created by nvrtd frst on 3/1/13.
//

#import <UIKit/UIKit.h>


@class JLSelectionTVC;

//all selectable objects should either conform to this protocol or be NSString
@protocol JLSelectionObjectProtocol <NSObject>
- (NSString*) getDisplayName;
@optional
- (UIImage*) getImage;
- (BOOL) isSelectable;
- (void) startActionWhenTapped;
- (void) stopAction;
@end

//delgate protocol
@protocol JLSelectionTVCDelegate
- (void) JLSelectionTVC:(JLSelectionTVC*)sender selection:(NSArray*)selectionObjectsArray;
@end


@interface JLSelectionTVC : UITableViewController

@property (nonatomic, weak) id <JLSelectionTVCDelegate> delegate;
@property (nonatomic) BOOL isMultipleSelection;
@property (nonatomic, strong, readonly) NSMutableArray *allObjectsArrayOfArrays; //Contains all possible objects. Objects should either be NSString or objects that implement the JLSelectionTVCDataObject protocol.
@property (nonatomic, strong, readonly) NSMutableArray *selectionObjectsArray; //An array of the selected objects.


- (void) insertSectionWithTitle:(NSString*)sectionTitle withRows:(NSArray*)objectsArray;
- (void) insertSectionWithTitle:(NSString*)sectionTitle withRows:(NSArray*)objectsArray withSectionFooter:(NSString*)sectionFooter;
- (void) setSelectionsByEnumeration:(BOOL (^)(id object))enumerationBlock;


@end