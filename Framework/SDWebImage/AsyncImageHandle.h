//
//  AsyncImageHandle.h
//  Hihey
//
//  Created by y xlong on 12-10-9.
//  Copyright (c) 2012年 水蓝 Tech. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AsyncImageHandle : NSObject{
    id delegate;
    SEL OnDownloadComplete;
    SEL OnDownloadFail;
}

@property (nonatomic, assign) id delegate;
@property (nonatomic, assign) SEL OnDownloadComplete;
@property (nonatomic, assign) SEL OnDownloadFail;

@property (nonatomic, retain) NSURLConnection                * conn;
@property (nonatomic, retain) NSMutableData                  * responseData;
@property (nonatomic, retain) NSURL                          * remoteUrl;

- (id) initWithRemoteURL:(NSURL *) url;
- (void) beginDownload;
- (void) cancelDownload;
@end
