#import "GNAbstractArticleBuilder_protected.h"
#import "GNRssEntryBuilder.h"

NSString * const GNArticleBuilderErrorDomain = @"GNArticleBuilderErrorDomain";

@interface GNAbstractArticleBuilder ()

@property (nonatomic) NSError * __autoreleasing *error;
@property (nonatomic) GNRssEntryBuilder *rssEntryBuilder;

@end

@implementation GNAbstractArticleBuilder

#pragma mark - Initializing a builder

- (instancetype)initWithRssEntryBuilder:(GNRssEntryBuilder *)rssEntryBuilder {
    self = [super init];
    
    if (self) {
        _rssEntryBuilder = rssEntryBuilder;
    }
    
    return self;
}

#pragma mark - Building articles

- (NSArray *)buildArticlesFromRssData:(NSData *)rssData
                                error:(NSError **)error
{
    self.error = error;
    NSArray *rssEntries = [self.rssEntryBuilder buildRssEntriesFromFeedData:rssData
                                                                      error:nil];
    if (!rssEntries) {
        [self buildInvalidFeedFormatError];
        return nil;
    }
    
    return [self createArticlesFromRssEntries:rssEntries];
}

- (void)buildInvalidFeedFormatError {
    if (self.error) {
        NSString *errorMessage = NSLocalizedString(@"Failed to parse RSS feed. Make sure the format is correct.", nil);
        NSDictionary *userInfo = @{ NSLocalizedDescriptionKey: errorMessage };
        *self.error = [NSError errorWithDomain:GNArticleBuilderErrorDomain
                                          code:GNArticleBuilderErrorCodeInvalidFeedFormat
                                      userInfo:userInfo];
    }
}

- (NSArray *)createArticlesFromRssEntries:(NSArray *)rssEntries {
    NSMutableArray *articles = [@[] mutableCopy];
    [rssEntries enumerateObjectsUsingBlock:^(GNRssEntry *rssEntry, NSUInteger index, BOOL *stop) {
        GNArticle *article = [self createArticleFromRssEntry:rssEntry];
        [articles addObject:article];
    }];
    
    return [articles copy];
}

- (GNArticle *)createArticleFromRssEntry:(GNRssEntry *)rssEntry {
    NSString *reason = [NSString stringWithFormat:@"Subclass must override %@ method.", NSStringFromSelector(_cmd)];
    NSException *exception = [NSException exceptionWithName:@"Missing implementation"
                                                     reason:reason
                                                   userInfo:nil];
    [exception raise];
    return nil;
}

@end
