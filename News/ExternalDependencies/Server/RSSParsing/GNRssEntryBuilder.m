#import "GNRssEntryBuilder.h"
#import "GDataXMLElement+GNAdditions.h"
#import "GNRssEntry.h"

@implementation GNRssEntryBuilder

- (NSArray *)buildRssEntriesFromFeedData:(NSData *)feedData
                                   error:(NSError **)error
{
    GDataXMLDocument *document = [[GDataXMLDocument alloc] initWithData:feedData
                                                               encoding:NSUTF8StringEncoding
                                                                  error:error];
    if (!document) {
        return nil;
    }
    
    return [self parseRssEntriesFromXmlDocument:document];
}

- (NSArray *)parseRssEntriesFromXmlDocument:(GDataXMLDocument *)xmlDocument {
    NSMutableArray *allRssEntries = [@[] mutableCopy];
    
    GDataXMLElement *rootElement = xmlDocument.rootElement;
    NSArray *channels = [rootElement elementsForName:@"channel"];
    
    [channels enumerateObjectsUsingBlock:^(GDataXMLElement *channel, NSUInteger index, BOOL *stop) {
        NSArray *entries = [self parseRssEntriesFromChannel:channel];
        [allRssEntries addObjectsFromArray:entries];
    }];
    
    return [allRssEntries copy];
}

- (NSArray *)parseRssEntriesFromChannel:(GDataXMLElement *)channel {
    NSMutableArray *rssEntries = [@[] mutableCopy];
    NSArray *items = [channel elementsForName:@"item"];
    
    [items enumerateObjectsUsingBlock:^(GDataXMLElement *item, NSUInteger index, BOOL *stop) {
        GNRssEntry *rssEntry = [self createRssEntryFromItem:item];
        [rssEntries addObject:rssEntry];
    }];
    
    return [rssEntries copy];
}

- (GNRssEntry *)createRssEntryFromItem:(GDataXMLElement *)item {
    GNRssEntry *rssEntry = [[GNRssEntry alloc] init];
    rssEntry.guid = [item valueForChild:@"guid"];
    rssEntry.title = [item valueForChild:@"title"];
    rssEntry.link = [item valueForChild:@"link"];
    rssEntry.summary = [item valueForChild:@"description"];
    rssEntry.pubDate = [item valueForChild:@"pubDate"];    
    return rssEntry;
}

@end
