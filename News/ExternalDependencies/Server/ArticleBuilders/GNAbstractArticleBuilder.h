@import Foundation;
@class GNRssEntryBuilder;

extern NSString * const GNArticleBuilderErrorDomain;

typedef NS_ENUM(NSInteger, GNArticleBuilderErrorCode) {
    GNArticleBuilderErrorCodeNone = 0,
    GNArticleBuilderErrorCodeInvalidFeedFormat
};

@interface GNAbstractArticleBuilder : NSObject

- (instancetype)initWithRssEntryBuilder:(GNRssEntryBuilder *)rssEntryBuilder NS_DESIGNATED_INITIALIZER;
- (NSArray *)buildArticlesFromRssData:(NSData *)rssData
                                error:(NSError **)error;

@end
