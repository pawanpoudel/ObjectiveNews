@import Foundation;

@interface GNRssEntryBuilder : NSObject

- (NSArray *)buildRssEntriesFromFeedData:(NSData *)feedData
                                   error:(NSError **)error;

@end
