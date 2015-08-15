#import "GNMockNetworkCommunicator.h"

@implementation GNMockNetworkCommunicator

- (void)performRequest:(NSURLRequest *)request
     completionHandler:(void (^)(NSData *, NSError *))completionHandler
{
    self.wasAskedToFetchData = YES;
    self.fetchRequest = request;
    
    if (completionHandler) {
        completionHandler(self.receivedData, self.downloadError);
    }
}

@end
