//
//  AsyncImageView.h
//  Hihey
//
//  Created by y xlong on 12-10-9.
//  Copyright (c) 2012年 水蓝 Tech. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AsyncImageView : UIImageView

@property (nonatomic, retain) NSURLConnection * conn;
@property (nonatomic, retain) NSMutableData * responseData;

-(void)setImageWithURL:(NSURL *) url;

-(void)setImageWithURL:(NSURL *) url 
       placeholdeImage:(UIImage *) image;

-(void)setImageWithURL:(NSURL *) url 
       placeholdeImage:(UIImage *) image 
                option:(BOOL) option;
@end
