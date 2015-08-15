#import "GNArticle.h"

@implementation GNArticle

#pragma mark - Checking equality

- (BOOL)isEqual:(id)otherObject {
    if (self == otherObject) {
        return YES;
    }
    
    if (![otherObject isKindOfClass:[GNArticle class]]) {
        return NO;
    }
    
    return [self isEqualToArticle:(GNArticle *)otherObject];
}

- (BOOL)isEqualToArticle:(GNArticle *)otherArticle {
    if (!otherArticle) {
        return NO;
    }
    
    return self.uniqueId && [self.uniqueId isEqualToString:otherArticle.uniqueId];
}

- (NSUInteger)hash {
    return [self.uniqueId hash];
}

@end
