@import Foundation;
@import CoreData;

@interface GNManagedArticle : NSManagedObject

@property (nonatomic, retain) NSString * imageUrl;
@property (nonatomic, retain) NSDate * publishedDate;
@property (nonatomic, retain) NSString * publisher;
@property (nonatomic, retain) NSString * sourceUrl;
@property (nonatomic, retain) NSString * summary;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * uniqueId;

@end
