@import Foundation;

@interface GNTestRssData : NSObject

- (NSData *)invalidRssData;
- (NSData *)validRssData;
- (NSData *)validGoogleNewsRssData;
- (NSData *)validAppleNewsRssData;
- (NSInteger)numberOfItemsInValidRss;

@end
