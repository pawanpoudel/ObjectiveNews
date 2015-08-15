@import Foundation;

extern NSString * const GNNetworkCommunicatorErrorDomain;

@interface GNNetworkCommunicator : NSObject

- (void)performRequest:(NSURLRequest *)request
     completionHandler:(void(^)(NSData *data, NSError *error))completionHandler;

@end
