//
//  JLSelectionTVC.m
//  
//
//  Created by nvrtd frst on 3/1/13.
//

#import "JLSelectionTVC.h"

@interface JLSelectionTVC ()
@property (nonatomic, strong) NSMutableArray *allObjectsArrayOfArrays;
@property (nonatomic, strong) NSMutableArray *selectionObjectsArray;
@property (nonatomic, strong) NSMutableDictionary *sectionTitlesDictionary;
@property (nonatomic, strong) NSMutableDictionary *sectionFootersDictionary;
@property (nonatomic, strong) id previousObjectPerformingAction;
@end


@implementation JLSelectionTVC


#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.tableView reloadData];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [self.delegate JLSelectionTVC:self selection:[self.selectionObjectsArray copy]];
    
    //stop any actions that might have started in the objects upon removing this view
    if ([self.previousObjectPerformingAction respondsToSelector:@selector(stopAction)])
        [self.previousObjectPerformingAction stopAction];
    
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

-(NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

-(BOOL)shouldAutorotate
{
    return NO;
}


#pragma mark - Lazy Instantiation

- (NSMutableArray*) allObjectsArrayOfArrays
{
    if (!_allObjectsArrayOfArrays)
        _allObjectsArrayOfArrays = [NSMutableArray array];
    
    return _allObjectsArrayOfArrays;
}

- (NSMutableArray*) selectionObjectsArray
{
    if (!_selectionObjectsArray)
        _selectionObjectsArray = [NSMutableArray array];
    
    return _selectionObjectsArray;
}

- (NSMutableDictionary*) sectionTitlesDictionary
{
    if (!_sectionTitlesDictionary)
        _sectionTitlesDictionary = [NSMutableDictionary dictionary];
    
    return _sectionTitlesDictionary;
}

- (NSMutableDictionary*) sectionFootersDictionary
{
    if (!_sectionFootersDictionary)
        _sectionFootersDictionary = [NSMutableDictionary dictionary];
    
    return _sectionFootersDictionary;
}


#pragma mark - Main Methods

//public method
- (void) insertSectionWithTitle:(NSString*)sectionTitle withRows:(NSArray*)objectsArray
{
    [self insertSectionWithTitle:sectionTitle withRows:objectsArray withSectionFooter:nil];
}

//public method
- (void) insertSectionWithTitle:(NSString*)sectionTitle withRows:(NSArray*)objectsArray withSectionFooter:(NSString*)sectionFooter
{
    //add the sectionTitle to the sectionTitlesDictionary
    if (sectionTitle)
        [self.sectionTitlesDictionary setObject:sectionTitle forKey:@(self.allObjectsArrayOfArrays.count)];
    else
        [self.sectionTitlesDictionary setObject:[NSNull null] forKey:@(self.allObjectsArrayOfArrays.count)];
    
    //add the sectionFooter to the secionFootersDictionary
    if (sectionFooter)
        [self.sectionFootersDictionary setObject:sectionFooter forKey:@(self.allObjectsArrayOfArrays.count)];
    else
        [self.sectionFootersDictionary setObject:[NSNull null] forKey:@(self.allObjectsArrayOfArrays.count)];
    
    //add objectsArray to the allObjectsArrayOfArrays
    if (objectsArray)
        [self.allObjectsArrayOfArrays addObject:objectsArray];
}

//public method
- (void) setSelectionsByEnumeration:(BOOL (^)(id object))enumerationBlock
{
    //enumerate through the all objects applying enumerationBlock and adding selected objects to selection
    [self.allObjectsArrayOfArrays enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop)
     {
         if ([obj isKindOfClass:[NSArray class]])
         {
             [obj enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop)
              {
                  //if enumerationBlock returns YES then add to selection
                  if (enumerationBlock(obj))
                      [self addObjectToSelectionObjectsArray:obj];
              }];
             
         } else {
             
             //if enumerationBlock returns YES then add to selection
             if (enumerationBlock(obj))
                 [self addObjectToSelectionObjectsArray:obj];
         }
     }];
}


#pragma mark - Helper Methods

- (NSIndexPath*) indexPathForObject:(id)object
{
    NSIndexPath *indexPath;
    
    for (NSArray *topLevelArray in self.allObjectsArrayOfArrays)
    {
        for (id aObject in topLevelArray)
        {
            if ([aObject isEqual:object])
            {
                indexPath = [NSIndexPath indexPathForRow:[topLevelArray indexOfObject:aObject] inSection:[self.allObjectsArrayOfArrays indexOfObject:topLevelArray]];
                return indexPath;
            }
        }
    }
    
    return indexPath;
}

- (id) objectAtIndexPath:(NSIndexPath*)indexPath
{
    return (self.allObjectsArrayOfArrays)[indexPath.section][indexPath.row];
}

- (void) addObjectToSelectionObjectsArray:(id)object
{
    if (object)
        [self.selectionObjectsArray addObject:object];
}

- (void) startActionForObject:(id)object
{
    //first stop action if any previous object is performing an action
    [self stopActionForPreviousObject];
    
    //call optional protocol method to start the action for the object
    if ([object respondsToSelector:@selector(startActionWhenTapped)])
        [object startActionWhenTapped];
    
    //keep this object in memory so that can stop this action before starting action on another object
    self.previousObjectPerformingAction = object;
}

- (void) stopActionForPreviousObject
{
    if ([self.previousObjectPerformingAction respondsToSelector:@selector(stopAction)])
        [self.previousObjectPerformingAction stopAction];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.allObjectsArrayOfArrays.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray *objectsArrayForSection = (self.allObjectsArrayOfArrays)[section];
    
    return objectsArrayForSection.count;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    id sectionTitle = (self.sectionTitlesDictionary)[@(section)];
    
    if ([sectionTitle isKindOfClass:[NSString class]]) return sectionTitle;
    else return nil;
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section
{
    id sectionFooter = (self.sectionFootersDictionary)[@(section)];
    
    if ([sectionFooter isKindOfClass:[NSString class]]) return sectionFooter;
    else return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"checkMarkCell"];
    
    //configure cell
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    //get the corresponding objects for this cell from the datasource
    id objectsArray = (self.allObjectsArrayOfArrays)[indexPath.section];
    id object = objectsArray[indexPath.row];
    
    //set cell title depending on whether object is one that implements JLSelectionTVCDataObject protocol or is simply an NSString
    NSString *cellLabelText;
    if ([object isKindOfClass:[NSString class]])
        cellLabelText = object;
    else if ([object respondsToSelector:@selector(getDisplayName)])
        cellLabelText = [object getDisplayName];
    else
        cellLabelText = nil;
    
    cell.textLabel.text = cellLabelText;
    
    //set cell image if exists
    if ([object respondsToSelector:@selector(getImage)])
    {
        UIImage* image = [object getImage];
        
        if (image)
            cell.imageView.image = image;
        else
            cell.imageView.image = nil;
    }
    
    //check if object is selected. If so put a checkmark
    if ([self.selectionObjectsArray containsObject:object])
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    else
        cell.accessoryType = UITableViewCellAccessoryNone;
    
    return cell;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //init variables
    id selectedObject = [self objectAtIndexPath:indexPath];
    BOOL isObjectSelectable = YES; //defaults to selectable
    
    if ([selectedObject respondsToSelector:@selector(isSelectable)])
        isObjectSelectable = [selectedObject isSelectable];
    
    //show checkmark if the object is selectable
    if(isObjectSelectable)
    {
        if (self.isMultipleSelection == NO)
        {
            //clear any previous selection, then add the new selected object
            [self.selectionObjectsArray removeAllObjects];
            if (selectedObject)
                [self.selectionObjectsArray addObject:selectedObject];
            
            //start the action for the object
            [self startActionForObject:selectedObject];
            
            [self.tableView reloadData];
            
        } else {
            
            //multiple selection mode
            if ([self.selectionObjectsArray containsObject:selectedObject])
            {
                //object was deselected
                [self.selectionObjectsArray removeObject:selectedObject];
                
                //if any object was performing an action, stop it
                [self stopActionForPreviousObject];
                
            } else {
                
                //object was selected
                if (selectedObject)
                    [self.selectionObjectsArray addObject:selectedObject];
                
                //start the action for the object
                [self startActionForObject:selectedObject];
            }
            
            //reload the changed cell
            [self.tableView reloadRowsAtIndexPaths:@[indexPath]
                                  withRowAnimation:UITableViewRowAnimationNone];
        }
        
    } else {
        
        //object can't be selected but was tapped. Start the action for the object
        [self startActionForObject:selectedObject];
    }
}


#pragma mark - UI Methods

- (IBAction) dismissVCAction:(id)sender
{
    //when view disappears, it will call the delegate method
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
