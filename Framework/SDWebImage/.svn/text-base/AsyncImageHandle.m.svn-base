//
//  AsyncImageHandle.m
//  Hihey
//
//  Created by y xlong on 12-10-9.
//  Copyright (c) 2012年 水蓝 Tech. All rights reserved.
//

#import "AsyncImageHandle.h"

#define kWBRequestTimeOutInterval   180.0

@implementation AsyncImageHandle
@synthesize delegate,OnDownloadFail,OnDownloadComplete;

@synthesize conn = _connection;
@synthesize responseData = _responseData;
@synthesize remoteUrl = _remoteUrl;

-(void) dealloc
{
    [_remoteUrl release]; _remoteUrl = nil;
    [super dealloc];
}

-(id)initWithRemoteURL:(NSURL *) url
{
    if(self = [super init])
    {
        _remoteUrl = [url copy];
    }
    
    return self;
}

-(void)beginDownload
{
    [self cancelDownload];
    
    if(_remoteUrl)
    {
        NSURLRequest * _urlRequest= [[NSURLRequest alloc] initWithURL:self.remoteUrl 
                                                          cachePolicy:NSURLRequestReloadIgnoringLocalCacheData
                                                      timeoutInterval:kWBRequestTimeOutInterval];
        // Begin download
        _connection= [[[NSURLConnection alloc] initWithRequest:_urlRequest
                                                     delegate:self 
                                             startImmediately:YES]autorelease];
    }
}

-(void)cancelDownload
{
    if(_connection)
    {
        [_connection cancel];
        self.conn = nil;
    }
    self.responseData = nil;
}


#pragma - NSURLConnectionDelegate Methods
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    if (response) {
		_responseData = [[NSMutableData alloc] init];
	}
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {

	[_responseData appendData:data];
	
}
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
	
	NSLog(@"Error loading: %@", [error localizedDescription]);
    
    [connection release];
    [_responseData release];
    
#pragma 下载失败
    if(delegate&&OnDownloadFail)
    {
        [delegate performSelector:OnDownloadFail withObject:error];
    }
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    
    UIImage * image = [[[UIImage alloc] initWithData:_responseData] autorelease];
#pragma 下载完成
    if(delegate&&OnDownloadComplete)
    {
        [delegate performSelector:OnDownloadComplete withObject:image];
    }
    
}
@end
