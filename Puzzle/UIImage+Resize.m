//
//  UIImage+Resize.m
//  Puzzle
//
//  Created by Syuuhi on 13-6-6.
//  Copyright (c) 2013年 周飞. All rights reserved.
//

#import "UIImage+Resize.h"

@implementation UIImage (Resize)

-(UIImage *)resizedImageWithSize:(CGSize)size{
    UIGraphicsBeginImageContextWithOptions(size, NO, 0.0);
    CGImageRef sourceImage = CGImageCreateCopy(self.CGImage);
    UIImage *newImage = [UIImage imageWithCGImage:sourceImage scale:0.0 orientation:self.imageOrientation];
    [newImage drawInRect:CGRectMake(0, 0, size.width, size.height)];
    CGImageRelease(sourceImage);
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

-(UIImage *)cropImageFromFrame:(CGRect)frame{
    CGRect destFrame = CGRectMake(0, 0, frame.size.width, frame.size.height);
    CGFloat scale = 1.0;
    if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)]) {
        scale = [[UIScreen mainScreen]scale];
    }
    CGRect sourceFrame = CGRectMake(frame.origin.x*scale, frame.origin.y*scale, frame.size.width*scale, frame.size.height*scale);
    UIGraphicsBeginImageContextWithOptions(destFrame.size, NO, 0.0);
    CGImageRef sourceImage = CGImageCreateWithImageInRect(self.CGImage, sourceFrame);
    UIImage *newImage = [UIImage imageWithCGImage:sourceImage scale:scale orientation:self.imageOrientation];
    [newImage drawInRect:destFrame];
    CGImageRelease(sourceImage);
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndPDFContext();
    return newImage;
}

@end
