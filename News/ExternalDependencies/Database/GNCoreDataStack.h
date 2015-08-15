@import Foundation;
@import CoreData;

@interface GNCoreDataStack : NSObject

/*!
    @description Returns a fully configured managed object context meant to
                 be used in main (UI) queue. This context uses a private queue
                 context behind the scene to save changes made to the managed 
                 objects registered in it to the persistent store. This mechanism 
                 reduces the risk of blocking the main queue while saving data.
 */
@property (nonatomic, readonly) NSManagedObjectContext *mainQueueContext;

/*!
    @description Returns a MDCoreDataStack object initialized by
                 using the specified persistent store type.
    @param storeType A NSString object representing the persistent
                     store type. If no store type is specified,
                     NSSQLiteStoreType will be used.
 */
- (instancetype)initWithPersistentStoreType:(NSString *)storeType;

/*!
    @description Attempts to commit unsaved changes to registered objects
                 in managed object context meant to be used in main queue.
 
    @discussion  Although the managed object context is tied to the main
                 queue, the actual saving of data to the persistent store
                 is carried out by a separate managed object context that
                 runs in its own private queue. This approach reduces the
                 risk of blocking main (UI) thread any time a managed object
                 needs to be saved into the database.
 */
- (void)saveContextForMainQueue;

@end
