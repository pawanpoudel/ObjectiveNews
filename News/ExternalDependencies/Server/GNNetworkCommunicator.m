#import "GNNetworkCommunicator.h"

NSString * const GNNetworkCommunicatorErrorDomain = @"GNNetworkCommunicatorErrorDomain";

@interface GNNetworkCommunicator ()

@property (copy) void(^completionHandler)(NSData *data, NSError *error);
@property (nonatomic) NSHTTPURLResponse *httpResponse;
@property (nonatomic) NSData *downloadedData;

@end

@implementation GNNetworkCommunicator

- (void)performRequest:(NSURLRequest *)request
     completionHandler:(void(^)(NSData *data, NSError *error))completionHandler
{
    self.completionHandler = completionHandler;
    NSURLSession *session = [NSURLSession sharedSession];    
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request
                                                completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                    if (error) {
                                                        [self notifyCallerWithError:error];
                                                    } else {
                                                        self.downloadedData = data;
                                                        self.httpResponse = (NSHTTPURLResponse *)response;
                                                        [self evaluateResponse];
                                                    }
                                                }];
    [dataTask resume];
}

- (void)notifyCallerWithError:(NSError *)error {
    if (self.completionHandler) {
        self.completionHandler(nil, error);
    }
}

- (void)notifyCallerWithDownloadedData {
    if (self.completionHandler) {
        self.completionHandler(self.downloadedData, nil);
    }
}

- (void)evaluateResponse {
    if ([self isSuccessfulResponse]) {
        [self notifyCallerWithDownloadedData];
    } else {
        NSError *error = [self buildErrorWithHttpStatusCode];
        [self notifyCallerWithError:error];
    }
}

- (NSError *)buildErrorWithHttpStatusCode {
    NSString *errorMessage = NSLocalizedString(@"Server returned non-200 status code.", nil);
    NSDictionary *userInfo = @{ NSLocalizedDescriptionKey : errorMessage };
    return [NSError errorWithDomain:GNNetworkCommunicatorErrorDomain
                               code:self.httpResponse.statusCode
                           userInfo:userInfo];
}

- (BOOL)isSuccessfulResponse {
    NSRegularExpression *regExp = [[NSRegularExpression alloc] initWithPattern:@"2[0-9][0-9]"
                                                                       options:kNilOptions
                                                                         error:nil];
    
    NSString *statusStr = [NSString stringWithFormat:@"%ld", (long)self.httpResponse.statusCode];
    NSArray *matches = [regExp matchesInString:statusStr
                                       options:kNilOptions
                                         range:NSMakeRange(0, statusStr.length)];
    
    if (matches.count > 0) {
        return YES;
    }
    
    return NO;
}

@end
