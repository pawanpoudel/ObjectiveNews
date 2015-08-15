@import Foundation;

@interface GNRssEntry : NSObject

@property (nonatomic, copy) NSString *guid;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *link;
@property (nonatomic, copy) NSString *summary;
@property (nonatomic, copy) NSString *pubDate;

@end
