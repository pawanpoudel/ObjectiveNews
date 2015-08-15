#import "NSManagedObjectContext+GNAdditions.h"

@implementation NSManagedObjectContext (GNAdditions)

- (void)saveRecursively {
    [self performBlockAndWait:^{
        if (self.hasChanges) {
            [self saveAlongWithAllParentContexts];
        }
    }];
}

- (void)saveAlongWithAllParentContexts {
    NSError *error = nil;
    
    if (![self save:&error]) {
        NSLog(@"Error saving context: %@", error.localizedDescription);
    } else if (self.parentContext) {
        [self.parentContext saveRecursively];
    }
}

@end
