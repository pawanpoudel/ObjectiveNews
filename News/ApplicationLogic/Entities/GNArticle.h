@import Foundation;

@interface GNArticle : NSObject

@property (nonatomic, copy) NSString *uniqueId;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *summary;
@property (nonatomic, copy) NSString *sourceUrl;
@property (nonatomic, copy) NSString *publisher;
@property (nonatomic, copy) NSString *imageUrl;
@property (nonatomic) NSDate *publishedDate;

@end
