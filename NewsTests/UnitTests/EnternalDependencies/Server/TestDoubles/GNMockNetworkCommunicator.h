#import "GNNetworkCommunicator.h"

@interface GNMockNetworkCommunicator : GNNetworkCommunicator

@property (nonatomic) NSError *downloadError;
@property (nonatomic) NSData *receivedData;
@property (nonatomic) NSURLRequest *fetchRequest;
@property (nonatomic) BOOL wasAskedToFetchData;

@end
