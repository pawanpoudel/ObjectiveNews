#import "NSManagedObject+GNAdditions.h"

@implementation NSManagedObject (GNAdditions)

+ (instancetype)createManagedObjectInContext:(NSManagedObjectContext *)context {
    NSEntityDescription *entity = [NSEntityDescription entityForName:NSStringFromClass([self class])
                                              inManagedObjectContext:context];
    
    return [[[self class] alloc] initWithEntity:entity
                 insertIntoManagedObjectContext:context];
}

@end
