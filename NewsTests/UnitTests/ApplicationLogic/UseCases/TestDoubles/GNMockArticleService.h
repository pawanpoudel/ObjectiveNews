#import "GNArticleService.h"

@interface GNMockArticleService : NSObject <GNArticleService>

@property (nonatomic) NSInteger numberOfArticlesToReturn;
@property (nonatomic) NSError *errorToReturn;

@end
