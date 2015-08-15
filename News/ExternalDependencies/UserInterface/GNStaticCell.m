#import "GNStaticCell.h"

@implementation GNStaticCell

+ (NSString *)reuseIdentifier {
    return NSStringFromClass([self class]);
}

+ (NSString *)nibName {
    return NSStringFromClass([self class]);
}

+ (CGFloat)height {
    return 40.0f;
}

@end
