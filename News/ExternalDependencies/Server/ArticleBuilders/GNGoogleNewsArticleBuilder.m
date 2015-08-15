#import "GNGoogleNewsArticleBuilder.h"
#import "GNAbstractArticleBuilder_protected.h"

@implementation GNGoogleNewsArticleBuilder

- (GNArticle *)createArticleFromRssEntry:(GNRssEntry *)rssEntry {
    GNArticle *article = [[GNArticle alloc] init];
    article.uniqueId = rssEntry.guid;
    article.title = [self extractRealTitleFromTitle:rssEntry.title];
    article.summary = rssEntry.summary;
    article.sourceUrl = [self sourceUrlFromRssLink:rssEntry.link];
    article.imageUrl = [self imageUrlFromSummary:article.summary];
    article.publisher = [self extractPublisherFromTitle:rssEntry.title];
    article.publishedDate = [NSDate dateFromInternetDateTimeString:rssEntry.pubDate
                                                        formatHint:DateFormatHintRFC822];
    return article;
}

#pragma mark - Extracting title

- (NSString *)extractRealTitleFromTitle:(NSString *)title {
    NSRange separatorRange = [title rangeOfString:@" - "];
    return [title substringToIndex:separatorRange.location];
}

#pragma mark - Extracting publisher info

- (NSString *)extractPublisherFromTitle:(NSString *)title {
    NSRange separatorRange = [title rangeOfString:@" - "];
    return [title substringFromIndex:separatorRange.location + separatorRange.length];
}

#pragma mark - Extracting source url

- (NSString *)sourceUrlFromRssLink:(NSString *)rssLink {
    __block NSString *sourceUrl = nil;    
    NSURLComponents *components = [NSURLComponents componentsWithString:rssLink];
    [components.queryItems enumerateObjectsUsingBlock:^(NSURLQueryItem *queryItem, NSUInteger index, BOOL *stop) {
        if ([queryItem.name isEqualToString:@"url"]) {
            sourceUrl = queryItem.value;
            *stop = YES;
        }
    }];
    
    return sourceUrl;
}

#pragma mark - Extracting image url

- (NSString *)imageUrlFromSummary:(NSString *)summary {
    GDataXMLDocument *document = [[GDataXMLDocument alloc] initWithHTMLString:summary
                                                                        error:nil];
    NSArray *imageNodes = [document nodesForXPath:@"//img"
                                            error:nil];
    __block NSString *imageUrl = nil;
    [imageNodes enumerateObjectsUsingBlock:^(GDataXMLNode *node, NSUInteger index, BOOL *stop) {
        GDataXMLElement *xmlElement = (GDataXMLElement *)node;
        GDataXMLNode *imageSourceAttribute = [xmlElement attributeForName:@"src"];
        
        if (imageSourceAttribute) {
            imageUrl = [@"http:" stringByAppendingString:imageSourceAttribute.stringValue];
            *stop = YES;
        }        
    }];
    
    return imageUrl;
}

@end
