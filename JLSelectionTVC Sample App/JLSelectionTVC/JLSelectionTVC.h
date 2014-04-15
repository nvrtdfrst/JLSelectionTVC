//
//  JLSelectionTVC.h
//  
//
//  Created by nvrtd frst on 3/1/13.
//

#import <UIKit/UIKit.h>


//************************************************/
// JLSelectionObjectProtocol Protocol
//
// All selectable objects should either conform to this protocol or be NSString*
//************************************************/

@protocol JLSelectionObjectProtocol <NSObject>

/** Method should return an NSString* representing the text to show in the tableViewCell title label **/
- (NSString*) getDisplayName;

@optional

/** Optional method should return a UIImage* representing the image to show in the tableViewCell image property **/
- (UIImage*) getImage;

/** Optional method should return whether the user should be able to select the cell associated with the object **/
- (BOOL) isSelectable;

/** Optional method whereby the object can perform an action when tapped **/
- (void) startActionWhenTapped;

/** Optional method to stop any actions that the object performs **/
- (void) stopAction;
@end



//************************************************/
// JLSelectionTVCDelegate Protocol
//************************************************/

@class JLSelectionTVC;

@protocol JLSelectionTVCDelegate

/** Method is called when this class's viewWillDisappear is invoked. selectionObjectsArray is an array of objects that either conform to the JLSelectionObjectProtocol or are NSString* **/
- (void) JLSelectionTVC:(JLSelectionTVC*)sender selection:(NSArray*)selectionObjectsArray;
@end



//************************************************/
// JLSelectionTVC header
//************************************************/

@interface JLSelectionTVC : UITableViewController

/** Delegate **/
@property (nonatomic, weak) id <JLSelectionTVCDelegate> delegate;

/** Determines whether the user should be allow to select only 1 object or select a multitude of objects **/
@property (nonatomic) BOOL isMultipleSelection;

/** This is the cellIdentifier used to identify the cell to dequeue. If nil at the time of table loading, set automatically to @"checkMarkCell" **/
@property (nonatomic, copy) NSString* cellIdentifier;

/** Creates sections of the table and populates each cell with the corresponding object in objectsArray. Objects should either be NSString* or conform to the JLSelectionObjectProtocol. Also allows setting the section title and footer. Can pass nil to any parameter. **/
- (void) insertSectionWithTitle:(NSString*)sectionTitle withRows:(NSArray*)objectsArray withSectionFooter:(NSString*)sectionFooter;

/** Convenience method similar to above except that the section footer is omitted. Can pass nil to any parameter. **/
- (void) insertSectionWithTitle:(NSString*)sectionTitle withRows:(NSArray*)objectsArray;

/** Sets which of the objects are to be preselected when table is first shown to the user. id object represents each one of the objects in the table. Return YES in the block to set it as selected. **/
- (void) setSelectionsByEnumeration:(BOOL (^)(id object))enumerationBlock;


@end