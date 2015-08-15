#import "GDataXMLNode.h"

@interface GDataXMLElement (GNAdditions)

- (GDataXMLElement *)elementForChild:(NSString *)childName;
- (NSString *)valueForChild:(NSString *)childName;

@end
