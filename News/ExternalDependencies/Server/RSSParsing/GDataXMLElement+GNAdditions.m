#import "GDataXMLElement+GNAdditions.h"

@implementation GDataXMLElement (GNAdditions)

- (GDataXMLElement *)elementForChild:(NSString *)childName {
    NSArray *children = [self elementsForName:childName];
    
    if (children.count > 0) {
        return (GDataXMLElement *)[children firstObject];
    }
    
    return nil;
}

- (NSString *)valueForChild:(NSString *)childName {    
    return [[self elementForChild:childName] stringValue];    
}

@end
