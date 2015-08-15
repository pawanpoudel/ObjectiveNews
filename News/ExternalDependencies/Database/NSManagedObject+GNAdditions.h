@import CoreData;

@interface NSManagedObject (GNAdditions)

+ (instancetype)createManagedObjectInContext:(NSManagedObjectContext *)context;

@end
