#import "GNArticleUrlRequest.h"
#import "GNArticleService.h"

@import Foundation;
@class GNAbstractArticleBuilder;
@class GNNetworkCommunicator;

@interface GNArticleApiClient : NSObject <GNArticleService>

- (instancetype)initWithArticleUrlRequest:(id<GNArticleUrlRequest>)articleUrlRequest
                      networkCommunicator:(GNNetworkCommunicator *)networkCommunicator
                           articleBuilder:(GNAbstractArticleBuilder *)articleBuilder NS_DESIGNATED_INITIALIZER;

@end
