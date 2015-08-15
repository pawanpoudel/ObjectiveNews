#import "GNCoreDataStack.h"
#import "NSManagedObjectContext+GNAdditions.h"
@import UIKit;

static NSString * const kPersistentStoreFileName = @"GoogleNews.sqlite";

@interface GNCoreDataStack() <UIAlertViewDelegate>

@property (nonatomic, copy) NSString *persistentStoreType;
@property (nonatomic) NSManagedObjectContext *masterSavingContext;
@property (nonatomic) NSManagedObjectContext *mainQueueContext;
@property (nonatomic) NSManagedObjectModel *managedObjectModel;
@property (nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

@end

@implementation GNCoreDataStack

#pragma mark - Initializing a core data stack

- (instancetype)initWithPersistentStoreType:(NSString *)storeType {
    self = [super init];
    
    if (self) {
        _persistentStoreType = storeType;
    }
    
    return self;
}

- (NSString *)persistentStoreType {
    if (!_persistentStoreType) {
        _persistentStoreType = NSSQLiteStoreType;
    }
    
    return _persistentStoreType;
}

#pragma mark - Saving main queue context

- (void)saveContextForMainQueue {
    [self.mainQueueContext saveRecursively];
}

#pragma mark - Creating managed object contexts

- (NSManagedObjectContext *)masterSavingContext {
    if (!_masterSavingContext) {
        _masterSavingContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
        _masterSavingContext.persistentStoreCoordinator = self.persistentStoreCoordinator;
        _masterSavingContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy;
    }
    
    return _masterSavingContext;
}

- (NSManagedObjectContext *)mainQueueContext {
    if (!_mainQueueContext) {
        _mainQueueContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
        _mainQueueContext.parentContext = self.masterSavingContext;
        _mainQueueContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy;
    }
    
    return _mainQueueContext;
}

#pragma mark - Creating managed object model

- (NSManagedObjectModel *)managedObjectModel {
    if (!_managedObjectModel) {
        NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"GoogleNews"
                                                  withExtension:@"momd"];
        _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    }
    
    return _managedObjectModel;
}

#pragma mark - Creating persistent store coordinator

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    if (!_persistentStoreCoordinator) {
        _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:self.managedObjectModel];
        
        NSError *error = nil;
        
        if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType
                                                       configuration:nil
                                                                 URL:[self persistentStoreURL]
                                                             options:[self autoMigrateOptions]
                                                               error:&error])
        {
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            dispatch_async(dispatch_get_main_queue(), ^{
                [self showFatalAlert];
            });
        }
    }
    
    return _persistentStoreCoordinator;
}

- (NSDictionary *)autoMigrateOptions {
    return @{ NSMigratePersistentStoresAutomaticallyOption: @YES,
              NSInferMappingModelAutomaticallyOption: @YES };
}

#pragma mark - Showing fatal error alert

- (void)showFatalAlert {
    NSString *title = NSLocalizedString(@"A fatal error occurred", nil);
    NSString *message = NSLocalizedString(@"This app will quit when you tap OK. Please re-launch the app.", nil);
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
                                                    message:message
                                                   delegate:self
                                          cancelButtonTitle:NSLocalizedString(@"OK", nil)
                                          otherButtonTitles:nil];
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView
    clickedButtonAtIndex:(NSInteger)buttonIndex
{
    abort();
}

#pragma mark - Finding applications' documents directory

- (NSURL *)applicationDocumentsDirectory {
    NSArray *urls = [[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory
                                                           inDomains:NSUserDomainMask];
    return [urls lastObject];
}

- (NSURL *)persistentStoreURL {
    return [self.applicationDocumentsDirectory URLByAppendingPathComponent:kPersistentStoreFileName];
}

@end
