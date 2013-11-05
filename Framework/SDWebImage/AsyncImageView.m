//
//  AsyncImageView.m
//  Hihey
//
//  Created by y xlong on 12-10-9.
//  Copyright (c) 2012年 水蓝 Tech. All rights reserved.
//

#import "AsyncImageView.h"

#define kWBRequestTimeOutInterval   180.0

@implementation AsyncImageView
@synthesize conn = _connection;
@synthesize responseData = _responseData;

-(void) dealloc
{
    [super dealloc];
}

-(void)setImageWithURL:(NSURL *) url
{
    [self setImageWithURL:url placeholdeImage:nil option:YES];
}
-(void)setImageWithURL:(NSURL *) url 
       placeholdeImage:(UIImage *) image
{
    [self setImageWithURL:url placeholdeImage:image option:YES];
}
-(void)setImageWithURL:(NSURL *) url 
       placeholdeImage:(UIImage *) image 
                option:(BOOL) option
{
    self.image = image;
    if(url)
    {
        NSURLRequest * _urlRequest= [[NSURLRequest alloc] initWithURL:url 
                                                          cachePolicy:NSURLRequestReloadIgnoringLocalCacheData
                                                      timeoutInterval:kWBRequestTimeOutInterval];
        // Begin download
        _connection= [[[NSURLConnection alloc] initWithRequest:_urlRequest
                                                     delegate:self 
                                             startImmediately:YES]autorelease];
        
        if(option)
        {
            UIActivityIndicatorView * loadingView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
            loadingView.tag = 10086;
            loadingView.center = CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2);
            [self addSubview: loadingView];
            [loadingView release];
            [loadingView startAnimating];
        }
    }
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
    UIActivityIndicatorView * loadingView = (UIActivityIndicatorView *)[self viewWithTag:10086];
    if(loadingView)
    {
        [loadingView stopAnimating];
        [loadingView removeFromSuperview];
        loadingView = nil;
    }
    
    [connection release];
    [_responseData release];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    
    UIActivityIndicatorView * loadingView = (UIActivityIndicatorView *)[self viewWithTag:10086];
    if(loadingView)
    {
        [loadingView stopAnimating];
        [loadingView removeFromSuperview];
        loadingView = nil;
    }
    
    UIImage * _image = [[[UIImage alloc] initWithData:_responseData] autorelease];
    self.image = _image;
    
    [_responseData release];
    [connection release];
}

@end
