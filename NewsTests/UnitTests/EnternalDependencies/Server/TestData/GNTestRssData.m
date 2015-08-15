#import "GNTestRssData.h"

@implementation GNTestRssData

- (NSData *)invalidRssData {
    return [@"Invalid XML" dataUsingEncoding:NSUTF8StringEncoding];
}

- (NSData *)validRssData {
    return [self validGoogleNewsRssData];
}

- (NSInteger)numberOfItemsInValidRss {
    return 2;
}

- (NSData *)validGoogleNewsRssData {
    NSBundle *testBundle = [NSBundle bundleForClass:[self class]];
    NSString *path = [testBundle pathForResource:@"validGoogleNewsRssFeed"
                                          ofType:@"xml"];
    return [NSData dataWithContentsOfFile:path];
}

- (NSData *)validAppleNewsRssData {
    NSBundle *testBundle = [NSBundle bundleForClass:[self class]];
    NSString *path = [testBundle pathForResource:@"validAppleNewsRssFeed"
                                          ofType:@"xml"];
    return [NSData dataWithContentsOfFile:path];    
}

@end
