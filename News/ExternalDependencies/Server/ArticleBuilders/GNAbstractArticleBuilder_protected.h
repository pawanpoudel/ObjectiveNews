#import "GNAbstractArticleBuilder.h"
#import "GNRssEntry.h"
#import "GNArticle.h"
#import "NSDate+InternetDateTime.h"
#import "GDataXMLElement+GNAdditions.h"

@interface GNAbstractArticleBuilder ()

- (GNArticle *)createArticleFromRssEntry:(GNRssEntry *)rssEntry;

@end
