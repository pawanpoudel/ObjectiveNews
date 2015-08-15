#import "GNAppleNewsArticleBuilder.h"
#import "GNAbstractArticleBuilder_protected.h"

@implementation GNAppleNewsArticleBuilder

- (GNArticle *)createArticleFromRssEntry:(GNRssEntry *)rssEntry {
    GNArticle *article = [[GNArticle alloc] init];
    article.uniqueId = rssEntry.guid ? rssEntry.guid : rssEntry.link;
    article.title = rssEntry.title;
    article.summary = rssEntry.summary;
    article.sourceUrl = rssEntry.link;
    article.publisher = [self domainNameFromSourceUrl:article.sourceUrl];
    article.publishedDate = [NSDate dateFromInternetDateTimeString:rssEntry.pubDate
                                                        formatHint:DateFormatHintRFC822];
    return article;
}

#pragma mark - Extracting publisher info

- (NSString *)domainNameFromSourceUrl:(NSString *)sourceUrl {
    NSURLComponents *components = [NSURLComponents componentsWithString:sourceUrl];
    NSString *host = [self removeWWWFromHost:components.host];
    return [self removeDotComFromHost:host];
}

- (NSString *)removeWWWFromHost:(NSString *)host {
    NSRange range = [host rangeOfString:@"www."];
    if ((range.location != NSNotFound) && (range.location == 0)) {
        host = [host stringByReplacingOccurrencesOfString:@"www."
                                               withString:@""];
    }
    
    return host;
}

- (NSString *)removeDotComFromHost:(NSString *)host {
    NSString *dotCom = @".com";
    NSRange range = [host rangeOfString:dotCom];
    
    NSUInteger dotComLocation = host.length - dotCom.length;
    if ((range.location != NSNotFound) && (range.location == dotComLocation)) {
        host = [host stringByReplacingOccurrencesOfString:dotCom
                                               withString:@""];
    }
    
    return host;
}

@end
